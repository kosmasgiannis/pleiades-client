unit ItemsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, TntDBCtrls, ComCtrls, TntStdCtrls,
  Buttons, DateUtils, TntDialogs,TntForms, TntComCtrls, TntButtons, DB,
  utility;

type
  TItemsForm = class(TTntForm)
    Label8: TTntLabel;
    Label9: TTntLabel;
    Label12: TTntLabel;
    Label14: TTntLabel;
    Label15: TTntLabel;
    Label16: TTntLabel;
    OK: TTntBitBtn;
    Cancel: TTntBitBtn;
    TntComboBox1: TTntComboBox;
    DateTimePicker2: TTntDateTimePicker;
    TntEdit5: TTntDBEdit;
    TntEdit7: TTntDBEdit;
    TntEdit8: TTntDBEdit;
    DeleteBtn: TTntBitBtn;
    Label1: TTntLabel;
    TntDBEdit1: TTntDBEdit;
    TntBitBtn1: TTntBitBtn;
    TntComboBox2: TTntComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure DateTimePicker2CloseUp(Sender: TObject);
    procedure TntComboBox1Change(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntComboBox2Change(Sender: TObject);
    procedure TntDBEdit1Change(Sender: TObject);
  private
    { Private declarations }
    procedure SaveItem;
    procedure DiscardItem;
  public
    { Public declarations }
  end;

var
  ItemsForm: TItemsForm;

implementation

uses DataUnit, GlobalProcedures, zoomit, common, TransferItemUnit;

{$R *.dfm}

procedure TItemsForm.FormShow(Sender: TObject);
begin
  PopulateFromMyTable(data.loancategory, 'name', TntComboBox1);
  PopulateFromMyTable(data.processstatus, 'name', TntComboBox2);

  with data.Items do
  begin

   //Loan category
{ // This was for old loan cat structure
   if FieldByName('loan_category').IsNull
        Then TntComboBox1.ItemIndex := -1
        Else
        begin
          if data.loancat.Locate('id', FieldByName('loan_category').AsInteger, [])
            Then TntComboBox1.ItemIndex := TntComboBox1.Items.IndexOf(data.loancat.FieldByName('description').Value)
            Else TntComboBox1.ItemIndex := -1;
        end;
}

   if FieldByName('loan_category').IsNull
        Then TntComboBox1.ItemIndex := -1
        Else
        begin
          if data.loancategory.Locate('code', FieldByName('loan_category').AsInteger, [])
            Then TntComboBox1.ItemIndex := TntComboBox1.Items.IndexOf(data.loancategory.FieldByName('name').Value)
            Else TntComboBox1.ItemIndex := -1;
        end;


   //Process Status
   if FieldByName('process_status').IsNull
        Then TntComboBox2.ItemIndex := -1
        Else
        begin
          if data.processstatus.Locate('code', FieldByName('process_status').AsInteger, [])
            Then TntComboBox2.ItemIndex := TntComboBox2.Items.IndexOf(data.processstatus.FieldByName('name').Value)
            Else TntComboBox2.ItemIndex := -1;
        end;



   //Date arrived
   if not FieldByName('datearrived').IsNull Then
    begin
      DateTimePicker2.Format := '';  // FIXME
      DateTimePicker2.Date := FieldByName('datearrived').AsDateTime;
    end
    Else
    begin
      DateTimePicker2.Format := ' '; // FIXME
      DateTimePicker2.Date := Today;
    end;
  end;

end;


procedure TItemsForm.SaveItem;
var
  recnr : integer;
begin

  with data.Items do
  begin
    FieldByName('modifier').AsInteger := UserCode;
    FieldByName('datemodified').AsDateTime := today;

    if State = dsInsert then
        append_move(UserCode, 6,today, CurrentUserName + ' added a new item for recno=' +
                    Data.SecureBasket.FieldByName('recno').AsString);
    if State = dsEdit then
        append_move(UserCode, 6,today, CurrentUserName + ' changed the item for recno=' +
                    Data.SecureBasket.FieldByName('recno').AsString);
    PostTable(data.items);
  end;

  recnr := Data.SecureBasket.FieldByName('recno').AsInteger;
  RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));
end;


procedure TItemsForm.DiscardItem;
begin
  CancelTable(data.Items);
end;


procedure TItemsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
 begin
  DiscardItem;
  WideShowMessage('You do not have permission to modify items for this record.');
 end
 else
 begin
  case ModalResult of
    mrOk : if IsInEdit(data.Items) Then SaveItem;
    mrCancel : DiscardItem;
  end;
 end;
end;

procedure TItemsForm.CancelClick(Sender: TObject);
begin
  ItemsForm.Close;
end;

procedure TItemsForm.OKClick(Sender: TObject);
begin
  ItemsForm.Close;
end;

procedure TItemsForm.DeleteBtnClick(Sender: TObject);
var
  recnr, res: integer;
begin
if ((current_user_access = 6) and (UserCode <> Data.securebasket.FieldByName('creator').AsInteger) ) then
begin
  WideShowMessage('You do not have permission to delete items for this record.');
end
else
begin
 if not data.items.IsEmpty then
 begin
   res := WideMessageDlg('Do you want to delete this item from the database?',
              mtConfirmation, [mbYes, mbNo], 0);
   if res = mrYes then
     begin
       data.items.Delete;
       recnr := Data.Securebasket.FieldByName('recno').AsInteger;
       RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));
       Close;
     end;
 end;
end;
end;

procedure TItemsForm.DateTimePicker2CloseUp(Sender: TObject);
begin
  DateTimePicker2.Format := '';

  EditTable(Data.Items);
  Data.Items.FieldByName('datearrived').AsDateTime := DateTimePicker2.Date;
end;

//FIXME
procedure TItemsForm.TntComboBox1Change(Sender: TObject);
begin

{// this was for old loan cat structure
  if TntComboBox1.ItemIndex >= 0 then
  begin
    EditTable(Data.Items);
    if data.loancat.Locate('description' , TntComboBox1.Text, [])
      Then Data.Items['loan_category'] := data.loancat.FieldByName('id').AsInteger
      Else
      begin
        Data.Items['loan_category'] := -1;
        TntComboBox1.ItemIndex := -1;
      end;
  end;
}

  if TntComboBox1.ItemIndex >= 0 then
  begin
    EditTable(Data.Items);
    if data.loancategory.Locate('name' , TntComboBox1.Text, [])
      Then Data.Items['loan_category'] := data.loancategory.FieldByName('code').AsInteger
      Else
      begin
        Data.Items['loan_category'] := -1;
        TntComboBox1.ItemIndex := -1;
      end;
  end;

end;

//FIXME
procedure TItemsForm.TntComboBox2Change(Sender: TObject);
begin
  if TntComboBox2.ItemIndex >= 0 then
  begin
    EditTable(Data.Items);
    if data.processstatus.Locate('name' , TntComboBox2.Text, [])
      Then Data.Items['process_status'] := data.processstatus.FieldByName('code').AsInteger
      Else
      begin
        Data.Items['process_status'] := -1;
        TntComboBox2.ItemIndex := -1;
      end;
  end;

end;


procedure TItemsForm.TntBitBtn1Click(Sender: TObject);
begin
//FIXME : activate this
wideshowmessage('Not tested yet...');
exit;

  TransferItemForm.ShowModal;
  if TransferItemForm.ModalResult = mrOk Then Close;
end;

//FIXME
procedure TItemsForm.TntDBEdit1Change(Sender: TObject);
begin
  // showmessage('boo '+  Data.Items.FieldByName('holdon').Asstring);
end;

end.
