unit CreateListUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, TntClasses, TntDialogs, ComCtrls,
  TntComCtrls, TntForms, cUnicodeCodecs;

type
  TCreateListForm = class(TTntForm)
    GroupBox1: TTntGroupBox;
    RadioButton2: TTntRadioButton;
    Edit2: TTntEdit;
    RadioButton4: TTntRadioButton;
    Edit4: TTntEdit;
    Label1: TTntLabel;
    Edit5: TTntEdit;
    RadioButton5: TTntRadioButton;
    RadioButton6: TTntRadioButton;
    RadioButton7: TTntRadioButton;
    ComboBox1: TTntComboBox;
    Button1: TTntButton;
    Button2: TTntButton;
    RadioButton8: TTntRadioButton;
    DateTimePicker1: TTntDateTimePicker;
    DateTimePicker2: TTntDateTimePicker;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure CreateListMod;
    procedure RadioButton8Click(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
  private
    { Private declarations }
    function CheckValidity : boolean;
    procedure CreateListBy(category : string; str : WideString);

  public
    { Public declarations }
  end;

var
  CreateListForm: TCreateListForm;

implementation

uses DataUnit, MainUnit, common, DB, MemDS, StrUtils, MyAccess,
  WideIniClass, ProgresBarUnit, DateUtils, GlobalProcedures;

{$R *.dfm}

function TCreateListForm.CheckValidity : boolean;
var
  s: string;
begin

  s := '';

  if RadioButton2.Checked Then
    if Edit2.Text = '' Then s := 'This is not a valid classification substring';

  if RadioButton7.Checked Then
    if ComboBox1.ItemIndex < 0 Then s := 'This is not a valid record level';

  if RadioButton4.Checked Then
    begin
      if(Edit4.Text = '')or(Edit5.Text = '') Then s := 'This is not a valid record range'
      else if strtoint(Edit4.Text) > strtoint(Edit5.Text) Then s := 'This is not a valid record range';
    end;

  if s <> '' Then wideShowMessage(s);

  Result := s = '';

end;
//==============================================================================
procedure TCreateListForm.CreateListBy(category : string; str : WideString);
var
  i, n, cnt : integer;
  F : TextFile;
  TempDateFormat : string;
  temp : WideString;
  BasketMark : TBookmark;
begin
  cnt:=0;

  AssignFile(F, FastRecordCreator.FNameList);

  Append(F);

  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'dd/mm/yyyy';

  ProgresBarForm.Show;
  ProgresBarForm.Label2.Caption := 'Create list by classification...';
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Visible := True;

  with data.hold do
  begin
    BasketMark := GetBookmark;
    DisableControls;
    MasterSource.Enabled := False;
    MasterFields := '';
    DetailFields := '';

//    Refresh;

    n := RecordCount;
    i := 0;

    try
      First;

      while not Eof do
      begin
        i := i + 1;
        temp := UTF8StringToWideString(FieldByName(category).Value);
        if pos(str, temp) > 0 then
           if AddToList(F, FieldByName('recno').AsInteger) Then cnt := cnt+1;

        ProgresBarForm.Label2.Caption := 'Processing RecNo:  '+FieldByName('holdon').AsString;
        ProgresBarForm.ProgressBar1.Position := Round(i*100/n);
        Application.ProcessMessages;

        Next;
      end;

    finally
      Closefile(F);
      ShortDateFormat := TempDateFormat;
      MasterSource.Enabled := True;
      MasterFields := 'recno';
      DetailFields := 'recno';
      EnableControls;
      ProgresBarForm.ProgressBar1.Visible := False;
      ProgresBarForm.Close;
      GotoBookmark(BasketMark);
      FreeBookmark(BasketMark);
    end;
  end;

  wideShowMessage(IntToStr(cnt)+' records added to list');
end;
//==============================================================================
procedure CreateListByLevel(str : integer);
var
  i, n, cnt : integer;
  F : TextFile;
  TempDateFormat : string;
  fil : string;
  fill : boolean;
  BasketMark : TBookmark;
begin
  cnt:=0;

  AssignFile(F, FastRecordCreator.FNameList);
  Append(F);

  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'dd/mm/yyyy';

  ProgresBarForm.Label2.Caption := 'Create list by level...';
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;
  ProgresBarForm.Show;

  with data.basket do
  begin
    BasketMark := GetBookmark;
    DisableControls;
    fil := Filter;
    fill := Filtered;
    Filter := '';
    Filtered := false;

//    Refresh;

    n := RecordCount;
    i := 0;

    try
      First;
      while not Eof do
      begin
        i := i + 1;

        if str=FieldByName('level').AsInteger then
           if AddToList(F, FieldByName('recno').AsInteger) Then cnt := cnt+1;

        ProgresBarForm.Label2.Caption := 'Processing RecNo:  '+FieldByName('recno').AsString;
        ProgresBarForm.ProgressBar1.Position := Round(i*100/n);
        Application.ProcessMessages;

        Next;
      end;

    finally
      Closefile(F);
      ShortDateFormat := TempDateFormat;
      EnableControls;
      ProgresBarForm.ProgressBar1.Visible := False;
      ProgresBarForm.Close;
      Filter := fil;
      Filtered := fill;
      GotoBookmark(BasketMark);
      FreeBookmark(BasketMark);
    end;
  end;
  wideShowMessage(IntToStr(cnt)+' records added to list');
end;
//==============================================================================
procedure CreateListByRecNo(nr1, nr2 : integer);
var
  i, n, cnt : integer;
  F : TextFile;
  TempDateFormat : string;
  fil : string;
  fill : boolean;
  BasketMark : TBookmark;
begin
  cnt:=0;

  AssignFile(F, FastRecordCreator.FNameList);
  Append(F);

  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'dd/mm/yyyy';

  ProgresBarForm.Show;
  ProgresBarForm.Label2.Caption := 'Create list by Recno...';
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;

  with data.basket do
  begin
    BasketMark := GetBookmark;
    DisableControls;
    fil := Filter;
    fill := Filtered;
    Filtered := true;
    Filter := '(recno>='+QuotedStr(inttostr(nr1))+')and(recno<='+QuotedStr(inttostr(nr2))+')';

//    Refresh;
    First;
    n := RecordCount;
    i := 0;
    try
      while not Eof do
      begin
        i := i + 1;

        if AddToList(F, FieldByName('recno').AsInteger) Then cnt := cnt+1;

        ProgresBarForm.Label2.Caption := 'Processing RecNo:  '+FieldByName('recno').AsString;
        ProgresBarForm.ProgressBar1.Position := Round(i*100/n);
        Application.ProcessMessages;

        Next;
      end;

    finally
      Closefile(F);
      ShortDateFormat := TempDateFormat;
      EnableControls;
      ProgresBarForm.ProgressBar1.Visible := False;
      ProgresBarForm.Close;
      Filter := fil;
      Filtered := fill;
      GotoBookmark(BasketMark);
      FreeBookmark(BasketMark);
    end;
  end;

  WideShowMessage(IntToStr(cnt)+' records added to list');
end;
//==============================================================================
procedure CreateListOutSubj;
var
  i, n, cnt : integer;
  F : TextFile;
  TempDateFormat : string;
  Line : TTntStringlist;
  k : integer;
  b : boolean;
  fil : string;
  fill : boolean;
  BasketMark : TBookmark;
begin
  cnt:=0;

  AssignFile(F, FastRecordCreator.FNameList);

  Append(F);

  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'dd/mm/yyyy';

  ProgresBarForm.Show;
  ProgresBarForm.Label2.Caption := 'Records without subject...';
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;
  Line := TTntStringList.Create;

  with data.basket do
  begin
    BasketMark := GetBookmark;
    DisableControls;
    fil := Filter;
    fill := Filtered;
    Filter := '';
    Filtered := false;

//    Refresh;

    n := RecordCount;
    i := 0;
    try
      First;
      while not Eof do
      begin
        i := i + 1;
        Line.Clear;
        marcrecord2lines(WideStringToString(GetBlob('text').AsWideString, Greek_codepage), line);
        b := true;

        for k := 0 to line.Count - 1 do
          if '[6' = LeftStr(Line.Strings[k], 2) then b := false;

        if(b)and(AddToList(F, FieldByName('recno').AsInteger)) Then cnt := cnt+1;
        ProgresBarForm.Label2.Caption := 'Processing RecNo:  '+fieldbyname('recno').AsString;
        ProgresBarForm.ProgressBar1.Position := Round(i*100/n);
        Application.ProcessMessages;

        Next;
      end;

    finally
      Line.Free;
      Closefile(F);
      ShortDateFormat := TempDateFormat;
      EnableControls;
      ProgresBarForm.ProgressBar1.Visible := False;
      ProgresBarForm.Close;
      Filter := fil;
      Filtered := fill;
      GotoBookmark(BasketMark);
      FreeBookmark(BasketMark);
    end;
  end;

  WideShowMessage(IntToStr(cnt)+' records added to list');
end;
//==============================================================================
procedure CreateListErr;
var
  msg : string;
  marcrec : UTF8String;
  cnt : integer;
  F : TextFile;
  Line : TTntStringList;
  TempDateFormat : string;
  n, i : integer;
  fil : string;
  fill,scflag : boolean;
  BasketMark : TBookmark;
begin
  cnt:=0;
  AssignFile(F, FastRecordCreator.FNameList);
  Append(F);
  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'dd/mm/yyyy';

  ProgresBarForm.Show;
  ProgresBarForm.Label2.Caption := 'Records with syntax errors...';
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;

  Line := TTntStringList.Create;
  with data.basket do
  begin
    BasketMark := GetBookmark;
    DisableControls;
    fil := Filter;
    fill := Filtered;
    Filter := '';
    Filtered := false;

//    Refresh;

    n := RecordCount;
    i := 0;
    First;
    try
      while (not eof) do
      begin
       inc(i);
       Line.Clear;

       marcrec := WideStringToString(GetBlob('text').AsWideString, Greek_codepage);
       marcrecord2lines(marcrec,line);

       scflag := syntaxchk(line,msg,BibUsmarcStx);
       if (not scflag) then
         if AddToList(F, FieldByName('recno').AsInteger) Then cnt := cnt+1;

       ProgresBarForm.Label2.Caption := 'Processing RecNo:  '+fieldbyname('recno').AsString;
       ProgresBarForm.ProgressBar1.Position := Round(i*100/n);
       Application.ProcessMessages;
       Next;
      end;
    finally
      EnableControls;
      Filter := fil;
      Filtered := fill;
      GotoBookmark(BasketMark);
      FreeBookmark(BasketMark);
      line.Free;
      Closefile(F);
      ShortDateFormat := TempDateFormat;
      ProgresBarForm.ProgressBar1.Visible := False;
      ProgresBarForm.Close;
    end;
  end;

  WideShowMessage(IntToStr(cnt)+' records added to list');
end;

procedure TCreateListForm.CreateListMod;
var
  i, n, cnt : integer;
  F : TextFile;
  TempDateFormat : string;
  fil : string;
  fill : boolean;
  BasketMark : TBookmark;
begin
  cnt:=0;

  AssignFile(F, FastRecordCreator.FNameList);
  Append(F);

  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'dd/mm/yyyy';

  ProgresBarForm.Show;
  ProgresBarForm.Label2.Caption := 'Create list by modified date...';
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;

  with data.basket do
  begin
    BasketMark := GetBookmark;
    DisableControls;
    fil := Filter;
    fill := Filtered;
    Filtered := true;
    Filter := '(modified>='+QuotedStr(DateToStr(DateTimePicker1.Date))+')and(modified<='+QuotedStr(DateToStr(DateTimePicker2.Date))+')';

//    Refresh;
    First;
    n := RecordCount;
    i := 0;
    try
      while not Eof do
      begin
        i := i + 1;

        if AddToList(F, FieldByName('recno').AsInteger) Then cnt := cnt+1;

        ProgresBarForm.Label2.Caption := 'Processing RecNo:  '+fieldbyname('recno').AsString;
        ProgresBarForm.ProgressBar1.Position := Round(i*100/n);
        Application.ProcessMessages;

        Next;
      end;

    finally
      Closefile(F);
      ShortDateFormat := TempDateFormat;
      EnableControls;
      ProgresBarForm.ProgressBar1.Visible := False;
      ProgresBarForm.Close;
      Filter := fil;
      Filtered := fill;
      GotoBookmark(BasketMark);
      FreeBookmark(BasketMark);
    end;
  end;

  WideShowMessage(IntToStr(cnt)+' records added to list');
end;

procedure TCreateListForm.FormClose(Sender: TObject;
  var Action: TCloseAction);

begin
  CreateListForm.Enabled := false;
  try
  case ModalResult of
    mrOk:   if CheckValidity Then
            begin
              if RadioButton2.Checked then CreateListBy('cln', Edit2.text);

              if RadioButton7.Checked then CreateListByLevel(ComboBox1.ItemIndex);

              if RadioButton4.Checked then CreateListByRecNo(strtoint(Edit4.Text), strtoint(Edit5.Text));

              if RadioButton5.Checked then CreateListErr;

              if RadioButton6.Checked then CreateListOutSubj;

              if RadioButton8.Checked then CreateListMod;

              SetCurrentList(FastRecordCreator.FNameList);
            end
            Else Action := caNone;

  end;
  finally
    CreateListForm.Enabled := true;
  end;
end;

procedure TCreateListForm.RadioButton1Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  Edit4.OnChange := nil;
  Edit5.OnChange := nil;
  ComboBox1.OnChange := nil;
  DateTimePicker1.OnChange := nil;
  DateTimePicker2.OnChange := nil;
  Edit2.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  ComboBox1.ItemIndex := -1;
  DateTimePicker1.Date := Today;
  DateTimePicker2.Date := Today;
  Edit2.OnChange := Edit2Change;
  Edit4.OnChange := Edit4Change;
  Edit5.OnChange := Edit4Change;
  ComboBox1.OnChange := ComboBox1Change;
  DateTimePicker1.OnChange := DateTimePicker1Change;
  DateTimePicker2.OnChange := DateTimePicker1Change;
end;

procedure TCreateListForm.RadioButton2Click(Sender: TObject);
begin
  Edit4.OnChange := nil;
  Edit5.OnChange := nil;
  ComboBox1.OnChange := nil;
  DateTimePicker1.OnChange := nil;
  DateTimePicker2.OnChange := nil;
  Edit4.Text := '';
  Edit5.Text := '';
  ComboBox1.ItemIndex := -1;
  DateTimePicker1.Date := Today;
  DateTimePicker2.Date := Today;
  Edit4.OnChange := Edit4Change;
  Edit5.OnChange := Edit4Change;
  ComboBox1.OnChange := ComboBox1Change;
  DateTimePicker1.OnChange := DateTimePicker1Change;
  DateTimePicker2.OnChange := DateTimePicker1Change;
end;

procedure TCreateListForm.RadioButton3Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  Edit4.OnChange := nil;
  Edit5.OnChange := nil;
  ComboBox1.OnChange := nil;
  DateTimePicker1.OnChange := nil;
  DateTimePicker2.OnChange := nil;
  Edit2.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  ComboBox1.ItemIndex := -1;
  DateTimePicker1.Date := Today;
  DateTimePicker2.Date := Today;
  Edit2.OnChange := Edit2Change;
  Edit4.OnChange := Edit4Change;
  Edit5.OnChange := Edit4Change;
  ComboBox1.OnChange := ComboBox1Change;
  DateTimePicker1.OnChange := DateTimePicker1Change;
  DateTimePicker2.OnChange := DateTimePicker1Change;
end;

procedure TCreateListForm.RadioButton7Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  Edit4.OnChange := nil;
  Edit5.OnChange := nil;
  DateTimePicker1.OnChange := nil;
  DateTimePicker2.OnChange := nil;
//  ComboBox1.ItemIndex := 0;
  Edit2.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  DateTimePicker1.Date := Today;
  DateTimePicker2.Date := Today;
  Edit2.OnChange := Edit2Change;
  Edit4.OnChange := Edit4Change;
  Edit5.OnChange := Edit4Change;
  DateTimePicker1.OnChange := DateTimePicker1Change;
  DateTimePicker2.OnChange := DateTimePicker1Change;

end;

procedure TCreateListForm.RadioButton4Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  ComboBox1.OnChange := nil;
  DateTimePicker1.OnChange := nil;
  DateTimePicker2.OnChange := nil;
  Edit2.Text := '';
  ComboBox1.ItemIndex := -1;
  DateTimePicker1.Date := Today;
  DateTimePicker2.Date := Today;
  Edit2.OnChange := Edit2Change;
  ComboBox1.OnChange := ComboBox1Change;
  DateTimePicker1.OnChange := DateTimePicker1Change;
  DateTimePicker2.OnChange := DateTimePicker1Change;
end;

procedure TCreateListForm.RadioButton5Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  Edit4.OnChange := nil;
  Edit5.OnChange := nil;
  ComboBox1.OnChange := nil;
  DateTimePicker1.OnChange := nil;
  DateTimePicker2.OnChange := nil;
  Edit2.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  ComboBox1.ItemIndex := -1;
  DateTimePicker1.Date := today;
  DateTimePicker2.Date := today;
  Edit2.OnChange := Edit2Change;
  Edit4.OnChange := Edit4Change;
  Edit5.OnChange := Edit4Change;
  ComboBox1.OnChange := ComboBox1Change;
  DateTimePicker1.OnChange := DateTimePicker1Change;
  DateTimePicker2.OnChange := DateTimePicker1Change;
end;

procedure TCreateListForm.RadioButton6Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  Edit4.OnChange := nil;
  Edit5.OnChange := nil;
  ComboBox1.OnChange := nil;
  DateTimePicker1.OnChange := nil;
  DateTimePicker2.OnChange := nil;
  Edit2.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  ComboBox1.ItemIndex := -1;
  DateTimePicker1.Date := today;
  DateTimePicker2.Date := today;
  Edit2.OnChange := Edit2Change;
  Edit4.OnChange := Edit4Change;
  Edit5.OnChange := Edit4Change;
  ComboBox1.OnChange := ComboBox1Change;
  DateTimePicker1.OnChange := DateTimePicker1Change;
  DateTimePicker2.OnChange := DateTimePicker1Change;
end;

procedure TCreateListForm.Edit2Change(Sender: TObject);
begin
  RadioButton2.Checked := true;
end;

procedure TCreateListForm.ComboBox1Change(Sender: TObject);
begin
  RadioButton7.Checked := true;
end;

procedure TCreateListForm.Edit4Change(Sender: TObject);
begin
  RadioButton4.Checked := true;
end;

procedure TCreateListForm.FormActivate(Sender: TObject);
begin
  DateTimePicker1.Date := today;
  DateTimePicker2.Date := today;
  if FastRecordCreator.bib_auth_status = 'bib' then
    PopulateComboFromIni('RecordLevel', ComboBox1)
  else
    PopulateComboFromIni('AuthRecordLevel', ComboBox1);
end;

procedure TCreateListForm.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if not ((key in ['0'..'9'])or(key=chr(8))) then key := #0;
end;

procedure TCreateListForm.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if not ((key in ['0'..'9'])or(key=chr(8))) then key := #0;
end;

procedure TCreateListForm.RadioButton8Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  Edit4.OnChange := nil;
  Edit5.OnChange := nil;
  ComboBox1.OnChange := nil;
  Edit2.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  ComboBox1.ItemIndex := -1;
  Edit2.OnChange := Edit2Change;
  Edit4.OnChange := Edit4Change;
  Edit5.OnChange := Edit4Change;
  ComboBox1.OnChange := ComboBox1Change;
end;

procedure TCreateListForm.DateTimePicker1Change(Sender: TObject);
begin
  RadioButton8.Checked := true;
end;

end.
