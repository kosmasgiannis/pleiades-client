unit GlobalProcedures;

interface

Uses DataUnit,Forms,StdCtrls, DB, MyAccess,TntStdCtrls, sysutils, variants,
  MemDS, Windows, Controls, DateUtils, WinInet, TntButtons, dialogs,TntMenus, TntDBGrids,
  Buttons, Menus, DBGrids, TntExtCtrls, ExtCtrls, TntForms, TntDBCtrls, ShellApi, common, md5;


  function DownloadFile(const Url: string): string;
  function return_comp_name(x:string) : string;
  function return_form_name(x:string) : string;
  function ControlAdminUser(UserName,Password:String):boolean;
  function CryptPassword(Pass:String): String;
  Function VerifyPass(BDPass, GivenPass: String) : boolean;

  function return_username(id : integer) : WideString;
  procedure load_user_settings(uscode:integer);
  Procedure SetUserSetings(uscode:integer);
  procedure Save_Content(spc:integer;nam : string);
  procedure Populate_Vocabulary(ClType, comp,def : WideString);
  function GetContent(Spcode: integer) : string; overload;
  Function GetContent(Spcode, usercode: integer) : String; overload;
  procedure add_components;
  procedure set_vocabulary;
  procedure execute_component(comp,cotype,nname:WideString);
  procedure add_language(lang:string);


  procedure PostTable(Table: TCustomMyDataset);
  procedure CancelTable(Table: TCustomMyDataset);
  procedure EditTable(Table: TCustomMyDataset);
  function IsEditMode(Table: TCustomMyDataset) : boolean;
  procedure OpenTable(Table : TCustomMyDataset);
  procedure OpenQuery(Query : TMyQuery);
  procedure CloseTable(Table : TCustomMyDataset);
  procedure CloseQuery(Query : TMyQuery);
  function IsEmptyField(Table : TCustomMyDataset; FieldName : string) : boolean;

  function MessYesNo(msg1: WideString) : Boolean;   //Shows a standard YesNo dialog and retulrs True if Yes was pressed
  procedure MessOK(msg1 : WideString);              //Shows a warning message
  procedure ShowSaveDialog(Table : TMyTable);       //Show Save Dialog and posts or cancels the table

  procedure DisableUseUnicode; //Disable UseUnicode from MyConnection1
  procedure EnableUseUnicode;  //Enable UseUnicode from MyConnection1 and connect all table and queries
  function create_virtual_connection: TCustomMyConnection;
  Procedure Backup_Data(file_name:WideString);

  procedure append_move(user_code, severity : integer; date : TDate; Action : WideString);

  function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
  function StringToWideString(const ws: String; codePage: Word): WideString;

  procedure PopulateFromMyTable(Table : TCustomMyDataset; field : string; var ComboBox : TTntComboBox);
  procedure open_web_page( url : string);

const
  Greek_codepage = 1253;
  Latin1 = 1251;
  classTForm = 'TForm';
  classTntForm = 'TTntForm';

  classTntLabel = 'TTntLabel';
  classTntBitBtn = 'TTntBitBtn';
  classTntButton = 'TTntButton';
  classTntMenuItem = 'TTntMenuItem';
  classTntGroupBox = 'TTntGroupBox';
  classTntDBGrid = 'TTntDBGrid';
  classTntComboBox = 'TTntComboBox';
  classTntRadioGroup = 'TTntRadioGroup';
  classTntRadioButton = 'TTntRadioButton';

  classTLabel = 'TLabel';
  classTBitBtn = 'TBitBtn';
  classTButton = 'TButton';
  classTMenuItem = 'TMenuItem';
  classTGroupBox = 'TGroupBox';
  classTDBGrid = 'TDBGrid';
  classTComboBox = 'TComboBox';
  classTRadioGroup = 'TRadioGroup';
  classTRadioButton = 'TRadioButton';

    begin_dump =
