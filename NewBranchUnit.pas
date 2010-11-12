unit NewBranchUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, TntStdCtrls;

type
  TNewBranchForm = class(TTntForm)
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntEdit1: TTntEdit;
    TntEdit2: TTntEdit;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    procedure TntFormActivate(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewBranchForm: TNewBranchForm;

implementation

uses DataUnit, GlobalProcedures;

{$R *.DFM}

procedure TNewBranchForm.TntFormActivate(Sender: TObject);
begin
  if not data.branch.FieldByName('code').IsNull then
    TntEdit1.Text := data.branch.FieldByName('code').Asvariant
  else
   TntEdit1.Text := '';
  if not data.branch.FieldByName('name').IsNull then
    TntEdit2.Text := data.branch.FieldByName('name').Asvariant
  else
   TntEdit2.Text := '';
  TntEdit1.SetFocus;
end;

procedure TNewBranchForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  case ModalResult of
    mrOK:
         begin
           data.branch.fieldbyname('name').AsVariant := TntEdit2.Text;
           data.branch.FieldByName('code').AsVariant := TntEdit1.Text;
           PostTable(Data.branch);
           data.branch.Refresh;
         end;
    mrCancel: CancelTable(data.branch);
  end;
end;

end.