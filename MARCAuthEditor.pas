unit MARCAuthEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, common, mycharconversion, TntStdCtrls, ComCtrls,
  Mask, DBCtrls, TntDBCtrls, dbcgrids, ExtCtrls, Grids, DBGrids, DateUtils,
  TntDBGrids, TntClasses, DB, TntComCtrls, Buttons, TntButtons, TntDialogs,
  TntMenus, TntForms, ActnList, cUnicodeCodecs;

type Tlink =
      record
       start : integer;
         len : integer;
         typ : Integer;
      spcode : integer;
        name : string;
      end;

      TCoord =
      record
        start : integer;
        len : integer;
      end;


type
  TMARCAuthEditorform = class(TTntForm)
    MainMenu1: TTntMainMenu;
    File1: TTntMenuItem;
    Save1: TTntMenuItem;
    Delete1: TTntMenuItem;
    Return1: TTntMenuItem;
    Edit0081: TTntMenuItem;
    Loadrecordfromfile1: TTntMenuItem;
    EditLeader1: TTntMenuItem;
    N1: TTntMenuItem;
    N2: TTntMenuItem;
    Saveastemplate1: TTntMenuItem;
    Editrecord1: TTntMenuItem;
    StatusBar1: TTntStatusBar;
    full: TTntMemo;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn5: TTntBitBtn;
    TntBitBtn6: TTntBitBtn;
    TntPopupMenu1: TTntPopupMenu;
    Editleader2: TTntMenuItem;
    Edit0082: TTntMenuItem;
    N3: TTntMenuItem;
    Loadfromtemplate1: TTntMenuItem;
    Saveastemplate2: TTntMenuItem;
    N4: TTntMenuItem;
    Arrangetags1: TTntMenuItem;
    ToolsBtn: TTntBitBtn;
    Edittag1: TTntMenuItem;
    ComboBox1: TTntComboBox;
    TntLabel1: TTntLabel;
    TntBitBtn7: TTntBitBtn;
    procedure Return1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Edit0081Click(Sender: TObject);
    procedure Loadrecordfromfile1Click(Sender: TObject);
    procedure EditLeader1Click(Sender: TObject);
    procedure Saveastemplate1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Editrecord1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure fullDblClick(Sender: TObject);
    procedure fullClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MakeReadOnly;
    procedure MakeEdit;
    procedure ToolsBtnClick(Sender: TObject);
    procedure Arrangetags1Click(Sender: TObject);
    procedure fullKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    saved : boolean;
    edit_from_result_set : boolean;
    record_index, previous_record, next_record : integer;
    
    function SaveAuthData : boolean;
  end;

var
  MARCAuthEditorform: TMARCAuthEditorform;
  reclock, inbasket, newrec : boolean;//saved,
  linenr : integer;
  myrecno:integer;
  links : array of Tlink;
  templatename : string;

procedure Refresh_auth;

implementation

uses form008auth, MyAccess, ldr, MainUnit, DataUnit,  Math, EditMarcUnit,
  StrUtils, WideIniClass, ProgresBarUnit, utility, GlobalProcedures;

{$R *.dfm}

procedure TMARCAuthEditorform.Return1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure load_from_template(filename : string);
var
  f : TextFile;
  rec : UTF8String;
begin

    AssignFile(F, FastRecordCreator.OpenDialog1.FileName);
    Reset(F);
    readln(f,rec);
    if (rec='MARC TEMPLATE') then
    begin
     while( not (eof(f))) do
     begin
      readln(f,rec);
      if (copy(rec,1,5) <> '[936]') then
        if (copy(rec,1,5) <> '[001]') then
          MARCAuthEditorForm.full.Lines.Add(UTF8StringToWideString(rec));
     end;
    end;
    CloseFile(f);

end;

procedure TMARCAuthEditorform.Save1Click(Sender: TObject);
begin
  SaveAuthData;
end;