'/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;'+#13#10+
'/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;'+#13#10+
'/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;'+#13#10+
'/*!40101 SET NAMES utf8 */;'+#13#10+
'/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;'+#13#10+
'/*!40103 SET TIME_ZONE=''+00:00'' */;'+#13#10+
'/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;'+#13#10+
'/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;'+#13#10+
'/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE=''NO_AUTO_VALUE_ON_ZERO'' */;'+#13#10+
'/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;'+#13#10;

    end_dump =
'/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;'+#13#10+
'/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;'+#13#10+
'/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;'+#13#10+
'/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;'+#13#10+
'/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;'+#13#10+
'/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;'+#13#10+
'/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;'+#13#10+
'/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;';

var
  UserName,
  CurrentUserName,
  branchcode : WideString;
  lang : string;

  usercode,
  current_user_access : integer;
  AppVersion, AppReleaseDate, AppName : string;
  Fetch : boolean;

implementation

uses Contnrs, Classes;

{
function DownloadFile_old(const Url: string): string;
var
  j:integer;
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1024] of Char;
  BytesRead: dWord;
begin
  Result := '';
  NetHandle := InternetOpen('Delphi 5.x', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then
  begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then
      // UrlHandle valid? Proceed with download
    begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        Result := Result + Buffer;
        FillChar(Buffer, SizeOf(Buffer), 0);
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
      until BytesRead = 0;
      InternetCloseHandle(UrlHandle);
    end;
    InternetCloseHandle(NetHandle);
  end
  else
    //NetHandle is not valid. Raise an exception 
    //raise Exception.Create('Unable to initialize Wininet');
    j:=0; // just be here
end;
}

function DownloadFile(const url: string): string;
var
  hInet: HINTERNET;
  hFile: HINTERNET;
  buffer: array[1..1024] of byte;
  bytesRead: DWORD;
