unit NewProcessStatusUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, TntStdCtrls;

type
  TNewProcessStatusForm = class(TTntForm)
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
  NewProcessStatusForm: TNewProcessStatusForm;

implementation

uses DataUnit, GlobalProcedures;

{$R *.DFM}

procedure TNewProcessStatusForm.TntBitBtn1Click(Sender: TObject);
begin
   with Data.processstatus do
   begin
     Append;
     FieldByName('name').AsVariant := TntEdit2.Text;
     FieldByName('code').AsVariant := TntEdit1.Text;
     PostTable(Data.processstatus);
     Refresh;
   end;
end;

procedure TNewProcessStatusForm.TntBitBtn2Click(Sender: TObject);
begin
 if MessYesNo('Do you want to save? ') then
   with Data.processstatus do
   begin
     Append;
     FieldByName('name').AsVariant := TntEdit2.Text;
     FieldByName('code').AsVariant := TntEdit1.Text;
     PostTable(Data.processstatus);
     Refresh;
   end;
end;

procedure TNewProcessStatusForm.TntFormActivate(Sender: TObject);
begin
  TntEdit1.Text := '';
  TntEdit2.Text := '';
end;

end.