procedure TMARCAuthEditorform.Delete1Click(Sender: TObject);
var
  res, recno: integer;
  text : UTF8String;
begin
  if not newrec then
  begin
    res := WideMessageDlg('Do you want to delete this record from the database?',
              mtConfirmation, [mbYes, mbNo], 0);
    if res = mrYes Then
    begin
      recno := data.auth.FieldByName('recno').AsInteger;
      text := WideStringToString(data.auth.GetBlob('text').AsWideString, Greek_codepage);

      data.auth.Delete;
      append_move(UserCode, 4, today, CurrentUserName + ' deleted auth recno=' + Data.auth.FieldByName('recno').AsString);
      RecordUpdated(myzebraauthhost, 'delete', recno, text);
      full.Modified := False;
      ModalResult := mrOk;
    end;
  end
  Else
  begin
    full.Modified := False;
    Close;
  end;

end;

procedure TMARCAuthEditorform.Edit0081Click(Sender: TObject);
var
  cl,i : integer;
begin
 cl := -1;
 for i:=0 to full.Lines.Count-1 do
  if copy(full.Lines[i],1,5) = '[008]' then begin cl := i; break; end;
 eightauth.Edit1.text:=copy(full.Lines[cl],7,length(full.Lines[cl]));
 eightauth.showmodal;
 full.Lines[cl] :='[008] '+eightauth.Edit1.text;
end;

procedure TMARCAuthEditorform.Loadrecordfromfile1Click(Sender: TObject);
begin
 load_and_merge_record(FastrecordCreator.Opendialog1, Full);
end;

procedure TMARCAuthEditorform.EditLeader1Click(Sender: TObject);
var
  cl,i : integer;
begin
 cl := -1;
 for i:=0 to full.Lines.Count-1 do
  if copy(full.Lines[i],1,5) = '[LDR]' then begin cl := i; break; end;
 if cl <> -1 then
 begin
  leaderform.record_type := 'auth';
  leaderform.Edit1.text:=copy(full.Lines[cl],7,length(full.Lines[cl]));
  leaderform.showmodal;
  full.Lines[cl] :='[LDR] '+leaderform.Edit1.text;
 end;
end;

procedure TMARCAuthEditorform.Saveastemplate1Click(Sender: TObject);
var
  i: integer;
  f: textfile;
begin
 FastRecordCreator.SaveDialog1.FileName := '';
 FastRecordCreator.SaveDialog1.Filter := 'TMPL files (*.tmpl)|*.tmpl';
 FastRecordCreator.SaveDialog1.FilterIndex := 1; { start the dialog showing all files }
 if FastRecordCreator.SaveDialog1.Execute then
 begin
  Assignfile(f,FastRecordCreator.Savedialog1.FileName);
  rewrite(f);
  writeln(f,'MARC TEMPLATE');
  for i:=0 to full.Lines.Count-1 do
   writeln(f,WideStringToUTF8String(full.lines[i]));
  CloseFile(f);
 end;
end;


procedure unlock_record;
begin
  if reclock Then
  begin
    EditTable(data.auth);
    data.auth['lockcode'] := -1;
    PostTable(data.auth);
    reclock := False;
  end;
end;


function TMARCAuthEditorform.SaveAuthData: boolean;
var
  action: string;
  rec: UTF8String;
  recnr : integer;