begin
  result := '';
  hInet := InternetOpen(PChar(application.title),
    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  hFile := InternetOpenURL(hInet,PChar(url),nil,0,0,0);
  if Assigned(hFile) then
  begin
    repeat
      FillChar(Buffer, SizeOf(Buffer), 0);
      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
      result:=result+copy(string(@buffer),1,bytesRead);
    until bytesRead = 0;
    InternetCloseHandle(hFile);
  end;
  InternetCloseHandle(hInet);
end;

// Procedures about Loading Settings for users
//_________________________________________________________________________
Procedure SetUserSetings(uscode:integer);
var
  admtools : array of integer;
  didi,l,v:integer;
  sname,sdes:string;
  s:string;
begin

  with Data.Tools do
  begin
    Filtered := false;
    Filter := 'usercode='+QuotedStr(IntToStr(0));
    Filtered := true;
    didi:=data.tools.RecordCount;
    str(didi,s);
    setlength(admtools,didi+1);

    data.tools.first;
    for l:=1 to didi do
       begin
         admtools[l]:=data.Tools.fieldbyname('id').asinteger;
         data.tools.next;
       end;


    Filtered := false;
    for l:=1 to didi do
       begin
         if data.Tools.Locate('id',admtools[l],[]) then
             begin
                v:= data.Tools.fieldbyname('spcode').asinteger;
                sname:= data.Tools.fieldbyname('name').asstring;
                sdes:= data.Tools.fieldbyname('description').asstring;
                  if not (Locate('usercode;spcode',VarArrayOf([uscode,v]),[])) then
                     begin
                     data.tools.Append;
                     data.tools['spcode']:=v;
                     data.tools['usercode']:=uscode;
                     data.tools['name']:=sname;
                     data.tools['description']:=sdes;
                     data.tools.post;
                     end;

             end;
       end;

    Filtered := false;
    Filter := 'usercode='+QuotedStr(IntToStr(uscode));
    Filtered := true;
    end;


end;


//_____________________________________________________________________________
Function GetContent(Spcode: integer) : String;
begin
 result:=GetContent(Spcode,0);
end;

//_____________________________________________________________________________
Function GetContent(Spcode, usercode: integer) : String;
begin
 result:='';

 with Data.Tools do
 begin
   if Locate('Spcode;usercode',vararrayof([Spcode,usercode]),[]) then
     Result := FieldByName('description').Asstring;
   if ((usercode <> 0) and (result = '')) then
    if Locate('Spcode;usercode',vararrayof([Spcode,0]),[]) then
      Result := FieldByName('description').Asstring;
 end;
end;

//_____________________________________________________________________________
Procedure Save_Content(spc:integer;nam : string);
begin
  with data.Tools do
  begin
    if  Locate('spcode',spc,[]) then
       begin
         Edit;
         data.tools['description'] := nam;
         post;
       end
       else
       begin
        if usercode <> 0 then
        begin
            Append;
          data.tools['spcode'] := spc;
          data.tools['description'] := nam;
          data.Tools['usercode']:= usercode;
            post;
        end;
             Append;
          data.tools['spcode'] := spc;
          data.tools['description'] := nam;
          data.Tools['usercode']:= 0;
          data.Tools.post;
       end;

  end;
end;

//_____________________________________________________________________________
procedure load_user_settings(uscode:integer);
begin
  branchcode := GetContent(1003);
  lang:=GetContent(1000);
  SetUserSetings(uscode);
end;

//______________________________________________________________________________







//procedures about languages
//______________________________________________________________________________
procedure add_language(lang:string);
var
  vsp : integer;
begin
  Data.vocabulary.First;
  while Not Data.vocabulary.Eof do
  begin
    vsp := Data.vocabulary.FieldByName('Spcode').AsInteger;
    if Not(Data.languages.Locate(' lang',lang,[])) then
    begin
      Data.languages.Append;
      Data.languages.FieldByName('vocspcode').AsInteger := vsp;
      Data.languages.FieldByName('lang').AsString := lang;
      Data.languages.Post
    end;
    Data.vocabulary.Next
  end;

end;


//______________________________________________________________________________
function return_form_name(x:string):string;
var
   didi,l:integer;
begin

  didi:=length(x);
  l:=0;
  repeat
    l:=l+1;
  until (l>=didi) or (x[l+1]='.');
  return_form_name:=copy(x,0,l);
end;
//______________________________________________________________________________

function return_comp_name(x:string):string;
var
didi,l,k:integer;
s:string;
begin

didi:=length(x);
l:=0;
repeat
    l:=l+1;
until (l>=didi) or (x[l+1]='.');
k:=l+2;
l:=k;
repeat
    l:=l+1;
until (l>=didi) or (x[l+1]='.');

s:=copy(x,k,l-k+1);

return_comp_name:=s;
end;
//______________________________________________________________________________

function return_db_item(x:string):string;
var
didi,l,k:integer;
s:string;
begin

didi:=length(x);
l:=0;
repeat
    l:=l+1;
until (l>=didi) or (x[l+1]='.');

k:=l+2;
l:=k;
repeat
    l:=l+1;
until (l>=didi) or (x[l+1]='.');

k:=l+2;
l:=k;
repeat
    l:=l+1;
until (l>=didi) or (x[l+1]='.');

s:=copy(x,k,l-k+1);

Result := s;
end;
//______________________________________________________________________________

Function CryptPassword(Pass:String):String;
begin
  result:=md5digesttostr(md5string(pass));
end;

//_____________________________________________________________________________
Function MessYesNo(msg1 : WideString) : Boolean;
var
   tit : WideString;
begin
  Result := false;

  tit := application.Title;
  case MessageBoxW(0,PWideChar(msg1),PWideChar(tit), MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL) of
   mrYes : Result := True;
   mrNo : Result := False;
  end;

end;
//______________________________________________________________________________
function IsEditMode(Table: TCustomMyDataset) : boolean;
begin
  Result := (Table.State = dsEdit)or(Table.State = dsInsert);
end;
//______________________________________________________________________________
Function VerifyPass(BDPass, GivenPass: String) : boolean;
begin

  Result := false;

  if BDPass = CryptPassword(GivenPass) then
   Result := true;

end;

//______________________________________________________________________________
//______________________________________________________________________________
Procedure Populate_Vocabulary(ClType, comp,def : WideString);
begin
  with Data.vocabulary do
  begin
    Append;
    FieldByName('component').AsVariant := comp;
    FieldByName('Defaults').AsVariant := def;
    FieldByName('CompType').AsVariant := ClType;
    Post;
  end;
end;
//______________________________________________________________________________

procedure extract_from_TntDBGrid(apn : WideString;dbg:TTntDBGrid);
var
   i : integer;
   s : WideString;
begin
     for i:= 0 to dbg.Columns.Count-1 do
     begin
       s:=apn+'.'+dbg.Name+'.'+dbg.Columns.Items[i].DisplayName;
       if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
           Populate_Vocabulary(classTntDBGrid, s,dbg.Columns.Items[i].Title.Caption);
     end;

end;
//______________________________________________________________________________

procedure extract_from_DBGrid(apn : WideString;dbg:TDBGrid);
var
   i : integer;
   s : WideString;
begin
     for i:= 0 to dbg.Columns.Count-1 do
     begin
       s:=apn+'.'+dbg.Name+'.'+dbg.Columns.Items[i].DisplayName;
       if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
           Populate_Vocabulary(classTntDBGrid, s,dbg.Columns.Items[i].Title.Caption);
     end;

end;
//______________________________________________________________________________
procedure add_components;
var
  i,l:integer;
  s : WideString;
begin

for l:=0 to application.ComponentCount-1 do
  begin
    s:=application.Components[l].Name;

    //------------+++++++++++---TForm---+++++++++++---
    if (application.Components[l] is TForm) then
      if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
        Populate_Vocabulary(classTForm, s,  (application.Components[l] as TForm).Caption);

    //------------+++++++++++---TTntForm---+++++++++++---
    if (application.Components[l] is TTntForm) then
      if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
        Populate_Vocabulary(classTntForm, s,  (application.Components[l] as TTntForm).Caption);

    for I := 0 to application.Components[l].ComponentCount - 1 do
    begin
      //------------------------------TNTLabel
        if (application.Components[l].Components[I] is TTntLabel) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTntlabel, s,  (application.Components[l].Components[I] as TTntLabel).Caption);
        end;
      //------------------------------classTntBitBtn
        if (application.Components[l].Components[I] is TTntBitBtn) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTntBitBtn, s,  (application.Components[l].Components[I] as TTntBitBtn).Caption);
        end;
      //------------------------------classTntButton
        if (application.Components[l].Components[I] is TTntButton) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTntButton, s,  (application.Components[l].Components[I] as TTntButton).Caption);
        end;
      //------------------------------classTntMenuItem
        if (application.Components[l].Components[I] is TTntMenuItem) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
             Populate_Vocabulary(classTntMenuItem, s,  (application.Components[l].Components[I] as TTntMenuItem).Caption);
        end;
      //------------------------------classTntGroupBox
        if (application.Components[l].Components[I] is TTntGroupBox) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTntGroupBox, s,  (application.Components[l].Components[I] as TTntGroupBox).Caption);
        end;
      //------------------------------classTntDBGrid
        if (application.Components[l].Components[I] is TTntDBGrid) then
        begin
           extract_from_TntDBgrid(application.Components[l].Name,(application.Components[l].Components[I] as TTntDBGrid));
        end;
      //------------------------------classTntComboBox
        if (application.Components[l].Components[I] is TTntComboBox) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTntComboBox, s,  (application.Components[l].Components[I] as TTntComboBox).Items.Text);
        end;
      //------------------------------classTntRadioGroup
        if (application.Components[l].Components[I] is TTntRadioGroup) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTntRadioGroup, s,  (application.Components[l].Components[I] as TTntRadioGroup).Items.Text);
        end;
      //------------------------------classTntRadioButton
        if (application.Components[l].Components[I] is TTntRadioButton) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTntRadioButton, s,  (application.Components[l].Components[I] as TTntRadioButton).Caption);
        end;
      //--------------------------------------
      //  =====================================================
      //------------------------------classTLabel
        if (application.Components[l].Components[I] is TLabel) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTLabel, s,  (application.Components[l].Components[I] as TLabel).Caption);
        end;
      //------------------------------classTBitBtn
        if (application.Components[l].Components[I] is TBitBtn) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTBitBtn, s,  (application.Components[l].Components[I] as TBitBtn).Caption);
        end;
      //------------------------------classTButton
        if (application.Components[l].Components[I] is TButton) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTButton, s,  (application.Components[l].Components[I] as TButton).Caption);
        end;
       //------------------------------classTMenuItem
        if (application.Components[l].Components[I] is TMenuItem) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTMenuItem, s,  (application.Components[l].Components[I] as TMenuItem).Caption);
        end;
       //------------------------------classTGroupBox
        if (application.Components[l].Components[I] is TGroupBox) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTGroupBox, s,  (application.Components[l].Components[I] as TGroupBox).Caption);
        end;
       //------------------------------classTDBGrid
        if (application.Components[l].Components[I] is TDBGrid) then
        begin
          extract_from_DBGrid(application.Components[l].Name,(application.Components[l].Components[I] as TDBGrid ));
        end;
       //------------------------------classTComboBox
        if (application.Components[l].Components[I] is TComboBox) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTComboBox, s,  (application.Components[l].Components[I] as TComboBox).Items.Text);
        end;
       //------------------------------classTRadioGroup
        if (application.Components[l].Components[I] is TRadioGroup) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTRadioGroup, s,  (application.Components[l].Components[I] as TRadioGroup).Items.Text);
        end;
       //------------------------------classTRadioButton
        if (application.Components[l].Components[I] is TRadioButton) then
        begin
          s:=application.Components[l].Name+'.'+application.Components[l].Components[I].Name ;
          if Not Data.vocabulary.Locate('component',s,[loCaseInsensitive]) then
              Populate_Vocabulary(classTRadioButton, s,  (application.Components[l].Components[I] as TRadioButton).Caption);
        end;
        end;
      end;
 //end;
