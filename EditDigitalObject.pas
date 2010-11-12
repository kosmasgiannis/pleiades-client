unit EditDigitalObject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DateUtils, Dialogs, TntDialogs, TntForms, Dropper, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls,
  DB, DataUnit, Mask, DBCtrls, TntDBCtrls, Buttons, TntButtons, ShellApi,
  utility, common, GlobalProcedures, mainunit;

type
  TEditDigital = class(TTntForm)
    TntLabel1: TTntLabel;
    FileDropper1: TFileDropper;
    TntDBEdit1: TTntDBEdit;
    TntDBMemo1: TTntDBMemo;
    TntLabel2: TTntLabel;
    TntLabel3: TTntLabel;
    TntLabel4: TTntLabel;
    TntDBMemo2: TTntDBMemo;
    TntDBMemo3: TTntDBMemo;
    OK: TTntBitBtn;
    Cancel: TTntBitBtn;
    DeleteBtn: TTntBitBtn;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    procedure FileDropper1Drop(Sender: TObject; Filename: String);
    procedure TntFormActivate(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure SaveDigital;
    procedure TntBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    prefix, origfilename, finalfilename : string;
    over : boolean;
    modifiedflag : boolean;

    { Public declarations }
  end;

var
  EditDigital: TEditDigital;

implementation

uses zoomit, MARCEditor;

{$R *.DFM}


procedure TEditDigital.FileDropper1Drop(Sender: TObject; Filename: String);
var s: string;
    res : integer;
begin
  s:=extractfilename(filename);
  over:=true;
  if filename <> prefix+s then
  begin
   if fileexists(prefix+s) then
   begin
     res := WideMessageDlg('Overwrite existing file?', mtConfirmation, [mbYes, mbNo], 0);
     if res = mrYes then over:=true
     else over:=false;
   end;
   tntdbedit1.Text:=s;
   finalfilename:=filename;
  end;
end;

procedure TEditDigital.TntFormActivate(Sender: TObject);
begin
 over := true;
 origfilename:=tntdbedit1.Text;
 prefix:='C:\';
 prefix:=trim(DO_Windows_storage_location);
 prefix:=maprecno2dir(prefix,data.digital.fieldbyname('recno').asinteger, 3, true);
 if prefix[length(prefix)] <> '\' then prefix:=prefix+'\';
 modifiedflag := false;
end;

procedure TEditDigital.OKClick(Sender: TObject);
var s : string;
begin
 if trim(tntdbedit1.Text) = '' then
 begin
   wideshowmessage('Please specify a valid file');
   Modalresult:=mrNone;
   modifiedflag:=false;
   exit;
 end;
 s:= prefix + trim(tntdbedit1.Text);
 if origfilename <> '' then
  if fileexists(prefix+origfilename) then
    DeleteFile(prefix+origfilename);
 CopyFile(Pchar(finalfilename), Pchar(s), over);
 modifiedflag:=true;
end;

procedure TEditDigital.DeleteBtnClick(Sender: TObject);
var res: integer;
begin
 if not data.digital.IsEmpty then
 begin
   res := WideMessageDlg('Do you want to delete this digital object from the database?',
              mtConfirmation, [mbYes, mbNo], 0);
   if res = mrYes then
     begin
       if fileexists(prefix+origfilename) then
        DeleteFile(prefix+origfilename);
       append_move(UserCode, 83,today, CurrentUserName + ' deleted D.O. '+prefix+origfilename+' for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString);
       data.digital.delete;
       modifiedflag := true;
       ModalResult:=mrOK;
     end;
 end;

end;

procedure TEditDigital.SaveDigital;
var rec : UTF8String;
begin
  if data.digital.State = dsInsert
    Then append_move(UserCode, 80,today, CurrentUserName + ' added a new D.O. for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString)
    Else append_move(UserCode, 81,today, CurrentUserName + ' changed the D.O. for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString);

  PostTable(data.digital);

  with Data.SecureBasket do
  begin
    EditTable(data.SecureBasket);
    disp2mrc(MarcEditorForm.full.Lines, rec);
    Refresh084(FieldByName('recno').AsInteger, rec);
    Refresh856(FieldByName('recno').AsInteger,DO_BaseURL, rec);
    GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
    TBlobField(FieldByName('text')).Modified := True;
    MarcEditorForm.full.Lines.Clear;
    marcrecord2memo(rec, MarcEditorForm.full);
    MARCEditorform.SaveData;
  end;
  close;
end;


procedure TEditDigital.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
//var recnr : integer;
begin

  case ModalResult of
    mrOK:  if modifiedflag then
           begin
             SaveDigital;
             //recnr := Data.Securebasket.FieldByName('recno').AsInteger;
             //RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));
           end;
    mrCancel: CancelTable(data.digital);
  end;
end;


procedure TEditDigital.TntBitBtn1Click(Sender: TObject);
var s : Widestring;
    x : Widestring;
    n : integer;
begin
 if tntdbedit1.Text <> '' then
 begin
  s:=prefix+tntdbedit1.Text;
  ShellExecuteW(handle,'Open', PWideChar(s), NiL, NiL, SW_SHOWNORMAL);
  x:=copy(prefix,length(DO_Windows_storage_location)+1,length(prefix));
  for n := 1 to length(x) do
    if x[n]='\' then x[n]:='/';
  x:=DO_BaseURL+x+URLEncode(tntdbedit1.Text,false);
//  showmessage(x);
 end;
end;

procedure TEditDigital.TntBitBtn2Click(Sender: TObject);
var s : widestring;
begin
  s:='c:\';
  ShellExecuteW(handle,'Open', PWideChar(s) , NiL, NiL, SW_SHOWNORMAL);
end;

end.
