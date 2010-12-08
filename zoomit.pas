unit zoomit;

interface

uses zoom, Classes, StrUtils, SysUtils,Windows, Variants, Qt,
     Dialogs, mycharconversion, TntClasses,
     XMLDoc, importunit,common,cUnicodeCodecs;


{procedure zoomtest;}
function zscan(var azoomhost:ZOOM_Host; query: WideString;  start, count:integer; results:TTntstrings): integer;

function zsearch(var azoomhost:ZOOM_HOST; query: WideString; timeout:integer) : integer;
function zresume_search(var azoomhost:ZOOM_Host) : integer;
procedure zclose(var azoomhost:ZOOM_Host);
function zpresent(var azoomhost:ZOOM_Host; count:integer; results:TTntstrings; element : string): integer;

function get_zoom_error(myzoom_connection : Pvariant; var errorstr:string): integer;
procedure setup_zebra_host(var azebrahost:ZOOM_Host; name, host,port,database,format,scharset,dcharset,proxy,profile :string; dommode: boolean);

function zebra_connect(var azebrahost:ZOOM_Host; package_create : boolean; var errorstr:string): integer;
procedure zebra_disconnect(var azebrahost:ZOOM_Host);

function zebra_init_database(var azebrahost:ZOOM_Host; var errorstr :string): integer;

function zebra_update_record(var azebrahost:ZOOM_Host; action, recid : string; rec : UTF8string;
                             commit, assume_active_connection : boolean;
                             var errorstr :string): integer;

function zebra_commit(var azebrahost:ZOOM_Host; assume_active_connection : boolean; var errorstr :string): integer;

function zebra_get_recordidnumber(var azebrahost:ZOOM_Host; recno:string; var recid : UTF8string;
                                  var errorstr :string): integer;
function zebra_get_recordidnumber_dom(var azebrahost:ZOOM_Host; recno:string; var recid : UTF8string;
                                  var errorstr :string): integer;

function getzoomhostbyname(zname : string) : PZoom_host;
function getzoomhostbyid(zid : string) : PZoom_host;

implementation

function getzoomhostbyname(zname : string) : PZoom_host;
var i : integer;
begin
  result:=nil;
  for i:=1 to MAXHOSTS do
  begin
   if Zoom_hosts[i].name = zname then
   begin
     result := @Zoom_hosts[i];
     break;
   end;
  end;
end;

function getzoomhostbyid(zid : string) : PZoom_host;
var i : integer;
begin
  result:=nil;
  for i:=1 to MAXHOSTS do
  begin
   if Zoom_hosts[i].id = zid then
   begin
     result := @Zoom_hosts[i];
     break;
   end;
  end;
end;

function rebuild_marc(marcrec: Pchar; charset : string) : string;
var i,p,base, start, leng : integer;
 r,ldr,newdir,hlp,tag,text : string;
 numoffields,newpos,newlen : integer;