end;
//______________________________________________________________________________
function find_dbgrid_index(dbg : TDBGrid; dbgn : String):Integer;
var
   i : integer;
begin
  Result := -1;
  for i := 0 to dbg.Columns.Count-1 do
    if LowerCase(dbg.Columns.Items[i].DisplayName) = LowerCase(dbgn) then
    begin
      Result := i;
      Break;
    end;
end;
//______________________________________________________________________________
function find_Tntdb_index(dbg : TTntDBGrid; dbgn : String):Integer;
var
   i : integer;
begin
  i := -1;
  repeat
  inc(i);
  until (i > dbg.Columns.Count-1)or(LowerCase(dbg.Columns.Items[i].DisplayName) = LowerCase(dbgn))  ;
  Result := i;
end;
//______________________________________________________________________________

procedure execute_component(comp,cotype,nname:WideString);
var
  l,apdidi, i,n :integer;
  compform,compname, s,
  dbitem : WideString;
  curform:integer;
begin

  curform:=0;
  compform:=return_form_name(comp);

  if (cotype = classTForm) or (cotype = classTntForm) then
    for i := 0 to Application.ComponentCount-1 do
    begin
      if (cotype = classTForm) Then
      begin
        if LowerCase(Application.Components[i].Name) = LowerCase(compform) then
        begin
          (Application.Components[i] as TForm).Caption := nname;
          break;
        end
      end
      Else
        if LowerCase(Application.Components[i].Name) = LowerCase(compform) then
        begin
          (Application.Components[i] as TTntForm).Caption := nname;
          break;
        end;
    end
  else
  begin

    compname:=return_comp_name(comp);


    apdidi := application.ComponentCount;

    for l:=1 to apdidi-1 do
    begin
      s:=application.Components[l].Name;
      if s = compform then curform := l;
    end;



    if curform>0 then
    begin
      with application.Components[curform] do
      begin
        if FindComponent(compname) <> nil then
        begin
          //-----------------TTntLabel
          if cotype = classTntLabel then
             TTntLabel(FindComponent(compname)).Caption := nname;
          //-----------------TTntBitBtn
          if cotype = classTntBitBtn then
             TTntBitBtn(FindComponent(compname)).Caption := nname;
          //-----------------TTntButton
          if cotype = classTntButton then
                    TTntButton(FindComponent(compname)).Caption := nname;
          //-----------------TTntMenuItem
          if cotype = classTntMenuItem then
                    TTntMenuItem(FindComponent(compname)).Caption := nname;
          //-----------------TTntGroupBox
          if cotype = classTntGroupBox then
                    TTntGroupBox(FindComponent(compname)).Caption := nname;
          //-----------------TTntDBGrid
          if cotype = classTntDBGrid then
          begin

            dbitem := return_db_item(comp);

            n := find_Tntdb_index(TTntDBGrid(FindComponent(compname)),dbitem);
            if n < TTntDBGrid(FindComponent(compname)).Columns.Count then
                TTntDBGrid(FindComponent(compname)).Columns.Items[n].Title.Caption := nname;
          end;
          //-----------------TTntComboBox
          if cotype = classTntComboBox then
                      TTntComboBox(FindComponent(compname)).Items.Text := nname;
          //-----------------TTntRadioGroup
          if cotype = classTntRadioGroup then
                      TTntRadioGroup(FindComponent(compname)).Items.Text := nname;
          //-----------------TTntRadioButton
          if cotype = classTntRadioButton then
                    TTntRadioButton(FindComponent(compname)).Caption := nname;
          //-----------------TLabel
          if cotype = classTLabel then
                    TLabel(FindComponent(compname)).Caption := nname;
          //-----------------TBitBtn
          if cotype = classTBitBtn then
                    TBitBtn(FindComponent(compname)).Caption := nname;
          //-----------------TButton
          if cotype = classTButton then
                      TButton(FindComponent(compname)).Caption := nname;
          //-----------------TMenuItem
          if cotype = classTMenuItem then
                      TMenuItem(FindComponent(compname)).Caption := nname;
          //-----------------TGroupBox
          if cotype = classTGroupBox then
                      TGroupBox(FindComponent(compname)).Caption := nname;
          //-----------------TDBGrid
          if cotype = classTDBGrid then
          begin
            dbitem := return_db_item(comp);
            TDBGrid(FindComponent(compname)).Columns.Items[find_dbgrid_index(TDBGrid(FindComponent(compname)),dbitem)].Title.Caption := nname;
          end;
          //-----------------TComboBox
          if cotype = classTComboBox then
                      TComboBox(FindComponent(compname)).Items.Text := nname;
          //-----------------TRadioGroup
          if cotype = classTRadioGroup then
                      TRadioGroup(FindComponent(compname)).Items.Text := nname;
          //-----------------TRadioButton
          if cotype = classTRadioButton then
                      TRadioButton(FindComponent(compname)).Caption := nname;
        end;
      end;
    end;
  end;

