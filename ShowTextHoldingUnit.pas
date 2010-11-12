unit ShowTextHoldingUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntButtons, TntStdCtrls, DB;

type
  TShowTextHoldingForm = class(TForm)
    TntMemo1: TTntMemo;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowTextHoldingForm: TShowTextHoldingForm;

implementation

uses HoldingsUnit, DataUnit, GlobalProcedures;

{$R *.dfm}

procedure TShowTextHoldingForm.TntBitBtn1Click(Sender: TObject);
begin
  if from_what = 1 then
  begin
    EditTable(Data.hold);
    Data.hold.GetBlob('f866').AsWideString := ShowTextHoldingForm.TntMemo1.Text;
    TBlobField(data.hold.FieldByName('f866')).Modified := True;
    PostTable(Data.hold);
  end;

  if from_what = 2 then
  begin
    EditTable(Data.hold);
    Data.hold.GetBlob('f867').AsWideString := ShowTextHoldingForm.TntMemo1.Text;
    TBlobField(data.hold.FieldByName('f867')).Modified := True;
    PostTable(Data.hold);
  end;

  if from_what = 3 then
  begin
    EditTable(Data.hold);
    Data.hold.GetBlob('f868').AsWideString := ShowTextHoldingForm.TntMemo1.Text;
    TBlobField(data.hold.FieldByName('f868')).Modified := True;
    PostTable(Data.hold);
  end;

  ShowTextHoldingForm.Close;
end;

procedure TShowTextHoldingForm.TntBitBtn2Click(Sender: TObject);
begin
  ShowTextHoldingForm.Close;
end;

end.