begin
{  newpos := pos(#0,marcrec);
  while (newpos >0) do
  begin
   marcrec[newpos] := ' ';
   newpos := pos(#0,marcrec);
  end; }
//  marcrec := ansireplacestr(marcrec,#0,' ');
  result:='';
//  if marcrec = nil then exit;
  hlp := copy(marcrec,1,5);
  leng := strtoint(hlp);
  for i:=1 to leng do if (marcrec[i]=#0) then marcrec[i]:='.';
  ldr := copy(marcrec,6,19);
  hlp := copy(marcrec,13,5);
  r:='';
  newdir:='';
  newpos:=0;
  base := strtoint(hlp);
  numoffields := (base - 1 -24) div 12;
  p := 25;
  for i:=1 to numoffields do
  begin
   hlp := copy(marcrec,p,12);
   tag := copy(hlp,1,3);
   leng:=strtoint(copy(hlp,4,4));
   start:=base+strtoint(copy(hlp,8,5));
   charset:=UpperCase(charset);
   text := copy(marcrec,start+1,leng);
   if copy(charset,1,7) = 'ISO5428' then
    text:=elot928toutf8(iso5428Toelot928(text))
   else if copy(charset,1,7) = 'ADVANCE' then
    text:=elot928toutf8(advanceToelot928(text))
   else if ((charset = 'WIN-1253') or (charset='CP1253')) then
    text := elot928toutf8(text)
   else if charset = 'LATIN1' then
    text := text;
   r:=r+text;
   newlen:=length(text);
   newdir:=newdir+tag+format('%.4d',[newlen])+format('%.5d',[newpos]);
   newpos:=newpos+newlen;
   p:=p+12;
  end;

  newlen:=5+length(ldr)+length(newdir)+length(r)+2;
  hlp:=format('%.5d',[newlen]);
  result:=hlp+ldr+newdir+#30+r+#29;
end;

function get_zoom_error(myzoom_connection : Pvariant; var errorstr:string): integer;
var errmsg,addinfo:string;
    xx,yy: Pchar;
    x,y : Pointer;
begin
  errorstr:='';
  result := ZOOM_connection_errcode(myzoom_connection);
  if (result <> 0) then
  begin
   x:=addr(xx); y:=addr(yy);
   ZOOM_connection_error(myzoom_connection,x,y);
   errmsg:=Pchar(xx);
   addinfo:=Pchar(yy);
   errorstr:='Error ('+inttostr(result)+'): '+errmsg+' Additional Info:"'+addinfo+'"';
  end;
end;

function zscan(var azoomhost:ZOOM_Host; query: WideString;  start, count:integer; results:TTntstrings): integer;
var portnum : Word;
    rssize,i : integer;
    type_spec,key,value : string;
    gquery : string;
    len : integer;
    zraw_record : Pchar;
    raw_record : string;
    Scan_record: wideString;
    occ:Integer;
    PRlen,PROcc : Pinteger;
begin
  if ZOOM_INITIALIZED = false then
  begin
   result:=-1;
   azoomhost.errorstring:='ZOOM not initialized';
   exit;
  end;
  azoomhost.mark:=0;
  azoomhost.hits:=0;
  portnum:=strtoint(azoomhost.port);
  type_spec:='raw';
  azoomhost.ZOOM_Package:=nil;
  azoomhost.ZOOM_options := ZOOM_options_create();
  azoomhost.ZOOM_connection := ZOOM_connection_create(azoomhost.ZOOM_options);
  key:='databaseName'; value:=azoomhost.database;
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  key:='preferredRecordSyntax'; value:=azoomhost.format;
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  key:='elementSetName'; value:='F';
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  if (azoomhost.proxy <> '' ) then
  begin
   key:='proxy'; value:=azoomhost.proxy;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.userid <> '' ) then
  begin
   key:='user'; value:=azoomhost.userid;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.password <> '' ) then
  begin
   key:='password'; value:=azoomhost.password;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.groupid <> '' ) then
  begin
   key:='group'; value:=azoomhost.groupid;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;

  ZOOM_connection_connect(azoomhost.ZOOM_connection,Pchar(azoomhost.host),portnum);
  azoomhost.errorcode := get_zoom_error(azoomhost.ZOOM_connection,azoomhost.errorstring);
  if (azoomhost.errorcode = 0) then
  begin
   gquery:=query;
   if ((azoomhost.scharset = 'WIN-1253') or (azoomhost.scharset='CP1253')) then
    gquery := Unicode2Elot928(query)
   else if copy(azoomhost.scharset,1,7) = 'ISO5428' then
    gquery := elot928ToUpperiso5428(Unicode2Elot928(query))
   else if copy(azoomhost.scharset,1,7) = 'ADVANCE' then
    gquery := elot928Toadvance(Unicode2Elot928(query))
   else if (UpperCase(azoomhost.scharset) = 'UTF8')or(UpperCase(azoomhost.scharset) = 'UTF-8') then
    gquery := UTF8Encode(query);

   key:='position'; value:=inttostr(start);
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));

   key:='number'; value:=inttostr(count);
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));

   azoomhost.scanSet := ZOOM_connection_scan(azoomhost.ZOOM_connection,PChar(gquery));
   azoomhost.errorcode := get_zoom_error(azoomhost.ZOOM_connection,azoomhost.errorstring);
   if (azoomhost.errorcode <> 0) then
   begin
    // FIXME
   end;
   rssize := ZOOM_scanset_size(azoomhost.scanSet);

   //   azoomhost.hits:=rssize;
   result:=rssize;
{}
   for i:=0 to rssize-1 do
   begin
    PRlen := @len;
    PROcc := @Occ;
    zraw_Record:=ZOOM_scanset_display_term(azoomhost.scanset,i,PROcc, PRlen);
//    if azoomhost.dcharset = 'WIN-1253' then
//     gquery := Elot928toutf8(query)
//    else if copy(azoomhost.dcharset,1,7) = 'ISO5428' then
//     gquery := elot928ToUpperiso5428(Unicode2Elot928(query))
//    else if copy(azoomhost.dcharset,1,7) = 'ADVANCE' then
//     gquery := elot928Toadvance(Unicode2Elot928(query))
//    else if (UpperCase(azoomhost.dcharset) = 'UTF8')or(UpperCase(azoomhost.dcharset) = 'UTF-8') then
//     gquery := UTF8Encode(query);

    raw_record := zraw_record;
//    scan_record:=UTF8StringToWideString(utf8decode(PChar(zraw_record)));
    scan_record:=UTF8StringToWideString(raw_record);