end;
//______________________________________________________________________________

//______________________________________________________________________________
procedure set_vocabulary;
var
didi,l:integer;
erminia : WideString;
begin

 if Data.Tools.Locate('Spcode;usercode',vararrayof(['1000',usercode]),[]) then
   lang := Data.Tools.FieldByName('description').Asstring;

  didi:=data.vocabulary.recordcount;
  data.vocabulary.First;
  for l:=1 to didi do
  begin
   erminia := data.vocabulary.fieldbyname('defaults').Value;
   if data.languages.Locate('lang',lang,[]) then if data.languages.fieldbyname('value').asstring <> '' then
                                                     erminia := data.languages.fieldbyname('value').Asvariant;
    execute_component(data.vocabulary.fieldbyname('component').AsVariant,data.vocabulary.fieldbyname('comptype').AsString,erminia);
    data.vocabulary.Next;
  end;
end;
//______________________________________________________________________________

procedure EditTable(Table: TCustomMyDataset);
begin
  if (Table.State <> dsEdit)and(Table.State <> dsInsert) Then
    Table.Edit;
end;

//______________________________________________________________________________
procedure PostTable(Table: TCustomMyDataset);
begin
  if (Table.State = dsEdit)or(Table.State = dsInsert) Then
    Table.Post;
end;

