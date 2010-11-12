unit transferholdings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, TntDialogs, TntStdCtrls, TntForms, Buttons,
  TntButtons;

type
  Txferholdings = class(TTntForm)
    Edit1: TTntEdit;
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Edit2: TTntEdit;
    Button1: TTntBitBtn;
    Button2: TTntBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  xferholdings: Txferholdings;

implementation

uses common, DataUnit;

{$R *.dfm}

procedure Txferholdings.Button1Click(Sender: TObject);
var
  FromRecno, ToRecno : integer;
begin
  FromRecno := StrToIntDef(Edit1.Text, -1);
  ToRecno := StrToIntDef(Edit2.Text, -1);
  if ((FromRecno <= 0) or (ToRecno<=0)) Then
  begin
    WideShowMessage('Invalid record numbers');
    ModalResult := mrNone;
    Exit;
  end;
  data.Query1.Close;
  data.Query1.SQL.Clear;
  data.Query1.SQL.Add('SELECT * FROM basket WHERE recno = '+inttostr(FromRecno));
  data.Query1.Execute;
  if not data.Query1.Locate('recno', FromRecno, []) Then
  begin
    WideShowMessage('Source record does not exist.');
    ModalResult := mrNone;
    Exit;
  end;
  data.Query1.Close;
  data.Query1.SQL.Clear;
  data.Query1.SQL.Add('SELECT * FROM basket WHERE recno = '+inttostr(ToRecno));
  data.Query1.Execute;
  if not data.Query1.Locate('recno', ToRecno, []) Then
  begin
    WideShowMessage('Destination record does not exist.');
    ModalResult := mrNone;
    Exit;
  end;
  MoveHoldings(FromRecno, ToRecno, True);
  data.hold.Refresh;
end;

procedure Txferholdings.FormShow(Sender: TObject);
begin
  ActiveControl := Edit1;
  Edit1.Text:='';
  Edit2.Text:='';
end;

end.