//    showmessage(scan_record+' '+inttostr(Occ));
    results.Add(inttostr(i+1));
    results.Add(scan_record);
    results.Add(inttostr(Occ));

    //    lines.Add('>'+scan_record+' ('+inttostr(occ)+')');
   end;
   ZOOM_scanset_destroy(azoomhost.scanset);
{}

  end
  else
  begin
   result:=-1;
   azoomhost.active:=false;
//   MessageDlg('Error ('+inttostr(errcode)+'): '+errmsg+' Additional Info:"'+addinfo+'"', mtError, [mbOk], 0);
  end;
end;

procedure zclose(var azoomhost:ZOOM_Host);
begin
 if azoomhost.active then
 begin
  if (azoomhost.ZOOM_Result_Set) <> nil then
   ZOOM_resultset_destroy(azoomhost.ZOOM_Result_Set);
  if (azoomhost.ZOOM_connection) <> nil then
   ZOOM_connection_destroy(azoomhost.ZOOM_connection);
  if (azoomhost.ZOOM_Package) <> nil then
     zoom_package_destroy(azoomhost.ZOOM_Package);
  azoomhost.active:=false;
 end;
end;

function zpresent(var azoomhost:ZOOM_Host; count:integer; results:TTntstrings; element : string): integer;
var ZOOM_rec: Pvariant;
    Rlen, i,cnt : integer;  // Rlen := PRlen^;
    key,value,raw_record,syntax,type_spec1,type_spec2 : string;
    zraw_record : PChar;
//    PRlen : Pinteger;
    Precs : Pointer;
//    f:textfile;
//    xmldoc : TXMLDocument;
begin
 type_spec1:='raw';
 type_spec2:='syntax';
 cnt := 0;
 try

  key:='elementSetName'; value:=element;
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));

  GetMem(Precs,count*sizeof(Pvariant));
  if azoomhost.mark+count > azoomhost.hits-1 then
   count:= azoomhost.hits-azoomhost.mark;
  ZOOM_resultset_records(azoomhost.ZOOM_Result_Set,Precs,azoomhost.mark,count);
  for i:=0 to count-1 do
  begin

   ZOOM_Rec := ZOOM_resultset_record(azoomhost.ZOOM_Result_Set,azoomhost.mark);

//   PRlen := @Rlen;
   zraw_record:=ZOOM_record_get(ZOOM_Rec,PChar(type_spec2),@Rlen);
   syntax:=zraw_record;
   setlength(syntax,Rlen);

   type_spec1:='raw';

//   PRlen := @Rlen;

//   AssignFile(f,'c:\foo.txt');
//   append(f);

//   zraw_record:=ZOOM_record_get(ZOOM_Rec,PChar(type_spec1),PRlen);
//   raw_record:=zraw_record;
//   setlength(raw_record,Rlen);
//   writeln(f,raw_record);

   if (azoomhost.format = 'OPAC') then
   begin
     type_spec1:='xml; charset='+azoomhost.dcharset+',utf8'
   end
   else
   begin
   if (azoomhost.dcharset <> 'UTF8') then
//    type_spec1:='xml; charset='+azoomhost.dcharset+',utf8'
    type_spec1:='raw;charset='+azoomhost.dcharset+',utf-8'
   else
    type_spec1:='raw';
   end;
{
   if UpperCase(azoomhost.dcharset) = 'MARC8' then
    type_spec1:='xml; charset=marc8,utf8'
   else if UpperCase(azoomhost.dcharset) = 'MARC8S' then
    type_spec1:='xml; charset=marc8s,utf8'
   else
    type_spec1:='raw';
}

   zraw_record:=ZOOM_record_get(ZOOM_Rec,PChar(type_spec1),@Rlen);
   raw_record:=zraw_record;

   setlength(raw_record,Rlen);

//   writeln(f,type_spec1,' ',raw_record);
//   CloseFile(f);

   // If the connection is lost, the record we get is an empty string
   if Rlen = 0 then
   begin
    cnt:=-2;
    break;
   end;

   if (azoomhost.format = 'OPAC') then
   begin
//    showmessage(raw_record);
    ImportForm.Xmldocument1.loadfromXml(raw_record);
    ImportForm.Xmldocument1.Active:=true;
    raw_record:=make_MARC_from_OPAC(ImportForm.xmldocument1.DocumentElement);
   end;

