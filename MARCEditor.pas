unit MARCEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, common, mycharconversion, TntStdCtrls, ComCtrls,
  Mask, IniFiles, DBCtrls, TntDBCtrls, dbcgrids, ExtCtrls, Grids, DBGrids, DateUtils,
  TntDBGrids, TntClasses, DB, TntComCtrls, Buttons, TntButtons, TntDialogs,
  TntMenus, TntForms, ActnList, cUnicodeCodecs;

type Tlink =
      record
       start : integer;
         len : integer;
         typ : Integer;
      holdon : integer;
      recno  : integer;
         aa  : integer;
        name : string;
      end;

      TCoord =
      record
        start : integer;
        len : integer;
      end;


type
  TMARCEditorform = class(TTntForm)
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
    ComboBox1: TTntComboBox;
    Label2: TTntLabel;
    full: TTntMemo;
    TntRichEditME: TTntRichEdit;
    New: TTntBitBtn;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn5: TTntBitBtn;
    TntBitBtn6: TTntBitBtn;
    TntBitBtn7: TTntBitBtn;
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
    DBText1: TTntDBText;
    DBText2: TTntDBText;
    TntBitBtn2: TTntBitBtn;
    TntBitBtn3: TTntBitBtn;
    N5: TTntMenuItem;
    Locate1: TTntMenuItem;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    FixHollis1: TTntMenuItem;
    ActionList1: TActionList;
    ActFixHollis: TAction;
    prevrec: TTntBitBtn;
    nextrec: TTntBitBtn;
    TntBitBtn4: TTntBitBtn;
    AuthorityLookup1: TTntMenuItem;
    procedure Return1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Edit0081Click(Sender: TObject);
    procedure Loadrecordfromfile1Click(Sender: TObject);
    procedure EditLeader1Click(Sender: TObject);
    procedure Saveastemplate1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Editrecord1Click(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure DBCtrlGrid1DblClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure fullDblClick(Sender: TObject);
    procedure fullClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TntRichEditMEMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TntRichEditMEMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MakeReadOnly;
    procedure MakeEdit;

    procedure Refresh_Holdings(var richedit : TTntRichEdit);

    procedure SetTextInRichEdit(TntRichEdit1 : TTntRichEdit);
    Procedure SetHoldInRichEdit(RichEdit : TTntRichEdit);
    procedure ToolsBtnClick(Sender: TObject);
    procedure Arrangetags1Click(Sender: TObject);
    procedure TntRichEditMEDblClick(Sender: TObject);
    procedure fullKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntFormShow(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntBitBtn3Click(Sender: TObject);
    procedure Locate1Click(Sender: TObject);
    procedure ActFixHollisExecute(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
    procedure prevrecClick(Sender: TObject);
    procedure nextrecClick(Sender: TObject);
    procedure TntBitBtn4Click(Sender: TObject);
    procedure AuthorityLookup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    holdings_moved,
    saved : boolean;
    edit_from_result_set : boolean;
    record_index, previous_record, next_record : integer;
    function SaveData : boolean;
  end;

var
  MARCEditorform: TMARCEditorform;
  reclock, inbasket, newrec : boolean;//saved,
  linenr : integer;
  myrecno:integer;
  links : array of Tlink;
  templatename : string;


procedure Refresh_SafeBasket;

implementation

uses zoomit, form008, MyAccess, ldr, MainUnit, DataUnit,  Math, EditMarcUnit,
  StrUtils, WideIniClass, ProgresBarUnit, utility,
  GlobalProcedures, HoldingsUnit, ShowHoldMemoUnit, DigitalUnit, zlocate,
  HoldingsRangeUnit,
  zauthlookup;

{$R *.dfm}

procedure TMARCEditorform.Return1Click(Sender: TObject);
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
          if (copy(rec,1,5) <> '[001]') then MARCEditorForm.full.Lines.Add(UTF8StringToWideString(rec));

     end;
    end;
    CloseFile(f);


// templatename := '';
end;

procedure TMARCEditorform.Save1Click(Sender: TObject);
begin
  SaveData;
end;

procedure TMARCEditorform.Delete1Click(Sender: TObject);
var
  res, recno: integer;
  text : UTF8String;
begin
  if not newrec then
  begin
    if Data.hold.RecordCount = 0 Then
    begin
      if Data.digital.RecordCount = 0 Then
      begin
        res := WideMessageDlg('Do you want to delete this record from the database?',
                  mtConfirmation, [mbYes, mbNo], 0);
        if res = mrYes Then
        begin
          recno := data.SecureBasket.FieldByName('recno').AsInteger;
          text := WideStringToString(data.SecureBasket.GetBlob('text').AsWideString, Greek_codepage);
  
          data.Securebasket.Delete;
          append_move(UserCode, 6, today, CurrentUserName + ' deleted recno=' + Data.auth.FieldByName('recno').AsString );

          RecordUpdated(myzebrahost, 'delete', recno, text);
          full.Modified := False;
          ModalResult := mrOk;
        end;
      end
      Else WideShowMessage('There are digital objects for this record. Please delete them first');
    end
    Else WideShowMessage('There are holdings for this record. Please delete them first');
  end
  Else
  begin
    full.Modified := False;
    Close;
  end;

end;

procedure TMARCEditorform.Edit0081Click(Sender: TObject);
var
  cl,i : integer;
  mater : string;
begin
 cl := -1;
 for i:=0 to full.Lines.Count-1 do
  if copy(full.Lines[i],1,5) = '[008]' then begin cl := i; break; end;
 for i:=0 to full.Lines.Count-1 do
  if copy(full.Lines[i],1,5) = '[LDR]' then begin mater:=type_of_material(copy(full.Lines[i],7,100)); break; end;
 if ((mater<>'MP') and (mater<>'VM') and (mater <> 'SE') and (mater <> 'AM')and (mater <> 'MA')and (mater <> 'MU')) then mater :='BK';
 if cl <> -1 then
 begin
  eight.Edit1.text:=copy(full.Lines[cl],7,length(full.Lines[cl]));
  eight.typeofmaterial:=mater;
  eight.showmodal;
  full.Lines[cl] :='[008] '+eight.Edit1.text;
 end;
end;

procedure TMARCEditorform.Loadrecordfromfile1Click(Sender: TObject);
begin
 load_and_merge_record(FastrecordCreator.Opendialog1, Full);
end;

procedure TMARCEditorform.EditLeader1Click(Sender: TObject);
var
  cl,i : integer;
begin
 cl := -1;
 for i:=0 to full.Lines.Count-1 do
  if copy(full.Lines[i],1,5) = '[LDR]' then begin cl := i; break; end;
 if cl <> -1 then
 begin
  leaderform.record_type := 'bib';
  leaderform.Edit1.text:=copy(full.Lines[cl],7,length(full.Lines[cl]));
  leaderform.showmodal;
  full.Lines[cl] :='[LDR] '+leaderform.Edit1.text;
 end;
end;

procedure TMARCEditorform.Saveastemplate1Click(Sender: TObject);
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
    EditTable(data.Securebasket);
    data.Securebasket['lockcode'] := -1;
    PostTable(data.Securebasket);

    reclock := False;
  end;
end;


function TMARCEditorform.SaveData: boolean;
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

    if  SyntaxCheck(full.Lines,'bib') <> true  then  result := false;

    if result = true then
    begin
      with data.secureBasket do
       begin
         action:='update';
         EditTable(data.SecureBasket);

         EnhanceMARC(FieldByName('recno').AsInteger, rec);
         Refresh084(FieldByName('recno').AsInteger, rec);
//FIXME :  Refresh856(FieldByName('recno').AsInteger, rec);

         FieldByName('level').AsInteger := ComboBox1.ItemIndex;
         GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
         TBlobField(FieldByName('text')).Modified := True;

         if templatename = '' then
           begin
              FieldByName('Modified').Value := Today;
              FieldByName('Modifier').Value := UserCode;
           end;

         PostTable(data.secureBasket);

         append_move(UserCode, 6,today, CurrentUserName + ' changed recno=' + Data.SecureBasket.FieldByName('recno').AsString);

         if not Data.securebasket.FieldByName('creator').IsNull then
              MARCEditorform.StatusBar1.Panels[1].Text := 'Created by: ' + return_username(Data.securebasket.FieldByName('creator').AsInteger) +
               '  on  ' + Data.securebasket.FieldByName('created').AsString;

         if not Data.securebasket.FieldByName('modifier').IsNull then
              MARCEditorform.StatusBar1.Panels[2].Text := 'Modified by: ' + return_username(Data.securebasket.FieldByName('modifier').AsInteger) +
               '  on  ' + Data.securebasket.FieldByName('modified').AsString;

       end;

    full.Lines.Clear;
    marcrecord2memo(rec, full);

    full.Modified := False;
    saved:=true;
    holdings_moved:=false;
    newrec := False;

    recnr := Data.SecureBasket.FieldByName('recno').AsInteger;
    RecordUpdated(myzebrahost, action, recnr, MakeMRCFromSecureBasket(recnr));

    unlock_record;
   end;
  end
  Else
    result := false;

 if result = false then
     WideShowMessage('You have a syntax error in this record. Please check.');

end;

procedure TMARCEditorform.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  res: integer;
begin
  if Full.Modified then
  begin
    res := WideMessageDlg('Record has not been saved.'+#10#13+'Do you want to save?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0);

    case res of
      mrYes: if not SaveData Then Action := caNone;
      mrCancel: Action := caNone;
    end;
  end
  else if (holdings_moved = true) then
  begin
    res := WideMessageDlg('Record must be saved because holdings have been moved.',
    mtConfirmation, [mbYes, mbCancel], 0);

    if res = mrYes then
    begin
      if not SaveData Then Action := caNone;
    end
    else
      Action := caNone;
  end;

  if (Action <> caNone) then
  begin
    data.freeparams(data.loancategories);
    data.freeparams(data.processstatuses);
    if (data.securebasket.RecordCount > 0)then unlock_record;
  end;
end;

function take_lock : boolean;
begin
  data.Securebasket.RefreshRecord;

  if (UserCode = 0) or  //User is an administrator
     (data.Securebasket.FieldByName('lockcode').AsInteger = -1) or   //The record is not edited by any user
     (data.Securebasket.FieldByName('lockcode').IsNull) or
     (data.Securebasket.FieldByName('lockcode').AsInteger = UserCode) or  //The record is editing by me
     (MinutesBetween(now, data.Securebasket.FieldByName('locktime').AsDateTime)>60)  //The lock is taken for more than 60 mins
  Then
  begin
    //Lock table
    EditTable(data.Securebasket);
    data.Securebasket['lockcode'] := UserCode;
    data.Securebasket['locktime'] := now;
    PostTable(data.Securebasket);

    reclock := True;
  end;

  Result := reclock;
end;

procedure TMARCEditorform.MakeEdit;
begin

if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
begin
  WideShowMessage('You do not have permission to modify this record.');
end
else
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
end;

procedure TMARCEditorform.MakeReadOnly;
begin
  full.ReadOnly := True;


  ToolsBtn.Enabled := False;
  TntBitBtn5.Enabled := False;
  TntBitBtn6.Enabled := False;

  ComboBox1.Enabled := False;

  full.OnDblClick := nil;
end;

procedure TMARCEditorform.Editrecord1Click(Sender: TObject);
begin
  MakeEdit;
end;

procedure TMARCEditorform.NewClick(Sender: TObject);
begin
if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
begin
  WideShowMessage('You do not have permission to add holdings for this record.');
end
else
begin

  if (SyntaxCheck(full.Lines,'bib') <> true) then
  begin
    showmessage('There are syntax errors. Please correct them first.');
    exit;
  end;
  if newrec Then
  begin
    if WideMessageDlg('This will save current record. Do you want to continue?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      if SaveData Then
        begin
          data.hold.Append;
          Holdings.ShowModal;
        end;
  end
  Else
  begin
    data.hold.Append;
    Holdings.ShowModal;
  end;

  SetHoldInRichEdit(TntRichEditME);
end;
end;


procedure TMARCEditorform.DBCtrlGrid1DblClick(Sender: TObject);
begin
  if not Data.hold.IsEmpty Then
      Holdings.Showmodal;
end;

procedure TMARCEditorform.ComboBox1Change(Sender: TObject);
begin
  full.Modified := True;
end;

procedure TMARCEditorform.fullDblClick(Sender: TObject);
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

      EditMarcForm.record_type := 'bib';
      EditMarcForm.ShowModal;
      if EditMarcForm.ModalResult = mrOk then
      begin
        full.Lines.Delete(linenr);
        full.Lines.Insert(linenr, EditMarcForm.str);
      end;
    end;
  end;
end;

procedure TMARCEditorform.fullClick(Sender: TObject);
begin
  linenr := full.CaretPos.Y;
end;

procedure TMARCEditorform.FormCreate(Sender: TObject);
begin
  PopulateComboFromIni('RecordLevel', ComboBox1);
end;

procedure TMARCEditorform.SetTextInRichEdit(TntRichEdit1: TTntRichEdit);
const items_threshold = 30;
var
  ItemCount,  i : integer;
  AllText, LabelText, ValueText : WideString;
begin
  TntRichEdit1.Font.Style :=[fsBold];
  TntRichEdit1.Font.Color := clBlack;

  AllText := '';

  //Branch
  if (not Data.hold.fieldbyname('Branch').IsNull) then
  begin
    ValueText:=data.lookupparam(data.brancheslist,Data.hold.fieldbyname('Branch').AsString, '');
    if ValueText='' then ValueText:=Data.hold.fieldbyname('Branch').AsString;

    LabelText := 'Branch  ';
    AllText := AllText + LabelText + ValueText;
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
  end;

  //Collection
  if not Data.hold.fieldbyname('collection').IsNull then
  begin
    ValueText:=data.lookupparam(data.collectionlist,Data.hold.fieldbyname('collection').AsString,Data.hold.fieldbyname('Branch').AsString);
    if ValueText='' then ValueText:=Data.hold.fieldbyname('collection').AsString;
    if AllText<>'' then LabelText := '      Collection  '
                   else LabelText := 'Collection  ';

    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;

    AllText := AllText + LabelText + ValueText;
  end;

  //Classification
  if not Data.hold.fieldbyname('cln').IsNull then
  begin
    ValueText := Data.hold.fieldbyname('cln').Value;
    if not Data.hold.fieldbyname('cln_ip').IsNull then
    begin
      ValueText := ValueText+' '+Data.hold.fieldbyname('cln_ip').Value;
    end;
    if AllText<>'' then LabelText := '      Cln  '
                   else LabelText := 'Cln  ';
    AllText := AllText + LabelText + ValueText;

    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;

  end;

  if AllText <> '' Then TntRichEdit1.SelText:=#13#10;

  AllText := '';

  if ((not Data.hold.FieldByName('enum1').IsNull) and (trim(Data.hold.FieldByName('enum1').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('enum1').Value+' ';
    LabelText := GetIniMappings('enumeration','1')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('enum2').IsNull) and (trim(Data.hold.FieldByName('enum2').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('enum2').Value+' ';
    LabelText := GetIniMappings('enumeration','2')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('enum3').IsNull) and (trim(Data.hold.FieldByName('enum3').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('enum3').Value+' ';
    LabelText := GetIniMappings('enumeration','3')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('enum4').IsNull) and (trim(Data.hold.FieldByName('enum4').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('enum4').Value+' ';
    LabelText := GetIniMappings('enumeration','4')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('enum5').IsNull) and (trim(Data.hold.FieldByName('enum5').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('enum5').Value+' ';
    LabelText := GetIniMappings('enumeration','5')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('enum6').IsNull) and (trim(Data.hold.FieldByName('enum6').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('enum6').Value+' ';
    LabelText := GetIniMappings('enumeration','6')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('chrono1').IsNull) and (trim(Data.hold.FieldByName('chrono1').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('chrono1').Value+' ';
    LabelText := GetIniMappings('chronology','1')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('chrono2').IsNull) and (trim(Data.hold.FieldByName('chrono2').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('chrono2').Value+' ';
    LabelText := GetIniMappings('chronology','2')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('chrono3').IsNull) and (trim(Data.hold.FieldByName('chrono3').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('chrono3').Value+' ';
    LabelText := GetIniMappings('chronology','3')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  if ((not Data.hold.FieldByName('chrono4').IsNull) and (trim(Data.hold.FieldByName('chrono4').Value)<>'')) then
  begin
    ValueText := Data.hold.FieldByName('chrono4').Value+' ';
    LabelText := GetIniMappings('chronology','4')+' ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;
  //FIXME Add Volume info etc...

  if AllText <> '' Then TntRichEdit1.SelText := #13#10;

  AllText := '';

  //Textual Holdings - Basic Bibliographic Unit
  if not Data.hold.fieldbyname('F866').IsNull then
  begin
    ValueText := Data.hold.GetBlob('F866').AsWideString;
    LabelText := 'Textual Holdings - Basic Bibliographic Unit  ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;

  if AllText <> '' Then TntRichEdit1.SelText := #13#10;

  AllText := '';


  //Textual Holdings - Supplementary Material
  if not Data.hold.fieldbyname('F867').IsNull then
  begin
    ValueText := Data.hold.GetBlob('F867').AsWideString;
    LabelText := 'Textual Holdings - Supplementary Material  ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;

  if AllText <> '' Then TntRichEdit1.SelText := #13#10;

  AllText := '';


  //Textual Holdings - Indexes
  if Data.hold.fieldbyname('F868').Value <> '' then
  begin
    ValueText := Data.hold.GetBlob('F868').AsWideString;
    LabelText := 'Textual Holdings - Indexes  ';
    TntRichEdit1.SelAttributes.Color := clBlack;
    TntRichEdit1.SelText := LabelText;
    TntRichEdit1.SelAttributes.Color := clBlue;
    TntRichEdit1.SelText := ValueText;
    AllText := AllText + LabelText + ValueText;
  end;

  if AllText <> '' Then TntRichEdit1.SelText := #13#10;

  //ITEMS
  ItemCount := data.Items.RecordCount;

  if ItemCount > 0 Then
  begin
    data.Items.First;
    LabelText := '      Total Items = ' + IntToStr(ItemCount);
    TntRichEdit1.SelAttributes.Color := clGreen;
    TntRichEdit1.SelText := LabelText+#13#10;

    for i := 1 to ItemCount do
    begin
      AllText := '';

      LabelText := '   ';
      TntRichEdit1.SelText := LabelText;
      ValueText := IntToStr(i)+'.';
      TntRichEdit1.SelText := ValueText;

      AllText := AllText + LabelText + ValueText;

      //Barcode
      if not IsEmptyField(Data.items, 'barcode') then
      begin
        LabelText := '   Barcode  ';
        ValueText := Data.items.fieldbyname('barcode').Value;  //barcode
        TntRichEdit1.SelAttributes.Color := clBlack;
        TntRichEdit1.SelText := LabelText;
        TntRichEdit1.SelAttributes.Color := clGreen;
        TntRichEdit1.SelText := ValueText;
        AllText := AllText + LabelText + ValueText;
      end;

      //Copy
      if not IsEmptyField(Data.items, 'copy') then
      begin
        ValueText := Data.items.fieldbyname('copy').Value;
        LabelText := '   Copy  ';
        TntRichEdit1.SelAttributes.Color := clBlack;
        TntRichEdit1.SelText := LabelText;
        TntRichEdit1.SelAttributes.Color := clGreen;
        TntRichEdit1.SelText := ValueText;
        AllText := AllText + LabelText + ValueText;
      end;


      // Loan category
      if not IsEmptyField(data.items, 'loan_category') then
      begin
        ValueText:=data.lookupparam(data.loancategories,data.items.FieldByname('loan_category').AsString, '');
        if ValueText='' then ValueText:=data.items.FieldByname('loan_category').AsString;
        LabelText := '   Loan category  ';
        TntRichEdit1.SelAttributes.Color := clBlack;
        TntRichEdit1.SelText := LabelText;
        TntRichEdit1.SelAttributes.Color := clGreen;
        TntRichEdit1.SelText := ValueText;
        AllText := AllText + LabelText + ValueText;
      end;


      //Process status
      if not IsEmptyField(data.items, 'process_status') then
      begin
        ValueText:=data.lookupparam(data.processstatuses,data.items.FieldByname('process_status').AsString, '');
        if ValueText='' then ValueText:=data.items.FieldByname('process_status').AsString;
        LabelText := '   Process status  ';
        TntRichEdit1.SelAttributes.Color := clBlack;
        TntRichEdit1.SelText := LabelText;
        TntRichEdit1.SelAttributes.Color := clGreen;
        TntRichEdit1.SelText := ValueText;
        AllText := AllText + LabelText + ValueText;
      end;

      //Date Arrived
      if not IsEmptyField(Data.items, 'datearrived') then
      begin
        ValueText := Data.items.FieldByName('datearrived').AsString;
        LabelText := '   Date Arrived  ';
        TntRichEdit1.SelAttributes.Color := clBlack;
        TntRichEdit1.SelText := LabelText;
        TntRichEdit1.SelAttributes.Color := clGreen;
        TntRichEdit1.SelText := ValueText;
        AllText := AllText + LabelText + ValueText;
      end;

      //Note opac
      if not IsEmptyField(Data.items, 'note_opac') then
      begin
        ValueText := Data.items.fieldbyname('note_opac').Value;
        LabelText := '   Note opac  ';
        TntRichEdit1.SelAttributes.Color := clBlack;
        TntRichEdit1.SelText := LabelText;
        TntRichEdit1.SelAttributes.Color := clGreen;
        TntRichEdit1.SelText := ValueText;
        AllText := AllText + LabelText + ValueText;
      end;

      //Note internal
      if not IsEmptyField(Data.items, 'note_internal') then
      begin
        ValueText := Data.items.fieldbyname('note_internal').Value;
        LabelText := '   Note internal  ';
        TntRichEdit1.SelAttributes.Color := clBlack;
        TntRichEdit1.SelText := LabelText;
        TntRichEdit1.SelAttributes.Color := clGreen;
        TntRichEdit1.SelText := ValueText;
        AllText := AllText + LabelText + ValueText;
      end;

      TntRichEdit1.SelText :=#13#10;

      data.Items.Next;

    end;
  end;
end;

Procedure TMARCEditorform.SetHoldInRichEdit(RichEdit : TTntRichEdit);
var
   NrOrd,
   KLength,k1, u1, d1, holdcnt, Cnt :integer;
   u,d,TexFirstCount : WideString;
begin
  RichEdit.SelAttributes.Color := clBlack;
  RichEdit.SelAttributes.Style := [fsBold];
  RichEdit.SelAttributes.Size := 8;

  NrOrd := 0;
  Data.hold.First;
  RichEdit.Lines.BeginUpdate;
  RichEdit.Clear;
  SetLength(links, 0);
  holdcnt := Data.hold.RecordCount;

  RichEdit.SelStart := RichEdit.GetTextLen;

  //RichEdit.SelText:= #13#10;
  RichEdit.SelAttributes.Color := clGreen;
  RichEdit.SelAttributes.Style := [fsBold];
  RichEdit.SelAttributes.Size := 10;

  TexFirstCount := 'Total Holdings = '+ IntToStr(holdcnt);

  RichEdit.SelText := '       '+TexFirstCount+ ' ';

 while Not Data.hold.Eof do
 begin
  inc(NrOrd);
  RichEdit.SelText:= #13#10;

  cnt := length(RichEdit.Text)+1;  // add one for the leading space

  SetLength(links, Length(links) + 1);
  KLength := length('Holding '+ inttostr(NrOrd));

  links[Length(links)-1].start := cnt-RichEdit.Lines.Count;
  links[Length(links)-1].len := KLength;
  links[Length(links)-1].holdon := Data.hold.FieldByName('holdon').AsInteger;
  links[Length(links)-1].recno := Data.hold.FieldByName('recno').AsInteger;
  links[Length(links)-1].aa := Data.hold.FieldByName('aa').AsInteger;
  links[Length(links)-1].name := 'open';
  k1 := length(RichEdit.Text)+1; // add one for the trailing space
  u:='';
  d:='';
if (current_user_access >= 8) then
begin
//up
  if (NrOrd >1 ) then
  begin
    SetLength(links, Length(links) + 1);
    links[Length(links)-1].holdon := Data.hold.FieldByName('holdon').AsInteger;
    links[Length(links)-1].recno := Data.hold.FieldByName('recno').AsInteger;
    links[Length(links)-1].aa := Data.hold.FieldByName('aa').AsInteger;
    links[Length(links)-1].name := 'up';
    links[Length(links)-1].len := 4;
    u:=' [UP] ';
    u1:=k1+KLength+2;
    links[Length(links)-1].start:=u1-RichEdit.Lines.Count;
  end;
// down
  if (NrOrd < holdcnt) then
  begin
    SetLength(links, Length(links) + 1);
    links[Length(links)-1].holdon := Data.hold.FieldByName('holdon').AsInteger;
    links[Length(links)-1].recno := Data.hold.FieldByName('recno').AsInteger;
    links[Length(links)-1].aa := Data.hold.FieldByName('aa').AsInteger;
    links[Length(links)-1].name := 'down';
    links[Length(links)-1].len := 6;
    d:=' [DOWN] ';
    d1:=k1+KLength+2+length(u);
    links[Length(links)-1].start:=d1-RichEdit.Lines.Count;
  end;
end;
  RichEdit.SelAttributes.Color := clBlue;
  RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
  RichEdit.SelText :=' '+'Holding '+ inttostr(NrOrd) + ' ';
  if (u <> '') then
  begin
   RichEdit.SelAttributes.Color := clPurple;
   RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
   RichEdit.SelText :=u;
  end;

  if (d <> '') then
  begin
   RichEdit.SelAttributes.Color := clFuchsia;
   RichEdit.SelAttributes.Style := [fsBold,fsUnderline];
   RichEdit.SelText :=d;
  end;
  RichEdit.SelText :=#13#10;
  RichEdit.SelAttributes.Color := clBlack;
  RichEdit.SelAttributes.Style := [fsBold];
  RichEdit.SelAttributes.Size := 8;

  SetTextInRichEdit(RichEdit);
  Data.hold.Next;
 end;

 RichEdit.SelStart := 1;
 RichEdit.Lines.EndUpdate;
end;

procedure TMARCEditorform.TntRichEditMEMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Pt : TPoint;
  ICharIndex, i : integer;
begin

  with TTntRichEdit(Sender) do
  begin
    Pt := Point(X, Y);
    Cursor := crDefault;

    // Get Character Index from word under the cursor
    iCharIndex := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt));
    if iCharIndex < 0 then Exit;
    for i := 0 to length(links) - 1 do
      if (iCharIndex >= links[i].start)and
         (iCharIndex <= links[i].start + links[i].len)
          then
            begin
              Cursor := crHandPoint;
              Break;
            end
       Else Cursor := crDefault;
   end;

end;

procedure TMARCEditorform.Refresh_Holdings(var richedit : TTntRichEdit);
begin
  if not data.hold.Active Then data.hold.Open;
  if not data.items.Active Then data.items.Open;

  data.hold.Refresh;
  data.Items.Refresh;
  marceditorform.SetHoldInRichEdit(RichEdit);
end;

procedure TMARCEditorform.TntRichEditMEMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Pt : TPoint;
  ICharIndex, i,
  line: integer;
begin
  with TTntRichEdit(Sender) do
  begin
    Pt := Point(X, Y);
    Cursor := crDefault;

    // Get Character Index from word under the cursor
    iCharIndex := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt));
    if iCharIndex < 0 then Exit;
    for i := 0 to length(links) - 1 do
      if (iCharIndex >= links[i].start)and
         (iCharIndex <= links[i].start + links[i].len)
          then
            begin
              if (links[i].name = 'open') then
              begin
                line := SendMessage(TntRichEditME.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
                 if Data.hold.Locate('holdon',links[i].holdon ,[]) then
                   Holdings.ShowModal;
                SendMessage(TntRichEditME.Handle, EM_LINESCROLL, 0, line);

                Refresh_Holdings(marceditorform.TntRichEditME);
              end
              else if (links[i].name = 'up') then
              begin
                line := SendMessage(TntRichEditME.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
                if Data.hold.Locate('holdon',links[i].holdon ,[]) then
                begin
                   MoveHoldingUpDown('up', links[i].recno, links[i].holdon, links[i].aa );
                   holdings_moved := true;
                end;
                SendMessage(TntRichEditME.Handle, EM_LINESCROLL, 0, line);
                Refresh_Holdings(marceditorform.TntRichEditME);
              end
              else if (links[i].name = 'down') then
              begin
                line := SendMessage(TntRichEditME.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
                if Data.hold.Locate('holdon',links[i].holdon ,[]) then
                begin
                   MoveHoldingUpDown('down', links[i].recno, links[i].holdon, links[i].aa );
                   holdings_moved := true;
                end;
                SendMessage(TntRichEditME.Handle, EM_LINESCROLL, 0, line);
                Refresh_Holdings(marceditorform.TntRichEditME);
              end;
              Break;
            end
       Else Cursor := crDefault;
   end;
end;

procedure Refresh_SafeBasket;
var
  rec: UTF8String;
begin

 with MARCEditorForm do
 begin

   StatusBar1.Panels[0].Text := '';
   StatusBar1.Panels[1].Text := '';
   StatusBar1.Panels[2].Text := '';
   full.Lines.Clear;
   holdings_moved:=false;
   saved := False;
   newrec := False;
   myrecno := FastRecordCreator.gotorecno;

   MakeReadOnly;
   OpenSecureBasketTable(myrecno);

   rec := WideStringToString(data.SecureBasket.GetBlob('text').AsWideString, Greek_codepage);

   try
     if rec<>'' then marcrecord2memo(rec, full);
   finally

     StatusBar1.Panels[0].Text := 'Record '+inttostr(myrecno)+'.';

     ComboBox1.ItemIndex := Data.SecureBasket.FieldByName('level').AsInteger;

     full.Modified := False;
   end;
 end;

end;

procedure Refresh_Form;
begin
  reclock := False;

  try
    Refresh_SafeBasket;
  finally
    marceditorform.Refresh_Holdings(marceditorform.TntRichEditME);

    if templatename <> '' Then
    begin
      load_from_template(templatename);
      MARCEditorform.SaveData;
      templatename := '';
    end;

    if not Data.securebasket.FieldByName('creator').IsNull then
           MARCEditorform.StatusBar1.Panels[1].Text := 'Created by: ' + return_username(Data.securebasket.FieldByName('creator').AsInteger) +
            '  on  ' + Data.securebasket.FieldByName('created').AsString;

    if not Data.securebasket.FieldByName('modifier').IsNull then
           MARCEditorform.StatusBar1.Panels[2].Text := 'Modified by: ' + return_username(Data.securebasket.FieldByName('modifier').AsInteger) +
            '  on  ' + Data.securebasket.FieldByName('modified').AsString;
  end;

end;

procedure TMARCEditorform.ToolsBtnClick(Sender: TObject);
var
  Point : TPoint;
begin
  Point.X := (Sender as TTntBitBtn).Left;
  Point.Y := (Sender as TTntBitBtn).Top + (Sender as TTntBitBtn).Height;

  Point := ClientToScreen(Point);

  TntPopupMenu1.Popup(Point.X, Point.Y);
end;

procedure TMARCEditorform.Arrangetags1Click(Sender: TObject);
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

procedure TMARCEditorform.TntRichEditMEDblClick(Sender: TObject);
begin
  SetHoldInRichEdit(ShowHoldMemoForm.TntRichEdit);
  ShowHoldMemoForm.ShowModal;
  SetHoldInRichEdit(TntRichEditME);
end;

// By pressing Ctrl-T rearranges tags in the MARC Editor.
procedure TMARCEditorform.fullKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (full.ReadOnly = False) then
 begin
  if (Shift = [ssCtrl]) and (Key = 84) Then   //Key = t
      Arrangetags1Click(Sender)
  else if (Key = VK_F5) then
     AuthorityLookup1Click(Sender)
  else if (Key = VK_F10) then
     Locate1Click(Sender);
 end;
end;

procedure TMARCEditorform.TntFormShow(Sender: TObject);
begin
  data.loadparams(data.loancategory, data.loancategories);
  data.loadparams(data.processstatus, data.processstatuses);
  data.loadparams(data.branch, data.brancheslist);
  data.loadparams(data.collection, data.collectionlist);
//  showmessage(inttostr(data.loancategories.Count));
//  data.showparams(data.loancategories);
//  showmessage(inttostr(data.processstatuses.Count));
//  data.showparams(data.processstatuses);
  refresh_form;
end;

procedure TMARCEditorform.TntBitBtn2Click(Sender: TObject);
var
  TempRichEdit : TTntRichEdit;
begin

  if data.PrintDialog1.Execute Then
  begin
    TempRichEdit := TTntRichEdit.Create(MarcEditorForm);
    with TempRichEdit do
    try
      Parent := MarcEditorForm;
      Visible := False;

      Font.Size := 12;
      Lines.BeginUpdate;
      Lines.Assign(full.Lines);
      Lines.Add('');
      Lines.AddStrings(TntRichEditME.Lines);

      Print('Recno: ' + IntToStr(myrecno));
    finally
      Free;
    end;
  end;

end;

procedure TMARCEditorform.TntBitBtn3Click(Sender: TObject);
begin
  if (SyntaxCheck(full.Lines,'bib') <> true) then
  begin
    showmessage('There are syntax errors. Please correct them first.');
    exit;
  end;
  DigitalForm.ShowModal;
end;


procedure TMARCEditorform.Locate1Click(Sender: TObject);
begin
  zlocateform.myrecno := -1;
  zlocateform.source_record := '';
  if not data.basket.FieldByName('recno').IsNull then
  begin
    zlocateform.myrecno := data.SecureBasket.FieldByName('recno').Value;
    zlocateform.calledfrom:='editor';
    disp2mrc(full.Lines, zlocateform.source_record);
    zlocateform.ShowModal;
    if zlocateform.merged_record <> '' then
    begin
     full.Lines.Clear;
     marcrecord2memo(zlocateform.merged_record, full);
    end;
  end;

end;

procedure TMARCEditorform.ActFixHollisExecute(Sender: TObject);
begin
  FixHollis(MARCEditorform.full);
end;

procedure get_record_siblings(index : integer;  var prev,next : integer);
begin
  next:=-1;
  prev:=-1;
  if ((index <= 0) or (Length(ZebraRecnos) = 0)) then
  begin
    exit;
  end;
  if index = 1 then
  begin
    if Length(ZebraRecnos) > 1 then next := ZebraRecnos[1];
  end
  else if Length(ZebraRecnos)<=index then
  begin
    if Length(ZebraRecnos) > 1 then prev := ZebraRecnos[index-2];
  end
  else
  begin
    if index-2 >= 0 then prev := ZebraRecnos[index-2];
    if index < Length(ZebraRecnos) then next := ZebraRecnos[index];
  end;
end;

procedure TMARCEditorform.TntFormActivate(Sender: TObject);
begin
  prevrec.Enabled := edit_from_result_set;
  nextrec.Enabled := edit_from_result_set;
  if edit_from_result_set then
  begin
    get_record_siblings(record_index,previous_record,next_record);
    if previous_record = -1 then prevrec.Enabled := false;
    if next_record = -1 then nextrec.Enabled := false;
  end;
  tntbitbtn3.Enabled:=true;
  if ((DO_BaseURL = '') or (DO_Windows_storage_location = '')) then
   tntbitbtn3.Enabled := false;
end;

procedure TMARCEditorform.prevrecClick(Sender: TObject);
begin
  record_index := record_index-1;
  FastRecordCreator.gotorecno := previous_record;

  Refresh_Form;

  get_record_siblings(record_index,previous_record,next_record);
  if previous_record = -1 then prevrec.Enabled := false
  else prevrec.Enabled := true;
  if next_record = -1 then nextrec.Enabled := false
  else nextrec.Enabled := true;
end;

procedure TMARCEditorform.nextrecClick(Sender: TObject);
begin
  record_index := record_index+1;
  FastRecordCreator.gotorecno := next_record;

  Refresh_Form;

  get_record_siblings(record_index,previous_record,next_record);
  if previous_record = -1 then prevrec.Enabled := false
  else prevrec.Enabled := true;
  if next_record = -1 then nextrec.Enabled := false
  else nextrec.Enabled := true;
end;

procedure TMARCEditorform.TntBitBtn4Click(Sender: TObject);
begin
 if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
 begin
  WideShowMessage('You do not have permission to add holdings for this record.');
 end
 else
 begin
  if (SyntaxCheck(full.Lines,'bib') <> true) then
  begin
    showmessage('There are syntax errors. Please correct them first.');
    exit;
  end;
  HoldingsRange.ShowModal;
  SetHoldInRichEdit(TntRichEditME);
 end;
end;

procedure TMARCEditorform.AuthorityLookup1Click(Sender: TObject);
var tag, myinifname2,path,inds : string;
tagmappings : Tstrings;
  myIniFile2 : TIniFile;
  i: integer;
  line : WideString;
begin
 tag := LeftStr(full.Lines.Strings[linenr], 5);
 if tag='' then exit;
 tag := copy(tag,2,3);
 tagmappings:=Tstringlist.Create;
 tagmappings.Clear;
 path:=extractfilepath(paramstr(0));
 myinifname2 := path+'zparams.ini';
 MyIniFile2 := TIniFile.Create(myinifname2);
 with MyIniFile2 do
 begin
   ReadSectionValues('tag2myzebauthcommand',tagmappings);
   i :=tagmappings.IndexOfName(tag);
 end;
 tagmappings.Clear;
 tagmappings.Free;

 if (i <> -1) then
 begin
   if length(full.Lines.Strings[linenr])>6 then
   begin
     zauthlookupform.tag := tag;
     zauthlookupform.heading := copy(full.Lines.Strings[linenr], 9, length(full.Lines.Strings[linenr]));
     inds := copy(full.Lines.Strings[linenr], 7, 2);
     zauthlookupform.ShowModal;

     if zauthlookupform.ModalResult = mrOk then
     begin
        if (zauthlookupform.result_heading <> '') then
        begin
          inds := copy(zauthlookupform.result_ind, 1, 1)+copy(inds, 2, 1);
          line := '['+tag+'] '+inds+zauthlookupform.result_heading;
          full.Lines.Delete(linenr);
          full.Lines.Insert(linenr, line);
        end;
     end;
   end;

 end;
end;

end.