//______________________________________________________________________________
procedure CancelTable(Table: TCustomMyDataset);
begin
  if (Table.State = dsEdit)or(Table.State = dsInsert) Then
    Table.Cancel;
end;

//______________________________________________________________________________
procedure MessOK(msg1 : WideString);
var
   tit : WideString;
begin
  tit := application.Title;
  MessageBoxW(0,PWideChar(msg1),PWideChar(Tit), MB_OK + MB_ICONEXCLAMATION + MB_TASKMODAL);
end;
//______________________________________________________________________________

procedure ShowSaveDialog(Table : TMyTable);
begin
  case
   MessageBox(0,'Do you want to save the changes?','New Entity', MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL) of
  mrYes :
           PostTable(Table);
  mrNo :
         CancelTable(Table);
   end;
end;
//______________________________________________________________________________
Procedure OpenTable(Table : TCustomMyDataset);
begin
  if Not Table.Active then
    Table.Open;
end;
//______________________________________________________________________________
procedure OpenQuery(Query : TMyQuery);
begin
    if Not Query.Active then
    Query.Open;
end;
//______________________________________________________________________________
Procedure CloseTable(Table : TCustomMyDataset);
begin
  if Table.Active then
    Table.Close;
end;
//______________________________________________________________________________
procedure CloseQuery(Query : TMyQuery);
begin
    if Query.Active then
    Query.close;