{   if (azoomhost.dcharset <> 'UTF8') then
   begin
    ImportForm.Xmldocument1.loadfromXml(raw_record);
    ImportForm.Xmldocument1.Active:=true;
    raw_record:=make_MARC_from_MARCXML(ImportForm.xmldocument1.DocumentElement);
   end;
}
{
   if ((azoomhost.dcharset <> 'UTF8') and (copy(azoomhost.dcharset,1,5) <> 'MARC8') ) then
    raw_record:=rebuild_marc(zraw_record,azoomhost.dcharset);

   if (copy(azoomhost.dcharset,1,5) = 'MARC8') then
   begin
    ImportForm.Xmldocument1.loadfromXml(raw_record);
    ImportForm.Xmldocument1.Active:=true;
    raw_record:=make_MARC_from_MARCXML(ImportForm.xmldocument1.DocumentElement);
   end;
}

   results.Add(azoomhost.name);
   if (syntax = 'OPAC') then syntax:='USMARC';
   results.Add(syntax);
   results.Add(raw_record);

   azoomhost.mark:=azoomhost.mark+1;

   cnt:=cnt+1;
  end;
  FreeMem(Precs);
 except
  on EOutOfMemory do
  begin
   cnt := -1;
  end;
 end;
 result := cnt;
end;

function zsearch(var azoomhost:ZOOM_Host; query: WideString; timeout:integer) : integer;
var portnum : Word;
    rssize : integer;
    type_spec,key,value : string;
    gquery : string;
begin
  if ZOOM_INITIALIZED = false then
  begin
   result:=-1;
   azoomhost.errorstring:='ZOOM not initialized';
   exit;
  end;
  azoomhost.mark:=0;
  azoomhost.hits:=0;
  portnum:=strtoint(azoomhost.port);
  type_spec:='raw';
  azoomhost.ZOOM_Package:=nil;
  azoomhost.ZOOM_options := ZOOM_options_create();
  azoomhost.ZOOM_connection := ZOOM_connection_create(azoomhost.ZOOM_options);
  key:='databaseName'; value:=azoomhost.database;
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  key:='preferredRecordSyntax'; value:=azoomhost.format;
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  key:='elementSetName'; value:='F';
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  key:='timeout'; value:=inttostr(timeout);
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  if (azoomhost.proxy <> '' ) then
  begin
   key:='proxy'; value:=azoomhost.proxy;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.userid <> '' ) then
  begin
   key:='user'; value:=azoomhost.userid;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.password <> '' ) then
  begin
   key:='password'; value:=azoomhost.password;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.groupid <> '' ) then
  begin
   key:='group'; value:=azoomhost.groupid;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;

  ZOOM_connection_connect(azoomhost.ZOOM_connection,Pchar(azoomhost.host),portnum);
  azoomhost.errorcode := get_zoom_error(azoomhost.ZOOM_connection,azoomhost.errorstring);
  if (azoomhost.errorcode = 0) then
  begin
   gquery:=query;
   if ((azoomhost.scharset = 'WIN-1253') or (azoomhost.scharset='CP1253')) then
    gquery := Unicode2Elot928(query)
   else if copy(azoomhost.scharset,1,7) = 'ISO5428' then
    gquery := elot928ToUpperiso5428(Unicode2Elot928(query))
   else if copy(azoomhost.scharset,1,7) = 'ADVANCE' then
    gquery := elot928Toadvance(Unicode2Elot928(query))
   else if (UpperCase(azoomhost.scharset) = 'UTF8')or(UpperCase(azoomhost.scharset) = 'UTF-8') then
    gquery := UTF8Encode(query);  // FIXME...

   azoomhost.lastquery:=gquery;

   azoomhost.ZOOM_Result_Set := ZOOM_connection_search_pqf(azoomhost.ZOOM_connection,PChar(gquery));
   azoomhost.errorcode := get_zoom_error(azoomhost.ZOOM_connection,azoomhost.errorstring);
   if (azoomhost.errorcode <> 0) then
   begin
    // FIXME
   end;
   rssize := ZOOM_resultset_size(azoomhost.ZOOM_Result_Set);
   azoomhost.hits:=rssize;
   result:=rssize;
  end
  else
  begin
   result:=-1;
   azoomhost.active:=false;
//   MessageDlg('Error ('+inttostr(errcode)+'): '+errmsg+' Additional Info:"'+addinfo+'"', mtError, [mbOk], 0);
  end;
end;

function zresume_search(var azoomhost:ZOOM_Host) : integer;
var portnum : Word;
    rssize : integer;
    type_spec,key,value : string;
begin
  if ZOOM_INITIALIZED = false then
  begin
   result:=-1;
   azoomhost.errorstring:='ZOOM not initialized';
   exit;
  end;

  zclose(azoomhost);

  azoomhost.hits:=0;
  portnum:=strtoint(azoomhost.port);
  type_spec:='raw';


  azoomhost.ZOOM_Package:=nil;
  azoomhost.ZOOM_options := ZOOM_options_create();
  azoomhost.ZOOM_connection := ZOOM_connection_create(azoomhost.ZOOM_options);
  key:='databaseName'; value:=azoomhost.database;
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  key:='preferredRecordSyntax'; value:=azoomhost.format;
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  key:='elementSetName'; value:='F';
  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