begin
   result :=true;
  FixMemo(full);

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  if disp2mrc(full.Lines,rec) = 0 then   //If the record was transformed successfully from Lines to MARC
   begin

    if  SyntaxCheck(full.Lines,'auth') <> true  then  result := false;

    if result = true then
    begin
      with data.auth do
       begin
         action:='update';
         EditTable(data.auth);
         EnhanceMARC(FieldByName('recno').AsInteger, rec);
         FieldByName('level').AsInteger := ComboBox1.ItemIndex;
         GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
         TBlobField(FieldByName('text')).Modified := True;

         if templatename = '' then
           begin
              FieldByName('Modified').Value := Today;
              FieldByName('Modifier').Value := UserCode;
           end;

         PostTable(data.auth);

         append_move(UserCode, 4, today, CurrentUserName + ' changed auth recno=' + Data.auth.FieldByName('recno').AsString);

         if not Data.auth.FieldByName('creator').IsNull then
              MARCAuthEditorform.StatusBar1.Panels[1].Text := 'Created by: ' + return_username(Data.auth.FieldByName('creator').AsInteger) +
               '  on  ' + Data.auth.FieldByName('created').AsString;

         if not Data.auth.FieldByName('modifier').IsNull then
              MARCAuthEditorform.StatusBar1.Panels[2].Text := 'Modified by: ' + return_username(Data.auth.FieldByName('modifier').AsInteger) +
               '  on  ' + Data.auth.FieldByName('modified').AsString;

       end;

    full.Lines.Clear;
    marcrecord2memo(rec, full);

    full.Modified := False;
    saved:=true;
    newrec := False;

    recnr := Data.auth.FieldByName('recno').AsInteger;
    RecordUpdated(myzebraauthhost, action, recnr, MakeMRCFromAuth(recnr));

    unlock_record;
   end;
  end
  Else
    result := false;

 if result = false then
     WideShowMessage('You have a syntax error in this record. Please check.');

end;

