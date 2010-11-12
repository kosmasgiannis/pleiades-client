unit NewLoanCategoryUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, TntStdCtrls;

type
  TNewLoanCategoryForm = class(TTntForm)
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntEdit1: TTntEdit;
    TntEdit2: TTntEdit;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewLoanCategoryForm: TNewLoanCategoryForm;

implementation

uses DataUnit, GlobalProcedures;

{$R *.DFM}

procedure TNewLoanCategoryForm.TntBitBtn1Click(Sender: TObject);
begin
   with Data.loancategory do
   begin
     Append;
     FieldByName('name').AsVariant := TntEdit2.Text;
     FieldByName('code').AsVariant := TntEdit1.Text;
     PostTable(Data.loancategory);
     Refresh;
   end;
end;

procedure TNewLoanCategoryForm.TntBitBtn2Click(Sender: TObject);
begin
 if MessYesNo('Do you want to save? ') then
   with Data.loancategory do
   begin
     Append;
     FieldByName('name').AsVariant := TntEdit2.Text;
     FieldByName('code').AsVariant := TntEdit1.Text;
     PostTable(Data.loancategory);
     Refresh;
   end;
end;

procedure TNewLoanCategoryForm.TntFormActivate(Sender: TObject);
begin
  TntEdit1.Text := '';
  TntEdit2.Text := '';
end;

end.
