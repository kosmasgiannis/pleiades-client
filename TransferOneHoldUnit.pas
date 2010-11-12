unit TransferOneHoldUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, Buttons, TntButtons, TntDialogs, DB;

type
  TTransferOneHoldForm = class(TForm)
    TntGroupBox1: TTntGroupBox;
    TntEdit1: TTntEdit;
    TntButton1: TTntBitBtn;
    TntButton2: TTntBitBtn;
    procedure TntButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentRecno, CurrentHoldon : integer;

    procedure MoveOneHolding(OldRecno, NewRecno : integer);
  end;

var
  TransferOneHoldForm: TTransferOneHoldForm;

implementation

uses DataUnit, zoomit, common, GlobalProcedures;

{$R *.dfm}

procedure TTransferOneHoldForm.MoveOneHolding(OldRecno, NewRecno : integer);
var
  rec : UTF8String;
  recnr : integer;
begin

  with Data.MyCommand1 do
  begin
    SQL.Clear;
    SQL.Add('UPDATE hold SET recno = :newrecno WHERE holdon = :holdon;');
    SQL.Add('UPDATE items SET recno = :newrecno WHERE holdon = :holdon;');

    ParamByName('newrecno').AsInteger := NewRecno;
    ParamByName('holdon').AsInteger := CurrentHoldon;
    Execute;
  end;

  //Update holding info for source record
  rec := WideStringToString(data.Securebasket.GetBlob('text').AsWideString, Greek_codepage);
  EditTable(data.Securebasket);
  Refresh084(OldRecno, rec);
  data.Securebasket.GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
  TBlobField(data.Securebasket.FieldByName('text')).Modified := True;
  PostTable(data.Securebasket);

  recnr := data.Securebasket.FieldByName('recno').AsInteger;
  RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));

  //Update holding info for destination record

  //FIXME: What if the recno is not currently in basket? !!!

  if data.basket.Locate('recno', NewRecno, []) Then
  begin
    rec := GetLastDataFromBasket(NewRecno);
    EditTable(data.basket);
    Refresh084(NewRecno, rec);
    data.basket.GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
    TBlobField(data.basket.FieldByName('text')).Modified := True;
    PostTable(data.basket);

    recnr := data.basket.FieldByName('recno').AsInteger;
    RecordUpdated(myzebrahost, 'update', recnr, MakeMRCFromSecureBasket(recnr));
  end;

end;


procedure TTransferOneHoldForm.TntButton1Click(Sender: TObject);
var
  ToRecno : integer;
begin

  ToRecno := StrToIntDef(TntEdit1.Text, -1);

  if not data.basket.Locate('recno', ToRecno, []) Then
  begin
    WideShowMessage('Destination record does not exist.');
    ModalResult := mrNone;
  end
  Else
  begin
    MoveOneHolding(CurrentRecno, ToRecno);
    data.hold.Refresh;
    data.basket.Locate('recno', CurrentRecno, []);
  end;

end;

end.
