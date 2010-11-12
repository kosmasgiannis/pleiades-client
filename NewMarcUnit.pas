unit NewMarcUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, Buttons, TntButtons, TntForms;

type
  TNewMarcForm = class(TTntForm)
    TntComboBox1: TTntComboBox;
    TntLabel1: TTntLabel;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewMarcForm: TNewMarcForm;

implementation

uses DataUnit, DB, NewGroupUnit, MyAccess;

{$R *.dfm}

procedure TNewMarcForm.BitBtn2Click(Sender: TObject);
begin
  NewGroupForm.ModalResult := mrNone;
  close;
end;

procedure TNewMarcForm.FormActivate(Sender: TObject);
var sqltext : string;
begin

  // Write in Combobox's dropdown list the distinct values from  column Vocabulary.Name
  TntComboBox1.Items.Clear;
  with data.Query1 do
  begin
    Close;
    sqltext := SQL.Text;
    SQL.Text :='SELECT DISTINCT  Name FROM marcdisplay';
    Open;
    First;
    while Not Eof do
    begin
      TntComboBox1.Items.Add(FieldByName('Name').AsString);
      Next;
    end;
    Close;
    SQL.Text := sqltext;
    Open;
  end;

end;

procedure TNewMarcForm.BitBtn1Click(Sender: TObject);
var sqltext :string;
begin

  with Data.Query1 do
  begin
    Close;
    sqltext := SQL.Text;
    SQL.Clear;
    SQL.Add('SELECT * FROM marcdisplay');
    SQL.Add('Where marcdisplay.Name = '+QuotedStr(TntComboBox1.Text));
    Open;
    First;
    while Not Eof do
    begin
      data.marcdisplay.Append;
      data.marcdisplay.FieldByName('Name').AsString := NewGroupForm.TntEdit1.Text;
      data.marcdisplay.FieldByName('Lang').AsString := NewGroupForm.TntComboBox1.Text;
      data.marcdisplay.FieldByName('Tag').AsString := FieldByName('Tag').AsString;
      data.marcdisplay.FieldByName('Label').AsString := FieldByName('Label').AsString;
      data.marcdisplay.FieldByName('print').AsBoolean := true;
      data.marcdisplay.Post;
      Next;
    end;

    Close;
    SQL.Text := sqltext;
    Open;
  end;

  NewGroupForm.ModalResult := mrOk;
  close;


end;

end.