//  key:='timeout'; value:=inttostr(timeout);
//  ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  if (azoomhost.proxy <> '' ) then
  begin
   key:='proxy'; value:=azoomhost.proxy;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.userid <> '' ) then
  begin
   key:='user'; value:=azoomhost.userid;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.password <> '' ) then
  begin
   key:='password'; value:=azoomhost.password;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  if (azoomhost.groupid <> '' ) then
  begin
   key:='group'; value:=azoomhost.groupid;
   ZOOM_connection_option_set(azoomhost.ZOOM_connection,PChar(key),PChar(value));
  end;
  ZOOM_connection_connect(azoomhost.ZOOM_connection,Pchar(azoomhost.host),portnum);
  azoomhost.errorcode := get_zoom_error(azoomhost.ZOOM_connection,azoomhost.errorstring);
  if (azoomhost.errorcode = 0) then
  begin
   azoomhost.ZOOM_Result_Set := ZOOM_connection_search_pqf(azoomhost.ZOOM_connection,PChar(azoomhost.lastquery));
   azoomhost.errorcode := get_zoom_error(azoomhost.ZOOM_connection,azoomhost.errorstring);

   if (azoomhost.errorcode <> 0) then
   begin
    // FIXME
   end;
   rssize := ZOOM_resultset_size(azoomhost.ZOOM_Result_Set);
   azoomhost.hits:=rssize;
   result:=rssize;
  end
  else
  begin
   result:=-1;
   azoomhost.active:=false;
//   MessageDlg('Error ('+inttostr(errcode)+'): '+errmsg+' Additional Info:"'+addinfo+'"', mtError, [mbOk], 0);
  end;
end;

function zebra_update_record(var azebrahost:ZOOM_Host; action, recid:string; rec : UTF8string;
                             commit, assume_active_connection : boolean;
                             var errorstr :string): integer;

var zebra_action,key,value : string;
    rc:integer;
    zebrarecid:UTF8string;
begin
 result:=0;
 errorstr:='';

 if (assume_active_connection = false) then
 begin
  rc:=zebra_connect(azebrahost, true,errorstr);
  if rc <> 0 then
  begin
   if rc = -1002 Then errorstr := ' Cannot connect to zebra database. Please verify the settings.';
   result:=rc;
   exit;
  end;
 end;

 if (action='insert') then
  zebra_action:='recordInsert'
 else if (action='delete') then
  zebra_action:='recordDelete'
 else
  zebra_action:='specialUpdate';

 zebrarecid:='';
 if (action <> 'insert') then
 begin
  if (azebrahost.dommode = true) then zebra_get_recordidnumber_dom(azebrahost, recid,zebrarecid,errorstr)
  else zebra_get_recordidnumber(azebrahost, recid,zebrarecid,errorstr);
 end;
 key:='record'; ZOOM_package_option_set(azebrahost.ZOOM_Package, Pchar(key), Pchar(rec));
 key:='format'; value:='Usmarc'; ZOOM_package_option_set(azebrahost.ZOOM_Package, Pchar(key), Pchar(value));
 key:='syntax'; value:='MARC'; ZOOM_package_option_set(azebrahost.ZOOM_Package, Pchar(key), Pchar(value));
 key:='action'; ZOOM_package_option_set(azebrahost.ZOOM_Package, Pchar(key), Pchar(zebra_action));
 if zebrarecid <> '' then
 begin
  key:='recordIdNumber';
  ZOOM_package_option_set(azebrahost.ZOOM_Package, Pchar(key), Pchar(zebrarecid));
 end
 else
 begin
  key:='recordIdOpaque';
  ZOOM_package_option_set(azebrahost.ZOOM_Package, Pchar(key), Pchar(recid));
 end;
 key:='update'; ZOOM_package_send(azebrahost.ZOOM_Package, Pchar(key));

 azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,azebrahost.errorstring);
 if (azebrahost.errorcode <> 0) then
 begin
  errorstr:=azebrahost.errorstring;
  result:=-1;
 end;

 if commit = true then
 begin
  key:='commit'; ZOOM_package_send(azebrahost.ZOOM_Package, Pchar(key));

  azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,azebrahost.errorstring);
  if (azebrahost.errorcode <> 0) then
  begin
   errorstr:=azebrahost.errorstring;
   result:=-1;
  end;
 end;

 if (assume_active_connection = false) then
 begin
  zclose(azebrahost);
 end;
end;