end;
 //_________________________________________________________________________
Function ControlAdminUser(UserName,Password:String):boolean;
begin

  Result := false;

  if UpperCase(UserName) = 'ADMIN' then
     if Password = Inttostr(20*DayOfTheMonth(today)) then
      begin
        current_user_access := 10;
        Result := true;
      end;

end;
//___

//_____this is for backup________________________________________________________________________
//Disable UseUnicode from MyConnection1 //
//_____________________________________________________________________________
Procedure DisableUseUnicode;
begin
  Data.MyConnection1.Disconnect;
  Data.MyConnection1 .Options.UseUnicode := false;;
  Data.MyConnection1.Connect;
end;
//_____________________________________________________________________________


//Enable UseUnicode from MyConnection1 and connect all table and queries
//_____________________________________________________________________________
procedure EnableUseUnicode;
begin
  Data.MyConnection1.Disconnect;
  Data.MyConnection1.Options.UseUnicode := true;
  Data.MyConnection1.Connect;
end;

//_________________________________________________________________________
procedure append_move(user_code, severity : integer; date : TDate; Action : WideString);
begin
  with Data do
  begin
    if not Moves.Active Then
    begin
      Moves.Filtered := true;
      Moves.Filter:='usercode='+inttostr(user_code)+' and date="'+datetostr(date)+'"';
      Moves.Open;
    end;
    PostTable(Moves);

    if Moves.IsEmpty then  moves.Edit
    else  Moves.Append;

    Moves.FieldByName('usercode').Value := user_code;
    Moves.FieldByName('date').Value := date;
    Moves.FieldByName('severity').AsInteger := severity;
    Moves.FieldByName('time').AsDateTime := now;    
    Moves.FieldByName('action').Value := Action;
    PostTable(Moves);
  end;
