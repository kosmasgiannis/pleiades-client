unit common;

interface

uses StdCtrls, db, dbtables, Classes, IniFiles, Forms, Windows, controls,
     dialogs, mycharconversion, sysutils, MyAccess, TntStdCtrls, TntClasses,
     Graphics, TntDialogs, xmldom, XMLIntf, msxmldom, XMLDoc, dateutils,
     WordXP, Variants, cUnicodeCodecs, Consts;

type

PZOOM_HOST = ^ZOOM_HOST;
ZOOM_HOST = record
      id : string;
      name: string;
      host : string;
      port : string;
      database: string;
      proxy: string;
      format : string;
      userid : string;
      password : string;
      groupid : string;
      scharset : string;
      dcharset : string;
      active : boolean;
      dommode : boolean;
      ZOOM_options : Pvariant;
      ZOOM_connection : Pvariant;
      ZOOM_Result_Set : Pvariant;
      ZOOM_Package : Pvariant;
      hits : integer;
      mark : integer;
      errorcode : integer;
      errorstring : string;
      Records : TTntstrings;
      profile:string;
      current_row:integer;
      lastquery : string;
      scanset : Pvariant;
      lastscanquery : widestring;
     end;

subfieldrec = record
      subfield : widechar;
      repeatable : widechar;
      occ:array[1..512] of integer;
      end;

Psyntaxrec = ^syntaxrec;

syntaxrec = record
      tag: string;
      repeatable : widechar;
      mandatory : widechar;
      occ : integer;
      subfieldcnt:integer;
      subfields : array [1..36] of subfieldrec;
      marc_help_url : string;
     end;

  TMyFont = record
              Name : string[40];
              Style : string[3];
              Size : integer;
            end;
  TPosition = record
                Start : integer;
                Len   : integer;
                Font  : TMyFont;
              end;
  integerArray = array of integer;

const MAXHOSTS=128;

var
  IniMappings : array of TTntStringList;
  ZebraRecnos : array of integer;
  savedmarc : boolean;
  LabelPos : array of TPosition;
  ContentPos : array of TPosition;

  // For Digital Objects handling.
  DO_Windows_storage_location, //=T:\maps\images
  DO_BaseURL : WideString; //=http://catalog.lib.gr/

ZOOM_INITIALIZED : Boolean;

Zoom_Hosts : array[1..MAXHOSTS] of ZOOM_HOST;
Zoom_AuthHosts : array[1..MAXHOSTS] of ZOOM_HOST;
myzebraauthhost, myzebrahost : ZOOM_HOST;

function koha_item_type(ldr : string) : string;
function type_of_material(ldr : string) : string;
procedure correct_marc_memo(fullrec : Tmemo);

// To load and sort a review list.
function rlistcmp(List: TStringList; Index1, Index2: Integer): Integer;
function loadrecnolist(list:TStringList; fname :string; sortrecs:boolean):integer;
function normalize(s:string) : string;
function remove_punctuation(s:Widestring) : widestring;
function squeeze(s : WideString) : WideString;

procedure dump_marcrecord(marcrec : string; var f : Textfile; len:integer);
procedure loadsyntaxdef(syntaxfiledef : string; var UsmarcStx : array of syntaxrec);

procedure zebraupdate(recno: integer; rec : string; mode : char; zebraindexer, zebradir : string; zebra_dir_depth : integer);
procedure zebrareindex(zebraindexer, zebradir : string);
procedure zap_dir(path:string);

procedure extract_headings(HL : TTntStringList; marcrec, recno: WideString; taginfo : array of WideString; taginfodim : integer);
function stripchars(s,t: WideString): Widestring;
procedure strip_sfd(var s : WideString);
//function syntaxchk(lines : TTntStringlist; var msg : string):boolean;
function syntaxchk(lines : TTntStringlist; var msg : string; var UsmarcStx : array of syntaxrec):boolean;
function merge_mrcs(source, retrieved : WideString): WideString;
procedure load_and_merge_record(dlg : TOpenDialog; memo : TTntMemo);
procedure append_fields(source,stag:WideString; var dir: UTF8String; var dirpos : integer; var marcrec:WideString);
function extract_field(s : WideString; f: WideString; which : integer; keepsfd : boolean) : WideString;
procedure get_author_title(rec: UTF8String; format : string; var author, title:WideString; adddate : boolean);
procedure get_main_heading(rec: UTF8String; var tag, heading:WideString);
procedure get_main_heading_from_memo(fullrec : TTntMemo; var tag, ind, heading : WideString);
procedure get_controlfieldtext(rec : UTF8String; tag,posit : string; var text:WideString);
procedure get_fieldtext(rec : UTF8String; tag,subfields : string; var text : WideString; which: integer = 0);
function get_lang(rec,format : string):string;
function remove_crlf(s:WideString) : WideString;
function trimlead(s:WideString) : WideString;
procedure filter_marc_memo(fullrec : TTntMemo);
function ReverseStringWide(const AText: WideString): WideString;

function extract_fields(s : string; f: string; delim : char) : string; overload;
function extract_fields(s : string; f: string) : string; overload;

function makemrcfromnew : UTF8String;
function makenewauthmrc : UTF8String;
procedure adddirentry(var dir : UTF8String; tag : string; len, pos : integer);
function MakeMRCFromBasket(var resrec : UTF8String) :integer; overload;
function MakeMRCFromBasket : UTF8String; overload;
function MakeMRCFromSecureBasket(recno : integer) : UTF8String; overload;
function MakeMRCFromSecureBasket(recno : integer; var resrec : UTF8String) : integer; overload;
function MakeMRCFromSecureBasketforKOHA(recno : integer) : UTF8String; overload;
function MakeMRCFromSecureBasketforKOHA(recno : integer; var resrec : UTF8String) : integer; overload;
function MakeMRCFromAuth(recno : integer) : UTF8String; overload;
function MakeMRCFromAuth(recno : integer; var resrec : UTF8String) : integer; overload;

procedure marcrecord2lines(marcrec : UTF8String; Lines:TTntStringlist);
function disp2mrc(lines : TTntStrings; var mrc : UTF8String) : integer;
procedure marcrecord2memo(marcrec : UTF8String; memo1:TTntMemo);
function ExportXMLInternal(addnewlines : boolean): UTF8String;
function make_MARC_from_OPAC(opac: IXMLNode) :UTF8string;
function make_MARC_from_MARCXML(marcxml: IXMLNode) :UTF8string;
function marc2marcxml(marcrec : UTF8String; addnewlines: boolean) : UTF8String;
procedure AddDBInfo(var rec: UTF8String; recno: integer);
procedure ReplaceRecno(recno: integer; var rec: UTF8String);
procedure ReplaceOrgCode(var rec: UTF8String);
procedure ReplaceDateStr(var rec: UTF8String);
function RemoveHoldings(rec: UTF8String) : UTF8String;
function GetRecno(rec: UTF8String) : integer;
procedure MoveHoldings(OldRecno, NewRecno : integer; UpdateZebra : boolean);
procedure Refresh084(recno : integer; var rec : UTF8String);
procedure Refresh856(recno : integer; baseurl : string; var rec : UTF8String);
procedure zap_tag(var rec: UTF8String; tag: string);

procedure PopulateComboFromIni(Category : WideString; ComboBox: TTntComboBox);
function GetIniMappings(Category : WideString; Ident : string) : WideString;

//Working with Lists
procedure SetCurrentList(FileListName : string);
function AddToList(FNameList : string; recno : integer) : boolean;  overload;
function AddToList(var F: TextFile; recno : integer) : boolean; overload;
function RemoveFromList(FNameList : string; recno : integer) : boolean;
procedure CloseList;
procedure PopulateArrayWithListRecno(FileListName : string);
function IsInList(recno: integer) : boolean;

procedure SetCurrentReviewList(FileListName : string);

procedure RecordUpdated(var azebrahost:ZOOM_Host; action: string; recno : integer; text : UTF8String; ShowProgressBar : boolean = true);
//procedure DelItemFromArray(a : array of pointer; index : integer);

//If it returns empty string the user pressed Cancel button
function EnterNumber(Title, Prompt: string) : string;

//Takes a memo with a MARC record and fixes it (erases empty rows, adds [001], [003], [005] tags etc
procedure FixMemo(var Memo : TTntMemo);

//Checks the syntax of a MARC record and shows the error message if some
function SyntaxCheck(Lines : TTntStrings; record_type : string) : boolean;

//Adds some automatically added tags and some more fixes
procedure EnhanceMARC(recno : integer; var rec : UTF8String);

function NewMARCRecord(tab : string) : integer;
function ProcessRecnoForPrinting(rec : UTF8String; nr : integer; textlen : longint; ForWord : boolean; var grouptext:WideString; template, lang : string) : WideString;
procedure OpenPrettyMARCQuery(ChosenName, lang : WideString; asinrec : boolean);

function GetLastDataFromBasket(recno : integer) : UTF8String;
function GetLastDataFromAuth(recno : integer) : UTF8String;
function InputEditBoxW(title_form, prompt, Adefault : WideString): WideString;

function maprecno2dir(startdir: string; r,depth : integer; createdirs : boolean) : string;

function is_mixed_greek_latin_word(s , Greek: WideString) : boolean;

procedure FixHollis(recmemo : TTntMemo);

function get_max_hold_aa(recno : integer) : integer;
procedure MoveHoldingUpDown(direction : string; recno, holdon, aa : integer);

const
 LC_BOOK    = 'aa,ac,ad,am,ta,tc,td,tm';
 LC_SERIAL  = 'as,cs,ds,es,fs,gs,is,js,ks,ms,os,ps,rs,ts,ab,cb,db,eb,fb,gb,ib,jb,kb,mb,ob,pb,rb,tb';
 LC_MAPS    = 'ea,eb,ec,ed,em,fa,fb,fc,fd,fm';
 LC_MUSIC   = 'ca,cc,cd,cm,da,dc,dd,dm,ia,ic,id,im';
 LC_MUSICSR = 'ja,jc,jd,jm';
 LC_VISUAL  = 'ga,gc,gd,gm,ka,kc,kd,km,oa,oc,od,om,ra,rc,rd,rm';
 LC_CFILES  = 'ma,mc,md,mm';
 LC_ARCHIVE = 'ba,bc,bd,bm,ta,tc,tm';
 PUNCTUATION = ',./?<>;:[]{}=-_+()*&^%$#@!~`"???';
 GreekUpper = '?????????????????????????????????????????????';
 GreekLower = '????ڼ?ۿ????????????????????????????????????';

var
  Lines : TTntStringList;
  BibUsmarcStx : array [0..1000] of syntaxrec;
  AuthUsmarcStx : array [0..1000] of syntaxrec;

implementation

uses DataUnit, NewBibliographicUnit, MARCEditor, MainUnit, NewRecnoUnit,
  WideIniClass, zoomit, ProgresBarUnit, GlobalProcedures,
  DBAccess, TntForms, utility;


{procedure DelItemFromArray(a : array of pointer; index : integer);
var
  i : integer;
begin
  for i := index to length(a)-1 do a[i] := a[i+1];
  SetLength(a, Length(a)-1);
end;}

function InputEditBoxW(title_form, prompt, Adefault : WideString): WideString;
var
  ComboForm: TTntForm;
  LabelP: TTntLabel;
  Edit: TTntEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var  { Message dialog }
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;
  
begin

  Result := '';
  ComboForm := TTntForm.Create(Application);
  with ComboForm do
  try
    Canvas.Font := Font;
    Font.Name := 'Arial';
    BorderStyle := bsDialog;
    Caption := title_form;
    DialogUnits := GetAveCharSize(Canvas);
    Position := poScreenCenter;
    ClientWidth := MulDiv(180,DialogUnits.X,4);
    
    LabelP := TTntLabel.Create(ComboForm);
    with LabelP do
    begin
      Parent := ComboForm;
      Caption := prompt;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
      WordWrap := True;
    end;

    Edit := TTntEdit.Create(ComboForm);
    with Edit do
    begin
      Parent := ComboForm;
      Font.Name := 'Arial';
      Top := LabelP.Top + LabelP.Height + 15;
      Left := MulDiv(8, DialogUnits.X, 4);
      Width := MulDiv(164, DialogUnits.X, 4);
      Text := Adefault;
      MaxLength := 255;
    end;

    ButtonTop := Edit.Top + Edit.Height + 25;
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);


    with TTntButton.Create(ComboForm) do
    begin
      Parent := ComboForm;
      Caption := SMsgDlgOK;
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
      ButtonHeight);
    end;

    with TTntButton.Create(ComboForm) do
    begin
      Parent := ComboForm;
      Caption := SMsgDlgCancel;
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 25,
      ButtonWidth, ButtonHeight);
      ComboForm.ClientHeight := Top + Height + 13;
    end;
    if ShowModal = mrOk then
      Result := Edit.Text;
  finally
    ComboForm.Free;
  end;

end;

procedure load_and_merge_record(dlg : TOpenDialog; memo : TTntMemo);
var
 F : Textfile;
 rec : UTF8String;
 reclen : integer;
 ch : char;
 flag : boolean;