function zebra_commit(var azebrahost:ZOOM_Host; assume_active_connection : boolean; var errorstr :string): integer;
var key : string;
    rc:integer;
begin
 result:=0;
 errorstr:='';

 if (assume_active_connection = false) then
 begin
  rc:=zebra_connect(azebrahost, true,errorstr);
  if rc <> 0 then
  begin
   result:=rc;
   exit;
  end;
 end;

 key:='commit'; ZOOM_package_send(azebrahost.ZOOM_Package, Pchar(key));

 azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,errorstr);
 if (azebrahost.errorcode <> 0) then
 begin
  errorstr:=azebrahost.errorstring;
  result:=-1;
 end;

 if (assume_active_connection = false) then
 begin
  zclose(azebrahost);
 end;
end;

function zebra_init_database(var azebrahost:ZOOM_Host; var errorstr :string): integer;

var rc:integer;
    key : string;
begin
 result:=0;
 errorstr:='';

 rc:=zebra_connect(azebrahost, true,errorstr);
 if rc <> 0 then
 begin
  result:=rc;
  exit;
 end;

 key:='drop'; ZOOM_package_send(azebrahost.ZOOM_Package, Pchar(key));
 azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,errorstr);
 if (azebrahost.errorcode <> 0) then
 begin
  errorstr:=azebrahost.errorstring;
  result:=-1;
 end;
 zebra_commit(azebrahost, true, errorstr);
 key:='create'; ZOOM_package_send(azebrahost.ZOOM_Package, Pchar(key));
 azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,errorstr);
 if (azebrahost.errorcode <> 0) then
 begin
  errorstr:=azebrahost.errorstring;
  result:=-1;
 end;
 zebra_commit(azebrahost, true,errorstr);
 zclose(azebrahost);
end;

function zebra_connect(var azebrahost:ZOOM_Host; package_create : boolean; var errorstr:string): integer;
var portnum:Word;
    key,value: string;
begin
 result:=0;

 if ((azebrahost.host='') or (azebrahost.port='') or (azebrahost.database='') ) then
 begin
  azebrahost.active:=false;
  azebrahost.errorstring:='Not set up for zebra';
  azebrahost.errorcode:=-1000;
  errorstr:=azebrahost.errorstring;
  result:=-1000;
  exit;
 end;

 portnum:=strtoint(azebrahost.port);
 azebrahost.ZOOM_options := ZOOM_options_create();
 azebrahost.ZOOM_connection := ZOOM_connection_create(azebrahost.ZOOM_options);

 key:='databaseName'; value:=azebrahost.database;
 ZOOM_connection_option_set(azebrahost.ZOOM_connection,PChar(key),PChar(value));
 key:='preferredRecordSyntax'; value:=azebrahost.format;
 ZOOM_connection_option_set(azebrahost.ZOOM_connection,PChar(key),PChar(value));
 key:='elementSetName'; value:='F';
 ZOOM_connection_option_set(azebrahost.ZOOM_connection,PChar(key),PChar(value));
 if (azebrahost.proxy <> '' ) then
 begin
  key:='proxy'; value:=azebrahost.proxy;
  ZOOM_connection_option_set(azebrahost.ZOOM_connection,PChar(key),PChar(value));
 end;
 if (azebrahost.userid <> '' ) then
 begin
  key:='user'; value:=azebrahost.userid;
  ZOOM_connection_option_set(azebrahost.ZOOM_connection,PChar(key),PChar(value));
 end;
 if (azebrahost.password <> '' ) then
 begin
  key:='password'; value:=azebrahost.password;
  ZOOM_connection_option_set(azebrahost.ZOOM_connection,PChar(key),PChar(value));
 end;
 if (azebrahost.groupid <> '' ) then
 begin
  key:='group'; value:=azebrahost.groupid;
  ZOOM_connection_option_set(azebrahost.ZOOM_connection,PChar(key),PChar(value));
 end;

 ZOOM_connection_connect(azebrahost.ZOOM_connection,Pchar(azebrahost.host),portnum);

 azebrahost.errorcode := ZOOM_connection_errcode(azebrahost.ZOOM_connection);
 if (azebrahost.errorcode = 0) then
 begin
  if (package_create = true) then
  begin
   azebrahost.ZOOM_Package := ZOOM_connection_package(azebrahost.ZOOM_connection,nil);
   azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,azebrahost.errorstring);
   if (azebrahost.errorcode <> 0) then
   begin
    zclose(azebrahost);
    errorstr:=azebrahost.errorstring;
    result:=-1003;
   end;
  end;
 end
 else
 begin
  errorstr:=azebrahost.errorstring;
  result:=-1002;
  azebrahost.active:=false;
 end;
end;

function zebra_get_recordidnumber(var azebrahost:ZOOM_Host; recno:string; var recid : UTF8string;
                                  var errorstr :string): integer;