end;

function return_username(id : integer) : WideString;
var
  f : WideString;
begin

  f := '';
  if id = 0 then
      f:= 'administrator'
  else if Data.Users.Locate('usercode', id, []) then
     begin
       if Data.Users.FieldByName('Userfirstname').AsString <> '' then
             f := Data.Users.FieldByName('Userfirstname').AsVariant;
       if Data.Users.FieldByName('Userlastname').AsString <> '' then
             f :=f + '  ' +Data.Users.FieldByName('Userlastname').AsVariant;
     end;

  Result := f;

end;


function IsEmptyField(Table : TCustomMyDataset; FieldName : string) : boolean;
begin

  Result := (Table.FieldByName(FieldName).IsNull) or
            (Table.FieldByName(FieldName).AsString = '');

end;
//______Create a new myconnection in runtime____________________________________
function create_virtual_connection: TCustomMyConnection;
var
   VirtualConnection : TMyConnection;
begin

  try
   with Data do
   begin
     VirtualConnection := TMyConnection.Create(Data);
     VirtualConnection.Server := MyConnection1.Server;
     VirtualConnection.Database := MyConnection1.Database;
     VirtualConnection.Username := MyConnection1.Username;
     VirtualConnection.Password := MyConnection1.Password;
     VirtualConnection.LoginPrompt := MyConnection1.LoginPrompt;
     VirtualConnection.Options.Charset := MyConnection1.Options.Charset;
     VirtualConnection.Options.UseUnicode := false;
     VirtualConnection.Connected := true;
     Result := VirtualConnection;
   end;
  except
      MessageBox(0,PAnsiChar('ERROR! Backup has been intrerupted!'),PAnsiChar(Application.Title), MB_OK + MB_ICONWARNING + MB_TASKMODAL);
      Result := nil;
  end;

end;

//____________________________________________________________________________
Procedure Backup_Data(file_name:WideString);
var
   f1,f2 : textfile;
   Value : string;
   tempfile : string;
   filename : string;
begin
    filename := 'tempf';
    tempfile := ExtractFilePath(Application.ExeName) + filename;
    try
      Data.MyDump1.Connection := create_virtual_connection;
      Data.MyDump1.BackupToFile(tempfile);
      AssignFile(f1,tempfile);
      Reset(f1);
      AssignFile(f2, file_name);
      Rewrite(f2);
      Writeln(f2, begin_dump);
        while not eof(f1) do
          begin
            Readln(f1,value);
            writeln(f2,value);
          end;
      writeln (f2, end_dump);
    finally
      CloseFile(f1);
      CloseFile(f2);
      DeleteFile(PAnsiChar(tempfile));
    end;
 end;
//___________________________________________________________________________

function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
else
  begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], -1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], -1, @Result[1], l - 1, nil, nil);
  end;
end;

function StringToWideString(const ws: String; codePage: Word): WideString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
else
  begin
    l := MultiByteToWideChar(codePage,
      MB_PRECOMPOSED,
      @ws[1], -1, nil, 0);
    SetLength(Result, l - 1);
    if l > 1 then
      MultiByteToWideChar(codePage,
        MB_PRECOMPOSED,
        @ws[1], -1, @Result[1], l - 1);
  end;
end;


procedure PopulateFromMyTable(Table : TCustomMyDataset; field : string; var ComboBox : TTntComboBox);
var
  i, n : integer;
begin

  ComboBox.Items.Clear;
  n := Table.RecordCount;
  Table.First;
  
  for i := 1 to n do
  begin
    if not IsEmptyField(Table, field) Then
      ComboBox.Items.Add(Table.FieldByName(field).Value);

    Table.Next;
  end;

end;

procedure open_web_page( url : string);
begin
  ShellExecute(GetDesktopWindow(), 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;

end.

