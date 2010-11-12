unit NewCollectionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, TntStdCtrls, MyAccess, DB;

type
  TNewCollectionForm = class(TTntForm)
    TntComboBox1: TTntComboBox;
    TntLabel1: TTntLabel;
    TntEdit1: TTntEdit;
    TntLabel2: TTntLabel;
    TntEdit2: TTntEdit;
    TntLabel3: TTntLabel;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewCollectionForm: TNewCollectionForm;
  branch_code : array of WideString;


implementation

uses DataUnit, TntDialogs, GlobalProcedures;

{$R *.DFM}

procedure TNewCollectionForm.TntBitBtn1Click(Sender: TObject);
begin
  data.CollectionQuery.close;
  data.CollectionQuery.ParamByName('branchcode').Value:=branch_code[TntComboBox1.ItemIndex];
  data.CollectionQuery.Execute;
  if data.collection.IsEmpty = false then
    data.CollectionQuery.First;

//  wideshowmessage(TntEdit1.Text);
//  wideshowmessage(data.collection.FieldByName('code').asVariant);
//  wideshowmessage(branch_code[TntComboBox1.ItemIndex]);
//  wideshowmessage(data.collection.FieldByName('branchcode').AsVariant);

  if ((TntEdit1.Text <> '') and  (TntEdit1.Text <> '') )then
  begin
   if (not ((TntEdit1.Text = data.collection.FieldByName('code').asVariant) and (branch_code[TntComboBox1.ItemIndex] = data.collection.FieldByName('branchcode').AsVariant))) then
   begin
     if Data.CollectionQuery.Locate('code;branchcode',vararrayof([TntEdit1.Text,branch_code[TntComboBox1.ItemIndex]]),[loCaseInsensitive]) then
     begin
       MessOK('This code exists! Please select another code!');
       ModalResult := mrNone;
     end;
   end;
  end
  else
  begin
     MessOK('Please complete all the fields');
     ModalResult := mrNone;
  end;
end;

procedure TNewCollectionForm.TntFormActivate(Sender: TObject);
var bc : Widestring;
    i:integer;
begin
  TntEdit1.text := '';
  TntEdit2.text := '';
  bc:='';

//  if ((data.collection.State <> dsEdit) and (data.collection.State <> dsInsert)) then
//   showmessage('ko');

  if data.collection.State = dsEdit then
  begin
   tntedit1.Text := data.collection.fieldbyname('code').AsVariant;
   tntedit2.Text := data.collection.fieldbyname('name').AsVariant;
   bc := data.collection.fieldbyname('branchcode').AsVariant;
  end;

  if Not Data.branch.IsEmpty then
  with Data.branch do
  begin
   TntComboBox1.Clear;
   Setlength(branch_code,0);
   First;
   while Not eof do
   begin
     if FieldByName('name').AsVariant <> '' then
     begin
       i := TntComboBox1.Items.Add(FieldByName('name').AsVariant);
       SetLength(branch_code,Length(branch_code)+1);
       branch_code[length(branch_code)-1] := FieldByName('code').AsVariant;
       if bc = FieldByName('code').AsVariant then
         TntComboBox1.ItemIndex := i;
     end;
     Next;
   end;
   TntComboBox1.ItemIndex := 0;
  end;
//  showmessage(inttostr(orD(data.collection.state)));
end;

procedure TNewCollectionForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  showmessage(inttostr(orD(data.collection.state)));

  case ModalResult of
    mrOK:begin
           data.collection.FieldByName('code').AsVariant := TntEdit1.Text;
//  showmessage('x1');
           data.collection.FieldByName('name').AsVariant := TntEdit2.Text;
//  showmessage('x2');
           data.collection.FieldByName('branchcode').AsVariant := branch_code[TntComboBox1.ItemIndex];
//  showmessage('x3');
           PostTable(data.collection);
//  showmessage('x4');
           data.collection.Refresh;
//  showmessage('x5');
         end;
    mrCancel: CancelTable(data.collection);
  end;
end;

end.
