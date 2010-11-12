unit HoldingsRangeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, Inifiles, TntStdCtrls, TntDBCtrls, db,
  ComCtrls, DateUtils, Buttons, TntDialogs, TntButtons, Grids, DBGrids,
  TntDBGrids, TntForms, utility, ExtCtrls;

type
  THoldingsRange = class(TTntForm)
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    OK: TTntBitBtn;
    Cancel: TTntBitBtn;
    BranchesComboBox: TTntComboBox;
    CollectionsComboBox: TTntComboBox;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntLabel3: TTntLabel;
    clnfield: TTntEdit;
    clnipfield: TTntEdit;
    StartBarCode: TTntEdit;
    NoOfItems: TTntEdit;
    RadioGroup1: TRadioGroup;
    procedure BranchesComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntFormShow(Sender: TObject);
    procedure CollectionsComboBoxChange(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetBranchesCombo;
    procedure SetCollectionCombo;
    procedure SaveHoldRange;
  public
    { Public declarations }
  end;

var
  HoldingsRange: THoldingsRange;
  from_what : integer;
  range_branch, range_collection : widestring;
implementation

uses zoomit, common, DataUnit, MainUnit, WideIniClass, ItemsUnit, GlobalProcedures,
  ShowTextHoldingUnit, MARCEditor, TransferOneHoldUnit, zlookup,
  HoldingsUnit;

{$R *.dfm}

procedure THoldingsRange.SetBranchesCombo;
begin
  range_branch := '';
  PopulateFromMyTable(data.branch, 'name', BranchesComboBox);
  BranchesComboBox.ItemIndex := 0;
  if data.branch.Locate('name' , BranchesComboBox.Text, []) and (not data.branch.FieldByName('code').IsNull)
  Then range_branch := data.branch.FieldByName('code').Value
  Else
  begin
    range_branch := '';
    BranchesComboBox.ItemIndex := -1;
  end;
end;

procedure THoldingsRange.SetCollectionCombo;
begin
  range_collection := '';
  with data do
  begin
    if range_branch <> '' Then
    begin
      CollectionQuery.Close;
      CollectionQuery.ParamByName('branchcode').Value := range_branch;
      CollectionQuery.Execute;

      PopulateFromMyTable(CollectionQuery, 'name', CollectionsComboBox);

      CollectionsComboBox.ItemIndex := 0;

      if data.collection.Locate('name;branchcode' , VarArrayOf([CollectionsComboBox.Text, range_branch]), []) and (not data.collection.FieldByName('code').IsNull)
      Then range_collection := data.collection.FieldByName('code').Value
      Else
      begin
        range_collection := '';
        CollectionsComboBox.ItemIndex := -1;
      end;

    end
    Else
    begin
      CollectionsComboBox.Items.Clear;
      CollectionsComboBox.ItemIndex := -1;
    end;
  end;

end;

procedure THoldingsRange.BranchesComboBoxChange(Sender: TObject);
begin

  if (Sender as TTntComboBox).ItemIndex >= 0 then
  begin
    if data.branch.Locate('name' , (Sender as TTntComboBox).Text, []) and (not data.branch.FieldByName('code').IsNull)
      Then range_branch := data.branch.FieldByName('code').Value
      Else
      begin
        range_branch := '';
        (Sender as TTntComboBox).ItemIndex := -1;
      end;
  end;

  SetCollectionCombo;
end;

procedure THoldingsRange.CollectionsComboBoxChange(Sender: TObject);
begin
  if (Sender as TTntComboBox).ItemIndex >= 0 then
  begin
    if data.collection.Locate('name;branchcode' , VarArrayOf([(Sender as TTntComboBox).Text, range_branch]), []) and (not data.collection.FieldByName('code').IsNull)
      Then range_collection := data.collection.FieldByName('code').Value
      Else
      begin
        range_collection := '';
        (Sender as TTntComboBox).ItemIndex := -1;
      end;
  end;
end;

procedure THoldingsRange.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  case ModalResult of
    mrOK: SaveHoldRange;
    mrCancel: CancelTable(data.hold);
  end;
end;

procedure THoldingsRange.SaveHoldRange;
var
  rec : UTF8String;
  //recnr : integer;
begin
  with Data.SecureBasket do
  begin
    EditTable(data.SecureBasket);
    disp2mrc(MarcEditorForm.full.Lines, rec);
    EnhanceMARC(FieldByName('recno').AsInteger, rec);
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

procedure THoldingsRange.TntFormShow(Sender: TObject);
begin
  RadioGroup1.ItemIndex := 0;
  clnfield.Text := '';
  clnipfield.Text := '';
  StartBarcode.Text := '';
  NoOfItems.Text := '';
  SetBranchesCombo;
  SetCollectionCombo;
  holdingsrange.clnfield.SetFocus;
end;

procedure THoldingsRange.CancelClick(Sender: TObject);
begin
 ModalResult := mrCancel;
end;

procedure THoldingsRange.OKClick(Sender: TObject);
var ans, i, j, sb, noi, padding_zeros,maxaa : integer;
    ibarcode : widestring;
begin
 ModalResult := mrOk;
 clnfield.Text := squeeze(clnfield.Text);
 clnipfield.Text := squeeze(clnipfield.Text);
 if (range_branch = '') then
 begin
   showmessage('Branch field is empty, please set a value.');
   ModalResult := mrNone;
   exit;
 end;
 if (range_collection = '') then
 begin
   showmessage('Collection field is empty, please set a value.');
   ModalResult := mrNone;
   exit;
 end;
 if (clnfield.Text = '') then
 begin
   showmessage('Classification field is empty, please set a value.');
   clnfield.SetFocus;
   ModalResult := mrNone;
   exit;
 end;
 sb := strtointdef(StartBarcode.Text, -1);
 if  sb = -1 then
 begin
   showmessage('Starting Barcode field should hold a number.');
   StartBarcode.SetFocus;
   ModalResult := mrNone;
   exit;
 end;
 noi := strtointdef(NoOfItems.Text, -1);
 if noi = -1 then
 begin
   showmessage('No Of Items field should hold a number.');
   NoOfItems.SetFocus;
   ModalResult := mrNone;
   exit;
 end;
 if (noi > 150) then
 begin
   ans := WideMessageDlg('Too many items, are you sure?',
          mtConfirmation, [mbYes, mbNo], 0, mbNo);
   if ans = mrNo Then
   begin
     NoOfItems.SetFocus;
     ModalResult := mrNone;
     exit;
   end;
 end;
// showmessage(StartBarcode.Text);
 padding_zeros := 0;
 for i:= 1 to length(StartBarcode.Text) do
   if StartBarcode.Text[i] = '0' then padding_zeros:=padding_zeros+1
   else break;
// showmessage(inttostr(padding_zeros));

 maxaa := get_max_hold_aa(Data.SecureBasket.FieldByName('recno').AsInteger);

 if (radiogroup1.ItemIndex = 0) then  // Multiple Holdings One Item per Holding
 begin
   with data do
   begin
     for i :=1 to noi do
     begin
       hold.Append;
       hold.FieldByName('recno').AsInteger := SecureBasket.FieldByName('recno').AsInteger;
       hold.FieldByName('aa').AsInteger := maxaa+i;
       hold.FieldByName('branch').Value := range_branch;
       hold.FieldByName('collection').Value := range_collection;
       hold.FieldByName('cln').Value := clnfield.Text;
       hold.FieldByName('cln_ip').Value := clnipfield.Text;
       hold.FieldByName('enum1').Value := inttostr(i);
       hold.Post;
       ibarcode:=inttostr(sb+i-1);
       for j:=1 to padding_zeros do
         ibarcode:='0'+ibarcode;
       items.Append;
       items.FieldByName('holdon').AsInteger := data.hold.FieldByName('holdon').AsInteger;
       items.FieldByName('recno').AsInteger := data.hold.FieldByName('recno').AsInteger;
       items.FieldByName('barcode').Value := ibarcode;
       items.FieldByName('copy').value := '1';
       items.FieldByName('datecreated').Value := today;
       items.FieldByName('creator').AsInteger := UserCode;
       items.FieldByName('loan_category').AsInteger := 0;
       items.FieldByName('process_status').AsInteger := 0;
       items.Post;
     end;
   end;
   append_move(UserCode, 6,today, CurrentUserName + ' added '+inttostr(noi)+' new holdings for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString);
   append_move(UserCode, 6,today, CurrentUserName + ' added '+inttostr(noi)+' new items for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString);

 end
 else  // One Holdings Multiple Items
 begin
   with data do
   begin
     hold.Append;
     hold.FieldByName('recno').AsInteger := SecureBasket.FieldByName('recno').AsInteger;
     hold.FieldByName('aa').AsInteger := maxaa+1;
     hold.FieldByName('branch').Value := range_branch;
     hold.FieldByName('collection').Value := range_collection;
     hold.FieldByName('cln').Value := clnfield.Text;
     hold.FieldByName('cln_ip').Value := clnipfield.Text;
     hold.FieldByName('enum1').Value := '1';
     hold.Post;
     for i :=1 to noi do
     begin
       ibarcode:=inttostr(sb+i-1);
       for j:=1 to padding_zeros do
         ibarcode:='0'+ibarcode;
       items.Append;
       items.FieldByName('holdon').AsInteger := data.hold.FieldByName('holdon').AsInteger;
       items.FieldByName('recno').AsInteger := data.hold.FieldByName('recno').AsInteger;
       items.FieldByName('barcode').Value := ibarcode;
       items.FieldByName('copy').value := inttostr(i);
       items.FieldByName('datecreated').Value := today;
       items.FieldByName('creator').AsInteger := UserCode;
       items.FieldByName('loan_category').AsInteger := 0;
       items.FieldByName('process_status').AsInteger := 0;
       items.Post;
     end;
   end;
   append_move(UserCode, 6,today, CurrentUserName + ' added 1 new holding for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString);
   append_move(UserCode, 6,today, CurrentUserName + ' added '+inttostr(noi)+' new items for recno=' +
                     Data.SecureBasket.FieldByName('recno').AsString);
 end;
 SaveHoldRange;
end;

end.
