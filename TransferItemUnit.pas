unit TransferItemUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, TntGrids, StdCtrls, TntStdCtrls, Buttons, TntButtons,
  DBGrids, TntDBGrids;

type
  TTransferItemForm = class(TForm)
    TntGroupBox1: TTntGroupBox;
    TntButton1: TTntBitBtn;
    TntButton2: TTntBitBtn;
    TntDBGrid1: TTntDBGrid;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntDBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TransferItemForm: TTransferItemForm;

implementation

uses DataUnit, zoomit, common, GlobalProcedures;

{$R *.dfm}

procedure TTransferItemForm.FormShow(Sender: TObject);
begin

  //Populate Holdings
  with data.Query2 do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM hold WHERE recno=:recno');
    ParamByName('recno').AsInteger := data.SecureBasket.FieldByName('recno').AsInteger;
    Execute;

    TntDBGrid1.DataSource := data.DataSource1;
  end;

end;

procedure MoveOneItem(NewHoldon, CurrentItemId : integer);
var
  rec : UTF8String;
  recnr : integer;
begin

  with Data.MyCommand1 do
  begin
    SQL.Clear;
    SQL.Add('UPDATE items SET holdon = :newholdon WHERE itemid = :itemid;');

    ParamByName('newholdon').AsInteger := NewHoldon;
    ParamByName('itemid').AsInteger := CurrentItemId;
    Execute;
  end;

  rec := WideStringToString(data.Securebasket.GetBlob('text').AsWideString, Greek_codepage);

  recnr := data.Securebasket.FieldByName('recno').AsInteger;
  RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));

end;

procedure TTransferItemForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  if ModalResult = mrOk Then
  begin
    MoveOneItem(data.Query2.FieldByName('holdon').AsInteger, data.Items.FieldByName('itemid').AsInteger);

    data.Items.Refresh;
  end;

  TntDBGrid1.DataSource := nil;
end;

procedure TTransferItemForm.TntDBGrid1DblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
