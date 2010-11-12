unit ProcessStatusUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, Grids, DBGrids,
  TntDBGrids, TntStdCtrls;

type
  TProcessStatusForm = class(TTntForm)
    TntDBGrid1: TTntDBGrid;
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
  ProcessStatusForm: TProcessStatusForm;

implementation

uses DataUnit, DB, GlobalProcedures, NewProcessStatusUnit;

{$R *.DFM}

procedure TProcessStatusForm.TntBitBtn1Click(Sender: TObject);
begin
  NewProcessStatusForm.ShowModal;
end;

procedure TProcessStatusForm.TntBitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