var rssize : integer;
    type_spec,key,value : string;
    gquery : string;

    ZOOM_rec: Pvariant;
    Rlen : integer;  // Rlen := PRlen^;
    zraw_record: Pchar;
    raw_record: string;
    PRlen : Pinteger;
    Precs : Pointer;
begin
  result:=-1;
  recid:='';
  type_spec:='xml';

  gquery:='@attr 1=12 '+recno;

  azebrahost.ZOOM_Result_Set := ZOOM_connection_search_pqf(azebrahost.ZOOM_connection,PChar(gquery));
  azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,azebrahost.errorstring);

  if (azebrahost.errorcode = 0) then
  begin
    rssize := ZOOM_resultset_size(azebrahost.ZOOM_Result_Set);
    if rssize > 0 then
    begin
      key:='preferredRecordSyntax'; value:='xml';
      ZOOM_resultset_option_set(azebrahost.ZOOM_Result_Set,PChar(key),PChar(value));
      GetMem(Precs,sizeof(Pvariant));
      ZOOM_resultset_records(azebrahost.ZOOM_Result_Set,Precs,1,1);

      ZOOM_Rec := ZOOM_resultset_record(azebrahost.ZOOM_Result_Set,0);
      PRlen := @Rlen;
      zraw_record:=ZOOM_record_get(ZOOM_Rec,PChar(type_spec),PRlen);
      raw_record:=zraw_record;
      //setlength(raw_record,Rlen);
      FreeMem(Precs);
      if pos('<localnumber>',raw_record) > 0 then
      begin
       recid:=copy(raw_record,pos('<localnumber>',raw_record)+13,100);
       recid:=copy(recid,1,pos('<',recid)-1);
       result:=1;
      end;
    end;
  end;
end;

function zebra_get_recordidnumber_dom(var azebrahost:ZOOM_Host; recno:string; var recid : UTF8string;
                                  var errorstr :string): integer;
var rssize : integer;
    type_spec,key,value : string;
    gquery : string;

    ZOOM_rec: Pvariant;
    Rlen : integer;  // Rlen := PRlen^;
    zraw_record: Pchar;
    raw_record: string;
    PRlen : Pinteger;
    Precs : Pointer;
begin
  result:=-1;
  recid:='';
  type_spec:='xml';

  gquery:='@attr 1=12 '+recno;

  azebrahost.ZOOM_Result_Set := ZOOM_connection_search_pqf(azebrahost.ZOOM_connection,PChar(gquery));
  azebrahost.errorcode := get_zoom_error(azebrahost.ZOOM_connection,azebrahost.errorstring);

  if (azebrahost.errorcode = 0) then
  begin
    rssize := ZOOM_resultset_size(azebrahost.ZOOM_Result_Set);
    if rssize > 0 then
    begin
      key:='preferredRecordSyntax'; value:='xml';
      ZOOM_resultset_option_set(azebrahost.ZOOM_Result_Set,PChar(key),PChar(value));
      key:='elementSetName'; value:='zebra::meta';
      ZOOM_resultset_option_set(azebrahost.ZOOM_Result_Set,PChar(key),PChar(value));
      GetMem(Precs,sizeof(Pvariant));
      ZOOM_resultset_records(azebrahost.ZOOM_Result_Set,Precs,1,1);

      ZOOM_Rec := ZOOM_resultset_record(azebrahost.ZOOM_Result_Set,0);
      PRlen := @Rlen;
      zraw_record:=ZOOM_record_get(ZOOM_Rec,PChar(type_spec),PRlen);
      raw_record:=zraw_record;
      //setlength(raw_record,Rlen);
      FreeMem(Precs);
      if pos('sysno="',raw_record) > 0 then
      begin
       recid:=copy(raw_record,pos('sysno="',raw_record)+7,100);
       recid:=copy(recid,1,pos('"',recid)-1);
       result:=1;
      end;
    end;
  end;
end;

procedure zebra_disconnect(var azebrahost:ZOOM_Host);
begin
 zclose(azebrahost);
end;

procedure setup_zebra_host(var azebrahost:ZOOM_Host; name, host,port,database,format,scharset,dcharset,proxy,profile :string; dommode : boolean);
begin
 azebrahost.name:=name;
 azebrahost.host:=host;
 azebrahost.port:=port;
 azebrahost.database:=database;
 azebrahost.proxy:=proxy;
 azebrahost.userid:='';
 azebrahost.password:='';
 azebrahost.groupid:='';
 azebrahost.profile:=profile;
 azebrahost.active:=false;
 azebrahost.errorcode:=0;
 azebrahost.errorstring:='';
 azebrahost.format:=format;
 azebrahost.scharset:=UpperCase(scharset);
 azebrahost.dcharset:=UpperCase(dcharset);
 azebrahost.mark:=0;
 azebrahost.hits:=0;
 azebrahost.ZOOM_Result_Set:=nil;
 azebrahost.ZOOM_Package:=nil;
 azebrahost.ZOOM_options:=nil;
 azebrahost.ZOOM_connection:=nil;
 azebrahost.dommode:=dommode;
