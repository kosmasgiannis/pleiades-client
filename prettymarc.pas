unit prettymarc;

interface

uses Classes, SysUtils   ;

function get_lenchars(s : string; len: integer) : integer;
procedure display_MARC(mrcin : string; maxlen : integer;
                       labellist, textlist : TstringList;
                       labelval,taginfo : array of string; labelsdim:integer);
procedure dump_marcrecord(marcrec : string; var f : Textfile; len:integer);
function load_labels(fname,language : string;
                     labelval,taginfo : array of string) : integer;

const
 punctuation = ' .,;:\|[]{}-_+=)(*&^%$#@!';
 MAXLABELS = 1000;

implementation

function get_lenchars(s : string; len: integer) : integer;
var  r:string;
     i:integer;
begin
 if ((length(s) <= len) or (len=0)) then
 begin
  result:=length(s);
  exit;
 end;
 r:=copy(s,1,len);
 for i:=len downto 1 do
 begin
  if (pos(r[i],punctuation)>0) then
  begin
   result := i;
   exit;
  end;
 end;
 result:=len;
end;

function extract_field(s : string; f: string; which : integer; keepsfd : boolean) : string;
var i:integer;
 cf : char;
 flag : boolean;
 r:string;
 current: integer;
begin
 flag:=false;
 r:='';
 i:=1;
 current:=0;
 while i <= length(s) do
 begin
  if s[i] = #31 then
  begin
   i:=i+1;
   cf := s[i];
   if (pos(cf,f)>0) then
   begin
    current :=current+1;
    if ((current=which) or (which=0)) then
    begin
     flag :=true;
     if keepsfd then
      r:=r+#31+cf
     else
      r:=r+' ';
    end;
    if ((which <> 0) and (current>which)) then break;
   end
   else
    flag:=false;
   i:=i+1;
  end
  else
  begin
   if (flag) then
    r:=r+s[i];
   i:=i+1;
  end;
 end;
 if ((r <>'') and (keepsfd=false))
  then r:= copy(r,2,length(r));
 result := r;
end;

procedure dump_marcrecord(marcrec : string; var f : Textfile; len:integer);
var
 i,p,base, start, leng : integer;
 hlp,tag,text : string;
 numoffields,j,just : integer;
begin
  writeln(f,'[LDR] ',copy(marcrec,1,24));
  hlp := copy(marcrec,13,5);
  base := strtoint(hlp);
  numoffields := (base - 1 -24) div 12;
  p := 25;
  for i:=1 to numoffields do
  begin
   hlp := copy(marcrec,p,12);
   tag := copy(hlp,1,3);
   leng:=strtoint(copy(hlp,4,4));
   start:=base+strtoint(copy(hlp,8,5));
   text := copy(marcrec,start+1,leng);
   for j:=1 to length(text) do
   begin
    if text[j] = #31 then text[j]:='$'
    else
     if text[j] = #30 then text[j] := ' ';
   end;
   text:=copy(text,1,length(text)-1);
   if len = 0 then
    writeln(f,'['+tag+'] ',text)
   else
   begin
    tag:='['+tag+'] ';
    just:=get_lenchars(text,len);

    writeln(f,tag,copy(text,1,just));
    text:=copy(text,just+1,length(text));
    tag:='      ';
    while (text<>'') do
    begin
     just:=get_lenchars(text,len);
     writeln(f,tag,copy(text,1,just));
     text:=copy(text,just+1,length(text));
    end;
   end;
   p:=p+12;
  end;
end;


function load_labels(fname,language : string;
                     labelval,taginfo : array of string) : integer;
var fs:Textfile;
    line : string;
    scnt : integer;
begin
 scnt:=0;
 if (fileexists(fname)) then
 begin
  AssignFile(fs,fname);
  Reset(fs);
  while(eof(fs)=false) do
  begin
   readln(fs,line);
   if ((line[1] = '#') or (copy(line,1,2) <> language)) then
    continue;
   scnt:=scnt+1;
   if (scnt > MAXLABELS) then
   begin
    break;
   end;
   line:=copy(line,4,length(line));
   labelval[scnt]:=copy(line,1,pos(':',line)-1);
   taginfo[scnt]:=copy(line,pos(':',line)+1,length(line));
  end;
  Closefile(fs);
 end;
 result := scnt;
end;

procedure display_MARC(mrcin : string; maxlen : integer;
                       labellist, textlist : TstringList;
                       labelval,taginfo : array of string; labelsdim:integer);
var proc:boolean;
    junk, hlp,tag,ftext,indic,elabel,plabel:string;
    scnt,cnt,j,i,k,p,base, start,just,leng,numoffields,x : integer;
begin
 plabel:='';
 elabel:='';
 for i:=1 to labelsdim do
 begin
  if plabel<>labelval[i] then
  begin
   plabel:=labelval[i];
   elabel:=plabel;
  end;
  hlp := copy(mrcin,13,5);
  base := strtoint(hlp);
  numoffields := (base - 1 -24) div 12;
  p := 25;
  for k:=1 to numoffields do
  begin
   hlp := copy(mrcin,p,12);
   tag := copy(hlp,1,3);
   leng:=strtoint(copy(hlp,4,4));
   start:=base+strtoint(copy(hlp,8,5));
   ftext := copy(mrcin,start+1,leng-1);
   proc:=false;
   if (tag = copy(taginfo[i],1,3)) then proc:=true;
   if (not proc) then
    for x:=3 downto 1 do
    begin
     tag[x]:='X';
     if (tag = copy(taginfo[i],1,3)) then begin proc:=true; break; end;
    end;
   tag := copy(hlp,1,3);
   if proc then
   begin
    if strtointdef(tag,0)>=10 then
    begin
     proc:=false;
     indic:=copy(ftext,1,2);
//   ftext:=copy(ftext,3,length(ftext));
     if (indic = copy(taginfo[i],4,2)) then proc:=true;
     if (not proc) then
      for x:=2 downto 1 do
      begin
       indic[x]:='?';
       if (indic = copy(taginfo[i],4,2)) then begin proc:=true; break; end;
      end;
    end;
    if proc then
    begin
     if plabel = elabel then
     begin
      // write(fo,plabel,':');
      labellist.Add(plabel);
      elabel:='';
      for x:=1 to length(plabel) do elabel:=elabel+' ';
     end
     else labellist.Add(elabel); // write(fo,elabel,' ');
     hlp:=copy(taginfo[i],6,length(taginfo[i]));
     if hlp='*' then hlp:='abcdefghijklmnopqrstuvwxyz0123456789';
     if hlp[1]='-' then
     begin
      junk:=copy(hlp,2,length(hlp));
      hlp :='';
      for j:=1 to length(junk) do
       if (pos(junk[j],'abcdefghijklmnopqrstuvwxyz0123456789') = 0) then
        hlp:=hlp+junk[j];
     end;
     if (strtointdef(tag,0)>=10) then ftext:=extract_field(ftext,hlp,0,false);
     just := get_lenchars(ftext,maxlen);
     textlist.Add(copy(ftext,1,just));
     // writeln(fo,copy(ftext,1,just));
     ftext:=copy(ftext,just+1,length(ftext));
     while (ftext <> '') do
     begin
      just := get_lenchars(ftext,maxlen);
      labellist.Add(elabel);
      textlist.Add(copy(ftext,1,just));
      // writeln(fo,elabel,' ',copy(ftext,1,just));
      ftext:=copy(ftext,just+1,length(ftext));
     end;
    end;
   end;
   p:=p+12;
  end;
 end;
end;

end.