begin
 dlg.FileName := '';
 dlg.Filter := 'MRC files (*.mrc)|*.mrc|Txt Files (*.txt)|*.txt|All Files (*.*)|*.*';
 dlg.FilterIndex := 1; { start the dialog showing all files }
 if dlg.Execute = true then
 begin
  Screen.Cursor:=crHourGlass;
  try
   AssignFile(F, dlg.FileName);
   Reset(F);

   flag := false;

   while (eof(f) = false) do
   begin
    read(f, ch);

    if ((ch=#13) or (ch=#10)) then ch:=' ';
    if (flag = false) then
    begin
     if ((ord(ch) >= ord('0')) and (ord(ch)<=ord('9'))) then
     begin
      rec:=ch;
      flag:=true;
     end;
    end
    else
    begin
     rec:=rec+ch;
     if (ch=#29) then
     begin
      reclen := strtointdef(copy(rec,1,5),-1);
      if reclen <> -1 then
      begin
       marcrecord2memo(rec,memo);
      end;
      break;
      Application.ProcessMessages;
     end;
    end;
   end;
   finally
    CloseFile(F);
    Screen.Cursor:=crDefault;
   end;
 end;
end;

procedure loadsyntaxdef(syntaxfiledef : string; var UsmarcStx : array of syntaxrec);
var f : textfile;
    subfields,
    rec, url : widestring;
    idx,i:integer;
begin
  for i:=0 to 1000 do
   UsmarcStx[i].tag:='';

  if fileexists(syntaxfiledef) = false then exit;

  AssignFile(f,syntaxfiledef);
  reset(f);

  while (not eof(f)) do
  begin
   readln(f,rec);
   if copy(rec,1,3) = 'LDR' then idx := 0
   else idx := strtointdef(copy(rec,1,3),-1);
   if idx >=0 then
   begin
    UsmarcStx[idx].tag:=copy(rec,1,3);
    UsmarcStx[idx].repeatable:=rec[5];
    UsmarcStx[idx].mandatory:=rec[6];
    UsmarcStx[idx].occ:=0;
    UsmarcStx[idx].subfieldcnt:=0;
    if pos(',',rec) > 0 then
    begin
     subfields:=copy(rec,pos(',',rec)+1,length(rec));
     if pos(',',subfields) > 0 then
     begin
      url:=copy(subfields,pos(',',subfields)+1,length(subfields));
      subfields:=copy(subfields,1,pos(',',subfields)-1);
      UsmarcStx[idx].marc_help_url:=url;
     end;
     if subfields <> '' then
     begin
      i:=1;
      while i<=length(subfields) do
      begin
       UsmarcStx[idx].subfieldcnt:=UsmarcStx[idx].subfieldcnt+1;
       UsmarcStx[idx].subfields[UsmarcStx[idx].subfieldcnt].subfield:=subfields[i];
       UsmarcStx[idx].subfields[UsmarcStx[idx].subfieldcnt].repeatable:=subfields[i+1];
       i:=i+2;
      end;
     end;
    end;
   end;
  end;
  Closefile(f);
end;

procedure initsyntax(var UsmarcStx : array of syntaxrec);
var i,j,k : integer;
begin
 for i:=0 to 1000 do
 begin
  UsmarcStx[i].occ:=0;
  for j:=1 to UsmarcStx[i].subfieldcnt do
   for k:=1 to 512 do UsmarcStx[i].subfields[j].occ[k]:=0;
 end;
end;

function mksyntax(tag,subfields:widestring; var msg:string; var UsmarcStx : array of syntaxrec):boolean;
var idx,j,k:integer;
    t:boolean;
begin
 result:=true;
 idx := strtointdef(tag,-1);
 if tag = 'LDR' then idx := 0;
 if idx <> -1 then
 begin
  if UsmarcStx[idx].tag = '' then
  begin
   result := false;
   msg:=msg+'['+tag+'] unknown tag appears in record.'+#10#13;
  end
  else
  begin
   UsmarcStx[idx].occ:=UsmarcStx[idx].occ+1;
   if subfields <> '' then
   begin
    for k :=1 to length(subfields) do
    begin
     t:=false;
     for j:=1 to UsmarcStx[idx].subfieldcnt do
     begin
      if UsmarcStx[idx].subfields[j].subfield = subfields[k] then
      begin
       UsmarcStx[idx].subfields[j].occ[UsmarcStx[idx].occ]:=UsmarcStx[idx].subfields[j].occ[UsmarcStx[idx].occ]+1;
       t:=true;
       break;
      end;
     end;
     if t = false then
     begin
      result :=false;
      msg:=msg+'['+tag+'] has invalid subfields.'+#10#13;
     end;
    end;
   end;
  end
 end
 else
 begin
  result := false;
  msg:=msg+'['+tag+'] invalid tag appears in record.'+#10#13;
 end;
end;

function syntaxchk(lines : TTntStringlist; var msg : string; var UsmarcStx : array of syntaxrec):boolean;
var i,l,k,x: integer;
    foo,tag,subfields:WideString;
begin
 msg:='';
 Result:=true;
 initsyntax(UsmarcStx);
 for i:=0 to Lines.Count-1 do
 begin
  tag:=copy(Lines[i],2,3);
  foo:=Lines[i];
  subfields:='';
  if pos(copy(Lines[i],6,1),' ') <=0 then
  begin
    result := false;
    msg:=msg+'['+tag+'] in line '+inttostr(i+1)+' has invalid value.'+#10#13;
  end;
  if strtointdef(tag,-1) > 9 then
  begin
   if pos(copy(Lines[i],7,1),' 0123456789|') <=0 then
   begin
     result := false;
     msg:=msg+'['+tag+'] in line '+inttostr(i+1)+' has invalid value ="'+Lines[i]+copy(Lines[i],7,1)+'" in first indicator.'+#10#13;
   end;
   if pos(copy(Lines[i],8,1),' 0123456789|') <=0 then
   begin
     result := false;
     msg:=msg+'['+tag+'] in line '+inttostr(i+1)+' has invalid value ="'+copy(Lines[i],8,1)+'" in second indicator.'+#10#13;
   end;
   if pos(copy(Lines[i],9,1),'$') <=0 then
   begin
     result := false;
     msg:=msg+'['+tag+'] in line '+inttostr(i+1)+' is malformed.'+#10#13;
   end;
  end;
  for l:=1 to length(Lines[i]) do
   if (Lines[i][l] = '$') then
    subfields:=subfields+Lines[i][l+1];
  for x :=1 to length(subfields) do
  begin
    if (pos(subfields[x], 'abcdefghijklmnopqrstuvwxyz0123456789') <= 0) then
    begin
      msg:=msg+'['+tag+'] has invalid subfields.'+#10#13;
      result:=false;
      break;
    end;
  end;
  if (not mksyntax(tag,subfields,msg,UsmarcStx)) then result:=false;
 end;
 for i:=0 to 1000 do
 begin
  if ((UsmarcStx[i].mandatory='M') and (UsmarcStx[i].occ = 0)) then
  begin
   result := false;
   msg:=msg+'['+UsmarcStx[i].tag+'] is mandatory but does not appear in record.'+#10#13;
  end;
  if ((UsmarcStx[i].repeatable='N') and (UsmarcStx[i].occ >1)) then
  begin
   result := false;
   msg:=msg+'['+UsmarcStx[i].tag+'] is nonrepeatable but appears more than once in record.'+#10#13;
  end;
  for l:=1 to UsmarcStx[i].subfieldcnt do
  begin
   for k:=1 to UsmarcStx[i].occ do
   if ((UsmarcStx[i].subfields[l].repeatable='N') and (UsmarcStx[i].subfields[l].occ[k] > 1)) then
   begin
    result := false;
    msg:=msg+'['+UsmarcStx[i].tag+'] : subfield ('+UsmarcStx[i].subfields[l].subfield+') is nonrepeatable but appears more than once in record.'+#10#13;
   end;
  end;
 end;
end;

//FIXME : Problem with very long fields...
// This is the main MakeMRC routine. It is more general as it takes as argument the dataset to
// retrieve the info from.
function MakeMRCFromBasketEx (t: TCustomMyDataset; var resrec : UTF8String) : integer;
var
  Lines : TTntStringList;
  hold, basehold, h853, h863, item876, fcln, fcln_ip, junk, temp : WideString;
  marcrec : UTF8String;
  tag : string;
  xx, yy, dpos, hcnt, itcnt, j, recno, holdon, k, dmrc : integer;
  FoundRecno : boolean;
  chk : TTntStringList;
begin
  resrec:='';
  Lines := TTntStringList.Create;
  Lines.Clear;

  recno := t.FieldByName('recno').AsInteger;

  Data.HoldQuery.Close;
  Data.HoldQuery.ParamByName('recno').AsInteger := recno;
  Data.HoldQuery.Open;

  marcrec := WideStringToString(t.GetBlob('text').AsWideString, Greek_codepage);

  if marcrec <> '' then marcrecord2lines(marcrec,lines);
  FoundRecno := False;

  //Erasing holdings information from MARC
  for xx:=Lines.Count-1 downto 0 do
  begin
    tag := copy(Lines[xx],2,3);
    if ((tag='936') or (tag='084')or (tag='852') or (tag='853') or (tag='863') or (tag='866')or (tag='867')or (tag='868')or (tag='876')) then
      Lines.Delete(xx)
    else if (tag='001') then
    begin
      Lines[xx] :='[001] '+IntToStr(recno);
      FoundRecno := True;
    end;
  end;
  if (not FoundRecno)and(Lines.Count>1) Then Lines[1] :='[001] '+IntToStr(recno);

  hcnt:=Data.HoldQuery.RecordCount;
  Data.HoldQuery.First;

  chk := TTntStringList.Create;

  //Inserting holdings information in MARC
  for xx:= 1 to hcnt do
  begin
    //Building 084 tag
    fcln:='';
    fcln_ip:='';

    if not IsEmptyField(Data.HoldQuery, 'cln') then
    begin
      fcln := Data.HoldQuery.fieldbyname('cln').Value;
      temp := '  '+'$a'+fcln;
      if not IsEmptyField(Data.HoldQuery, 'cln_ip') then
      begin
        fcln_ip := Data.HoldQuery.fieldbyname('cln_ip').Value;
        temp := temp+'$b'+fcln_ip;
      end;
      dpos:=0;
      for yy:=Lines.Count-1 downto 0 do
      begin
        dpos := strtointdef(copy(Lines[yy],2,3),0);
        if ((dpos > 0) and (dpos <= 84)) then
        begin
          dpos:=yy+1;
          break;
        end;
        dpos :=0;
      end;

      if (dpos <> 0) then
        if chk.IndexOf(temp) < 0 then
        begin
          Lines.Insert(dpos,'[084] '+temp);
          chk.Add(temp);
        end;
    end;

    hold := '8 ';
    hold := hold+'$8'+inttostr(xx);
    if (not Data.HoldQuery.FieldByName('branch').IsNull) and
       (trim(Data.HoldQuery.FieldByName('branch').Value)<>'') then
    begin
      hold := hold+'$a'+Data.HoldQuery.fieldbyname('branch').Value;
// FIXME : Should be able to put description
    end;

    if (not Data.HoldQuery.FieldByName('collection').IsNull) and
       (trim(Data.HoldQuery.FieldByName('collection').Value)<>'')  then
    begin
      hold := hold+'$b'+Data.HoldQuery.fieldbyname('collection').Value;
// FIXME : Should be able to put description
    end;

    if (not Data.HoldQuery.FieldByName('cln').IsNull) and
       (trim(Data.HoldQuery.FieldByName('cln').Value)<>'')  then
    begin

      hold := hold+'$j'+Data.HoldQuery.fieldbyname('cln').Value;

      if (not Data.HoldQuery.FieldByName('cln_ip').IsNull) and
         (trim(Data.HoldQuery.FieldByName('cln_ip').Value)<>'')  then
      begin
        hold := hold+' '+Data.HoldQuery.fieldbyname('cln_ip').Value;
      end;
    end;

    if hold <> '8 ' then
    begin
      hold:='[852] '+hold;
      Lines.Add(hold);
    end;

    h853 := '';
    h863 := '';
    with  Data.HoldQuery do
    begin
      if (((not FieldByName('enum1').IsNull) and (trim(FieldByName('enum1').Value)<>'')) or
          ((not FieldByName('enum2').IsNull) and (trim(FieldByName('enum2').Value)<>'')) or
          ((not FieldByName('enum3').IsNull) and (trim(FieldByName('enum3').Value)<>'')) or
          ((not FieldByName('enum4').IsNull) and (trim(FieldByName('enum4').Value)<>'')) or
          ((not FieldByName('enum5').IsNull) and (trim(FieldByName('enum5').Value)<>'')) or
          ((not FieldByName('enum6').IsNull) and (trim(FieldByName('enum6').Value)<>'')) or
          ((not FieldByName('chrono1').IsNull) and (trim(FieldByName('chrono1').Value)<>'')) or
          ((not FieldByName('chrono2').IsNull) and (trim(FieldByName('chrono2').Value)<>'')) or
          ((not FieldByName('chrono3').IsNull) and (trim(FieldByName('chrono3').Value)<>'')) or
          ((not FieldByName('chrono4').IsNull) and (trim(FieldByName('chrono4').Value)<>''))) then
      begin
        if ((not FieldByName('enum1').IsNull) and (trim(FieldByName('enum1').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','1');
          if junk <> '' then h853 := h853+'$a'+junk;
          h863 := h863+'$a'+FieldByName('enum1').Value;
        end;
        if ((not FieldByName('enum2').IsNull) and (trim(FieldByName('enum2').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','2');
          if junk <> '' then h853 := h853+'$b'+junk;
          h863 := h863+'$b'+FieldByName('enum2').Value;
        end;
        if ((not FieldByName('enum3').IsNull) and (trim(FieldByName('enum3').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','3');
          if junk <> '' then h853 := h853+'$c'+junk;
          h863 := h863+'$c'+FieldByName('enum3').Value;
        end;
        if ((not FieldByName('enum4').IsNull) and (trim(FieldByName('enum4').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','4');
          if junk <> '' then h853 := h853+'$d'+junk;
          h863 := h863+'$d'+FieldByName('enum4').Value;
        end;
        if ((not FieldByName('enum5').IsNull) and (trim(FieldByName('enum5').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','5');
          if junk <> '' then h853 := h853+'$e'+junk;
          h863 := h863+'$e'+FieldByName('enum5').Value;
        end;
        if ((not FieldByName('enum6').IsNull) and (trim(FieldByName('enum6').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','6');
          if junk <> '' then h853 := h853+'$f'+junk;
          h863 := h863+'$f'+FieldByName('enum6').Value;
        end;
        if ((not FieldByName('chrono1').IsNull) and (trim(FieldByName('chrono1').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','1');
          if junk <> '' then h853 := h853+'$i'+junk;
          h863 := h863+'$i'+FieldByName('chrono1').Value;
        end;
        if ((not FieldByName('chrono2').IsNull) and (trim(FieldByName('chrono2').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','2');
          if junk <> '' then h853 := h853+'$j'+junk;
          h863 := h863+'$j'+FieldByName('chrono2').Value;
        end;
        if ((not FieldByName('chrono3').IsNull) and (trim(FieldByName('chrono3').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','3');
          if junk <> '' then h853 := h853+'$k'+junk;
          h863 := h863+'$k'+FieldByName('chrono3').Value;
        end;
        if ((not FieldByName('chrono4').IsNull) and (trim(FieldByName('chrono4').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','4');
          if junk <> '' then h853 := h853+'$l'+junk;
          h863 := h863+'$l'+FieldByName('chrono4').Value;
        end;
      end;
    end;

    if h853 <> '' then
    begin
      h853:='[853]   '+'$8'+inttostr(xx)+'.1'+h853;
      Lines.Add(h853);
    end;

    if h863 <> '' then
    begin
      h863:='[863]   '+'$8'+inttostr(xx)+'.1'+h863;
      Lines.Add(h863);
    end;

    if (not Data.HoldQuery.FieldByName('f866').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f866').Value)<>'')  then
    begin
      hold:='[866] '+' 0'+'$8'+inttostr(xx)+'.1$a';
      junk := Data.HoldQuery.GetBlob('f866').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
      Lines.Add(hold);
    end;

    if (not Data.HoldQuery.FieldByName('f867').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f867').Value)<>'')  then
    begin
      hold:='[867] '+' 0'+'$8'+inttostr(xx)+'.1$a';
      junk := Data.HoldQuery.GetBlob('f867').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
      Lines.Add(hold);
    end;

    if (not Data.HoldQuery.FieldByName('f868').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f868').Value)<>'')  then
    begin
      hold:='[868] '+' 0'+'$8'+inttostr(xx)+'.1$a';
      junk := Data.HoldQuery.GetBlob('f868').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
      Lines.Add(hold);
    end;

    holdon := data.HoldQuery.FieldByName('holdon').AsInteger;

    Data.ItemsQuery.Close;
    Data.ItemsQuery.ParamByName('holdon').AsInteger := holdon;
    Data.ItemsQuery.Open;
    itcnt := data.ItemsQuery.RecordCount;
    Data.ItemsQuery.First;

    for k := 1 to itcnt do
    begin
      item876 := '  '+'$8'+inttostr(xx)+'.'+inttostr(k);
//      hold:=basehold;
      //From Items
      if (not Data.ItemsQuery.FieldByName('barcode').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('barcode').Value)<>'')  then
      begin
        item876 := item876+'$p';
        junk := Data.ItemsQuery.fieldbyname('barcode').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then item876:=item876+junk[j];
      end;

      if (not Data.ItemsQuery.FieldByName('copy').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('copy').Value)<>'')  then
      begin
        item876 := item876+'$t';
        junk := Data.ItemsQuery.fieldbyname('copy').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then item876:=item876+junk[j];
      end;

{
      if (not Data.ItemsQuery.FieldByName('loan_category').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('loan_category').Value)<>'')  then
      begin
        item876 := item876+'$h';
        // Kosmas: Do not delete the comments bellow. Using codes instead of descriptions to reduce space...
        // in any case it should be changed to use the table from mysql
        junk := GetIniMappings('loancategory',Data.ItemsQuery.fieldbyname('loan_category').Value);
        if junk = '' then
        junk := Data.ItemsQuery.fieldbyname('loan_category').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then item876:=item876+junk[j];
      end;
}
      if (not Data.ItemsQuery.FieldByName('process_status').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('process_status').Value)<>'')  then
      begin
        item876 := item876+'$j';
        // Kosmas: Do not delete the comments bellow. Using codes instead of descriptions to reduce space...
        // in any case it should be changed to use the table from mysql
        junk := GetIniMappings('processstatus',Data.ItemsQuery.fieldbyname('process_status').Value);
        if junk='' then
        junk := Data.ItemsQuery.fieldbyname('process_status').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then item876:=item876+junk[j];
      end;

      //From items
      if (not Data.ItemsQuery.FieldByName('note_opac').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('note_opac').Value)<>'')  then
      begin
        item876 := item876+'$z';
        junk := Data.ItemsQuery.fieldbyname('note_opac').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then item876:=item876+junk[j];
      end;

    if item876 <> '  ' then
    begin
      item876:='[876] '+item876;
      Lines.Add(item876);
    end;
      Data.ItemsQuery.Next;
    end;

    Data.HoldQuery.Next;
  end;

  dmrc := disp2mrc(Lines,marcrec);

  chk.Free;
  Lines.Free;
  if length(marcrec)>=10 then marcrec[10]:='a';
  if length(marcrec)>=11 then marcrec[11]:='2';
  if length(marcrec)>=12 then marcrec[12]:='2';
  resrec:=marcrec;
  result := dmrc;
end;

function MakeMRCFromBasketEx_old (t: TCustomMyDataset; var resrec : UTF8String) : integer;
var
  Lines : TTntStringList;
  hold, basehold, fcln, fcln_ip, junk, temp : WideString;
  marcrec : UTF8String;
  tag : string;
  xx, yy, dpos, hcnt, itcnt, j, recno, holdon, k, dmrc : integer;
  FoundRecno : boolean;
  chk : TTntStringList;
begin
  resrec:='';
  Lines := TTntStringList.Create;
  Lines.Clear;

  recno := t.FieldByName('recno').AsInteger;

  Data.HoldQuery.Close;
  Data.HoldQuery.ParamByName('recno').AsInteger := recno;
  Data.HoldQuery.Open;

  marcrec := WideStringToString(t.GetBlob('text').AsWideString, Greek_codepage);

/////////////

  if marcrec <> '' then marcrecord2lines(marcrec,lines);
  FoundRecno := False;

  //Erasing holdings information from MARC
  for xx:=Lines.Count-1 downto 0 do
  begin
    tag := copy(Lines[xx],2,3);
    if ((tag='936') or (tag='084') ) then
       Lines.Delete(xx)
      else if (tag='001') then
      begin
        Lines[xx] :='[001] '+IntToStr(recno);
        FoundRecno := True;
      end;
  end;
  if (not FoundRecno)and(Lines.Count>1) Then Lines[1] :='[001] '+IntToStr(recno);

  hcnt:=Data.HoldQuery.RecordCount;
  Data.HoldQuery.First;

  chk := TTntStringList.Create;

  //Inserting holdings information in MARC
  for xx:= 1 to hcnt do
  begin
    //Building 084 tag
    fcln:='';
    fcln_ip:='';
    if not IsEmptyField(Data.HoldQuery, 'cln') then
    begin
      fcln := Data.HoldQuery.fieldbyname('cln').Value;
      temp := '  '+'$a'+fcln;
      if not IsEmptyField(Data.HoldQuery, 'cln_ip') then
      begin
        fcln_ip := Data.HoldQuery.fieldbyname('cln_ip').Value;
        temp := temp+'$b'+fcln_ip;
      end;
      dpos:=0;
      for yy:=Lines.Count-1 downto 0 do
      begin
        dpos := strtointdef(copy(Lines[yy],2,3),0);
        if ((dpos > 0) and (dpos <= 84)) then
        begin
          dpos:=yy+1;
          break;
        end;
        dpos :=0;
      end;

      if (dpos <> 0) then
        if chk.IndexOf(temp) < 0 then
        begin
          Lines.Insert(dpos,'[084] '+temp);
          chk.Add(temp);
        end;
    end;

    hold := '  ';
    if (not Data.HoldQuery.FieldByName('branch').IsNull) and
       (trim(Data.HoldQuery.FieldByName('branch').Value)<>'') then
    begin
      temp := Data.HoldQuery.fieldbyname('branch').Value;
      hold := hold+'$a'+temp;
    end;

    if (not Data.HoldQuery.FieldByName('collection').IsNull) and
       (trim(Data.HoldQuery.FieldByName('collection').Value)<>'')  then
    begin
      temp := Data.HoldQuery.fieldbyname('collection').Value;
      hold := hold+'$b'+temp;
    end;

    if (not Data.HoldQuery.FieldByName('cln').IsNull) and
       (trim(Data.HoldQuery.FieldByName('cln').Value)<>'')  then
    begin
      temp := Data.HoldQuery.fieldbyname('cln').Value;
      hold := hold+'$c'+temp;
    end;
    if (not Data.HoldQuery.FieldByName('cln_ip').IsNull) and
       (trim(Data.HoldQuery.FieldByName('cln_ip').Value)<>'')  then
    begin
      temp := Data.HoldQuery.fieldbyname('cln_ip').Value;
      hold := hold+'$c'+temp;
    end;


    if (not Data.HoldQuery.FieldByName('f868').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f868').Value)<>'')  then
    begin
      hold := hold+'$i';
      junk := Data.HoldQuery.GetBlob('f868').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
    end;

    if (not Data.HoldQuery.FieldByName('f867').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f867').Value)<>'')  then
    begin
      hold := hold+'$s';
      junk := Data.HoldQuery.GetBlob('f867').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
    end;

    if (not Data.HoldQuery.FieldByName('f866').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f866').Value)<>'')  then
    begin
      hold := hold+'$v';
      junk := Data.HoldQuery.GetBlob('f866').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
    end;


    holdon := data.HoldQuery.FieldByName('holdon').AsInteger;

    Data.ItemsQuery.Close;
    Data.ItemsQuery.ParamByName('holdon').AsInteger := holdon;
    Data.ItemsQuery.Open;
    itcnt := data.ItemsQuery.RecordCount;
    Data.ItemsQuery.First;
    basehold:=hold;
    for k := 1 to itcnt do
    begin
      hold:=basehold;
      //From Items
      if (not Data.ItemsQuery.FieldByName('barcode').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('barcode').Value)<>'')  then
      begin
        hold := hold+'$d';
        junk := Data.ItemsQuery.fieldbyname('barcode').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then hold:=hold+junk[j];
      end;

      if (not Data.ItemsQuery.FieldByName('copy').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('copy').Value)<>'')  then
      begin
        hold := hold+'$f';
        junk := Data.ItemsQuery.fieldbyname('copy').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then hold:=hold+junk[j];
      end;
      if (not Data.ItemsQuery.FieldByName('loan_category').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('loan_category').Value)<>'')  then
      begin
        hold := hold+'$g';
        // Kosmas: Do not delete the comments bellow. Using codes instead of descriptions to reduce space...
        // in any case it should be changed to use the table from mysql
        // junk := GetIniMappings('loancategory',Data.ItemsQuery.fieldbyname('loan_category').Value);
        // if junk = '' then
        junk := Data.ItemsQuery.fieldbyname('loan_category').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then hold:=hold+junk[j];
      end;
      if (not Data.ItemsQuery.FieldByName('process_status').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('process_status').Value)<>'')  then
      begin
        hold := hold+'$h';
        // Kosmas: Do not delete the comments bellow. Using codes instead of descriptions to reduce space...
        // in any case it should be changed to use the table from mysql
        // junk := GetIniMappings('processstatus',Data.ItemsQuery.fieldbyname('process_status').Value);
        // if junk='' then
        junk := Data.ItemsQuery.fieldbyname('process_status').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then hold:=hold+junk[j];
      end;

      //From items
      if (not Data.ItemsQuery.FieldByName('note_opac').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('note_opac').Value)<>'')  then
      begin
        hold := hold+'$z';
        junk := Data.ItemsQuery.fieldbyname('note_opac').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then hold:=hold+junk[j];
      end;

    if hold <> '  ' then
    begin
      hold:='[936] '+hold;
      Lines.Add(hold);
    end;
      Data.ItemsQuery.Next;
    end;

    Data.HoldQuery.Next;
  end;

  dmrc := disp2mrc(Lines,marcrec);

  chk.Free;
  Lines.Free;
  if length(marcrec)>=10 then marcrec[10]:='a';
  if length(marcrec)>=11 then marcrec[11]:='2';
  if length(marcrec)>=12 then marcrec[12]:='2';
  resrec:=marcrec;
  result := dmrc;
end;

function MakeMRCFromBasket (var resrec : UTF8String) : integer;
begin
 result:= MakeMRCFromBasketEx(Data.basket, resrec);
end;

function MakeMRCFromBasket : UTF8String;
begin
 MakeMRCFromBasket(result);
end;

function MakeMRCFromSecureBasket(recno : integer; var resrec : UTF8String) : integer;
begin
  with data do
  begin
    LastDataFromBasket.Close;
    LastDataFromBasket.ParamByName('recno').AsInteger := recno;
    LastDataFromBasket.Open;
    if lastdatafrombasket.RecordCount <> 0 then
      result:= MakeMRCFromBasketEx(LastDataFromBasket, resrec)
    else
    begin
      resrec:='';
      result:=-1;
    end;
  end;
end;

function MakeMRCFromSecureBasket(recno : integer) : UTF8String;
begin
  MakeMRCFromSecureBasket(recno, result);
end;

//FIXME : Problem with very long fields...
function MakeMRCFromBasketExforKOHA (t: TCustomMyDataset; var resrec : UTF8String) : integer;
var
  Lines : TTntStringList;
  kohaitemtype,
  hold, basehold, i952, h952, fcln, fcln_ip, junk, temp : WideString;
  marcrec : UTF8String;
  tag : string;
  xx, yy, dpos, hcnt, itcnt, j, recno, holdon, k, dmrc : integer;
  FoundRecno : boolean;
  chk : TTntStringList;
begin
  resrec:='';
  Lines := TTntStringList.Create;
  Lines.Clear;

  recno := t.FieldByName('recno').AsInteger;

  Data.HoldQuery.Close;
  Data.HoldQuery.ParamByName('recno').AsInteger := recno;
  Data.HoldQuery.Open;

  marcrec := WideStringToString(t.GetBlob('text').AsWideString, Greek_codepage);

  kohaitemtype := koha_item_type(marcrec);

  if marcrec <> '' then marcrecord2lines(marcrec,lines);
  FoundRecno := False;

  //Erasing holdings information from MARC
  for xx:=Lines.Count-1 downto 0 do
  begin
    tag := copy(Lines[xx],2,3);
    if ((tag='936') or (tag='084')or (tag='952') or (tag='852') or (tag='853') or (tag='863') or (tag='866')or (tag='867')or (tag='868')or (tag='876')) then
      Lines.Delete(xx)
    else if (tag='001') then
    begin
      Lines[xx] :='[001] '+IntToStr(recno);
      FoundRecno := True;
    end;
  end;
  if (not FoundRecno)and(Lines.Count>1) Then Lines[1] :='[001] '+IntToStr(recno);

  hcnt:=Data.HoldQuery.RecordCount;
  Data.HoldQuery.First;

  chk := TTntStringList.Create;

  //Inserting holdings and items information in MARC 952
  for xx:= 1 to hcnt do
  begin
    //Building 084 tag
    fcln:='';
    fcln_ip:='';

    if not IsEmptyField(Data.HoldQuery, 'cln') then
    begin
      fcln := Data.HoldQuery.fieldbyname('cln').Value;
      temp := '  '+'$a'+fcln;
      if not IsEmptyField(Data.HoldQuery, 'cln_ip') then
      begin
        fcln_ip := Data.HoldQuery.fieldbyname('cln_ip').Value;
        temp := temp+'$b'+fcln_ip;
      end;
      dpos:=0;
      for yy:=Lines.Count-1 downto 0 do
      begin
        dpos := strtointdef(copy(Lines[yy],2,3),0);
        if ((dpos > 0) and (dpos <= 84)) then
        begin
          dpos:=yy+1;
          break;
        end;
        dpos :=0;
      end;

      if (dpos <> 0) then
        if chk.IndexOf(temp) < 0 then
        begin
          Lines.Insert(dpos,'[084] '+temp);
          chk.Add(temp);
        end;
    end;

    h952 := '  ';

    if (not Data.HoldQuery.FieldByName('branch').IsNull) and
       (trim(Data.HoldQuery.FieldByName('branch').Value)<>'') then
    begin
      h952 := h952+'$a'+Data.HoldQuery.fieldbyname('branch').Value;
      h952 := h952+'$b'+Data.HoldQuery.fieldbyname('branch').Value;
    end;

    if (not Data.HoldQuery.FieldByName('collection').IsNull) and
       (trim(Data.HoldQuery.FieldByName('collection').Value)<>'')  then
    begin
      h952 := h952+'$8'+Data.HoldQuery.fieldbyname('collection').Value;
    end;

    fcln:='';

    if (not Data.HoldQuery.FieldByName('cln').IsNull) and
       (trim(Data.HoldQuery.FieldByName('cln').Value)<>'')  then
    begin
      fcln := Data.HoldQuery.fieldbyname('cln').Value;

      if (not Data.HoldQuery.FieldByName('cln_ip').IsNull) and
         (trim(Data.HoldQuery.FieldByName('cln_ip').Value)<>'')  then
      begin
        fcln := fcln+' '+Data.HoldQuery.fieldbyname('cln_ip').Value;
      end;
      h952 := h952+'$j'+fcln;
      h952 := h952+'$o'+fcln;  // FIXME : is this correct?
    end;

    h952 := h952+'$90'; // Withdrawn status (default value)
    h952 := h952+'$40'; // Damaged status (default value)
    h952 := h952+'$y'+kohaitemtype;

{
    if hold <> '  ' then
    begin
      hold:='[852] '+hold;
      Lines.Add(hold);
    end;
}
    temp := '';
    with  Data.HoldQuery do
    begin
      if (((not FieldByName('enum1').IsNull) and (trim(FieldByName('enum1').Value)<>'')) or
          ((not FieldByName('enum2').IsNull) and (trim(FieldByName('enum2').Value)<>'')) or
          ((not FieldByName('enum3').IsNull) and (trim(FieldByName('enum3').Value)<>'')) or
          ((not FieldByName('enum4').IsNull) and (trim(FieldByName('enum4').Value)<>'')) or
          ((not FieldByName('enum5').IsNull) and (trim(FieldByName('enum5').Value)<>'')) or
          ((not FieldByName('enum6').IsNull) and (trim(FieldByName('enum6').Value)<>'')) or
          ((not FieldByName('chrono1').IsNull) and (trim(FieldByName('chrono1').Value)<>'')) or
          ((not FieldByName('chrono2').IsNull) and (trim(FieldByName('chrono2').Value)<>'')) or
          ((not FieldByName('chrono3').IsNull) and (trim(FieldByName('chrono3').Value)<>'')) or
          ((not FieldByName('chrono4').IsNull) and (trim(FieldByName('chrono4').Value)<>''))) then
      begin
        if ((not FieldByName('enum1').IsNull) and (trim(FieldByName('enum1').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','1');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('enum1').Value;
        end;
        if ((not FieldByName('enum2').IsNull) and (trim(FieldByName('enum2').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','2');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('enum2').Value;
        end;
        if ((not FieldByName('enum3').IsNull) and (trim(FieldByName('enum3').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','3');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('enum3').Value;
        end;
        if ((not FieldByName('enum4').IsNull) and (trim(FieldByName('enum4').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','4');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('enum4').Value;
        end;
        if ((not FieldByName('enum5').IsNull) and (trim(FieldByName('enum5').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','5');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('enum5').Value;
        end;
        if ((not FieldByName('enum6').IsNull) and (trim(FieldByName('enum6').Value)<>'')) then
        begin
          junk := GetIniMappings('enumeration','6');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('enum6').Value;
        end;

        if ((not FieldByName('chrono1').IsNull) and (trim(FieldByName('chrono1').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','1');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('chrono1').Value;
        end;
        if ((not FieldByName('chrono2').IsNull) and (trim(FieldByName('chrono2').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','2');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('chrono2').Value;
        end;
        if ((not FieldByName('chrono3').IsNull) and (trim(FieldByName('chrono3').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','3');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('chrono3').Value;
        end;
        if ((not FieldByName('chrono4').IsNull) and (trim(FieldByName('chrono4').Value)<>'')) then
        begin
          junk := GetIniMappings('chronology','4');
          if junk <> '' then temp := temp+junk;
          temp := ' '+temp+' '+FieldByName('chrono4').Value;
        end;
        temp:=squeeze(temp);
      end;
    end;
    if (temp <> '') then
    begin
      h952 := h952+'$h'+temp;
    end;

    if (not Data.HoldQuery.FieldByName('f866').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f866').Value)<>'')  then
    begin
      hold:='[866] '+' 0'+'$a';
      junk := Data.HoldQuery.GetBlob('f866').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
      Lines.Add(hold);
    end;

    if (not Data.HoldQuery.FieldByName('f867').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f867').Value)<>'')  then
    begin
      hold:='[867] '+' 0'+'$a';
      junk := Data.HoldQuery.GetBlob('f867').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
      Lines.Add(hold);
    end;

    if (not Data.HoldQuery.FieldByName('f868').IsNull) and
       (trim(Data.HoldQuery.FieldByName('f868').Value)<>'')  then
    begin
      hold:='[868] '+' 0'+'$a';
      junk := Data.HoldQuery.GetBlob('f868').AsWideString;
      for j:=1 to length(junk) do
        if (ord(junk[j])>31) then hold:=hold+junk[j];
      Lines.Add(hold);
    end;

    holdon := data.HoldQuery.FieldByName('holdon').AsInteger;

    Data.ItemsQuery.Close;
    Data.ItemsQuery.ParamByName('holdon').AsInteger := holdon;
    Data.ItemsQuery.Open;
    itcnt := data.ItemsQuery.RecordCount;
    Data.ItemsQuery.First;

    for k := 1 to itcnt do
    begin
      i952 := h952;
      //From Items
      if (not Data.ItemsQuery.FieldByName('barcode').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('barcode').Value)<>'')  then
      begin
        i952 := i952+'$p';
        junk := Data.ItemsQuery.fieldbyname('barcode').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then i952:=i952+junk[j];
      end;

      if (not Data.ItemsQuery.FieldByName('copy').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('copy').Value)<>'')  then
      begin
        i952 := i952+'$t';
        junk := Data.ItemsQuery.fieldbyname('copy').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then i952:=i952+junk[j];
      end;
{
// FIXME KOHA
      if (not Data.ItemsQuery.FieldByName('loan_category').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('loan_category').Value)<>'')  then
      begin
        i952 := i952+'$h';
        // Kosmas: Do not delete the comments bellow. Using codes instead of descriptions to reduce space...
        // in any case it should be changed to use the table from mysql
        junk := GetIniMappings('loancategory',Data.ItemsQuery.fieldbyname('loan_category').Value);
        if junk = '' then
        junk := Data.ItemsQuery.fieldbyname('loan_category').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then i952:=i952+junk[j];
      end;

// FIXME KOHA
      if (not Data.ItemsQuery.FieldByName('process_status').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('process_status').Value)<>'')  then
      begin
        i952 := i952+'$j';
        // Kosmas: Do not delete the comments bellow. Using codes instead of descriptions to reduce space...
        // in any case it should be changed to use the table from mysql
        junk := GetIniMappings('processstatus',Data.ItemsQuery.fieldbyname('process_status').Value);
        if junk='' then
        junk := Data.ItemsQuery.fieldbyname('process_status').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then i952:=i952+junk[j];
      end;
}
      //From items
      if (not Data.ItemsQuery.FieldByName('note_opac').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('note_opac').Value)<>'')  then
      begin
        i952 := i952+'$z';
        junk := Data.ItemsQuery.fieldbyname('note_opac').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then i952:=i952+junk[j];
      end;
      if (not Data.ItemsQuery.FieldByName('note_internal').IsNull) and
         (trim(Data.ItemsQuery.FieldByName('note_internal').Value)<>'')  then
      begin
        i952 := i952+'$x';
        junk := Data.ItemsQuery.fieldbyname('note_internal').Value;
        for j:=1 to length(junk) do
          if (ord(junk[j])>31) then i952:=i952+junk[j];
      end;

      if i952 <> '  ' then
      begin
        i952:='[952] '+i952;
        Lines.Add(i952);
      end;
      Data.ItemsQuery.Next;
    end;

    Data.HoldQuery.Next;
  end;

  dmrc := disp2mrc(Lines,marcrec);

  chk.Free;
  Lines.Free;
  if length(marcrec)>=10 then marcrec[10]:='a';
  if length(marcrec)>=11 then marcrec[11]:='2';
  if length(marcrec)>=12 then marcrec[12]:='2';
  resrec:=marcrec;
  result := dmrc;
end;

function MakeMRCFromSecureBasketforKOHA(recno : integer; var resrec : UTF8String) : integer;
begin
  with data do
  begin
    LastDataFromBasket.Close;
    LastDataFromBasket.ParamByName('recno').AsInteger := recno;
    LastDataFromBasket.Open;
    if lastdatafrombasket.RecordCount <> 0 then
      result:= MakeMRCFromBasketExforKOHA(LastDataFromBasket, resrec)
    else
    begin
      resrec:='';
      result:=-1;
    end;
  end;
end;

function MakeMRCFromSecureBasketforKOHA(recno : integer) : UTF8String;
begin
  MakeMRCFromSecureBasketforKOHA(recno, result);
end;

function MakeMRCFromAuth(recno : integer; var resrec : UTF8String) : integer;
begin
  with data do
  begin
    Auth.Close;
    Auth.ParamByName('recno').AsInteger := recno;
    Auth.Open;
    if Auth.RecordCount <> 0 then
    begin
      resrec := WideStringToString(auth.GetBlob('text').AsWideString, Greek_codepage);
      result := 1;
    end
    else
    begin
      resrec:='';
      result:=-1;
    end;
  end;
end;

function MakeMRCFromAuth(recno : integer) : UTF8String;
begin
  MakeMRCFromAuth(recno, result);
end;


// FIXME : Check if this function is correct to be called or the MAkeMRCFromSecureBasket should
//         be called instead.
function GetLastDataFromBasket(recno : integer) : UTF8String;
begin

  with data do
  begin
    LastDataFromBasket.Close;
    LastDataFromBasket.ParamByName('recno').AsInteger := recno;
    LastDataFromBasket.Open;
    if lastdatafrombasket.RecordCount <> 0 then
      Result := WideStringToString(LastDataFromBasket.GetBlob('text').AsWideString, Greek_codepage)
    else
      Result := '';
  end;

end;

function GetLastDataFromAuth(recno : integer) : UTF8String;
begin

  with data do
  begin
    LastDataFromAuth.Close;
    LastDataFromAuth.ParamByName('recno').AsInteger := recno;
    LastDataFromAuth.Open;
    if lastdatafromAuth.RecordCount <> 0 then
      Result := WideStringToString(LastDataFromAuth.GetBlob('text').AsWideString, Greek_codepage)
    else
      Result := '';
  end;

end;

function mkwellform_xml(s : string) :string;
var i,o : integer;
begin
 result:='';
 for i:=1 to length(s) do
 begin
  o := ord(s[i]);
  if ((o >= 0) and (o <= 31)) then
  begin
   if ((o <> 9) and (o <> 10) and (o <> 13)) then
    continue;
  end;
  case s[i] of
   '<' : result:=result+'&lt;';
   '>' : result:=result+'&gt;';
   '&' : result:=result+'&amp;';
   '"' : result:=result+'&quot;';
   '''': result:=result+'&apos;';
   '$' : result:=result+'&#036;';
   else result:=result+s[i];
  end;
 end;
end;


// In order to be valid xml a makewellformed xml should be called...
// remove_crlf should be called only for fields that in UI are edited with memo fields.
function ExportXMLInternal(addnewlines : boolean): UTF8String;
var
  temp : UTF8String;
  xx, hcnt, recno: integer;
begin
  result:='<internal>';
  if addnewlines then result:=result+#13#10;
  result:=result+'<basket>';
  if addnewlines then result:=result+#13#10;

  recno := Data.basket.FieldByName('recno').AsInteger;
  result:=result+'<recno>'+inttostr(recno)+'</recno>';
  if addnewlines then result:=result+#13#10;

  if (not Data.basket.FieldByName('text').IsNull) then
  begin
    temp := WideStringToString(data.Basket.GetBlob('text').AsWideString, Greek_codepage);
    temp := marc2marcxml(temp,addnewlines);
  end
  else temp:='';
  result:=result+'<text>'+temp+'</text>';
  if addnewlines then result:=result+#13#10;

  if (not Data.basket.FieldByName('format').IsNull) then
    temp := Data.basket.fieldbyname('format').AsString
  else temp:='';
  result:=result+'<format>'+temp+'</format>';
  if addnewlines then result:=result+#13#10;

  if (not Data.basket.FieldByName('level').IsNull) then
    temp := Data.basket.fieldbyname('level').AsString
  else temp:='';
  result:=result+'<level>'+temp+'</level>';
  if addnewlines then result:=result+#13#10;

  if (not Data.basket.FieldByName('creator').IsNull) then
    temp := Data.basket.fieldbyname('creator').AsString
  else temp:='';
  result:=result+'<creator>'+temp+'</creator>';
  if addnewlines then result:=result+#13#10;

  if (not Data.basket.FieldByName('modifier').IsNull) then
    temp := Data.basket.fieldbyname('modifier').AsString
  else temp:='';
  result:=result+'<modifier>'+temp+'</modifier>';
  if addnewlines then result:=result+#13#10;

  if (not Data.basket.FieldByName('created').IsNull) then
    temp := Data.basket.fieldbyname('created').AsString
  else temp:='';
  result:=result+'<created>'+temp+'</created>';
  if addnewlines then result:=result+#13#10;

  if (not Data.basket.FieldByName('modified').IsNull) then
    temp := Data.basket.fieldbyname('modified').AsString
  else temp:='';
  result:=result+'<modified>'+temp+'</modified>';
  if addnewlines then result:=result+#13#10;

  result:=result+'</basket>';
  if addnewlines then result:=result+#13#10;


  Data.hold.Close;
  Data.hold.Open;

/////////////

  hcnt:=Data.hold.RecordCount;
  if hcnt > 0 then
  begin
    result:=result+'<hold count="'+inttostr(hcnt)+'">';
    if addnewlines then result:=result+#13#10;
    Data.hold.First;

    for xx:= 1 to hcnt do
    begin
      result:=result+'<holdrec id="'+inttostr(xx)+'">';
      if addnewlines then result:=result+#13#10;

      temp := Data.hold.fieldbyname('holdon').asstring;
      result:=result+'<holdon>'+temp+'</holdon>';
      if addnewlines then result:=result+#13#10;

      if (not Data.hold.FieldByName('branch').IsNull) then
        temp := Data.hold.fieldbyname('branch').Value
      else temp:='';
      result:=result+'<branch>'+temp+'</branch>';
      if addnewlines then result:=result+#13#10;

      if (not Data.hold.FieldByName('collection').IsNull) then
          temp := Data.hold.fieldbyname('collection').Value
      else temp:='';
      result:=result+'<collection>'+temp+'</collection>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('cln').IsNull = false) then
        temp := Data.hold.fieldbyname('cln').Value
      else temp:='';
      result:=result+'<cln>'+mkwellform_xml(temp)+'</cln>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('cln_ip').IsNull = false) then
        temp := Data.hold.fieldbyname('cln_ip').Value
      else temp:='';
      result:=result+'<cln_ip>'+mkwellform_xml(temp)+'</cln_ip>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('item').IsNull = false) then
        temp := Data.hold.fieldbyname('item').Value
      else temp:='';
      temp:=WideStringToUTF8String(remove_crlf(UTF8StringToWideString(mkwellform_xml(temp))));
      result:=result+'<item>'+temp+'</item>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('f866').IsNull = false) then
        temp := Data.hold.fieldbyname('f866').Value
      else temp:='';
      temp:=WideStringToUTF8String(remove_crlf(UTF8StringToWideString(mkwellform_xml(temp))));
      result:=result+'<f866>'+temp+'</f866>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('f867').IsNull = false) then
        temp := Data.hold.fieldbyname('f867').Value
      else temp:='';
      temp:=WideStringToUTF8String(remove_crlf(UTF8StringToWideString(mkwellform_xml(temp))));
      result:=result+'<f867>'+temp+'</f867>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('f868').IsNull = false) then
        temp := Data.hold.fieldbyname('f868').Value
      else temp:='';
      temp:=WideStringToUTF8String(remove_crlf(UTF8StringToWideString(mkwellform_xml(temp))));
      result:=result+'<f868>'+temp+'</f868>';
      if addnewlines then result:=result+#13#10;

// FIXME : This is not supposed to come from hold but from items...

      if (Data.hold.FieldByName('copy').IsNull = false) then
        temp := Data.hold.fieldbyname('copy').Value
      else temp:='';
      temp:=WideStringToUTF8String(remove_crlf(UTF8StringToWideString(mkwellform_xml(temp))));
      result:=result+'<copy>'+temp+'</copy>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('loan_category').IsNull = false) then
        temp := Data.hold.fieldbyname('loan_category').Value
      else temp:='';
      result:=result+'<loan_category>'+temp+'</loan_category>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('process_status').IsNull = false) then
        temp := Data.hold.fieldbyname('process_status').Value
      else temp:='';
      result:=result+'<process_status>'+temp+'</process_status>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('datecreated').IsNull = false) then
        temp := Data.hold.fieldbyname('datecreated').asstring
      else temp:='';
      result:=result+'<datecreated>'+temp+'</datecreated>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('datearrived').IsNull = false) then
        temp := Data.hold.fieldbyname('datearrived').asstring
      else temp:='';
      result:=result+'<datearrived>'+temp+'</datearrived>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('note_opac').IsNull = false) then
        temp := Data.hold.fieldbyname('note_opac').Value
      else temp:='';
      temp:=WideStringToUTF8String(remove_crlf(UTF8StringToWideString(mkwellform_xml(temp))));
      result:=result+'<note_opac>'+temp+'</note_opac>';
      if addnewlines then result:=result+#13#10;

      if (Data.hold.FieldByName('note_internal').IsNull = false) then
        temp := Data.hold.fieldbyname('note_internal').Value
      else temp:='';
      temp:=WideStringToUTF8String(remove_crlf(UTF8StringToWideString(mkwellform_xml(temp))));
      result:=result+'<note_internal>'+temp+'</note_internal>';
      if addnewlines then result:=result+#13#10;

      result:=result+'</holdrec>';
      if addnewlines then result:=result+#13#10;
      Data.hold.Next;
    end;

    result:=result+'</hold>';
    if addnewlines then result:=result+#13#10;
  end;

  result:=result+'</internal>';
  if addnewlines then result:=result+#13#10;
end;


procedure append_fields(source,stag:WideString; var dir: UTF8String; var dirpos : integer; var marcrec:WideString);
var i, numoffields_s, p,base_s, start, leng : integer;
 hlp,tag,text : WideString;
begin
 hlp := copy(source,13,5);
 base_s := strtoint(hlp);
 numoffields_s := (base_s - 1 -24) div 12;
 p := 25;
 for i:=1 to numoffields_s do
 begin
  hlp := copy(source,p,12);
  tag := copy(hlp,1,3);
  leng:=strtoint(copy(hlp,4,4));
  start:=base_s+strtoint(copy(hlp,8,5));
  text := copy(source,start+1,leng);
  if (tag =stag) then
  begin
   adddirentry(dir,tag,length(text),dirpos);
   dirpos := dirpos+length(text);
   marcrec := marcrec+text;
  end;
  p:=p+12;
 end;

end;

function get_field(s,sfd : string; var f: string; which : integer) : string;
var i:integer;
 flag : boolean;
 r:string;
 current: integer;
begin
 flag:=false;
 r:='';
 i:=1;
 current:=0;
 f:='';
 while i <= length(s) do
 begin
  if s[i] = sfd then
  begin
   current:=current+1;
   if current = which then flag := true
   else if current > which then break;
   i:=i+1;
   f:=s[i];
  end
  else
  begin
   if flag=true then r:=r+s[i];
  end;
  i:=i+1;
 end;
 result:=r;
end;

function extract_field(s : WideString; f: WideString; which : integer; keepsfd : boolean) : WideString;
var i:integer;
 cf : WideChar;
 flag : boolean;
 r:WideString;
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

function extract_fields(s : string; f: string) : string;
begin
  result:=extract_fields(s, f, #31);
end;

function extract_fields(s : string; f: string; delim : char) : string;
var i:integer;
 cf : char;
 flag : boolean;
 r:string;
begin
 flag:=false;
 r:='';
 i:=1;
 while i <= length(s) do
 begin
  if s[i] = delim then
  begin
   i:=i+1;
   cf := s[i];
   if (pos(cf,f)>0) then
   begin
    flag :=true;
    r:=r+' ';
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
 if (r <>'') then r:= copy(r,2,length(r));
 result := r;
end;

procedure get_controlfieldtext(rec : UTF8String; tag,posit : string; var text:WideString);
var
  i, fl,ind, base,nf : integer;
  direntry, junk : WideString;
  start,len : integer;
begin
 if rec = '' Then exit;

 text:='';
 junk := copy(rec,13,5);
 if not TryStrToInt(junk, base) Then exit;
 nf := (base-1-24)div 12;
 for i:=1 to nf do
 begin
  direntry:=copy(rec,25+(i-1)*12,12);
  fl := strtoint(copy(direntry,4,4));
  ind := strtoint(copy(direntry,8,5));
  if (copy(direntry,1,3) = tag) then
   text := UTF8StringToWideString(copy(rec,base+ind+1,fl-1));
//    text := StringtoWideString(copy(rec,base+ind+1,fl-1),Greek_codepage);
 end;
 if text <> '' then
 begin
  start:=strtoint(copy(posit,1,pos('-',posit)-1));
  len:=strtoint(copy(posit,pos('-',posit)+1,length(posit)));
  text := copy(text,start,len);
 end;
end;

procedure get_fieldtext(rec : UTF8String; tag,subfields : string; var text : WideString; which: integer = 0);
var
  i, fl,ind, base,nf : integer;
  direntry, junk : WideString;
begin
 if rec = '' Then exit;

 text:='';
 junk := copy(rec,13,5);
 if not TryStrToInt(junk, base) Then exit;
 nf := (base-1-24)div 12;
 for i:=1 to nf do
 begin
  direntry:=copy(rec,25+(i-1)*12,12);
  fl := strtoint(copy(direntry,4,4));
  ind := strtoint(copy(direntry,8,5));
  if (copy(direntry,1,3) = tag) then
    text := UTF8StringToWideString(copy(rec,base+ind+3,fl-3));
//    text := StringtoWideString(copy(rec,base+ind+3,fl-3),Greek_codepage);
 end;
 text := extract_field(text,subfields,0,false);
end;

procedure get_author_title(rec: UTF8String; format : string; var author, title:WideString; adddate : boolean);
var
  i, fl,ind, base,nf : integer;
  direntry : WideString;
  junk,fields : string;
begin
 author:='';  title:='';

 if rec = '' then exit;

 junk := copy(rec,13,5);
 if not TryStrToInt(junk, base) Then exit;

 nf := (base-1-24)div 12;
 format := uppercase(format);
 for i:=1 to nf do
 begin
  direntry:=copy(rec,25+(i-1)*12,12);
  fl := strtoint(copy(direntry,4,4));
  ind := strtoint(copy(direntry,8,5));
  if (format = 'USMARC') then
  begin
   fields:='a';
   if adddate=true then fields := 'ad';
   if ((copy(direntry,1,3) = '100') or (copy(direntry,1,3) = '110') or (copy(direntry,1,3) = '111')) then
     //author := UTF8Decode(copy(rec,base+ind+3,fl-3));
     author := UTF8StringToWideString(copy(rec,base+ind+3,fl-3));
//?author :=StringToWideString(copy(rec,base+ind+3,fl-3),Greek_codepage);
   if (copy(direntry,1,3) = '245') then
//     title := UTF8Decode(copy(rec,base+ind+3,fl-3));
     title := UTF8StringToWideString(copy(rec,base+ind+3,fl-3));
//?title :=StringToWideString(copy(rec,base+ind+3,fl-3),Greek_codepage);
  end
  else
  if format = 'UNIMARC' then
  begin
   fields:='abd';
   if adddate=true then fields := 'abdf';
   if ((copy(direntry,1,3) = '700') or (copy(direntry,1,3) = '710') or (copy(direntry,1,3) = '720')) then
     author := UTF8StringToWideString(copy(rec,base+ind+3,fl-3));
//?author :=StringToWideString(copy(rec,base+ind+3,fl-3),Greek_codepage);
   if (copy(direntry,1,3) = '200') then
     title := UTF8StringToWideString(copy(rec,base+ind+3,fl-3));
//?title :=StringToWideString(copy(rec,base+ind+3,fl-3),Greek_codepage);
  end;
 end;
 author := extract_field(author,fields,0,false);
 title := extract_field(title,'a',0,false);
end;

procedure get_main_heading(rec: UTF8String; var tag, heading:WideString);
var
  i, fl,ind, base,nf : integer;
  direntry : WideString;
  junk,fields : string;
begin
 tag:='';  heading:='';

 if rec = '' then exit;

 junk := copy(rec,13,5);
 if not TryStrToInt(junk, base) Then exit;

 nf := (base-1-24)div 12;
 fields := 'abcdefghijklmnopqrstuvwxyz';
 for i:=1 to nf do
 begin
  direntry:=copy(rec,25+(i-1)*12,12);
  fl := strtoint(copy(direntry,4,4));
  ind := strtoint(copy(direntry,8,5));
  if (copy(direntry,1,1) = '1') then
  begin
     tag := copy(direntry,1,3);
     heading := UTF8StringToWideString(copy(rec,base+ind+3,fl-3));
     break;
  end;
 end;
 heading := extract_field(heading,fields,0,false);
end;

procedure get_main_heading_from_memo(fullrec : TTntMemo; var tag, ind, heading : WideString);
var p : integer;
    htag : WideString;
begin
 tag := '';
 ind := '';
 heading := '';
 for p:=0 to fullrec.Lines.Count-1 do
 begin
  htag := copy(fullrec.Lines[p],2,3);
  if (copy(htag,1,1) <> '1') then
   continue
  else
  begin
    tag := htag;
    ind := copy(fullrec.Lines[p],7,2);
    heading := copy(fullrec.Lines[p],9,length(fullrec.Lines[p]));
    break;
  end;
 end;
end;

function merge_mrcs(source, retrieved : WideString): WideString;
var
  tag, hlp, junk, marcrec, curdate, leader, ptag : WideString;
  dir : UTF8String;
  i, dirpos : integer;
  TempDateFormat : string;
const
  taglist = ',090,500,';

begin
 TempDateFormat := ShortDateFormat;
 ShortDateFormat := 'yymmdd';
 curdate := datetostr(Date);
 marcrec := '';
 dir:='';
 dirpos := 0;
 ptag := '001';
 leader := copy(source,1,24);

 for i:=1 to 899 do
 begin
  tag := WideFormat('%.3d',[i]);
  if ((tag<>'008') and (tag<>'100')) then
   append_fields(source,tag,dir,dirpos,marcrec);
  if ((tag <> '001') and (tag <> '003') and (tag <>'005')) then
   append_fields(retrieved,tag,dir,dirpos,marcrec);
 end;

 append_fields(source,'936',dir,dirpos,marcrec);

// #29 Record Terminator #30 Field Terminator #31 Subfield Delimiter.

 marcrec:=leader+dir+#30+marcrec+#29;
 hlp:=leader+dir+#30;
 i:=length(hlp);
 junk:=WideFormat('%.5d',[i]);
 for i:=1 to 5 do
  marcrec[12+i]:=junk[i];
 i:=length(marcrec);
 junk:=WideFormat('%.5d',[i]);
 for i:=1 to 5 do
  marcrec[i]:=junk[i];
 result := marcrec;

 ShortDateFormat := TempDateFormat;
end;


function is_mixed_greek_latin_word(s , Greek: WideString) : boolean;
var what1,what2, gpos, i : integer;
begin
 result:=true;
 what1 := 0;
 what2:=0;
 for i:=1 to length(s) do
 begin
   gpos:=pos(s[i],Greek);
   if ( gpos > 0 ) then
    what1:=what1+1
   else
    what2:=what2+1;
 end;
 if ((what1 = 0) or (what2 = 0)) then
  result:=false;
end;

function extract_mixed_greek_latin_words(s, Greek : WideString) : Widestring;
type
  Pstackrec = ^stackrec;
  stackrec = record
   subject : Widestring;
   next : Pstackrec;
  end;

var i : integer;
  wrd : Widestring;
   sc : Pstackrec;


function lookupstack(s : WideString) : boolean;
var t : Pstackrec;
begin
 result:=false;
 t:=sc;
 while ((t <> nil) and (result = false)) do
 begin
  if (t^.subject = s) then
   result:=true;
  t:=t^.next;
 end;
end;

function popstack : Widestring;
var t : Pstackrec;
begin
 if sc <> nil then
 begin
  result:=sc^.subject;
  t:=sc^.next;
  dispose(sc);
  sc:=t;
 end
 else
  result := '';
end;

procedure pushstack(s : WideString);
var t : Pstackrec;
begin
 new(t);
 t^.next := sc;
 t^.subject:=s;
 sc:=t;
end;

procedure emptystack;
var t : Pstackrec;
begin
 t:=sc;
 while t <> nil do
 begin
  t:=t^.next;
  Dispose(sc);
  sc:=t;
 end;
 sc:=nil;
end;

procedure initstack;
begin
 sc:=nil;
end;

begin
 result:='';
 initstack;
 wrd:='';
 for i:=1 to length(s) do
 begin
  if (pos(s[i],widestring(PUNCTUATION+' '))<=0) then
   wrd:=wrd+s[i]
  else
   if wrd<>'' then
   begin
    if is_mixed_greek_latin_word(wrd, Greek) = true then
     if lookupstack(wrd) = false then
      pushstack(wrd);
    wrd:='';
    end;
 end;
 if wrd<>'' then
  if is_mixed_greek_latin_word(wrd, Greek) = true then
   if lookupstack(wrd) = false then
    pushstack(wrd);
 wrd := popstack;
 while (wrd <> '') do
 begin
   result:=result+','+wrd;
   wrd := popstack;
 end;
 if result<>'' then result:=copy(result,2,length(result));
 emptystack;
end;

function remove_crlf(s:WideString) : WideString;
var i,f: integer;
begin
 result:='';
 f:=0;
 for i:=1 to length(s) do
 begin
  if ((s[i] = #13) or (s[i] = #10)) then
   f:=1
  else
  begin
   if (f = 1) then
   begin
    if (s[i]<>' ') then result:=result+' ';
    f:=0;
   end;
   result:=result+s[i];
  end;
 end;
end;

function trimlead(s:WideString) : WideString;
var r:WideString;
    i:integer;
begin
 i:=1;
 while ((i<=length(s)) and (s[i] = ' ')) do i:=i+1;
 while (i<=length(s)) do begin r:=r+s[i]; i:=i+1; end;
 result:=r;
end;

function stripchars(s,t: WideString): Widestring;
var i : integer;
begin
 result:='';
 for i:=1 to length(s) do
 begin
  if (pos(s[i],widestring(t))<=0) then
   result:=result+s[i];
 end;
 result:=squeeze(result);
end;

procedure strip_sfd(var s : WideString);
var junk : WideString;
 i:integer;
begin
 junk := '';
 i:=1;
 while i <= length(s) do
 begin
  if s[i] = #31 then
  begin
   junk:=junk+' ';
   i:=i+2;
  end;
  junk:=junk+s[i];
  i:=i+1;
 end;
 s:=junk;
end;

procedure adddirentry(var dir : UTF8String; tag : string; len, pos : integer);
var
  hlp : string;
begin
 dir := dir+tag;
 hlp := Format('%.4d',[len]);
 dir := dir+hlp;
 hlp := Format('%.5d',[pos]);
 dir := dir+hlp;
end;

procedure marcrecord2lines(marcrec : UTF8String; Lines:TTntStringlist);
var
 i,p,base, start, leng : integer;
 hlp,text : UTF8String;
 tag,dir,rleng : string;
 numoffields,j : integer;
begin
  //Do not clear lines in here...
  Lines.Add('[LDR] '+copy(marcrec,1,24));

  leng := length(marcrec);
  rleng := copy(marcrec,1,5);
  if leng <> strtointdef(rleng,-1) then // FIXME : may be we have a record exceeding MARC limits.
  begin
   j:=pos(#30,marcrec);
   dir:=copy(marcrec,25,j-26);
   numoffields := length(dir) div 12;
   hlp:=copy(marcrec,j+1,length(marcrec));
   for i:=1 to numoffields do
   begin
    tag:=copy(dir,1,3);
    dir:=copy(dir,13,length(dir));
    j:=pos(#30,hlp);
    text:=copy(hlp,1,j-1);
    hlp:=copy(hlp,j+1,length(hlp));
    for j:=1 to length(text) do if text[j] = #31 then text[j]:='$';
    Lines.Add('['+tag+'] '+UTF8StringToWideString(text));
   end;
  end
  else
  begin

   hlp := copy(marcrec,13,5);
   base := StrToIntDef(hlp, -1);
   if base <> -1 Then
   begin
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
      Lines.Add('['+tag+'] '+UTF8StringToWideString(text));
      p:=p+12;
     end;
   end;
  end;
end;

procedure marcrecord2memo(marcrec : UTF8String; memo1:TTntMemo);
var
 i,p,base, start, leng : integer;
 tag, hlp, text : WideString;
 numoffields,j : integer;
 rleng,dir : string;
begin
  // Do not clear memo here...
  memo1.Lines.Add('[LDR] '+copy(marcrec,1,24));

  leng := length(marcrec);
  rleng := copy(marcrec,1,5);
  if leng <> strtointdef(rleng,-1) then // FIXME : may be we have a record exceeding MARC limits.
  begin
   j:=pos(#30,marcrec);
   dir:=copy(marcrec,25,j-26);
   numoffields := length(dir) div 12;
   showmessage('Number of fields='+inttostr(numoffields));
   hlp:=copy(marcrec,j+1,length(marcrec));
   for i:=1 to numoffields do
   begin
    tag:=copy(dir,1,3);
    dir:=copy(dir,13,length(dir));
    j:=pos(#30,hlp);
    text:=copy(hlp,1,j-1);
    hlp:=copy(hlp,j+1,length(hlp));
    for j:=1 to length(text) do if text[j] = #31 then text[j]:='$';
    memo1.Lines.Add('['+tag+'] '+UTF8StringToWideString(text));
   end;
  end
  else
  begin
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
//    memo1.Lines.Add('['+tag+'] '+UTF8Decode(text));
    memo1.Lines.Add('['+tag+'] '+UTF8StringToWideString(text));
    p:=p+12;
   end;
  end;
end;

function disp2mrc(lines : TTntStrings; var mrc : UTF8String) : integer;
var
  dirpos,i,j,fcnt,tcnt : integer;
  junk, ldr, dir, text : UTF8String;
  tag : string;
begin
 result := 0;
 dir:='';
 mrc :='';
 dirpos:=0;
 if lines.Count>0 then
   if copy(lines[0],1,5) <> '[LDR]' then exit
 else
  ldr := copy(lines[0],7,length(lines[0]));
 if length(ldr) <> 24 then exit;
 text:='';
 tag:='';
 tcnt:=26; // leader + record terminator + directory delimiter.
 for i:=1 to lines.Count-1 do
 begin
  if ((lines[i][1] = '[') and (lines[i][5]=']')) then
  begin
   if(tag <> '')then //and b
   begin
    text:=text+#30;
    fcnt:=length(text);
    if fcnt > 9999 then result:=1; // this is an error since MARC can not handle fields bigger than 9999 bytes (directory limitation)
    for j:=1 to fcnt do
     if text[j]='$' then text[j]:=#31;
    adddirentry(dir, tag, fcnt, dirpos);
    dirpos := dirpos+fcnt;
    if dirpos > 99999 then result:=1; // this is an error since MARC can not handle records bigger than 99999 bytes
    tcnt := tcnt + 12 + fcnt;
    if tcnt > 99999 then result:=1; // this is an error since MARC can not handle records bigger than 99999 bytes
    mrc := mrc+text;
   end;
   tag:=copy(lines[i],2,3);
   text:=WideStringToUTF8String(copy(lines[i],7,length(lines[i])));
  end
  else
   text:=text+WideStringToUTF8String(lines[i]);
 end;
// chk.Free;
 if tag <> '' then
 begin
  text:=text+#30;
  fcnt:=length(text);
  for j:=1 to fcnt do
   if text[j]='$' then text[j]:=#31;
  if fcnt > 9999 then result:=1; // this is an error since MARC can not handle fields bigger than 9999 bytes (directory limitation)
  adddirentry(dir, tag, fcnt, dirpos);
  tcnt := tcnt + 12 + fcnt;
  if tcnt > 99999 then result:=1; // this is an error since MARC can not handle records bigger than 99999 bytes
  mrc := mrc+text;
 end;

 mrc :=  ldr+dir+#30+mrc+#29;
 junk:=ldr+dir+#30;
 i:=length(junk);
 if i > 99999 then result:=1; // this is an error since MARC can not handle records bigger than 99999 bytes
 junk:=Format('%.5d',[i]);
 for i:=1 to 5 do
  mrc[12+i]:=junk[i];
 i:=length(mrc);
 junk:=Format('%.5d',[i]);
 for i:=1 to 5 do
  mrc[i]:=junk[i];
 //mrc:=ldr;
end;

procedure filter_marc_memo(fullrec : TTntMemo);
var p,x,index:integer;
    tag,invalidfields,ind,htag,text,allfields,validfields : WideString;
    path, myinifname : string;
    myIniFile : TWideIniFile;
    mftags : TStringList;
    mffields : TTntStringList;
begin
 allfields:='abcdefghijklmnopqrstuvwxyz0123456789';
 mftags:=TStringList.Create;
 mffields:=TTntStringList.Create;
 mftags.Clear;
 mffields.Clear;
 path:=extractfilepath(paramstr(0));
 myinifname := path+'MARCFilter.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 with MyIniFile do
 begin
  ReadSection('@@@MARCFilter',mftags);
  mftags.Sort;
  for p:=0 to mftags.Count -1 do
  begin
   mffields.Add(ReadString('@@@MARCFilter',mftags[p],''));
  end;
 end;
 MyIniFile.Free;

 for p:=fullrec.Lines.Count-1 downto 0 do
 begin
  tag := copy(fullrec.Lines[p],2,3);
  if ((tag='LDR') or (tag='936') or (tag='084')) then
   continue;
  invalidfields:='';
  if mftags.Find(tag,index) then
  begin
   invalidfields:=mffields.Strings[index];
  end;
  htag:=tag;
  for x:=3 downto 1 do
  begin
   htag[x]:='X';
   if mftags.Find(htag,index) then
   begin
    if (mffields.Strings[index] = '*') then
    begin
     invalidfields:='*';
     break;
    end
    else
     invalidfields:=invalidfields+mffields.Strings[index];
   end;
  end;
  if (pos('*',invalidfields)>0) then
   fullrec.Lines.Delete(p)
  else
  begin
   if (strtointdef(tag,10) <10) then
    continue
   else
   begin
//    showmessage(tag+invalidfields);
    ind := copy(fullrec.Lines[p],7,2);
    text := copy(fullrec.Lines[p],9,length(fullrec.Lines[p]));
   end;
   validfields:='';
   for index:=1 to length(allfields) do
    if (pos(allfields[index],invalidfields) <= 0) then
     validfields:=validfields+allfields[index];
   for index:=1 to length(text) do
    if (text[index]='$') then text[index]:=#31;
       text:=extract_field(text,validfields,0,true);
   for index:=1 to length(text) do
    if (text[index]=#31) then text[index]:='$';
   if (text = '') then
    fullrec.Lines.Delete(p)
   else
    fullrec.Lines[p]:='['+tag+'] '+ind+text;
  end;
 end;

 mftags.Free;
 mffields.Free;
end;

procedure correct_marc_memo(fullrec : Tmemo);
var p,x:integer;
    pf,ind,text,tag,ftext,f,aline : string;
begin
 for p:=fullrec.Lines.Count-1 downto 0 do
 begin
  tag := copy(fullrec.Lines[p],2,3);
  ind := copy(fullrec.Lines[p],6,2);
  text := copy(fullrec.Lines[p],8,length(fullrec.Lines[p]));
  aline:='['+tag+']'+ind;
  if (tag='260') then
  begin
   x:=1; pf:='';
   repeat
    ftext:=get_field(text,'$',f,x);
    x:=x+1;
    pf:=f;
   until f='';
  end
  else if (tag='245') then
  begin
  end
  else if (tag='300') then
  begin
  end
 end;
end;

function type_of_material(ldr : string) : string;
var s:string;
begin
 s:=copy(ldr,7,2);
 if (pos(s,LC_BOOK) > 0 ) then result:='BK'
 else
  if (pos(s,LC_SERIAL) > 0 ) then result:='SE'
  else
   if (pos(s,LC_MAPS) > 0 ) then result:='MP'
   else
    if (pos(s,LC_MUSIC) > 0 ) then result:='MA'
    else
     if (pos(s,LC_MUSICSR) > 0 ) then result:='MU'
     else
      if (pos(s,LC_VISUAL) > 0 ) then result:='VM'
      else
       if (pos(s,LC_CFILES) > 0 ) then result:='CF'
       else
        if (pos(s,LC_ARCHIVE) > 0 ) then result:='AM'
        else
         result:='??';
end;

function koha_item_type(ldr : string) : string;
var s:string;
begin
 s:=copy(ldr,7,2);
 if (pos(s,LC_BOOK) > 0 ) then result:='BK'
 else
  if (pos(s,LC_SERIAL) > 0 ) then result:='CR'
  else
   if (pos(s,LC_MAPS) > 0 ) then result:='MP'
   else
    if (pos(s,LC_MUSIC) > 0 ) then result:='MU'
    else
     if (pos(s,LC_MUSICSR) > 0 ) then result:='MU'
     else
      if (pos(s,LC_VISUAL) > 0 ) then result:='VM'
      else
       if (pos(s,LC_CFILES) > 0 ) then result:='CF'
       else
        if (pos(s,LC_ARCHIVE) > 0 ) then result:='MX'
        else
         result:='BK';
end;

function check008(text:string) : integer;
var htext : string;
begin

 hText := copy(Text,1,6); // Date Entered
 hText := copy(Text,7,1); // Type of Date
 hText := copy(Text,8,4); // Date 1
 hText := copy(Text,12,4); // Date 2
 hText := copy(Text,16,3); // Place of publication             //////////
 hText := copy(Text,36,3); // Language
 hText := copy(Text,39,1); // Modified Record
 hText := copy(Text,40,1); // Cataloguing Source

 hText := copy(Text,19,4); // Illustrations
 hText:= copy(Text,23,1); // Target audience
 hText:= copy(Text,24,1); // Form of Item
 hText:= copy(Text,25,4); // Nature of contents
 hText:= copy(Text,29,1); // Government Publication   /////////
 hText:= copy(Text,30,1); // Conference Publication
 hText:= copy(Text,31,1); // Festschrift
 hText:= copy(Text,32,1); // Index
 hText:= copy(Text,33,1); // Undefined
 hText:= copy(Text,34,1); // Literary Form
 hText:= copy(Text,35,1); // Biography

 result:=0;
end;

function rlistcmp(List: TStringList; Index1, Index2: Integer): Integer;
begin
 result:=strtoint(list[index1])-strtoint(list[index2]);
end;

function loadrecnolist(list:TStringList; fname :string; sortrecs:boolean):integer;
var rlist : textfile;
    rec : string;
begin
  result:=0;
  SetLength(FastRecordCreator.ReviewList, 0);

  AssignFile(rlist,fname);
  reset(rlist);
  list.Clear;
  while (not eof(rlist)) do
  begin
   readln(rlist,rec);
   if pos(' ',rec) > 0 then
    rec := copy(rec,1,pos(' ',rec)-1);
   if StrToIntDef(rec,-1) <> -1 then
   begin
    list.Add(rec);
    result:=result+1;

    SetLength(FastRecordCreator.ReviewList, length(FastRecordCreator.ReviewList) + 1);
    FastRecordCreator.ReviewList[length(FastRecordCreator.ReviewList) - 1] := StrToIntDef(rec, -1);
   end;
  end;
  if sortrecs then
   list.CustomSort(rlistcmp);
  CloseFile(rlist);
end;

function squeeze(s : WideString) : WideString;
var i : integer;
    f : boolean;
begin
 setlength(result,length(s));
 f:=true;
 result:='';
 for i:=1 to length(s) do
 begin
  if (s[i] = ' ') then
  begin
   if f=false then
   begin
    f:=true;
    result:=result+' ';
   end
  end
  else
  begin
   result:=result+s[i];
   f:=false;
  end;
 end;
 if ((result <> '') and (result[length(result)] = ' ')) then
  result:=copy(result,1,length(result)-1);
end;

function remove_punctuation(s:Widestring) : widestring;
var i : integer;
begin
 result:='';
 for i:=1 to length(s) do
 begin
  if (pos(s[i],widestring(PUNCTUATION))<=0) then
   result:=result+s[i]
  else result:=result+' ';
 end;
 result:=squeeze(result);
end;

function normalize(s:string) : string;
var gpos,i : integer;
begin
 setlength(result,length(s));
 s:=uppercase(s);
 result:='';
 for i:=1 to length(s) do
 begin
  if (pos(s[i],PUNCTUATION)<=0) then
  begin
   gpos:=pos(s[i],GreekLower);
   if ( gpos > 0 ) then
    result:=result+copy(GreekUpper,gpos,1)
   else
    result:=result+s[i];
  end;
 end;
 result:=squeeze(result);
end;

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

procedure extract_headings(HL : TTntStringList; marcrec, recno: WideString; taginfo : array of WideString; taginfodim : integer);
var
    proc:boolean;
    hlp,hh,tag,text,indic:WideString;
    i,k,p,base, start,leng,numoffields,x : integer;
begin
       for i:=0 to taginfodim-1 do
       begin
        hlp := copy(marcrec,13,5);
        base := StrToIntDef(hlp, 0);
        numoffields := (base - 1 -24) div 12;
        p := 25;
        for k:=1 to numoffields do
        begin
         hlp := copy(marcrec,p,12);
         tag := copy(hlp,1,3);
         leng:=strtoint(copy(hlp,4,4));
         start:=base+strtoint(copy(hlp,8,5));
         text := copy(marcrec,start+1,leng-1);
         proc:=false;
         hh:=copy(taginfo[i],1,3);
         if (tag = hh) then proc:=true;
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
           indic:=copy(text,1,2);
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
           hlp:=copy(taginfo[i],6,length(taginfo[i]));
           if hlp='*' then hlp:='abcdefghijklmnopqrstuvwxyz0123456789';
           if strtointdef(tag,0)>=10 then
           begin
            text:=extract_field(text,hlp,0,false);
            if recno<>'' then text:=text+'#'+recno;
            HL.Add(text);
           end;
          end;
         end;
         p:=p+12;
        end;
       end;
end;

function maprecno2dir(startdir: string; r,depth : integer; createdirs : boolean) : string;
var i : integer;
begin
 result:=startdir;
 if result[length(result)]='\' then result:=copy(result,1,length(result)-1);
 for i:=1 to depth do
 begin
  result:=result+'\'+inttostr(r mod 10);
  r:=r div 10;
  if createdirs then
   if not DirectoryExists(result) then
     if not CreateDir(result) then
     begin
      raise Exception.Create('Cannot create '+result);
      result:='';
     end
 end;
 result:=result+'\'+inttostr(r);
 if createdirs then
 if not DirectoryExists(result) then
  if not CreateDir(result) then
  begin
   raise Exception.Create('Cannot create directory'+result);
   result:='';
  end
end;

procedure zebrareindex(zebraindexer, zebradir : string);
begin
 if ((zebraindexer = '') or (zebradir = '')) then
  exit;
 RunFile(zebradir,zebraindexer,'init',SW_HIDE);
 RunFile(zebradir,zebraindexer,'update '+zebradir+'\records',SW_HIDE);
 RunFile(zebradir,zebraindexer,'commit',SW_HIDE);
end;

procedure zebraupdate(recno: integer; rec : string; mode : char; zebraindexer, zebradir : string; zebra_dir_depth : integer);
var f:textfile;
    fn,subdir:string;
begin
 if ((zebraindexer = '') or (zebradir = '')) then
  exit;
 if recno <=0 then exit;
 // we assume that in zebradir is the full path to the zebra.cfg location
 subdir := maprecno2dir(zebradir+'\records',recno,zebra_dir_depth,true);
 fn:=subdir+'\'+inttostr(recno)+'.mrc';
 if mode = 'd' then
 begin
  if fileexists(fn) then
  begin
   RunFile(zebradir,zebraindexer,'delete '+fn,SW_HIDE);
   RunFile(zebradir,zebraindexer,'commit',SW_HIDE);
   deletefile(Pchar(fn));
  end;
 end
 else if ((mode = 'u') or (mode = 'a')) then
 begin
  if DirectoryExists(subdir) then
  begin
   if fileexists(fn) then
   if mode = 'u' then RunFile(zebradir,zebraindexer,'delete '+fn,SW_HIDE);
   AssignFile(f,fn);
   rewrite(f);
   writeln(f,rec);
   CloseFile(f);
   if mode = 'u' then RunFile(zebradir,zebraindexer,'update '+fn,SW_HIDE);
   if mode = 'u' then RunFile(zebradir,zebraindexer,'commit',SW_HIDE);
  end;
 end;
end;

procedure zap_dir(path:string);
var   sr: TSearchRec;
      apath : string;
begin
 apath:=path+'\*';
 if FindFirst(apath, faAnyFile, sr) = 0 then
 begin
  repeat
    if (sr.Attr = faDirectory) then
    begin
     if ((sr.name<> '.') and (sr.name<>'..')) then
     begin
//      showmessage('dir:'+sr.Name);
      zap_dir(path+'\'+sr.Name);
      removedir(path+'\'+sr.Name);
     end;
    end
    else
    begin
//     showmessage('file:'+sr.Name);
     deletefile(path+'\'+sr.name);
    end;
  until (FindNext(sr) <> 0);
  findclose(sr);
 end;
end;

function ReverseStringWide(const AText: WideString): WideString;
var
  I: Integer;
  P: PWideChar;
begin
  SetLength(Result, Length(AText));
  P := PWideChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function get_lang(rec,format : string):string;
var i, fl,ind, base,nf : integer;
 direntry, junk : string;
begin
 result:='';
 junk := copy(rec,13,5);
 base := strtoint(junk);
 nf := (base-1-24)div 12;
 format := uppercase(format);
 for i:=1 to nf do
 begin
  direntry:=copy(rec,25+(i-1)*12,12);
  fl := strtoint(copy(direntry,4,4));
  ind := strtoint(copy(direntry,8,5));
  if (format = 'USMARC') then
  begin
   if (copy(direntry,1,3) = '008') then
    result := copy(rec,base+ind+fl-5,3);
  end
  else
  if format = 'UNIMARC' then
  begin
//   if (copy(direntry,1,3) = '???') then
//    result:='...';
  end;
 end;
end;


function marc2marcxml(marcrec : UTF8String; addnewlines: boolean) : UTF8String;
var
 numoffields, i, p, base, start, leng : integer;
 hlp,tag,text,sc,sd : string;
begin

  result:='<record xmlns="http://www.loc.gov/MARC21/slim">';
  if addnewlines then result:=result+#13#10;
  result:=result+'<leader>'+copy(marcrec,1,24)+'</leader>';
  if addnewlines then result:=result+#13#10;
  hlp := copy(marcrec,13,5);
  base := StrToIntDef(hlp, -1);

  if base <> -1 Then
  begin
    numoffields := (base - 1 -24) div 12;
    p := 25;
    for i:=1 to numoffields do
    begin
     hlp := copy(marcrec,p,12);
     tag := copy(hlp,1,3);
     if (strtointdef(tag,-1) <> -1) then
     begin
      leng:=strtoint(copy(hlp,4,4));
      start:=base+strtoint(copy(hlp,8,5));
      text := copy(marcrec,start+1,leng);
      text:=copy(text,1,length(text)-1);
      if (strtoint(tag) < 10) then
      begin
       text:=mkwellform_xml(text);
       result:=result+'  <controlfield tag="'+tag+'">'+text+'</controlfield>';
       if addnewlines then result:=result+#13#10;
      end
      else
      begin
        if length(text) > 1 Then result:=result+'  <datafield tag="'+tag+'" ind1="'+text[1]+'" ind2="'+text[2]+'">'
                            Else result:=result+'  <datafield tag="'+tag+'" ind1="" ind2="">';
        if addnewlines then result:=result+#13#10;
        sc:=''; sd:='';
        text:=copy(text,4,length(text))+#31;
        while pos(#31,text) > 1 do
        begin
          sc:=text[1];
          sd:=copy(text,2,pos(#31,text)-2);
          text:=copy(text,pos(#31,text)+1,length(text));
          sd:=mkwellform_xml(sd);
          result:=result+'    <subfield code="'+sc+'">'+sd+'</subfield>';
          if addnewlines then result:=result+#13#10;
        end;
        result:=result+'  </datafield>';
        if addnewlines then result:=result+#13#10;
      end;
     end;
     p:=p+12;
    end;
    result:=result+'</record>';
    if addnewlines then result:=result+#13#10;
  end
  else result := '';
end;

function makemrcfromnew : UTF8String;
var
  pages,dimen,physdescr,ib,iss,a,t,pu,pl,y,hlp,junk,ed,notes : UTF8String;
  marcrec, temp, dir, phlp, leader, lang, f008 : UTF8String;
  x, i : integer;
  ind, tag1, f001 : string;
  dirpos, dpos : integer;
  curdate:string;
  TempDateFormat, ua : string;

begin
  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'yymmdd';

  curdate := datetostr(Date);
  marcrec := '';

  with NewBibliographicForm do
  begin
    f001:=inttostr(Data.SecureBasket['recno'])+#30;
//    f001:=inttostr(Data.Basket['recno'])+#30;
    f001:='0'+#30;
    f008:=curdate;
    y := '';
    if (DBEdit5.Text <> '') then
     y := WideStringToUTF8String(DBEdit5.Text);
    if (y <> '') then
    begin
     if (copy(y,1,1) = 'c') or (copy(y,1,1) = '[') then
      y:=copy(y,2,4);
     y:=copy(y,1,4);
     if strtointdef(y,-1) = -1 then
      y:='||||';
     f008 := f008+'s'+y;
     if length(y) < 4 then
      for i:=1 to 4 - length(y) do
       f008 := f008+'u'
    end
    else
    f008 := f008+'     ';
    f008 := f008+'    ';
    f008 := f008 + '   '; //15-17
    f008 := f008 + '    ';
    if (LangComboBox.Text = '' ) then lang:='   '
    else lang:=WideStringToUTF8String(LangComboBox.Text);
    f008 := f008 + '             '+lang+'  '+#30;
    leader:='00000nam  22.....7a 4500';
    dir:='';
    dirpos := 0;
    marcrec:=f001+f008;
    adddirentry(dir,'001',length(f001),dirpos);
    dirpos := dirpos+length(f001);
    adddirentry(dir,'008',length(f008),dirpos);
    dirpos := dirpos+length(f008);
    a:=''; t:=''; pu:=''; pl:=''; y:='';ed:=''; notes:='';ib:='';iss:='';
    ua:=''; pages:=''; dimen:=''; physdescr:='';

    // #29 Record Terminator #30 Field Terminator #31 Subfield Delimiter.
    if (DBEdit1.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBEdit1.Text);
      a := '  '+#31+'a'+temp;
    end;
    if (DBMemo3.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBMemo3.Text);
      t := '  '+#31+'a'+temp;
    end;
    t:=remove_crlf(t);
    x:=pos(' :',t);
    if (x > 0) then t:=copy(t,1,x+1)+#31+'b'+copy(t,x+2,length(t));
    x:=pos(' /',t);
    if (x > 0) then t:=copy(t,1,x+1)+#31+'c'+copy(t,x+2,length(t));

    if (DBEdit3.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBEdit3.Text);
      pu := #31+'b'+temp;
    end;
    if (DBEdit6.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBEdit6.Text);
      ed := '  '+#31+'a'+temp;
    end;
    if (DBEdit4.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBEdit4.Text);
      pl := #31+'a'+temp;
    end;
    if (DBEdit5.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBEdit5.Text);
      y := #31+'c'+temp;
    end;
    if (DBMemo1.Text <> '' ) then
      notes := WideStringToUTF8String(DBMemo1.Text);

    notes:=remove_crlf(notes);
    notes:=trimright(notes);
    if (length(notes) > 0) then
    begin
      if notes[length(notes)]='@' then
        notes:=copy(notes,1,length(notes)-1);
      notes:=trimright(notes);
    end;
    if (DBEdit7.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBEdit7.Text);
      ib := '  '+#31+'a'+temp;
    end;
    if (DBEdit8.Text <> '') then
    begin
      temp := WideStringToUTF8String(DBEdit8.Text);
      iss := '  '+#31+'a'+temp;
    end;

    if (DBEdit12.Text <> '') then
      physdescr := WideStringToUTF8String(DBEdit12.Text);

    if (MaterialComboBox.Text = 'bk') then
     leader[8] := 'm'
    else if (MaterialComboBox.Text = 'cp') then
    begin
     leader[6] :='n';
     leader[7] :='a';
     leader[8] :='a';
     leader[9] :=' ';
     leader[20] :='b';
    end
    else if (MaterialComboBox.Text = 'vm') then
    begin
     leader[6] :='n';
     leader[7] :='k';
     leader[8] :='d';
     leader[9] :='a';
    end
    else if (MaterialComboBox.Text = 'am') then
    begin
     leader[7] :='t';
     leader[8] :='m';
     leader[9] :='a';
    end
    else if (MaterialComboBox.Text = 'mu') then
    begin
     leader[7] :='j';
     leader[8] :='m';
     leader[9] :='a';
    end
    else if (MaterialComboBox.Text = 'ma') then
    begin
     leader[7] :='i';
     leader[8] :='m';
     leader[9] :='a';
    end
    else if (MaterialComboBox.Text = 'mp') then
    begin
     leader[7] :='e';
     leader[8] :='m';
     leader[9] :='a';
    end
    else
     leader[8] := 's';
    if (ib <> '') then
    begin
     ib:=ib+#30;
     adddirentry(dir,'020',length(ib),dirpos);
     dirpos:=dirpos+length(ib);
     marcrec:=marcrec+ib;
    end;
    if (iss <> '') then
    begin
     iss:=iss+#30;
     adddirentry(dir,'022',length(iss),dirpos);
     dirpos:=dirpos+length(iss);
     marcrec:=marcrec+iss;
    end;

    if (a<> '') then
    begin
     a:=a+#30;

     if (a[5] = '#') then begin
      junk:=copy(a,1,4)+copy(a,6,length(a));
      a:=junk;
      adddirentry(dir,'110',length(a),dirpos);
     end
     else
      if (a[5] = '*') then begin
       junk:=copy(a,1,4)+copy(a,6,length(a));
       a:=junk;
       adddirentry(dir,'111',length(a),dirpos);
      end
      else
       adddirentry(dir,'100',length(a),dirpos);

     dirpos := dirpos+length(a);
     marcrec := marcrec+a;
    end;
    if (t<> '') then
    begin
     t:=t+#30;
     adddirentry(dir,'245',length(t),dirpos);
     dirpos := dirpos+length(t);
     marcrec := marcrec+t;
    end;
    if (ed<> '') then
    begin
     ed:=ed+#30;
     adddirentry(dir,'250',length(ed),dirpos);
     dirpos := dirpos+length(ed);
     marcrec := marcrec+ed;
    end;
    if ((pu<>'') or (pl<>'') or (y<>'')) then
    begin
     phlp := '  '+pl+pu+y;
     phlp := '  ';
     if pl<>'' then
     begin
      phlp:=phlp+pl;
      if pu <> '' then phlp:=phlp+' :'
     end;
     phlp:=phlp+pu;
     if y <> '' then
     begin
      if phlp <> '  ' then
      begin
       phlp:=phlp+','
      end;
      phlp:=phlp+y;
     end;
     pu:=phlp;
    end;

    if pu <>'' then
    begin
     pu:=pu+#30;
     adddirentry(dir,'260',length(pu),dirpos);
     dirpos := dirpos+length(pu);
     marcrec:=marcrec+pu;
    end;
    physdescr:=trimleft(physdescr);
    if (physdescr<>'') then
    begin
     if (physdescr[1] <> '$') then
      physdescr := '$a'+physdescr;
     for x := 1 to length(physdescr) do
      if physdescr[x] = '$' then physdescr[x]:=#31;
     physdescr:='  '+physdescr+#30;
     adddirentry(dir,'300',length(physdescr),dirpos);
     dirpos:=dirpos+length(physdescr);
     marcrec:=marcrec+physdescr;
    end;
    if (notes<> '') then
    begin
     while (notes <> '') do
     begin
      dpos := pos('@',notes);
      if (dpos <=0) then
      begin
       junk:=notes;
       notes:='';
      end
      else
      begin
       junk := copy(notes,1,dpos-1);
       notes := copy(notes,dpos+1,length(notes));
      end;
      junk:=trimlead(junk);
      hlp:=copy(junk,1,2);
      if hlp = '1.' then begin tag1:='490'; ind:='0 '; junk:=copy(junk,3,length(junk)); end
      else if hlp = '3.' then begin tag1:='502'; ind:='  '; junk:=copy(junk,3,length(junk)); end
      else if hlp = '4.' then begin tag1:='505'; ind:='1 '; junk:=copy(junk,3,length(junk)); end
      else if hlp = '5.' then begin tag1:='546'; ind:='  '; junk:=copy(junk,3,length(junk)); end
      else if hlp = '6.' then begin tag1:='300'; ind:='  '; junk:=copy(junk,3,length(junk)); end
      else if hlp = '7.' then begin tag1:='510'; ind:='4 '; junk:=copy(junk,3,length(junk)); end
      else if hlp = '8.' then begin tag1:='590'; ind:='  '; junk:=copy(junk,3,length(junk)); end
      else if hlp = '9.' then begin tag1:='790'; ind:='1 '; junk:=copy(junk,3,length(junk)); end
      else if ((hlp = 'Z.') or (hlp = 'z.')or(hlp = '?.') or (hlp = '?.')) then begin tag1:='099'; ind:=' 9'; junk:=copy(junk,3,length(junk)); end
      else if ((hlp = 'B.') or (hlp = 'b.')or(hlp = '?.') or (hlp = '?.')) then begin tag1:='504'; ind:='  '; junk:=copy(junk,3,length(junk)); end
      else  begin tag1:='500'; ind:='  '; if hlp='2.' then junk:=copy(junk,3,length(junk)); end;
      junk:=ind+#31+'a'+junk+#30;
      adddirentry(dir,tag1,length(junk),dirpos);
      dirpos := dirpos+length(junk);
      marcrec := marcrec+junk;
     end;
    end;

    marcrec:=leader+dir+#30+marcrec+#29;
    hlp:=leader+dir+#30;
    i:=length(hlp);
    junk:=WideFormat('%.5d',[i]);
    for i:=1 to 5 do
     marcrec[12+i]:=junk[i];
    i:=length(marcrec);
    junk:=WideFormat('%.5d',[i]);
    for i:=1 to 5 do
     marcrec[i]:=junk[i];

  end;
  result := marcrec;
  ShortDateFormat := TempDateFormat;
end;

function makenewauthmrc : UTF8String;
var
  hlp,junk, marcrec, dir, leader, f008 : UTF8String;
  dirpos, i : integer;
  f001, curdate, TempDateFormat : string;
begin
  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'yymmdd';
  curdate := datetostr(Date);
  marcrec := '';
  f001:=inttostr(data.auth.FieldByName('recno').AsInteger)+#30;
  f008:= curdate+' | |||||||||||||||||||||||||||||||'+#30;
  leader:='00000nz  a22.....n  4500';
  dir:='';
  dirpos := 0;
  marcrec:=f001+f008;
  adddirentry(dir,'001',length(f001),dirpos);
  dirpos := dirpos+length(f001);
  adddirentry(dir,'008',length(f008),dirpos);

  marcrec:=leader+dir+#30+marcrec+#29;
  hlp:=leader+dir+#30;
  i:=length(hlp);
  junk:=WideFormat('%.5d',[i]);
  for i:=1 to 5 do
   marcrec[12+i]:=junk[i];
  i:=length(marcrec);
  junk:=WideFormat('%.5d',[i]);
  for i:=1 to 5 do
   marcrec[i]:=junk[i];
  result := marcrec;
  ShortDateFormat := TempDateFormat;
end;

procedure zap_fields(fields : string; start : integer);
var i : integer;
begin
 if start < 0 then start :=0
 else if start > lines.Count-1 then start := lines.Count-1;
 for i := lines.Count-1 downto start do
 begin
   if pos(copy(Lines[i],2,3),fields) > 0 then
    lines.Delete(i);
 end;
end;

function normal_first_field_position(tag:string) : integer;
var i, dpos,ntag : integer;
begin
  result:=-(lines.Count);
  ntag:=strtoint(tag);
  for i := 1 to Lines.Count-1 do // downto 0 do
  begin
   dpos := strtointdef(copy(Lines[i],2,3),0);
   if dpos = ntag then
   begin
    result:=i;
    break;
   end
   else
   if dpos > ntag then
   begin
    result:=-i;
    break;
   end;
  end;
end;

procedure ReplaceOrgCode(var rec: UTF8String);
var i : integer;
begin
  lines.Clear;
  marcrecord2lines(rec, lines);
  if trim(FastRecordCreator.OrganisationCode) <> '' Then
  begin
   i:=normal_first_field_position('003');
   if i > 0 then
     Lines[i]:='[003] ' + trim(FastRecordCreator.OrganisationCode)
   else
     Lines.Insert(-i, '[003] '+ trim(FastRecordCreator.OrganisationCode));
   zap_fields('003',abs(i)+1);
  end
  else zap_fields('003',1);
  disp2mrc(lines, rec);
end;

procedure ReplaceDateStr(var rec: UTF8String);
var
  i : integer;
  ttt : string;
begin
  lines.Clear;
  marcrecord2lines(rec, lines);
  i:=normal_first_field_position('005');
  ttt := FormatDateTime('yyyymmddhhmmss', Now);
  if i > 0 then Lines[i]:='[005] ' + ttt+'.0'
  else if i < 0 then Lines.Insert(-i, '[005] '+ttt+'.0');
  zap_fields('005', abs(i)+1);
  disp2mrc(lines, rec);
end;

procedure ReplaceRecno(recno: integer; var rec: UTF8String);
var i : integer;
begin
  lines.Clear;
  marcrecord2lines(rec, lines);
  i:=normal_first_field_position('001');
  if i > 0 then Lines[i]:='[001] '+IntToStr(recno)
  else if i < 0 then Lines.Insert(-i, '[001] '+IntToStr(recno));
  disp2mrc(lines, rec);
end;

function RemoveHoldings(rec: UTF8String) : UTF8String;
var i, n: integer;
    tag : string;
begin
  lines.Clear;
  marcrecord2lines(rec, lines);
  n := Lines.Count-1;
  for i := n downto 0 do
  begin
    tag :=copy(Lines[i], 0, 5);
    if ((tag='[936]') or (tag='[084]')or (tag='[852]') or (tag='[853]') or (tag='[863]') or (tag='[866]')or (tag='[867]')or (tag='[868]')or (tag='[876]')) then
      Lines.Delete(i);
  end;
  disp2mrc(lines, Result);
end;

function GetRecno(rec: UTF8String) : integer;
var i, n: integer;
begin
  lines.Clear;
  marcrecord2lines(rec, lines);
  i := 0;
  n := Lines.Count;
  while (i<n)and(copy(Lines[i], 0, 5)<>'[001]') do i := i + 1;
  if i<n Then
    Result := StrToIntDef(Copy(Lines[i], 6, length(Lines[i])-5) , 0)
  else Result := 0;
end;

function EnterNumber(Title, Prompt: string) : string;
begin
  with NewRecnoForm do
  begin
    Caption := Title;
    Label1.Caption := Prompt;
    ShowModal;
    if ModalResult = mrCancel Then
      Result := ''
    else
      Result := Edit1.Text;
  end;
end;

procedure MoveHoldings(OldRecno, NewRecno : integer; UpdateZebra : boolean);
var
  rec : UTF8String;
  maxaa : integer;
begin
  maxaa := get_max_hold_aa(NewRecno);
  with Data.MyCommand1 do
  begin
    SQL.Clear;
    SQL.Add('UPDATE hold SET aa = aa + :maxaa WHERE recno = :oldrecno;');
    ParamByName('maxaa').AsInteger := maxaa;
    ParamByName('oldrecno').AsInteger := OldRecno;
    Execute;
    SQL.Clear;
    SQL.Add('UPDATE hold SET recno = :newrecno WHERE recno = :oldrecno;');
    SQL.Add('UPDATE items SET recno = :newrecno WHERE recno = :oldrecno;');
    ParamByName('newrecno').AsInteger := NewRecno;
    ParamByName('oldrecno').AsInteger := OldRecno;
    Execute;
  end;
  //Update holding info for source record
  data.basket.SQL.Clear;
  data.basket.SQL.Add('SELECT * FROM basket WHERE recno = '+inttostr(OldRecno));
  data.basket.Execute;
  rec := GetLastDataFromBasket(OldRecno);
  EditTable(data.basket);
  Refresh084(OldRecno, rec);
  data.basket.GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
  TBlobField(data.basket.FieldByName('text')).Modified := True;
  PostTable(data.basket);
  if UpdateZebra then
    RecordUpdated(myzebrahost, 'update', data.basket.FieldByName('recno').AsInteger, MakeMRCFromBasket);
  //Update holding info for destination record
  data.basket.SQL.Clear;
  data.basket.SQL.Add('SELECT * FROM basket WHERE recno = '+inttostr(NewRecno));
  data.basket.Execute;
  rec := GetLastDataFromBasket(NewRecno);
  EditTable(data.basket);
  Refresh084(NewRecno, rec);
  data.basket.GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
  TBlobField(data.basket.FieldByName('text')).Modified := True;
  PostTable(data.basket);
  if UpdateZebra then
    RecordUpdated(myzebrahost, 'update', data.basket.FieldByName('recno').AsInteger, MakeMRCFromBasket);
end;

procedure SetCurrentList(FileListName : string);
var
  s : string;
begin
  s := ExtractFileName(FileListName);
  if s <> '' Then
    FastRecordCreator.StatusBar1.Panels[2].Text :=
              IntToStr(length(FastRecordCreator.List)) + ' records in working list (' +
                  Copy(s, 1, length(s)-4) + ')'
  Else FastRecordCreator.StatusBar1.Panels[2].Text := '';
end;

function AddToList(FNameList : string; recno : integer) : boolean;
var
  F: TextFile;
  TempDateFormat : string;
begin
  if not IsInList(recno) Then
  begin
    Assignfile(F, FNameList);
    Append(F);
    TempDateFormat := ShortDateFormat;
    ShortDateFormat := 'dd/mm/yyyy';
    WriteLn(F, recno, ' ', DateToStr(Date));
    Closefile(F);
    with FastRecordCreator do
    begin
      SetLength(List, length(List) + 1);
      List[length(List) - 1] := recno;
    end;
    SetCurrentList(FNameList);
    ShortDateFormat := TempDateFormat;
    Result := True;
  end
  Else Result := False;
end;

function AddToList(var F: TextFile; recno : integer) : boolean;
var
  TempDateFormat : string;
begin
  if not IsInList(recno) Then
  begin
    TempDateFormat := ShortDateFormat;
    ShortDateFormat := 'dd/mm/yyyy';
    WriteLn(F, recno, ' ', DateToStr(Date));
    with FastRecordCreator do
    begin
      SetLength(List, length(List) + 1);
      List[length(List) - 1] := recno;
    end;
    ShortDateFormat := TempDateFormat;
    Result := True;
  end
  Else Result := False;
end;

function RemoveFromList(FNameList : string; recno : integer) : boolean;
var
  i, n : integer;
  Strings : TStringList;
begin
  if IsInList(recno) Then
  begin
    //Delete the record from the file
    Strings := TStringList.Create;
    Strings.LoadFromFile(FNameList);
    n := Strings.Count-1;
    for i := n downto 0 do
      if recno = StrToIntDef(Copy(Strings[i], 1, Pos(' ', Strings[i])-1), -1) Then Strings.Delete(i);
    Strings.SaveToFile(FNameList);
    Strings.Free;
    //Delete record from array
    with FastRecordCreator do
    begin
      n := length(List)-1;
      i := 0;
      //Find the record we need in the array
      while (i<=n)and(List[i]<>recno) do i := i + 1;
      if i <= n Then
      begin
        while (i<n) do
        begin
          List[i] := List[i+1];
          i := i + 1;
        end;
        SetLength(List, n);
      end;
    end;
    SetCurrentList(FNameList);
    Result := True;
  end
  Else Result := False;
end;

procedure CloseList;
begin
  with FastRecordCreator do
  begin
    SetLength(List, 0);
    FNameList := '';
    SetCurrentList(FNameList);
  end;
end;

procedure PopulateArrayWithListRecno(FileListName : string);
var F : TextFile;
    temp : string;
begin
  with FastRecordCreator do
  begin
    SetLength(List, 0);
    Assignfile(F, FileListName);
    Reset(F);
    while (not Eof(F)) do
    begin
      ReadLn(F, temp);
      if pos(' ',temp) > 0 then temp := copy(temp, 1, pos(' ',temp)-1);
      SetLength(List, length(List) + 1);
      List[length(List) - 1] := StrToIntDef(temp, -1);
    end;
    CloseFile(F);
  end;
end;

function IsInList(recno: integer) : boolean;
var
  b : boolean;
  i, n : integer;
begin
  b := False;
  with FastRecordCreator do
  begin
    i := 0;
    n := length(List)-1;
    while (i <= n)and(not b) do
    begin
      if List[i] = recno Then b := True;
      i := i + 1;
    end;
  end;
  Result := b;
end;

procedure SetCurrentReviewList(FileListName : string);
var s : string;
begin
  s := ExtractFileName(FileListName);

  with FastRecordCreator do
  begin
    if s <> '' Then
      StatusBar1.Panels[3].Text :=IntToStr(length(ReviewList)) +
                                  ' records in review list (' +
                                  Copy(s, 1, length(s)-4) + ')'
    else StatusBar1.Panels[3].Text := '';
  end;
end;

procedure RecordUpdated(var azebrahost:ZOOM_Host; action: string; recno : integer; text : UTF8String; ShowProgressBar : boolean = true);
var rc:integer;
    err:string;
begin
  if ShowProgressBar then
  begin
    ProgresBarForm.Show;
    ProgresBarForm.ProgressBar1.Visible := true;
    ProgresBarForm.ProgressBar1.Max := 100;
    ProgresBarForm.ProgressBar1.Position := 70;
    ProgresBarForm.Label2.Caption := 'Updating Zebra Server...';
    Application.ProcessMessages;
  end;
  rc:=zebra_update_record(azebrahost, action, inttostr(recno), text, true, false, err);
  if (rc <> 0) then showmessage('('+inttostr(rc)+'): '+err);

  if ShowProgressBar then
    begin
      ProgresBarForm.ProgressBar1.Position := 100;
      ProgresBarForm.ProgressBar1.Visible := false;
      ProgresBarForm.Close;
    end;
end;

procedure PopulateComboFromIni(Category : WideString; ComboBox: TTntComboBox);
var
  MyIniFName : string;
  MyIniFile : TWideIniFile;
  Strings : TtntStringList;
  i : integer;
begin
  //Category mappings
  Strings := TtntStringList.Create;
  ComboBox.Items.Clear;
  MyIniFName := ExtractFilePath(paramstr(0))+'pleiades.ini';
  MyIniFile := TWideIniFile.Create(MyIniFName);
  try
    with MyIniFile do
    begin
      ReadwideSectionValues(Category, Strings);
      for i := 0 to Strings.Count-1 do
        ComboBox.Items.Add(ReadWideString(Category, IntToStr(i), ''));
    end;
  finally
    MyIniFile.Free;
    Strings.Free;
  end;
end;

function GetValueFromIniList(Ident : Widestring; list : TtntStringList) : WideString;
var i :integer; key:widestring;
begin
 result:='';
 for i:=0 to list.Count-1 do
 begin
  key:=copy(list[i],1,pos('=',list[i])-1);
  if key = Ident then
  begin
   result:=copy(list[i],pos('=',list[i])+1,length(list[i]));
  end;
 end;
end;


function GetIniMappings(Category : WideString; Ident : string) : WideString;
var
  tag : integer;
begin
  tag:=0;
  if UpperCase(Category) = 'RECORDLEVEL' Then tag := 0;
  if UpperCase(Category) = 'LOANCATEGORY' Then tag := 1;
  if UpperCase(Category) = 'PROCESSSTATUS' Then tag := 2;
  if UpperCase(Category) = 'ENUMERATION' Then tag := 3;
  if UpperCase(Category) = 'CHRONOLOGY' Then tag := 4;
  Result := GetValueFromIniList(Ident, IniMappings[tag]);
end;

function make_MARC_from_OPAC(opac: IXMLNode) :UTF8string;
var sf,ma,f,op,fx,hn: IXMLNode;
    dirpos, i, m,s,o,x,h : integer;
    leader, marcrec, directory,tag,str,ind1,ind2,sfield,sfd : UTF8string;
begin
 result:='';
 dirpos:=0;
 directory:='';
 marcrec:='';
 op := opac;
 for o:=0 to op.ChildNodes.Count-1 do
 begin
  f := op.ChildNodes[o];

  if (f.LocalName = 'bibliographicRecord') then
  begin
    ma := f.ChildNodes[0];
    for m:=0 to ma.ChildNodes.Count-1 do
    begin
     f := ma.ChildNodes[m];
     if f.LocalName = 'leader' then leader:=WideStringToUTF8String(f.Text);
     if f.LocalName = 'controlfield' then
     begin
       tag:=f.AttributeNodes['tag'].Text;
       str:=WideStringToUTF8String(f.Text)+#30;
       adddirentry(directory,tag,length(str),dirpos);
       dirpos:=dirpos+length(str);
       marcrec:=marcrec+str;
     end;
     if f.LocalName = 'datafield' then
     begin
       tag:=f.AttributeNodes['tag'].Text;
       ind1:=WideStringToUTF8String(f.AttributeNodes['ind1'].Text);
       ind2:=WideStringToUTF8String(f.AttributeNodes['ind2'].Text);
       str:=ind1+ind2;
       for s:=0 to f.ChildNodes.Count-1 do
       begin
         sf:=f.ChildNodes[s];
         sfd:=WideStringToUTF8String(sf.AttributeNodes['code'].Text);
         sfield:=WideStringToUTF8String(sf.Text);
         str:=str+#31+sfd+sfield;
       end;
       str:=str+#30;
       adddirentry(directory,tag,length(str),dirpos);
       dirpos:=dirpos+length(str);
       marcrec:=marcrec+str;
     end;
    end;
  end
  else if (f.localName = 'holdings') then
  begin
    for x:=0 to f.ChildNodes.Count-1 do
    begin
      fx := f.ChildNodes[x];
//      showmessage(fx.LocalName);
      tag:='899';
      str:='  '; // indicators
      for h:=0 to fx.ChildNodes.Count-1 do
      begin
        hn := fx.ChildNodes[h];
//        showmessage(hn.LocalName);
        if (hn.LocalName = 'localLocation') then
         str:=str+#31+'a'+hn.Text
        else if (hn.LocalName = 'copyNumber') then
         str:=str+#31+'c'+hn.Text
        else if (hn.LocalName = 'callNumber') then
         str:=str+#31+'h'+hn.Text
        else if (hn.LocalName = 'enumAndChron') then
         str:=str+#31+'k'+hn.Text;
      end;
      str:=str+#30;
      adddirentry(directory,tag,length(str),dirpos);
      dirpos:=dirpos+length(str);
      marcrec:=marcrec+str;
    end;
  end;
 end;

 {ma :=marcxml; }

 result:=leader+directory+#30+marcrec+#29;
 str:=leader+directory+#30;
 i:=length(str);
 str:=Format('%.5d',[i]);
 for i:=1 to 5 do
  result[12+i]:=str[i];
 i:=length(result);
 str:=Format('%.5d',[i]);
 for i:=1 to 5 do
  result[i]:=str[i];
end;

function make_MARC_from_MARCXML(marcxml: IXMLNode) :UTF8string;
var sf,ma,f: IXMLNode;
    dirpos, i, m,s : integer;
    leader, marcrec, directory,tag,str,ind1,ind2,sfield,sfd : UTF8string;
begin
 result:='';
 dirpos:=0;
 directory:='';
 marcrec:='';
 ma :=marcxml;
 for m:=0 to ma.ChildNodes.Count-1 do
 begin
  f := ma.ChildNodes[m];
  if f.LocalName = 'leader' then leader:=WideStringToUTF8String(f.Text);
  if f.LocalName = 'controlfield' then
  begin
    tag:=f.AttributeNodes['tag'].Text;
    str:=WideStringToUTF8String(f.Text)+#30;
    adddirentry(directory,tag,length(str),dirpos);
    dirpos:=dirpos+length(str);
    marcrec:=marcrec+str;
  end;
  if f.LocalName = 'datafield' then
  begin
    tag:=f.AttributeNodes['tag'].Text;
    ind1:=WideStringToUTF8String(f.AttributeNodes['ind1'].Text);
    ind2:=WideStringToUTF8String(f.AttributeNodes['ind2'].Text);
    str:=ind1+ind2;
    for s:=0 to f.ChildNodes.Count-1 do
    begin
      sf:=f.ChildNodes[s];
      sfd:=WideStringToUTF8String(sf.AttributeNodes['code'].Text);
      sfield:=WideStringToUTF8String(sf.Text);
      str:=str+#31+sfd+sfield;
    end;
    str:=str+#30;
    adddirentry(directory,tag,length(str),dirpos);
    dirpos:=dirpos+length(str);
    marcrec:=marcrec+str;
  end;
 end;

 result:=leader+directory+#30+marcrec+#29;
 str:=leader+directory+#30;
 i:=length(str);
 str:=Format('%.5d',[i]);
 for i:=1 to 5 do
  result[12+i]:=str[i];
 i:=length(result);
 str:=Format('%.5d',[i]);
 for i:=1 to 5 do
  result[i]:=str[i];
end;

procedure FixMemo(var Memo : TTntMemo);
var
  i, n : integer;
begin
  //Remove empty lines from Memo
  n := Memo.Lines.Count-1;
  for i := n downto 0 do
    if Memo.Lines[i] = '' Then Memo.Lines.Delete(i);
end;

function SyntaxCheck(Lines : TTntStrings; record_type:string) : boolean;
var
  stxlist : TTntStringList;
  x : integer;
  msg : string;
  r : Boolean;
begin
  stxlist := TTntStringList.create;
  Result := True;

  try
    for x:=0 to lines.Count-1 do
      stxlist.Add(lines[x]);
    if record_type = 'auth' then
      r := syntaxchk(stxlist, msg,AuthUsmarcStx)
    else
      r := syntaxchk(stxlist, msg,BibUsmarcStx);
    if (not r) then
    begin
      WideShowMessage(msg);
      Result := False;
    end;
  finally
    stxlist.free;
  end;
end;

procedure EnhanceMARC(recno : integer; var rec : UTF8String);
begin
  ReplaceRecno(recno, rec);
  ReplaceOrgCode(rec);
  ReplaceDateStr(rec);
  if length(rec) >= 10 then rec[10] := 'a';
  if length(rec)>=11 then rec[11]:='2';
  if length(rec)>=12 then rec[12]:='2';
end;

function NewMARCRecord(tab : string) : integer;
begin
  with data.InsertSecureBasket do
  begin
    SQL.Clear;
    SQL.Add('INSERT INTO '+tab+' (format, level, creator, created ) VALUES (:format, :level, :creator, :created)');
    ParamByName('level').AsInteger := 0;
    ParamByName('format').AsString := 'USmarc';
    ParamByName('Creator').AsInteger := UserCode;
    ParamByName('Created').AsDate := today;
    Execute;
    if tab = 'basket' then
    begin
      OpenSecureBasketTable(InsertId);
      Result := data.SecureBasket.FieldByname('recno').AsInteger;
      append_move(UserCode, 6,today, CurrentUserName + ' added a new record recno=' + IntToStr(Result));
    end
    else
    begin
      OpenAuthTable(InsertId);
      Result := data.Auth.FieldByname('recno').AsInteger;
      append_move(UserCode, 4,today, CurrentUserName + ' added a new authority record recno=' + IntToStr(Result));
    end;
  end;
end;

procedure Refresh084(recno : integer; var rec : UTF8String);
var
  n, xx, yy, hcnt, dpos : integer;
  tag, fcln, fcln_ip, temp : WideString;
  chk : TTntStringList;
begin
  Data.HoldQuery.Close;
  Data.HoldQuery.ParamByName('recno').AsInteger := recno;
  Data.HoldQuery.Open;
  lines.Clear;
  marcrecord2lines(rec, lines);
  n := Lines.Count;
  //Erasing holdings information from MARC
  for xx := n-1 downto 0 do
  begin
    tag := copy(Lines[xx],2,3);
    if tag='084' then Lines.Delete(xx);
  end;
  hcnt := Data.HoldQuery.RecordCount;
  Data.HoldQuery.First;
  chk := TTntStringList.Create;
  //Inserting holdings information in MARC
  for xx:= 1 to hcnt do
  begin
    //Building 084 tag
    fcln:='';
    fcln_ip:='';
    if not IsEmptyField(Data.HoldQuery, 'cln') then
    begin
      fcln := Data.HoldQuery.fieldbyname('cln').Value;
      temp := '  '+'$a'+fcln;
      if not IsEmptyField(Data.HoldQuery, 'cln_ip') then
      begin
        fcln_ip := Data.HoldQuery.fieldbyname('cln_ip').Value;
        temp := temp+'$b'+fcln_ip;
      end;
      dpos:=0;
      for yy:=Lines.Count-1 downto 0 do
      begin
        dpos := strtointdef(copy(Lines[yy],2,3),0);
        if ((dpos > 0) and (dpos <= 84)) then
        begin
          dpos:=yy+1;
          break;
        end;
        dpos :=0;
      end;
      if (dpos <> 0) then
        if chk.IndexOf(temp) < 0 then
        begin
          Lines.Insert(dpos,'[084] '+temp);
          chk.Add(temp);
        end;
    end;
    data.HoldQuery.Next;
  end;
  chk.Free;
  disp2mrc(lines, rec);
end;


procedure Refresh856(recno : integer; baseurl : string; var rec : UTF8String);
var
  n, xx, yy, hcnt, dpos : integer;
  tag, furl : WideString;
  chk : TTntStringList;
  prefix : string;
begin
  Data.Query1.Close;
  Data.Query1.SQL.Clear;
  data.Query1.SQL.Add('select * from digital where recno='+inttostr(recno));
  Data.Query1.Execute;
  prefix:=trim(DO_Windows_storage_location);
  if prefix = '' then exit;
  prefix:=maprecno2dir(prefix,recno, 3, false);
  if prefix[length(prefix)] <> '/' then prefix:=prefix+'/';
  prefix:=copy(prefix,length(DO_Windows_storage_location)+1,length(prefix));
  for n := 1 to length(prefix) do
    if prefix[n]='\' then prefix[n]:='/';

  lines.Clear;
  marcrecord2lines(rec, lines);
  n := Lines.Count;
  //Erasing holdings information from MARC
  for xx := n-1 downto 0 do
  begin
    tag := copy(Lines[xx],2,3);
    if tag='856' then
    begin
      if pos('$xsrc',lines[xx]) > 0 then
        Lines.Delete(xx);
    end;
  end;
  hcnt := Data.Query1.RecordCount;
  Data.Query1.First;
  chk := TTntStringList.Create;
  //Inserting holdings information in MARC
  for xx:= 1 to hcnt do
  begin
    //Building 084 tag
    furl:='';
    if not IsEmptyField(Data.Query1, 'filename') then
    begin
      // FIXME : Filename should be htmlized
      furl :='4 '+'$u'+baseurl+prefix+URLEncode(Data.Query1.fieldbyname('filename').Value,false);
      if not IsEmptyField(Data.Query1, 'link_text') then
        furl :=furl+'$y'+Data.Query1.fieldbyname('link_text').Value;
      if not IsEmptyField(Data.Query1, 'note') then
        furl :=furl+'$z'+Data.Query1.fieldbyname('note').Value;
      furl := furl+'$xsrc';
      dpos:=0;
      for yy:=Lines.Count-1 downto 0 do
      begin
          dpos := strtointdef(copy(Lines[yy],2,3),0);
          if ((dpos > 0) and (dpos <= 856)) then
            begin
              dpos:=yy+1;
              break;
            end;
          dpos :=0;
      end;

      if (dpos <> 0) then
        if chk.IndexOf(furl) < 0 then
        begin
          Lines.Insert(dpos,'[856] '+furl);
          chk.Add(furl);
        end;
    end;
    data.query1.Next;
  end;
  chk.Free;
  disp2mrc(lines, rec);
end;


{
From Holis Classic:
08200 	|a 599.9/43 |2 22
1112 	|a International Symposium on Dental Morphology |n (14th : |d 2008 : |c Greifswald, Germany)
24510 	|a Comparative dental morphology : |b selected papers of the 14th International Symposium on Dental Morphology, August 27-30, 2008, Greifswald, Germany / |c volume editors, T. Koppe, G. Meyer, K.W. Alt ; co-editors, A. Brook ... [et al.].
260 	|a Basel [Switzerland] ; |a New York : |b Karger, |c c2009.
300 	|a xiii, 202 p. : |b ill. (some col.) ; |c 26 cm.
650 0 	|a Teeth |v Congresses.


042 	__ |a lcac
050 	00 |a TT382.6 |b .C65
100 	1_ |a Conway, Valerie.
650 	_0 |a Enamel and enameling.
}

procedure FixHollis(recmemo : TTntMemo);
var tag,ind, s:widestring;
    k,x,l,sfno:integer;
    frompleiades,nsp : boolean;
begin
  l := recmemo.CaretPos.Y;
  s := recmemo.lines[l];
  frompleiades := false;
  if ((s[1] = '[') or (s[5]=']')) then exit;

  if pos ('|', s) = 0 then frompleiades:=true;
  //exit;
  if frompleiades = false then
  begin
    x:=pos('|',s);
    tag := copy(s,1,x-1);
    s:=copy(s,x,length(s));

    x:=pos(#9,tag);
    if (x = 5) then // This means that it comes from LC
    begin
      ind := copy(tag,x+1,2);
      for k:=1 to length(ind) do
        if (ind[k]='_') then ind[k]:=' ';
      if length(ind) = 0 then ind:='  ';
    end
    else  // This is from Hollis Classic (Aleph)
    begin
      if (x = 0) then ind := copy(tag,4,length(tag))
      else ind := copy(tag,4,x-1);
      ind:=ind+'  ';
      if length(ind) >= 2 then ind:=copy(ind,1,2);
    end;
    tag := copy(tag,1,3);

    s := '['+tag+'] '+ind+s;


    k:=1;
    x:=1;
    sfno:=0;

    while x<=length(s) do
    begin
     if s[x]='|' then
     begin
      sfno:=sfno+1;
      if (k>1) then
        if ((s[k-1] = ' ') and (sfno > 1)) then
          k:=k-1; // Remove space before subfield delimiter.
      s[k]:='$';
      x:=x+1;
      k:=k+1;
      if s[x] = ' ' then x:=x+1;
      s[k]:=s[x];
      x:=x+1;
     end
     else s[k]:=s[x];
     k:=k+1;
     x:=x+1;
    end;
    while k<=length(s) do begin s[k]:=' '; k:=k+1; end;
    s:=trimright(s);
  end
  else
  begin /// copy from pleiades webopac
    if ((s[4] = #9) and (s[7] = #9)) then
    begin
      tag := copy(s,1,3);
      s:='['+tag+'] '+copy(s,8,length(s));
      k:=1;
      x:=1;
      nsp := false;
      while x<=length(s) do
      begin
       if s[x]='$' then begin nsp := true; s[k]:= s[x]; end
       else if s[x] = ' ' then begin if nsp = false then s[k]:= s[x] else begin nsp:=false; k:=k-1; end; end
       else s[k] := s[x];
       k:=k+1;
       x:=x+1;
      end;
      while k<=length(s) do begin s[k]:=' '; k:=k+1; end;
      s:=trimright(s);
    end
  end;
  recmemo.lines[l]:=s;
  recmemo.SetFocus;
end;

procedure AddDBInfo(var rec: UTF8String; recno: integer);
var
  i : integer;
begin
  lines.Clear;
  marcrecord2lines(rec, lines);
  zap_fields('935',1);
  if trim(FastRecordCreator.currentdatabase) <> '' Then
  begin
   i:=normal_first_field_position('935');
   if i > 0 then
     Lines[i]:='[935]   ' + '$a'+trim(FastRecordCreator.currentdatabase)+'$b'+inttostr(recno)
   else
     Lines.Insert(-i, '[935]   '+ '$a'+trim(FastRecordCreator.currentdatabase)+'$b'+inttostr(recno));
  end;
  disp2mrc(lines, rec);
end;

procedure zap_tag(var rec: UTF8String; tag: string);
begin
  lines.Clear;
  marcrecord2lines(rec, lines);
  zap_fields(tag,1);
  disp2mrc(lines, rec);
end;

{
function TagExists(tag, subf : string; var PrintLabel, Prefix, Suffix : WideString;
                   var LineFeed : boolean; var LFont, CFont : TMyFont) : boolean;
var
  b : boolean;
begin

  if subf <> ''
    Then
      b := data.Query1.Locate('Tag;Subf', VarArrayOf([tag, subf]), []) and data.Query1.FieldByName('print').AsBoolean
    Else
      b := data.Query1.Locate('Tag', VarArrayOf([tag]), []) and data.Query1.FieldByName('print').AsBoolean;

  if b Then
  begin
    PrintLabel := '';
    Prefix := '';
    Suffix := '';
    LineFeed := False;
    LFont.Name := '';
    LFont.Style := '000';
    LFont.Size := -1;
    CFont.Name := '';
    CFont.Style := '000';
    CFont.Size := -1;


    if not data.Query1.FieldByName('Prefix').IsNull Then
         Prefix := data.Query1.FieldByName('Prefix').Value;
    if not data.Query1.FieldByName('Label').IsNull Then
        PrintLabel := data.Query1.FieldByName('Label').Value;
    if not data.Query1.FieldByName('Linef').IsNull Then
        LineFeed := data.Query1.FieldByName('Linef').Value;
    if not data.Query1.FieldByName('Suffix').IsNull Then
        Suffix := data.Query1.FieldByName('Suffix').Value;

    //Label font
    if not data.Query1.FieldByName('l_font').IsNull Then
        LFont.Name := data.Query1.FieldByName('l_font').Value;
    if not data.Query1.FieldByName('l_style').IsNull Then
        LFont.Style := data.Query1.FieldByName('l_style').Value;
    if not data.Query1.FieldByName('l_size').IsNull Then
        LFont.Size := data.Query1.FieldByName('l_size').Value;

    //Content font
    if not data.Query1.FieldByName('c_font').IsNull Then
        CFont.Name := data.Query1.FieldByName('c_font').Value;
    if not data.Query1.FieldByName('c_style').IsNull Then
        CFont.Style := data.Query1.FieldByName('c_style').Value;
    if not data.Query1.FieldByName('c_size').IsNull Then
        CFont.Size := data.Query1.FieldByName('c_size').Value;
  end;

  Result := b;

end;
}

procedure OpenPrettyMARCQuery(ChosenName, lang : WideString; asinrec : boolean);
begin
  with Data.Query1 do
  begin
    Close;
    Filtered := False;
    SQL.Clear;
    SQL.Add('select * from marcdisplay');
    SQL.Add('where (Name = :name) and (Lang = :lang)');
    if asinrec then
      SQL.Add(' and fgroup = 1')
    else
      SQL.Add(' and (fgroup = 0 or fgroup is NULL)');
    SQL.Add(' Order by forder');
    ParamByName('name').AsWideString := ChosenName;
    ParamByName('lang').AsWideString := lang;
    Execute;
  end;
end;

procedure GetPrintTagLine(var tag, ind1, ind2, subf : string; var PrintLabel, Prefix, Suffix : WideString;
                   var LineFeed, asinrec: boolean; var LFont, CFont : TMyFont);
begin
  tag:='XXX';
  ind1:='?';
  ind2:='?';
  subf:='*';

  PrintLabel := '';
  Prefix := '';
  Suffix := '';
  LineFeed := False;
  asinrec:=false;
  LFont.Name := '';
  LFont.Style := '000';
  LFont.Size := -1;
  CFont.Name := '';
  CFont.Style := '000';
  CFont.Size := -1;


  if not data.Query1.FieldByName('tag').IsNull Then
    tag := data.Query1.FieldByName('tag').Value;

  if not data.Query1.FieldByName('ind1').IsNull Then
    ind1 := data.Query1.FieldByName('ind1').Value;

  if not data.Query1.FieldByName('ind2').IsNull Then
    ind2 := data.Query1.FieldByName('ind2').Value;

  if not data.Query1.FieldByName('subf').IsNull Then
    subf := data.Query1.FieldByName('subf').Value;

  if not data.Query1.FieldByName('Prefix').IsNull Then
    Prefix := data.Query1.FieldByName('Prefix').Value;
  if not data.Query1.FieldByName('Suffix').IsNull Then
    Suffix := data.Query1.FieldByName('Suffix').Value;
  if not data.Query1.FieldByName('Label').IsNull Then
    PrintLabel := data.Query1.FieldByName('Label').Value;

  if not data.Query1.FieldByName('Linef').IsNull Then
    LineFeed := data.Query1.FieldByName('Linef').AsBoolean;
  if not data.Query1.FieldByName('fgroup').IsNull Then
    asinrec := data.Query1.FieldByName('fgroup').AsBoolean;

  //Label font
  if not data.Query1.FieldByName('l_font').IsNull Then
    LFont.Name := data.Query1.FieldByName('l_font').Value;
  if not data.Query1.FieldByName('l_style').IsNull Then
    LFont.Style := data.Query1.FieldByName('l_style').Value;
  if not data.Query1.FieldByName('l_size').IsNull Then
    LFont.Size := data.Query1.FieldByName('l_size').Value;

  //Content font
  if not data.Query1.FieldByName('c_font').IsNull Then
    CFont.Name := data.Query1.FieldByName('c_font').Value;
  if not data.Query1.FieldByName('c_style').IsNull Then
    CFont.Style := data.Query1.FieldByName('c_style').Value;
  if not data.Query1.FieldByName('c_size').IsNull Then
    CFont.Size := data.Query1.FieldByName('c_size').Value;

end;

function process_tag (tag, ind1, ind2, ptag, pind1, pind2 : string) : boolean;
var x: integer;
begin
  result := false;
  if (tag = ptag) then result := true;
  if (not result) then
    for x:=3 downto 1 do
    begin
      tag[x]:='X';
      if (tag = ptag) then
      begin
        result:=true;
        break;
      end;
    end;

    if result then
    begin
      if ((strtointdef(tag,0) >= 10) and (ind1 <> '') and (ind2 <> '')) then
      begin
        result:=false;
        if (((ind1 = pind1) or (pind1 = '?')) and ((ind2=pind2) or (pind2='?'))) then
          result:=true;
      end;
    end;
end;

function ProcessRecnoForPrinting(rec : UTF8String; nr : integer;
textlen : longint; ForWord : boolean; var grouptext:WideString;
template, lang : string) : WideString;

type
      print_conf = record
        tag, ind1, ind2, subf : string;
        PrintLabel, Prefix, Suffix : Widestring;
        LineFeed, asinrec : Boolean;
        LFont, CFont : TMyFont;
      end;
var //Li, Ci,
  x, i, n, p, pc_cnt, MaxLabelLength : integer;
  Emptylabel, PrevLabel, PrintLabel,
  Prefix, Suffix, dtext,
  PrevLineFeed, LineFeedS, LineFeedWord,
  TextTillContent, stemp, temp, subtext, separator, emptyseparator : WideString;
  LineFeed, asinrec : boolean;
  ind1,ind2,tag, ptag, pind1,pind2, psubf : string;
  LFont, CFont : TMyFont;
  Print_conf_Array : array[1..1000] of print_conf;
begin
  Lines.Clear;
  MaxLabelLength := 0;
  pc_cnt := 0;
  try
    marcrecord2lines(rec, Lines);
  except
    exit;
  end;

  dtext := '';
  result:='';

  if ForWord then
  begin
    LineFeedWord := #13;
    separator := '$';
    emptyseparator :='$';
  end
  else
  begin
    LineFeedWord := #13#10;
    separator:= ': ';
    emptyseparator := '  ';
  end;

  PrevLineFeed := LineFeedWord;
  // FIXME : fonts and colors
  // FIXME : max length in line

  OpenPrettyMARCQuery(template, lang, false);
  data.Query1.First;
  PrevLabel := '';
  while not data.Query1.Eof do
  begin
    GetPrintTagLine(ptag, pind1,pind2, psubf,PrintLabel, Prefix, Suffix, LineFeed, asinrec, LFont, CFont);

    if pind1='' then pind1:='?';
    if pind2='' then pind2:='?';
    if ((psubf='') or (psubf='*')) then psubf:='abcdefghijklmnopqrstuvwxyz0123456789';
    psubf:=lowercase(psubf);

    pc_cnt:=pc_cnt +1;
    Print_conf_Array[pc_cnt].tag := ptag;
    Print_conf_Array[pc_cnt].ind1 := pind1;
    Print_conf_Array[pc_cnt].ind2 := pind2;
    Print_conf_Array[pc_cnt].subf := psubf;
    Print_conf_Array[pc_cnt].PrintLabel := PrintLabel;
    Print_conf_Array[pc_cnt].Prefix := Prefix;
    Print_conf_Array[pc_cnt].Suffix := Suffix;
    Print_conf_Array[pc_cnt].LineFeed := LineFeed;
    Print_conf_Array[pc_cnt].asinrec := asinrec;
    Print_conf_Array[pc_cnt].LFont := LFont;
    Print_conf_Array[pc_cnt].CFont := CFont;
    if length(PrintLabel) > MaxLabelLength then MaxLabelLength:=length(PrintLabel);
    data.Query1.Next;
  end;

  Emptylabel:='';
  for x:=1 to MaxLabelLength do Emptylabel:=Emptylabel+' ';

  n := Lines.Count - 1;
  PrevLabel := '';

  for p:=1 to pc_cnt do
  begin
    subtext:='';
    ptag       := Print_conf_Array[p].tag;
    pind1      := Print_conf_Array[p].ind1;
    pind2      := Print_conf_Array[p].ind2;
    psubf      := Print_conf_Array[p].subf;
    PrintLabel := Print_conf_Array[p].PrintLabel;
    Prefix     := Print_conf_Array[p].Prefix;
    Suffix     := Print_conf_Array[p].Suffix;
    LineFeed   := Print_conf_Array[p].LineFeed;
    asinrec    := Print_conf_Array[p].asinrec;
    LFont      := Print_conf_Array[p].LFont;
    CFont      := Print_conf_Array[p].CFont;

    if asinrec then continue;

    if LineFeed Then LineFeedS := LineFeedWord
    Else LineFeedS := ' ';

    if ptag = 'NUM' then
    begin
      if Printlabel <> '' then
      begin
       TextTillContent := PrintLabel;
       for x:=1 to MaxLabelLength - length(Printlabel) do
        TextTillContent:=TextTillContent+' ';
      end;
      dtext := dtext + TextTillContent + Prefix + IntToStr(nr) + Suffix + LineFeedS;
      continue;
    end;

    for i := 0 to n do
    begin
      ind1:='';
      ind2:='';
      tag := Copy(Lines[i], 2, 3);
      if strtointdef(tag,0) >= 10 Then
      begin
        temp := Copy(Lines[i], 9, length(Lines[i]));
        if length(Lines[i]) >=7 then ind1 := Lines[i][7];
        if length(Lines[i]) >=8 then ind2 := Lines[i][8];
      end
      Else temp := Copy(Lines[i], 7, length(Lines[i]));

      if process_tag(tag, ind1, ind2, ptag, pind1, pind2) then
      begin

         if strtointdef(tag,0) >= 10 then
         begin
           if ((strtointdef(tag,0) >=600) and (strtointdef(tag,0) <=699)) then
           begin
             for x:=1 to length(temp) do
               if temp[x]='$' then
               begin
                 if ((temp[x+1] = 'x') or(temp[x+1] = 'y') or(temp[x+1] = 'z') or(temp[x+1] = 'v')) then
                 begin
                   temp[x] := '-';
                   temp[x+1] := '-';
                 end
                 else temp[x]:=#31;
               end;
           end
           else
             for x:=1 to length(temp) do if temp[x]='$' then temp[x]:=#31;

           temp:=extract_field(temp,psubf,0,false);
         end;

         if temp <> '' Then
         begin
          if LineFeed Then LineFeedS := LineFeedWord
          Else LineFeedS := ' ';

          TextTillContent :='';
          if Printlabel <> '' then
          begin
           if PrevLabel <> PrintLabel then
           begin
            TextTillContent := PrintLabel;
            for x:=1 to MaxLabelLength - length(Printlabel) do
             TextTillContent:=TextTillContent+' ';
            TextTillContent := TextTillContent + separator;
           end
           else
            if PrevLineFeed = LineFeedWord then
            begin
              TextTillContent := Emptylabel + emptyseparator;
              PrevLineFeed := LineFeedS;
            end;
          end;

          PrevLabel:=Printlabel;

          subtext := subtext + TextTillContent +Prefix + temp + Suffix + LineFeedS;
         end
         else
           if ((LineFeed) and (psubf='-')) then subtext := subtext + LineFeedWord;
      end;
    end; // Line from MARC

    PrevLineFeed := LineFeedS;
    dtext := dtext + subtext;
  end;  // Line from marcdisplay


  // Process as the tags appear in the MARC record.
  pc_cnt :=0;
  OpenPrettyMARCQuery(template, lang, true);
  data.Query1.First;
  PrevLabel := '';
  while not data.Query1.Eof do
  begin
    GetPrintTagLine(ptag, pind1,pind2, psubf,PrintLabel, Prefix, Suffix, LineFeed, asinrec, LFont, CFont);

    if pind1='' then pind1:='?';
    if pind2='' then pind2:='?';
    if ((psubf='') or (psubf='*')) then psubf:='abcdefghijklmnopqrstuvwxyz0123456789';
    psubf:=lowercase(psubf);

    pc_cnt:=pc_cnt +1;
    Print_conf_Array[pc_cnt].tag := ptag;
    Print_conf_Array[pc_cnt].ind1 := pind1;
    Print_conf_Array[pc_cnt].ind2 := pind2;
    Print_conf_Array[pc_cnt].subf := psubf;
    Print_conf_Array[pc_cnt].PrintLabel := PrintLabel;
    Print_conf_Array[pc_cnt].Prefix := Prefix;
    Print_conf_Array[pc_cnt].Suffix := Suffix;
    Print_conf_Array[pc_cnt].LineFeed := LineFeed;
    Print_conf_Array[pc_cnt].asinrec := asinrec;
    Print_conf_Array[pc_cnt].LFont := LFont;
    Print_conf_Array[pc_cnt].CFont := CFont;
    if length(PrintLabel) > MaxLabelLength then MaxLabelLength:=length(PrintLabel);
    data.Query1.Next;
  end;

  PrevLabel := '';
  for i := 0 to n do
  begin
    ind1:='';
    ind2:='';
    tag := Copy(Lines[i], 2, 3);
    if strtointdef(tag,0) >= 10 Then
    begin
      temp := Copy(Lines[i], 9, length(Lines[i]));
      if length(Lines[i]) >=7 then ind1 := Lines[i][7];
      if length(Lines[i]) >=8 then ind2 := Lines[i][8];
    end
    Else temp := Copy(Lines[i], 7, length(Lines[i]));

    stemp := temp;

    for p:=1 to pc_cnt do
    begin
      ptag       := Print_conf_Array[p].tag;
      pind1      := Print_conf_Array[p].ind1;
      pind2      := Print_conf_Array[p].ind2;
      psubf      := Print_conf_Array[p].subf;
      PrintLabel := Print_conf_Array[p].PrintLabel;
      Prefix     := Print_conf_Array[p].Prefix;
      Suffix     := Print_conf_Array[p].Suffix;
      LineFeed   := Print_conf_Array[p].LineFeed;
      asinrec    := Print_conf_Array[p].asinrec;
      LFont      := Print_conf_Array[p].LFont;
      CFont      := Print_conf_Array[p].CFont;

      if not asinrec then continue;

      subtext:='';
      temp := stemp;
      if LineFeed Then LineFeedS := LineFeedWord
      Else LineFeedS := ' ';

      if process_tag(tag, ind1, ind2, ptag, pind1, pind2) then
      begin

         if strtointdef(tag,0) >= 10 then
         begin
           if ((strtointdef(tag,0) >=600) and (strtointdef(tag,0) <=699)) then
           begin
             for x:=1 to length(temp) do
               if temp[x]='$' then
               begin
                 if ((temp[x+1] = 'x') or(temp[x+1] = 'y') or(temp[x+1] = 'z') or(temp[x+1] = 'v')) then
                 begin
                   temp[x] := '-';
                   temp[x+1] := '-';
                 end
                 else temp[x]:=#31;
               end;
           end
           else
             for x:=1 to length(temp) do if temp[x]='$' then temp[x]:=#31;

           temp:=extract_field(temp,psubf,0,false);
         end;

         if temp <> '' Then
         begin
          if LineFeed Then LineFeedS := LineFeedWord
          Else LineFeedS := ' ';

          TextTillContent :='';
          if Printlabel <> '' then
          begin
           if PrevLabel <> PrintLabel then
           begin
            TextTillContent := PrintLabel;
            for x:=1 to MaxLabelLength - length(Printlabel) do
             TextTillContent:=TextTillContent+' ';
            TextTillContent := TextTillContent + separator;
           end
           else
            if PrevLineFeed = LineFeedWord then
            begin
              TextTillContent := Emptylabel + emptyseparator;
              PrevLineFeed := LineFeedS;
            end;
          end;

          PrevLabel:=Printlabel;

          subtext := subtext + TextTillContent +Prefix + temp + Suffix + LineFeedS;
         end
         else
           if ((LineFeed) and (psubf='-')) then subtext := subtext + LineFeedWord;
      end;

    PrevLineFeed := LineFeedS;
    dtext := dtext + subtext;

    end; // From MARCDISPLAY


  end; // Line from MARC

  Result := dtext + LineFeedWord;
end;

function get_max_hold_aa(recno : integer) : integer;
begin
  result := 0;
  data.Query1.Close;
  data.Query1.SQL.Clear;
  data.Query1.SQL.Add('SELECT MAX(aa) AS maxaaval FROM hold where recno='+inttostr(recno));
  data.Query1.Execute;
  if data.Query1.RecordCount > 0 Then
  begin
    data.Query1.First;
    if data.Query1.Fields[0].IsNull <> true then result:= data.Query1.Fields[0].AsInteger;
  end;
  data.Query1.Close;
end;

procedure MoveHoldingUpDown(direction : string; recno, holdon, aa : integer);
var q1, q2 : string;
begin
{
r h aa
1 1 1
1 2 2

up
UPDATE hold SET aa = :aa WHERE recno = :recno AND aa = :aa;
UPDATE hold SET aa = aa - 1 WHERE recno = :recno AND holdon = :holdon;

down
UPDATE hold SET aa = :aa WHERE recno = :recno AND aa = :aa+1;
UPDATE hold SET aa = aa + 1 WHERE recno = :recno AND holdon = :holdon;

}
  if (direction = 'up') then
  begin
    q1 := 'UPDATE hold SET aa = '+inttostr(aa)+' WHERE recno = '+inttostr(recno)+' AND aa = '+inttostr(aa-1);
    q2 := 'UPDATE hold SET aa = aa - 1 WHERE recno = '+inttostr(recno)+' AND holdon = '+inttostr(holdon);
  end
  else
  begin
    q1 := 'UPDATE hold SET aa = '+inttostr(aa)+' WHERE recno = '+inttostr(recno)+' AND aa = '+inttostr(aa+1);
    q2 := 'UPDATE hold SET aa = aa + 1 WHERE recno = '+inttostr(recno)+' AND holdon = '+inttostr(holdon);
  end;

  data.Query1.Close;
  data.Query1.SQL.Clear;
  data.Query1.SQL.Add(q1);
  data.Query1.Execute;

  data.Query1.Close;
  data.Query1.SQL.Clear;
  data.Query1.SQL.Add(q2);
  data.Query1.Execute;

end;

end.

