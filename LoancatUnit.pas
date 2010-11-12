unit LoancatUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, TntGrids, DBGrids, TntDBGrids, StdCtrls, Buttons,
  TntButtons, ExtCtrls, TntExtCtrls, TntStdCtrls;

type
  TLoancatForm = class(TForm)
    TntDBGrid1: TTntDBGrid;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntBitBtn3: TTntBitBtn;
    TntGroupBox1: TTntGroupBox;
    TntStringGrid1: TTntStringGrid;
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntBitBtn4Click(Sender: TObject);
    procedure TntBitBtn3Click(Sender: TObject);
    procedure TntDBGrid1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TntStringGrid1Click(Sender: TObject);
    procedure TntDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoancatForm: TLoancatForm;

implementation

uses DataUnit, common, DB, DBAccess, MyAccess, GlobalProcedures;

{$R *.dfm}

Procedure GetLoancat;
var
   g,i,maxl,l : integer;
   name : WideString;
   found:boolean;

begin

  Data.loancat.Filtered := false;

  for i := 0 to loancatform.TntStringGrid1.RowCount do
    loancatform.TntStringGrid1.Cells[1,i] := '';

  loancatform.TntStringGrid1.RowCount := 0;


  maxl:= data.loancat.recordcount;
  i:=0;
  data.loancat.First;

  for l:= 1 to maxl do
  begin
    found := false;
    name := data.loancat.fieldbyname('description').AsVariant;

    for g:=0 to loancatform.TntStringGrid1.RowCount-1 do
     if loancatform.TntStringGrid1.Cells[1,g]=name then
          found:=true;

    if Not found then
    begin
         loancatform.TntStringGrid1.RowCount := i+1;
         loancatform.TntStringGrid1.Cells[1,i]:= name;
         i:=i+1;
    end;
    data.loancat.next;
  end;

  data.loancat.Filtered := true;

end;

procedure FiltrLoancat(s: widestring);
begin

  with Data.loancat do
  begin
    Filtered := false;
    Filter := 'description='+QuotedStr(s);
    Filtered := true;
  end;

end;

procedure adjust_loan_categories(f: WideString);
var
didi,l,i:integer;
begin
  if data.loancat.RecordCount = 0 Then exit;

  didi:=data.patroncat.recordcount;
  data.patroncat.First;
  for l:=1 to didi do
      begin
         i:=data.patroncat.fieldbyname('id').asinteger;
         if not(data.loancat.locate('patroncatid',i,[])) then
              begin
                data.loancat.Append;
                data.loancat['description']:=f;
                data.loancat['patroncatid']:=i;
                data.loancat.Post;
              end;
      data.patroncat.next;
      end;

end;


procedure TLoancatForm.TntBitBtn2Click(Sender: TObject);
var
  temp : WideString;
begin

  temp := InputEditBoxW('Add New Category','Loan Category Description' + #13,'');
  if trim(temp) <> '' Then
  begin
    Data.loancat.append;
    Data.loancat.FieldByName('patroncatid').AsInteger := 0;
    Data.loancat.FieldByName('description').AsVariant := temp;
    PostTable (data.loancat);

    FiltrLoancat(temp);
    adjust_loan_categories(temp);

    data.loancat.Refresh;
    GetLoancat;
    FiltrLoancat(TntStringGrid1.Cells[TntStringGrid1.col,TntStringGrid1.row]);
  end;

end;

procedure TLoancatForm.TntBitBtn4Click(Sender: TObject);
begin
  PostTable(Data.loancat)
end;

procedure TLoancatForm.TntBitBtn3Click(Sender: TObject);
begin


  if MessageBox(0,PAnsiChar('Are you sure you want to delete the selected category?'),PAnsiChar('Delete Loan Category'), MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL)=mrYes then
  begin
    while Data.loancat.RecordCount <> 0 do
      Data.loancat.Delete;
    Data.loancat.Refresh;
    GetLoancat;
    FiltrLoancat(TntStringGrid1.Cells[TntStringGrid1.col,TntStringGrid1.row]);
  end;

end;

procedure TLoancatForm.TntDBGrid1DblClick(Sender: TObject);
var
  tex : WideString;
  reccount : integer;
begin
  reccount := data.loancat.RecordCount;
  if reccount <> 0 Then
  begin
    tex := InputEditBoxW('Edit Loan Category','Loan Category Description'  + #13, Data.loancat.FieldByName('description').AsVariant);
    if trim(tex) <> '' Then
    with data.loancat do
    begin
      First;
      while not eof do
      begin
        EditTable(data.loancat);
        FieldByName('description').Value := tex;
        PostTable(data.loancat);
        Refresh;
        if RecordCount = reccount Then Next;
      end;
      Refresh;
      GetLoancat;
      FiltrLoancat(TntStringGrid1.Cells[TntStringGrid1.col,TntStringGrid1.row]);
    end;
  end;
end;


procedure TLoancatForm.FormActivate(Sender: TObject);
begin
  GetLoancat;
  TntStringGrid1Click(Sender);
end;

procedure TLoancatForm.TntStringGrid1Click(Sender: TObject);
begin
  FiltrLoancat(TntStringGrid1.Cells[TntStringGrid1.col,TntStringGrid1.row]);
  adjust_loan_categories(TntStringGrid1.Cells[TntStringGrid1.col,TntStringGrid1.row]);

end;

procedure TLoancatForm.TntDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
   nr : integer;
   s : WideString;
   TempRect : TRect;
begin

 if Column.FieldName = 'patroncatid' then
 begin
   nr := Column.Field.AsInteger;
   TDBGrid(Sender).Canvas.FillRect(Rect);
   TempRect := Rect;
   if Data.patroncat.Locate('id',nr,[]) then
   begin
     s := Data.patroncat.FieldByName('description').Value;
     TempRect.Left := TempRect.Left + 2;
     TempRect.Top := TempRect.Top + 2; 
     DrawTextW(TTntDBGrid(Sender).Canvas.Handle, PWideChar(s), -1, TempRect, DT_LEFT);
   end
   else
     TTntDBGrid(Sender).Canvas.TextOut(Rect.Left+2,Rect.Top+2,'None');
 end;

end;

procedure TLoancatForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  data.loancat.Filter := 'patroncatid = 0';
  data.loancat.Filtered := True;
end;

end.
