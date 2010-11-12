unit VocabUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, 
  Dialogs, StdCtrls, TntStdCtrls, Grids, DBGrids, TntDBGrids, Buttons,
  Mask, DBCtrls, TntDBCtrls, TntButtons, TntForms;

type
  TVocabForm = class(TTntForm)
    TntDBGrid1: TTntDBGrid;
    TntComboBox1: TTntComboBox;
    TntLabel1: TTntLabel;
    Button4: TTntBitBtn;
    TntComboBox2: TTntComboBox;
    TntLabel2: TTntLabel;
    TntDBGrid2: TTntDBGrid;
    TntBitBtn1: TTntBitBtn;
    TntComboBox3: TTntComboBox;
    TntBitBtn2: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure TntComboBox1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VocabForm: TVocabForm;

implementation

uses DataUnit, DB, DBAccess, MyAccess, GlobalProcedures;

{$R *.dfm}

procedure TVocabForm.FormActivate(Sender: TObject);
var
  Query : TMyQuery;
begin

// Write in Combobox's dropdown list the distinct values from  column Vocabulary.Form
  TntComboBox1.Items.Clear;
  Query := TMyQuery.Create(Self);
  Query.Connection := data.MyConnection1;

  with Query do
  begin
    SQL.Text :='SELECT DISTINCT  Form FROM vocabulary';
    Open;
    TntComboBox1.Items.Add('All forms');
    while Not Eof do
    begin
      TntComboBox1.Items.Add(FieldByName('Form').AsString);
      Next;
    end;
    Close;
  end;

  Query.Free;

end;

procedure TVocabForm.TntComboBox1Change(Sender: TObject);
begin

// Sort the table by Form 
 if TntComboBox1.ItemIndex > 0 then
  with Data.vocabulary do
  begin
    Filtered := false;
    Filter := 'Form=' + QuotedStr(TntComboBox1.Text);
    Filtered := true;
  end
  else
    Data.vocabulary.Filtered := false;
end;

procedure TVocabForm.Button4Click(Sender: TObject);
begin
  close;
end;

procedure TVocabForm.TntBitBtn1Click(Sender: TObject);
begin
  add_language(TntComboBox3.Text);
end;

procedure TVocabForm.TntBitBtn2Click(Sender: TObject);
begin
 Data.vocabulary.Refresh;
 Data.languages.Refresh;
end;

end.
