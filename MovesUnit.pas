unit MovesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, TntStdCtrls, TntDBGrids, MyAccess, TntForms,
  TntButtons;

type TUserCode = record
      usecod : WideString;
end;

type
  TMovesForm = class(TTntForm)
    DBGrid1: TTntDBGrid;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    TntComboBox1: TTntComboBox;
    Label1: TTntLabel;
    Label3: TTntLabel;
    TntBitBtn1: TTntBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TntComboBox1Change(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    Procedure GetUsers;
  public
    { Public declarations }
  end;

var
  MovesForm: TMovesForm;
  Usecod : array of TUserCode;
implementation

uses DataUnit, DB;

{$R *.dfm}

Procedure TMovesForm.GetUsers;
begin

 setlength(Usecod,0);

// Write in Combobox's dropdown list all the users
  TntComboBox1.Items.Clear;
  with data.users do
  begin
    First;
    TntComboBox1.Items.Add('All users');
    TntComboBox1.Items.Add('admin');
    while Not Eof do
    begin
      TntComboBox1.Items.Add(fieldByName('Username').AsVariant);
      SetLength(Usecod, length(Usecod)+1);
      Usecod[length(Usecod)-1].usecod := fieldByName('Usercode').AsVariant;
      Next;
    end;
  end;
  
end;




procedure TMovesForm.BitBtn1Click(Sender: TObject);
var
  Query : TMyQuery;
begin
  Query := TMyQuery.Create(Self);

  try
    Query.Connection := data.MyConnection1;
    Query.SQL.Text := 'DELETE FROM moves';
    Query.Execute;
  finally
    Query.Free;
  end;

end;

procedure TMovesForm.BitBtn2Click(Sender: TObject);
begin
  Data.moves.Refresh;
end;

procedure TMovesForm.FormActivate(Sender: TObject);
begin
  GetUsers;
  TntComboBox1.ItemIndex := 0;
end;

procedure TMovesForm.TntComboBox1Change(Sender: TObject);
begin

  if TntComboBox1.ItemIndex > 1 then
  begin
    Data.moves.Filtered := false;
    data.moves.Filter := 'Usercode='+QuotedStr(Usecod[TntComboBox1.ItemIndex-2].usecod);
    Data.moves.Filtered := true;
  end
  else if TntComboBox1.ItemIndex = 1 then
    begin
      Data.moves.Filtered := false;
      data.moves.Filter := 'Usercode='+QuotedStr('0');
      Data.moves.Filtered := true;
    end
      else
        Data.moves.Filtered := false;
end;

procedure TMovesForm.TntBitBtn1Click(Sender: TObject);
begin
 close
end;

procedure TMovesForm.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Column.FieldName = 'severity' then
  with (TTntDBGrid(Sender).Canvas) do
  begin
    if Not Column.Field.IsNull then
     case Column.Field.AsInteger of
     1:TextRect(Rect,Rect.Left+2,Rect.Top+2,'System Messages');
     2:TextRect(Rect,Rect.Left+2,Rect.Top+2,'Login Logout Actions');
     3:TextRect(Rect,Rect.Left+2,Rect.Top+2,'Delete Actions');
     4:TextRect(Rect,Rect.Left+2,Rect.Top+2,'Print Actions');
     5:TextRect(Rect,Rect.Left+2,Rect.Top+2,'Export Actions');
     6:TextRect(Rect,Rect.Left+2,Rect.Top+2,'Add, Modify, Save Actions');
     end
    else
      FillRect(Rect);
  end;
end;

end.