procedure TMARCAuthEditorform.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  res: integer;
begin
  if Full.Modified then
  begin
    res := WideMessageDlg('Record has not been saved.'+#10#13+'Do you want to save?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0);

    case res of
      mrYes: if not SaveAuthData Then Action := caNone;
      mrCancel: Action := caNone;
    end;
  end;

  if (Action <> caNone)and (data.auth.RecordCount > 0)
      then unlock_record;

end;

function take_lock : boolean;
begin
  data.auth.RefreshRecord;

  if (UserCode = 0) or  //User is an administrator
     (data.auth.FieldByName('lockcode').AsInteger = -1) or   //The record is not edited by any user
     (data.auth.FieldByName('lockcode').IsNull) or
     (data.auth.FieldByName('lockcode').AsInteger = UserCode) or  //The record is editing by me
     (MinutesBetween(now, data.auth.FieldByName('locktime').AsDateTime)>60)  //The lock is taken for more than 60 mins
  Then
  begin
    //Lock table
    EditTable(data.auth);
    data.auth['lockcode'] := UserCode;
    data.auth['locktime'] := now;
    PostTable(data.auth);

    reclock := True;
  end;

  Result := reclock;
end;

procedure TMARCAuthEditorform.MakeEdit;
begin

  if take_lock Then
  begin
    full.ReadOnly := False;

    ToolsBtn.Enabled := True;
    TntBitBtn5.Enabled := True;
    TntBitBtn6.Enabled := True;

    ComboBox1.Enabled := True;

    full.OnDblClick := fullDblClick;
  end
  Else
  ShowMessage('This record is being edited by another user');

end;

procedure TMARCAuthEditorform.MakeReadOnly;
begin
  full.ReadOnly := True;

  ToolsBtn.Enabled := False;
  TntBitBtn5.Enabled := False;
  TntBitBtn6.Enabled := False;

  ComboBox1.Enabled := False;

  full.OnDblClick := nil;
end;

procedure TMARCAuthEditorform.Editrecord1Click(Sender: TObject);
begin
  MakeEdit;
end;

procedure TMARCAuthEditorform.ComboBox1Change(Sender: TObject);
begin
  full.Modified := True;
end;

procedure TMARCAuthEditorform.fullDblClick(Sender: TObject);
var
  strr : string;
begin
  strr := LeftStr(full.Lines.Strings[linenr], 5);
  if strr='' then exit;

  if (strr='[LDR]') then MainMenu1.Items[0].Items[1].Click
  else if (strr='[008]') then MainMenu1.Items[0].Items[2].Click
  else
  begin
    EditMarcForm.str := full.Lines.Strings[linenr];
    if length(full.Lines.Strings[linenr])>6 then
    begin
      EditMarcForm.StatusBar1.SimpleText := StatusBar1.Panels[0].Text;
      EditMarcForm.record_type := 'auth';
      EditMarcForm.ShowModal;
      if EditMarcForm.ModalResult = mrOk then
      begin
        full.Lines.Delete(linenr);
        full.Lines.Insert(linenr, EditMarcForm.str);
      end;
    end;
  end;
end;

procedure TMARCAuthEditorform.fullClick(Sender: TObject);
begin
  linenr := full.CaretPos.Y;
end;

procedure TMARCAuthEditorform.FormCreate(Sender: TObject);
begin
  PopulateComboFromIni('AuthRecordLevel', ComboBox1);
end;

procedure Refresh_Auth;
var
  rec: UTF8String;
begin

 with MARCAuthEditorForm do
 begin

   StatusBar1.Panels[0].Text := '';
   StatusBar1.Panels[1].Text := '';
   StatusBar1.Panels[2].Text := '';
   full.Lines.Clear;
   saved := False;
   newrec := False;
   myrecno := FastRecordCreator.gotoauthrecno;

   MakeReadOnly;
   OpenAuthTable(myrecno);

   rec := WideStringToString(data.auth.GetBlob('text').AsWideString, Greek_codepage);

   try
     if rec<>'' then marcrecord2memo(rec, full);
   finally

     StatusBar1.Panels[0].Text := 'Record '+inttostr(myrecno)+'.';

     ComboBox1.ItemIndex := Data.auth.FieldByName('level').AsInteger;

     full.Modified := False;
   end;
 end;

end;

procedure Refresh_Form;
begin
  reclock := False;

  try
    Refresh_Auth;
  finally

    if templatename <> '' Then
    begin
      load_from_template(templatename);
      MARCAuthEditorform.SaveAuthData;
      templatename := '';
    end;

    if not Data.auth.FieldByName('creator').IsNull then
           MARCAuthEditorform.StatusBar1.Panels[1].Text := 'Created by: ' + return_username(Data.auth.FieldByName('creator').AsInteger) +
            '  on  ' + Data.auth.FieldByName('created').AsString;

    if not Data.auth.FieldByName('modifier').IsNull then
           MARCAuthEditorform.StatusBar1.Panels[2].Text := 'Modified by: ' + return_username(Data.auth.FieldByName('modifier').AsInteger) +
            '  on  ' + Data.auth.FieldByName('modified').AsString;
  end;

end;

procedure TMARCAuthEditorform.ToolsBtnClick(Sender: TObject);
var
  Point : TPoint;
begin
  Point.X := (Sender as TTntBitBtn).Left;
  Point.Y := (Sender as TTntBitBtn).Top + (Sender as TTntBitBtn).Height;

  Point := ClientToScreen(Point);

  TntPopupMenu1.Popup(Point.X, Point.Y);
end;

procedure TMARCAuthEditorform.Arrangetags1Click(Sender: TObject);
var
  a : wideString;
  b : wideString;
  i : integer;
  c : boolean;
begin

  repeat
    c:=false;

    for i := 1 to full.Lines.Count-2 do
    begin
      a := full.Lines.Strings[i];
      b := full.Lines.Strings[i+1];

      if Copy(full.Lines.Strings[i], 2, 3) > Copy(full.Lines.Strings[i+1], 2, 3) then
      begin
        full.Lines.Strings[i+1]:= a;
        full.Lines.Strings[i] := b;
        c := true;
      end;
    end;
  until (c=false);

end;

// By pressing Ctrl-T rearranges tags in the MARC Editor.
procedure TMARCAuthEditorform.fullKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 84) Then   //Key = t
      Arrangetags1Click(Sender);
end;

procedure TMARCAuthEditorform.TntFormShow(Sender: TObject);
begin
  refresh_form;
end;

end.
