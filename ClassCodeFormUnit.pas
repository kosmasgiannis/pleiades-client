unit ClassCodeFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntStdCtrls, DB, TntForms,
  TntDialogs, TntButtons;

type
  TClassCodeForm = class(TTntForm)
    TntEdit1: TTntEdit;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    Label1: TTntLabel;
    Label2: TTntLabel;
    SaveDialog1: TTntSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Reporthold(category : string);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    myfield : string;
  end;

var
  ClassCodeForm: TClassCodeForm;

implementation

uses Math, DataUnit, MyAccess, ReportsUnit, MainUnit,
  MemDS,
  ProgresBarUnit;

{$R *.dfm}

procedure TClassCodeForm.Reporthold(category : string);
var
  col,collection,item,cln : String;
  cnt,j:integer;
  f : textfile;
  n : integer;
  b : boolean;
  i, int : integer;
  book:TBookMark;

begin
 cnt := 0;
 b := true;
 col := TntEdit1.Text;
 SaveDialog1.FileName := '';
 SaveDialog1.Filter := 'TXT files (*.txt)|*.txt';
 SaveDialog1.DefaultExt := 'txt';
 SaveDialog1.FilterIndex := 0; { start the dialog showing all files }

  if not SaveDialog1.Execute then exit;

  Assignfile(f,Savedialog1.FileName);

  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Visible := True;

  with Data.hold do
  begin
    book := GetBookMark;
    MasterSource := nil;
    DisableControls;
    Refresh;
    n := RecordCount;
    First;

    if ReportsForm.IfList then
      for i := 0 to Length(FastRecordCreator.List)-1 do
        begin
         try
          int := FastRecordCreator.List[i];
//          if Locate('recno', int, []) then
          Filtered := true;
          Filter := 'recno='+QuotedStr(IntToStr(int));
          First;
          while not Eof do
          begin
          if pos(col,FieldByName(category).AsString) > 0 then
            begin
              if b then begin b := false; Rewrite(f); end;
              if not FieldByName('collection').IsNull then collection :=FieldByName('collection').AsString else collection := '';
              if not FieldByName('cln').IsNull then cln := FieldByName('cln').AsString else cln := '';
              if not FieldByName('item').IsNull then item := FieldByName('item').AsString else item := '';

              writeln(f,collection,',',cln);
              for j:=1 to length(item) do
                if item[j] = ',' then writeln(f,collection,',',cln);

              cnt := cnt + 1;
              ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+IntToStr(FastRecordCreator.List[i]);
              ProgresBarForm.ProgressBar1.Position := Round(cnt*100/n);
              Application.ProcessMessages;
            end;
            Next;
          end;
          Filtered := false;
         except
          ShowMessage('Error...');
         end;
        end
    else
      while not Eof do
        begin
         try
          if not FieldByName(category).IsNull then
          begin
          if pos(col,FieldByName(category).AsString) > 0 then
            begin
              if b then begin b := false; Rewrite(f); end;
              if not FieldByName('collection').IsNull then collection :=FieldByName('collection').AsString else collection := '';
              if not FieldByName('cln').IsNull then cln := FieldByName('cln').AsString else cln := '';
              if not FieldByName('item').IsNull then item := FieldByName('item').AsString else item := '';

              writeln(f,collection,',',cln);
              for j:=1 to length(item) do
                if item[j] = ',' then writeln(f,collection,',',cln);

              cnt := cnt + 1;
              ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+fieldbyname('recno').AsString;
              ProgresBarForm.ProgressBar1.Position := Round(cnt*100/n);
              Application.ProcessMessages;
            end;
            Next;
          end
          else next;
         except
          ShowMessage('Error...');
         end;
        end;
   ProgresBarForm.ProgressBar1.Visible := false;
   ProgresBarForm.Close;
   EnableControls;
   MasterSource := Data.BasketSource;
   GotoBookmark(book);
   FreeBookmark(book);
  end;
  if not b then Closefile(f);
  ShowMessage(inttostr(cnt)+' records found');
 SetFocus;
end;

procedure TClassCodeForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  If ModalResult <> mrOk then exit;
  if TntEdit1.Text = '' then exit;
  Reporthold(myfield);
end;

procedure TClassCodeForm.FormActivate(Sender: TObject);
begin
  TntEdit1.Clear;
  TntEdit1.SetFocus;
end;

end.
