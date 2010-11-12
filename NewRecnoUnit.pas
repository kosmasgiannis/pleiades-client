unit NewRecnoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntStdCtrls, TntButtons, TntForms;

type
  TNewRecnoForm = class(TTntForm)
    Label1: TTntLabel;
    Edit1: TTntEdit;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewRecnoForm: TNewRecnoForm;

implementation

{$R *.dfm}

procedure TNewRecnoForm.FormActivate(Sender: TObject);
begin
  ActiveControl := Edit1;
  Edit1.Text := '1';
end;

procedure TNewRecnoForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0','1','2','3','4','5','6','7','8','9'])) and
     (Key <> #8) Then Key := #0;
end;

end.
