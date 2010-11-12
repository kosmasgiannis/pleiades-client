unit NewGroupUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntButtons, TntStdCtrls, ExtCtrls,
  TntExtCtrls, TntForms;

type
  TNewGroupForm = class(TTntForm)
    RadioGroup1: TTntRadioGroup;
    GroupBox1: TTntGroupBox;
    TntLabel1: TTntLabel;
    TntEdit1: TTntEdit;
    TntLabel2: TTntLabel;
    TntComboBox1: TTntComboBox;
    TntBitBtn2: TTntBitBtn;
    Button4: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure TntEdit1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewGroupForm: TNewGroupForm;

implementation

uses NewMarcUnit, DataUnit, DB, MARCDisplayUnit;

{$R *.dfm}

procedure TNewGroupForm.FormActivate(Sender: TObject);
begin
  TntComboBox1.Items := MARCDisplayForm.TntComboBox2.Items;
end;

procedure TNewGroupForm.Button4Click(Sender: TObject);
begin
  close;
end;

procedure TNewGroupForm.TntEdit1Change(Sender: TObject);
begin
  if (TntComboBox1.Text <> '') and (TntEdit1.Text <> '') then
    RadioGroup1.Enabled := true
   else
    RadioGroup1.Enabled := false;
end;

procedure TNewGroupForm.RadioGroup1Click(Sender: TObject);
begin
  if (TntComboBox1.Text <> '') and (TntEdit1.Text <> '') and (RadioGroup1.ItemIndex <> -1) then
    TntBitBtn2.Enabled := true
  else TntBitBtn2.Enabled := false;
end;

procedure TNewGroupForm.TntBitBtn2Click(Sender: TObject);
begin

 if RadioGroup1.ItemIndex = 1 then
       NewMarcForm.ShowModal
   else
      begin
        with data.marcdisplay do
        begin
         Append;
          FieldByName('Name').AsString := TntEdit1.Text;
          FieldByName('Lang').AsString := TntComboBox1.Text;
          Post;
        end;
        ModalResult := mrOk;
      end;

  if ModalResult = mrOk then
    Close;


end;

end.
