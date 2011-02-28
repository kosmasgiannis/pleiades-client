unit HoldingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, Inifiles, TntStdCtrls, TntDBCtrls, db,
  ComCtrls, DateUtils, Buttons, TntDialogs, TntButtons, Grids, DBGrids,
  TntDBGrids, TntForms, utility;

type
  THoldings = class(TTntForm)
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    OK: TTntBitBtn;
    Cancel: TTntBitBtn;
    BranchesComboBox: TTntComboBox;
    CollectionsComboBox: TTntComboBox;
    Label5: TTntLabel;
    Label6: TTntLabel;
    Label7: TTntLabel;
    TntEdit1: TTntDBMemo;
    TntEdit2: TTntDBMemo;
    TntEdit3: TTntDBMemo;
    TntEdit4: TTntDBEdit;
    DeleteBtn: TTntBitBtn;
    TntGroupBox1: TTntGroupBox;
    TntDBGrid1: TTntDBGrid;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntLabel1: TTntLabel;
    TntEdit5: TTntDBEdit;
    TntDBEdit1: TTntDBEdit;
    enumlabel1: TTntLabel;
    TntDBEdit2: TTntDBEdit;
    TntDBEdit3: TTntDBEdit;
    TntDBEdit4: TTntDBEdit;
    TntDBEdit5: TTntDBEdit;
    TntGroupBox2: TTntGroupBox;
    enumlabel2: TTntLabel;
    enumlabel3: TTntLabel;
    enumlabel4: TTntLabel;
    enumlabel5: TTntLabel;
    TntGroupBox3: TTntGroupBox;
    chronolabel1: TTntLabel;
    TntDBEdit6: TTntDBEdit;
    TntDBEdit7: TTntDBEdit;
    chronolabel2: TTntLabel;
    TntDBEdit8: TTntDBEdit;
    TntDBEdit9: TTntDBEdit;
    chronolabel3: TTntLabel;
    chronolabel4: TTntLabel;
    TntDBEdit10: TTntDBEdit;
    enumlabel6: TTntLabel;
    TntBitBtn3: TTntBitBtn;
    procedure BranchesComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure TntComboBox2Change(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntDBGrid1DblClick(Sender: TObject);
    procedure TntDBGrid1CellClick(Column: TColumn);
    procedure TntEdit1DblClick(Sender: TObject);
    procedure TntEdit2DblClick(Sender: TObject);
    procedure TntEdit3DblClick(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure CollectionsComboBoxChange(Sender: TObject);
    procedure TntBitBtn3Click(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetBranchesCombo;
    procedure SetCollectionCombo;
    function SaveHold : integer;
  public
    { Public declarations }
  end;

var
  Holdings: THoldings;
  from_what : integer;

implementation

uses zoomit, common, DataUnit, MainUnit, WideIniClass, ItemsUnit, GlobalProcedures,
  ShowTextHoldingUnit, MARCEditor, TransferOneHoldUnit, zlookup;

{$R *.dfm}

procedure SetWindowsPosition;
begin
  if Holdings.Left + Holdings.Width + ItemsForm.Width > Screen.Width Then
  begin
    if Screen.Width - Holdings.Width - ItemsForm.Width > 0 Then
      Holdings.Left := Screen.Width - Holdings.Width - ItemsForm.Width;
    ItemsForm.Left := Screen.Width - ItemsForm.Width;
  end
  Else
    ItemsForm.Left := Holdings.Left + Holdings.Width;

  ItemsForm.Top := Holdings.Top + Holdings.Height - ItemsForm.Height;

  if not data.items.Active Then data.items.Open;
end;


procedure THoldings.SetBranchesCombo;
begin

  PopulateFromMyTable(data.branch, 'name', BranchesComboBox);

  if not data.hold.FieldByName('branch').IsNull Then
  begin
    if data.branch.Locate('code', data.hold.FieldByName('branch').Value, [])
      Then BranchesComboBox.ItemIndex := BranchesComboBox.Items.IndexOf(data.branch.FieldByName('name').Value)
      Else BranchesComboBox.ItemIndex := -1;
  end;

end;

procedure THoldings.SetCollectionCombo;
begin

  with data do
  begin
    if not data.hold.FieldByName('branch').IsNull Then
    begin
      CollectionQuery.Close;
      CollectionQuery.ParamByName('branchcode').Value := data.hold.FieldByName('branch').Value; 
      CollectionQuery.Execute;

      PopulateFromMyTable(CollectionQuery, 'name', CollectionsComboBox);

      if not hold.FieldByName('collection').IsNull Then
      begin
        if collection.Locate('code;branchcode', VarArrayOf([hold.FieldByName('collection').Value, hold.FieldByName('branch').Value]), [])
            Then CollectionsComboBox.ItemIndex := CollectionsComboBox.Items.IndexOf(collection.FieldByName('name').Value)
            Else CollectionsComboBox.ItemIndex := -1;
      end;
    end
    Else
    begin
      CollectionsComboBox.Items.Clear;
      CollectionsComboBox.ItemIndex := -1;
    end;
  end;

end;

procedure THoldings.BranchesComboBoxChange(Sender: TObject);
begin

  if (Sender as TTntComboBox).ItemIndex >= 0 then
  begin
    EditTable(Data.hold);
    if data.branch.Locate('name' , (Sender as TTntComboBox).Text, []) and (not data.branch.FieldByName('code').IsNull)
      Then Data.hold['branch'] := data.branch.FieldByName('code').Value
      Else
      begin
        Data.hold['branch'] := '';
        (Sender as TTntComboBox).ItemIndex := -1;
      end;
  end;

  SetCollectionCombo;
end;

procedure THoldings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  case ModalResult of
    mrOK: SaveHold;
    mrCancel: CancelTable(data.hold);
  end;
ItemsForm.Close;
end;

function THoldings.SaveHold : integer;
var
  rec : UTF8String;
  maxaa : integer;
  //recnr : integer;
begin
  if ((data.hold.fieldbyname('aa').IsNull = true) or (data.hold.fieldbyname('aa').AsInteger = 0) ) then 
  begin
    maxaa := get_max_hold_aa(Data.SecureBasket.FieldByName('recno').AsInteger);
    data.hold.FieldByName('aa').AsInteger := maxaa+1;
  end;
  PostTable(data.hold);
  result:=data.hold.fieldbyname('holdon').asinteger;
//  data.hold.Refresh;
//  data.items.Refresh;

  if data.hold.State = dsInsert
    Then append_move(UserCode, 6,today, CurrentUserName + ' added a new holding for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString)
    Else append_move(UserCode, 6,today, CurrentUserName + ' changed the holding for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString);


  with Data.SecureBasket do
  begin
    EditTable(data.SecureBasket);
    disp2mrc(MarcEditorForm.full.Lines, rec);
    Refresh084(FieldByName('recno').AsInteger, rec);
    GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
    TBlobField(FieldByName('text')).Modified := True;
    MarcEditorForm.full.Lines.Clear;
    marcrecord2memo(rec, MarcEditorForm.full);
    MARCEditorform.SaveData;
  end;

  //recnr := Data.SecureBasket.FieldByName('recno').AsInteger;
  //RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));
end;

procedure THoldings.DateTimePicker1Change(Sender: TObject);
begin
  (Sender as TDateTimePicker).Format := '';
end;

procedure THoldings.TntComboBox2Change(Sender: TObject);
begin
  (Sender as TTntComboBox).Color := clWindow;
end;

procedure THoldings.DeleteBtnClick(Sender: TObject);
var
  res, aa, recnr : integer;
  q : string;
begin
if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
begin
  WideShowMessage('You do not have permission to delete holdings for this record.');
end
else
begin
 q := '';
 aa:=0;
 if not data.hold.IsEmpty then
 begin
   res := WideMessageDlg('Do you want to delete this holding from the database?',
              mtConfirmation, [mbYes, mbNo], 0);
   if res = mrYes then
     begin
       recnr := Data.Securebasket.FieldByName('recno').AsInteger;
       if (Data.hold.FieldByName('aa').isNULL = false) then
       begin
         aa := Data.hold.FieldByName('aa').AsInteger;
         q := 'UPDATE hold SET aa=aa-1 WHERE recno = :recno AND aa > :aa;';
       end;
       data.hold.delete;
       if (q <> '') then
       begin
         with Data.MyCommand1 do
         begin
           SQL.Clear;
           SQL.Add(q);
           ParamByName('recno').AsInteger := recnr;
           ParamByName('aa').AsInteger := aa;
           Execute;
         end;
       end;
       RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));
       Close;
     end;
 end;
end;
end;

procedure Refresh_Items;
begin
  with data.Items do
  begin
   //Loan category
{ // This was for old loan cat
   if FieldByName('loan_category').IsNull
        Then ItemsForm.TntComboBox1.ItemIndex := -1
        Else
        begin
          if data.loancat.Locate('id', FieldByName('loan_category').AsInteger, [])
            Then ItemsForm.TntComboBox1.ItemIndex := ItemsForm.TntComboBox1.Items.IndexOf(data.loancat.FieldByName('description').Value)
            Else ItemsForm.TntComboBox1.ItemIndex := -1;
        end;
}
   if FieldByName('loan_category').IsNull
        Then ItemsForm.TntComboBox1.ItemIndex := -1
        Else
        begin
          if data.loancategory.Locate('code', FieldByName('loan_category').AsInteger, [])
            Then ItemsForm.TntComboBox1.ItemIndex := ItemsForm.TntComboBox1.Items.IndexOf(data.loancategory.FieldByName('name').Value)
            Else ItemsForm.TntComboBox1.ItemIndex := -1;
        end;

   //Process Status
   if FieldByName('process_status').IsNull
        Then ItemsForm.TntComboBox2.ItemIndex := -1
        Else
        begin
          if data.processstatus.Locate('code', FieldByName('process_status').AsInteger, [])
            Then ItemsForm.TntComboBox2.ItemIndex := ItemsForm.TntComboBox2.Items.IndexOf(data.processstatus.FieldByName('name').Value)
            Else ItemsForm.TntComboBox2.ItemIndex := -1;
        end;

   //Date arrived
   if not FieldByName('datearrived').IsNull Then
    begin
      ItemsForm.DateTimePicker2.Format := '';
      ItemsForm.DateTimePicker2.Date := FieldByName('datearrived').AsDateTime;
    end
    Else
    begin
      ItemsForm.DateTimePicker2.Format := ' ';
      ItemsForm.DateTimePicker2.Date := Today;
    end;
  end;
end;


procedure THoldings.TntBitBtn1Click(Sender: TObject);
var ho : integer;
begin
if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
begin
  WideShowMessage('You do not have permission to add items for this record.');
end
else
begin
  ho := -1;
  if IsInEdit(Data.hold) Then ho:=SaveHold;

  with data.Items do
  begin
    if ho <> -1 then data.hold.locate('holdon', ho, [loCaseInsensitive]);
    Append;
    FieldByName('holdon').AsInteger := data.hold.FieldByName('holdon').AsInteger;
    FieldByName('recno').AsInteger := data.hold.FieldByName('recno').AsInteger;
    FieldByName('datecreated').Value := today;
    FieldByName('creator').AsInteger := UserCode;

    FieldByName('loan_category').AsInteger := 0;
    FieldByName('process_status').AsInteger := 0;

//    Post;

    Refresh_Items;

    SetWindowsPosition;
    ItemsForm.Show;
  end;
end;
end;

procedure THoldings.TntDBGrid1DblClick(Sender: TObject);
begin

 if data.Items.RecordCount > 0 Then
 begin
   SetWindowsPosition;
   ItemsForm.Show;
 end;

end;

procedure THoldings.TntDBGrid1CellClick(Column: TColumn);
begin
  Refresh_Items;
end;

procedure THoldings.TntEdit1DblClick(Sender: TObject);
begin
  from_what := 1;
  ShowTextHoldingForm.TntMemo1.Text := Holdings.TntEdit1.Text;
  ShowTextHoldingForm.ShowModal;
end;

procedure THoldings.TntEdit2DblClick(Sender: TObject);
begin
  from_what := 2;
  ShowTextHoldingForm.TntMemo1.Text := Holdings.TntEdit2.Text;
  ShowTextHoldingForm.ShowModal;
end;

procedure THoldings.TntEdit3DblClick(Sender: TObject);
begin
  from_what := 3;
  ShowTextHoldingForm.TntMemo1.Text := Holdings.TntEdit3.Text;
  ShowTextHoldingForm.ShowModal;
end;

procedure THoldings.TntBitBtn2Click(Sender: TObject);
begin
//FIXME : activate this
wideshowmessage('Not tested yet...');
exit;

  if MarcEditorForm.SaveData Then
  begin
    TransferOneHoldForm.CurrentHoldon := data.hold.FieldByName('holdon').AsInteger;
    TransferOneHoldForm.CurrentRecno := data.hold.FieldByName('recno').AsInteger;
    TransferOneHoldForm.ShowModal;
    if TransferOneHoldForm.ModalResult = mrOk Then
    begin
      Refresh_SafeBasket;
      Close;
    end;
  end

end;

procedure setformlabel(category:string; which : integer);
begin
end;

procedure THoldings.TntFormShow(Sender: TObject);
var junk: widestring;
begin

  junk := GetIniMappings('enumeration','1');
  if junk = '' then junk := '-';
  enumlabel1.Caption :=junk;

  junk := GetIniMappings('enumeration','2');
  if junk = '' then junk := '-';
  enumlabel2.Caption :=junk;

  junk := GetIniMappings('enumeration','3');
  if junk = '' then junk := '-';
  enumlabel3.Caption :=junk;

  junk := GetIniMappings('enumeration','4');
  if junk = '' then junk := '-';
  enumlabel4.Caption :=junk;

  junk := GetIniMappings('enumeration','5');
  if junk = '' then junk := '-';
  enumlabel5.Caption :=junk;

  junk := GetIniMappings('enumeration','6');
  if junk = '' then junk := '-';
  enumlabel6.Caption :=junk;

  junk := GetIniMappings('chronology','1');
  if junk = '' then junk := '-';
  chronolabel1.Caption :=junk;

  junk := GetIniMappings('chronology','2');
  if junk = '' then junk := '-';
  chronolabel2.Caption :=junk;

  junk := GetIniMappings('chronology','3');
  if junk = '' then junk := '-';
  chronolabel3.Caption :=junk;

  junk := GetIniMappings('chronology','4');
  if junk = '' then junk := '-';
  chronolabel4.Caption :=junk;

  if data.hold.State = dsInsert Then
  begin
    data.hold['branch'] := branchcode;                    //Default branch code
    if FastRecordCreator.DefCln <> '' Then
        data.hold['cln'] := FastRecordCreator.DefCln;     //Default Classification No
  end;

  //Branch
  SetBranchesCombo;

  //Collection
  SetCollectionCombo;

  holdings.TntEdit4.SetFocus;
end;

procedure THoldings.CollectionsComboBoxChange(Sender: TObject);
begin
  if (Sender as TTntComboBox).ItemIndex >= 0 then
  begin
    EditTable(Data.hold);
    if data.collection.Locate('name' , (Sender as TTntComboBox).Text, []) and (not data.collection.FieldByName('code').IsNull)
      Then Data.hold['collection'] := data.collection.FieldByName('code').Value
      Else
      begin
        Data.hold['collection'] := '';
        (Sender as TTntComboBox).ItemIndex := -1;
      end;
  end;
end;

procedure THoldings.TntBitBtn3Click(Sender: TObject);
begin
    zlookupform.lookupcommand := 'classification_phrase';
    zlookupform.scanterm.Text := tntedit4.Text;
    zlookupform.selected_term := '';
    zlookupform.ShowModal;
//    wideshowmessage(zlookupform.selected_term);
end;



procedure THoldings.CancelClick(Sender: TObject);
begin
 ModalResult := mrCancel;
end;

procedure THoldings.OKClick(Sender: TObject);
begin
 if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
 begin
  WideShowMessage('You do not have permission to modify holdings for this record.');
  ModalResult := mrNone;
 end
 else
 begin
  ModalResult := mrOk;
  if (data.hold.FieldByName('collection').IsNull = true) then
  begin
   showmessage('Collection field is empty, please set a value.');
   ModalResult := mrNone;
  end;
 end;
end;

end.