end;

{
procedure Scantest(hostname : string; portnum: word; databasename:
string; searchstr : widestring; lines: TtntStrings);
var ZOOM_options, ZOOM_connection: Pvariant;
    len, errcode, i, rssize : integer;
    q, key,value : string;
    addinfo,errmsg : PChar;
    zraw_record : Pointer;
    Scan_record: wideString;
    occ:Integer;
    Scan_Result:PVariant;
    PRlen,PROcc : Pinteger;
begin
  lines.Clear;
  ZOOM_options := ZOOM_options_create();
  ZOOM_connection := ZOOM_connection_create(ZOOM_options);
  key:='databaseName'; value:=databasename;
  ZOOM_connection_option_set(ZOOM_connection,PChar(key),PChar(value));
  key:='preferredRecordSyntax';
  value:='USMARC';
  ZOOM_connection_option_set(ZOOM_connection,PChar(key),PChar(value));
  key:='elementSetName';
  value:='F';
  ZOOM_connection_option_set(ZOOM_connection,PChar(key),PChar(value));
  ZOOM_connection_connect(ZOOM_connection,Pchar(hostname),portnum);
  errcode := ZOOM_connection_errcode(ZOOM_connection);
  if (errcode = 0) then
  begin
   q:=widestringtoutf8(searchstr);
   Scan_Result:=ZOOM_connection_scan(ZOOM_connection, Pointer(q));
   rssize := ZOOM_scanset_size(Scan_Result);
   lines.Add('Hits :'+inttostr(rssize));
   for i:=0 to rssize-1 do
   begin
    PRlen := @len;
    PROcc := @Occ;
    zraw_Record:=ZOOM_scanset_display_term(Scan_Result,i,PROcc, PRlen);
    scan_record:=utf8towidestring(PChar(zraw_record));
    lines.Add('>'+scan_record+' ('+inttostr(occ)+')');
   end;
   ZOOM_connection_destroy(ZOOM_connection);
  end
end;

procedure zoomtest;
var ZOOM_options, ZOOM_rec, ZOOM_connection, r : Pvariant;
    portnum : Word;
    Rlen, errcode, i, rssize : integer;  // Rlen := PRlen^;
    q, host, type_spec,key,value : string;
    zraw_record, addinfo,errmsg : PChar;
    raw_record: string;
    PRlen : Pinteger;
begin
  portnum:=210;
  host:='alcyone.libh.uoc.gr';
  type_spec:='raw';
  ZOOM_options := ZOOM_options_create();
  ZOOM_connection := ZOOM_connection_create(ZOOM_options);
  key:='databaseName'; value:='ptolemeos_ii';
  ZOOM_connection_option_set(ZOOM_connection,PChar(key),PChar(value));
  key:='preferredRecordSyntax'; value:='USMARC';
  ZOOM_connection_option_set(ZOOM_connection,PChar(key),PChar(value));
  key:='elementSetName'; value:='F';
  ZOOM_connection_option_set(ZOOM_connection,PChar(key),PChar(value));

  ZOOM_connection_connect(ZOOM_connection,Pchar(host),portnum);
  errcode := ZOOM_connection_errcode(ZOOM_connection);
  if (errcode = 0) then
  begin
   q:='@attr 1=4 @attr 4=6 "international physics"';
   r := ZOOM_connection_search_pqf(ZOOM_connection,PChar(q));

   rssize := ZOOM_resultset_size(r);
   //showmessage('Total : '+inttostr(rssize));
   for i:=0 to rssize-1 do
   begin
    ZOOM_Rec := ZOOM_resultset_record(r,i);
    PRlen := @Rlen;
    zraw_record:=ZOOM_record_get(ZOOM_Rec,PChar(type_spec),PRlen);
    raw_record:=zraw_record;
    setlength(raw_record,Rlen);
   end;
   ZOOM_resultset_destroy(r);
   ZOOM_connection_destroy(ZOOM_connection);
  end
  else
  begin
   errmsg := ZOOM_connection_errmsg(ZOOM_connection);
   addinfo := ZOOM_connection_addinfo(ZOOM_connection);
   MessageDlg('Error ('+inttostr(errcode)+'): '+errmsg+' Additional Info:"'+addinfo+'"', mtError, [mbOk], 0);
  end;
end;
}

end.


