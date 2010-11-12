unit LoanCategoryUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, Grids, DBGrids,
  TntDBGrids, TntStdCtrls;

type
  TLoanCategoryForm = class(TTntForm)
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
  LoanCategoryForm: TLoanCategoryForm;

implementation

uses DataUnit, DB, GlobalProcedures, NewLoanCategoryUnit;

{$R *.DFM}

procedure TLoanCategoryForm.TntBitBtn1Click(Sender: TObject);
begin
  NewLoanCategoryForm.ShowModal;
end;

procedure TLoanCategoryForm.TntBitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
