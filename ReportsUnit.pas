unit ReportsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, TntClasses, TntDialogs,
  TntStdCtrls, TntButtons, TntForms, cUnicodeCodecs;

type
  TReportsForm = class(TTntForm)
    GroupBox1: TTntGroupBox;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    RadioButton1: TTntRadioButton;
    RadioButton2: TTntRadioButton;
    RadioButton3: TTntRadioButton;
    RadioButton4: TTntRadioButton;
    RadioButton5: TTntRadioButton;
    SaveDialog1: TTntSaveDialog;
    CheckBox1: TTntCheckBox;
    OpenDialog1: TTntOpenDialog;
    BitBtn3: TTntBitBtn;
    BitBtn4: TTntBitBtn;
    Edit1: TTntEdit;
    Edit2: TTntEdit;
    RadioButton6: TTntRadioButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure ByAuthorTitle;
    procedure CheckBox1Click(Sender: TObject);
    procedure ExportRecord;
    procedure ReportHeadings;
    procedure ReportHeadingsIndex;
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IfList : boolean;
  end;

var
  ReportsForm: TReportsForm;
  l : TTntStringList;
  taginfo : array [1..128] of WideString;
//  scnt : integer;
//  status : boolean;

implementation

uses DataUnit, common, ClassCodeFormUnit, MainUnit, MyAccess,
  ProgresBarUnit, PrettyMARCUnit;


{$R *.dfm}

{function mycmp(rl : TstringList; i,j:integer) : integer;
var a,b:string;
begin
 a:=normalize(rl[i]);
 b:=normalize(rl[j]);
 if a = b then result:=0
 else if a > b then result:=1
 else result:=-1;
end;}

function ReverseString(const AText: WideString): WideString;
var
  I: Integer;
  P: PWideChar;
begin
  SetLength(Result, Length(AText));
  P := PwideChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

procedure TReportsForm.ExportRecord;
var
  author, title, barcodes, rec, marcrec : WideString;
  taginfo : array [1..10] of WideString;
  rl : TTntStringList;
  xx : integer;
begin
 try
  rec := data.basket.FieldByName('recno').AsString;
  marcrec := makemrcfrombasket;
  taginfo[1]:='936??d';
  rl := TTntStringList.Create;
  rl.Clear;
  extract_headings(rl,marcrec,'',taginfo,1);
  barcodes:='';
  for xx:=0 to rl.count-1 do barcodes:=barcodes+rl[xx];
  rl.free;
  get_author_title(marcrec,'USmarc',author,title,true);
  l.Add(author+#$0d+#$0a+title+#$0d+#$0a+barcodes+'#'+rec);
  except
    ShowMessage('Error...');
  end;
end;

procedure TReportsForm.ByAuthorTitle;
var
  rec, author, title, barcodes : WideString;
  book:TBookMark;
  j,p,len:integer;
  f : textfile;
  b : boolean;
  i : integer;
  cnt, n : integer;
begin
 cnt:=0;
 SaveDialog1.FileName := '';
 SaveDialog1.Filter := 'TXT files (*.txt)|*.txt';
 SaveDialog1.DefaultExt := 'txt';
 SaveDialog1.FilterIndex := 1; { start the dialog showing all files }
 if SaveDialog1.Execute then
 begin
  l := TTntStringList.Create;
  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Visible := True;

  with data.basket do
  begin
   DisableControls;
   book:=GetBookMark;
   First;
   Screen.Cursor:=crHourGlass;

   n := RecordCount;

  if ReportsForm.IfList then
    for i := 0 to Length(FastRecordCreator.List)-1 do
      begin
        if not Locate('recno', FastRecordCreator.List[i], [])then continue;
        ExportRecord;
        cnt:=cnt+1;
        ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+IntToStr(FastRecordCreator.List[i]);
        ProgresBarForm.ProgressBar1.Position := Round(cnt*100/n);
        Application.ProcessMessages;
      end
  else
    while not Eof do
      begin
        ExportRecord;
        cnt:=cnt+1;
        ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+fieldbyname('recno').AsString;
        ProgresBarForm.ProgressBar1.Position := Round(cnt*100/n);
        Application.ProcessMessages;
        Next;
      end;

   GotoBookmark(book);
   FreeBookmark(book);
   EnableControls;
   ProgresBarForm.ProgressBar1.Visible := False;
   ProgresBarForm.Close;
  end;
//  l.CustomSort(mycmp);
  try
  Assignfile(f,Savedialog1.FileName);
  b := false;
  if l.Count>0 then
    begin
      Rewrite(f);
      b := true;
    end;
  l.Sort;
  for j:=0 to l.Count-1 do
  begin
   len:=length(l[j]);
   p := pos('#',reversestring(l[j]));
   p := len-p+1;
   rec := copy(l[j],p+1,len);
   l[j] := copy(l[j],1,p-1);
   p:=pos(#$0d+#$0a,l[j]);
   author:=copy(l[j],1,p-1);
   l[j]:=copy(l[j],p+2,len);
   p:=pos(#$0d+#$0a,l[j]);
   title:=copy(l[j],1,p-1);
   barcodes:=copy(l[j],p+2,len);
   writeln(f,'Recno    : ', WideStringToUTF8String(rec));
   writeln(f,'Author   : ', WideStringToUTF8String(author));
   writeln(f,'Title    : ', WideStringToUTF8String(title));
   writeln(f,'Barcodes : ', WideStringToUTF8String(barcodes));
   writeln(f);
  end;
  if b then Closefile(f);
  Screen.Cursor:=crDefault;
  l.Free;
  except
    ShowMessage('Error...');
  end;
 end;
end;

procedure TReportsForm.BitBtn3Click(Sender: TObject);
begin
 OpenDialog1.FileName := '';
 OpenDialog1.Filter := 'TXT files (*.txt)|*.txt|All Files (*.*)|*.*';
 OpenDialog1.FilterIndex := 0; { start the dialog showing all files }
 if opendialog1.Execute then Edit1.Text := OpenDialog1.FileName;

end;

procedure TReportsForm.ReportHeadings;
var
  rec,marcrec : WideString;
  hlp : WideString;
  book:TBookMark;
  cnt,j:integer;
  scnt : integer;
  f : textfile;
  fs : TextFile;
  l : TTntStringList;
  i : integer;
  b : boolean;
begin
  cnt:=0;
  scnt:=0;
 if FileExists(Edit1.Text) then
 begin
 try
  AssignFile(fs,OpenDialog1.FileName);
  Reset(fs);
  while(eof(fs)=false) do
  begin
   readln(fs,hlp);
   if (hlp[1] = '#') then
    continue;
   scnt:=scnt+1;
   taginfo[scnt]:=hlp;
  end;
  Closefile(fs);
 except
  ShowMessage('Error...');
 end;
 end
 else
  begin
    showmessage('Specify tag''s file');
    ModalResult := mrNone;
    exit;
  end;
  SaveDialog1.FileName := '';
  SaveDialog1.Filter := 'TXT files (*.txt)|*.txt';
  SaveDialog1.FilterIndex := 1; { start the dialog showing all files }
  if SaveDialog1.Execute then
  begin
   l := TTntStringList.Create;

  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;
  ProgresBarForm.ProgressBar1.Max := data.basket.RecordCount;
  try
   with Data.basket do
   begin
    DisableControls;
    book:=GetBookMark;
    first;
    Screen.Cursor:=crHourGlass;
    if IfList then
      for i := 0 to Length(FastRecordCreator.List)-1 do
        begin
          if Locate('recno', FastRecordCreator.List[i], [])then
          begin
           rec :=fieldbyname('recno').asstring;
           marcrec:=makemrcfrombasket;
           extract_headings(l,marcrec,'',taginfo,scnt);
           cnt:=cnt+1;
    //       FastRecordCreator.statusbar1.SimpleText:=inttostr(cnt);
           ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+IntToStr(FastRecordCreator.List[i]);
           ProgresBarForm.ProgressBar1.Position := cnt;
           Application.ProcessMessages;
          end;
        end
      else
        while not eof do
        begin
         rec :=fieldbyname('recno').asstring;
         marcrec:=makemrcfrombasket;
         extract_headings(l,marcrec,'',taginfo,scnt);
         cnt:=cnt+1;
//         FastRecordCreator.statusbar1.SimpleText:=inttostr(cnt);
         ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+rec;
         ProgresBarForm.ProgressBar1.Position := cnt;
         Application.ProcessMessages;
         next;
        end;
    GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
    ProgresBarForm.ProgressBar1.Visible := false;
    ProgresBarForm.Close;
   end;
  except
    ShowMessage('Error...');
  end;
   FastRecordCreator.statusbar1.SimpleText:='Sorting';
//   l.CustomSort(mycmp2);
   l.Sort;
   FastRecordCreator.statusbar1.SimpleText:='Writing to file...';
   hlp:='';
  try
  Assignfile(f,Savedialog1.FileName);
  b := false;
  if l.Count>0 then
    begin
      Rewrite(f);
      b := true;
    end;

    for j:=0 to l.Count-1 do
     begin
      if (hlp<>l[j]) then
       writeln(f,l[j]);
       hlp:=l[j];
     end;

   if b then
    begin
      Closefile(f);
      ModalResult := mrOk;
    end;
   except
    ShowMessage('Error...');
   end;
   Screen.Cursor:=crDefault;
   l.Free;
   FastRecordCreator.statusbar1.SimpleText:='Finished!';
  end;
 fastrecordcreator.SetFocus;
end;

procedure TReportsForm.BitBtn1Click(Sender: TObject);
var
  fil, holdfil : boolean;
  fill, holdfill : string;
begin

  fil := Data.basket.Filtered;
  fill := data.basket.Filter;
  data.basket.Filtered := false;
  holdfil := Data.hold.Filtered;
  holdfill := data.hold.Filter;
  data.hold.Filtered := false;

  IfList := CheckBox1.Checked;

  if RadioButton1.Checked then
    begin
      ReportsForm.Enabled := false;
      try
        ByAuthorTitle;
      finally
        ReportsForm.Enabled := true;
      end;
      ModalResult := mrOk;
    end;

  if RadioButton2.Checked then
    begin
      ReportsForm.Enabled := false;
      ClassCodeForm.Label1.Caption := 'Enter collection Code, it will be matched as a substring';
      ClassCodeForm.Label2.Caption := 'in the collection data fields.';
      ClassCodeForm.Caption := 'Enter Collection Code';
      ClassCodeForm.myfield := 'collection';
      try
        ClassCodeForm.ShowModal;
      finally
        ReportsForm.Enabled := true;
      end;
    end;

  if RadioButton3.Checked then
    begin
      ReportsForm.Enabled := false;
      ClassCodeForm.Label1.Caption := 'Enter classification Code, it will be matched as a substring';
      ClassCodeForm.Label2.Caption := 'in the classification data fields.';
      ClassCodeForm.Caption := 'Enter Classification Code';
      ClassCodeForm.myfield := 'cln';
      try
        ClassCodeForm.ShowModal;
      finally
        ReportsForm.Enabled := true;
      end;
    end;

  if RadioButton4.Checked then
    begin
      ReportsForm.Enabled := false;
      try
        ReportHeadings;
      finally
        ReportsForm.Enabled := true;
      end;
    end;

  if RadioButton5.Checked then
    begin
      ReportsForm.Enabled := false;
      try
        ReportHeadingsIndex;
      finally
        ReportsForm.Enabled := true;
      end;
    end;

  if RadioButton6.Checked then
    begin
      if Data.basket.RecordCount = 0 then
        begin
          ShowMessage('Database is empty');
          ModalResult := mrCancel;
          Exit;
        end;
      ReportsForm.Enabled := false;
      try
        PrettyMARCForm.ShowModal;
        if PrettyMARCForm.ModalResult = mrCancel then ModalResult := mrNone;
      finally
        ReportsForm.Enabled := true;
      end;
    end;

  Data.basket.Filter := fill;
  data.basket.Filtered := fil;
  Data.hold.Filter := holdfill;
  data.hold.Filtered := holdfil;
  if ClassCodeForm.ModalResult = mrOk then ModalResult := mrok

end;

procedure TReportsForm.CheckBox1Click(Sender: TObject);
begin
  if FastRecordCreator.FNameList = '' then
    begin
      CheckBox1.OnClick := nil;
      WideShowMessage('No active list.');
      CheckBox1.Checked := false;
      CheckBox1.OnClick := CheckBox1Click;
    end;
end;

procedure TReportsForm.ReportHeadingsIndex;
var hlp,rec,marcrec : WideString;
    book:TBookMark;
    len,p,cnt,scnt,j:integer; //
    f, fs : textfile;
    l : TTntStringList;
    taginfo : array [1..128] of WideString;
    i : integer;
    b : boolean;
begin
 if FileExists(Edit2.Text) then
 begin
  scnt:=0;
  try
  AssignFile(fs,OpenDialog1.FileName);
  Reset(fs);
  while(eof(fs)=false) do
  begin
   readln(fs,hlp);
   if (hlp[1] = '#') then
    continue;
   scnt:=scnt+1;
   taginfo[scnt]:=hlp;
  end;
  Closefile(fs);
 except
  ShowMessage('Error...');
 end;
 end
 else
 begin
  showmessage('Specify tag''s file');
  ModalResult := mrNone;
  exit;
 end;

  cnt:=0;

  SaveDialog1.FileName := '';
  SaveDialog1.Filter := 'TXT files (*.txt)|*.txt';
  SaveDialog1.FilterIndex := 1; { start the dialog showing all files }
  if SaveDialog1.Execute then
  begin
   l := TTntStringList.Create;

  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;
  ProgresBarForm.ProgressBar1.Max := data.basket.RecordCount;

   with data.basket do
   begin
    DisableControls;
    book:=GetBookMark;
    first;
    Screen.Cursor:=crHourGlass;

  if IfList then
    for i := 0 to Length(FastRecordCreator.List)-1 do
      begin
       try
        if Locate('recno', FastRecordCreator.List[i], [])then
        begin
         rec :=fieldbyname('recno').asstring;
         marcrec:=makemrcfrombasket;
         extract_headings(l,marcrec,rec,taginfo,scnt);
         cnt:=cnt+1;
//         FastRecordCreator.statusbar1.SimpleText:=inttostr(cnt);
         ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+IntToStr(FastRecordCreator.List[i]);
         ProgresBarForm.ProgressBar1.Position := cnt;
         Application.ProcessMessages;
        end;
       except
        ShowMessage('Error...');
       end;
      end
  else
    while not eof do
      begin
       try
        rec :=fieldbyname('recno').asstring;
        marcrec:=makemrcfrombasket;
        extract_headings(l,marcrec,rec,taginfo,scnt);
        cnt:=cnt+1;
//        FastRecordCreator.statusbar1.SimpleText:=inttostr(cnt);
        ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+rec;
        ProgresBarForm.ProgressBar1.Position := cnt;
        Application.ProcessMessages;
        next;
       except
        ShowMessage('Error...');
       end;
      end;
    GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
    ProgresBarForm.ProgressBar1.Visible := false;
    ProgresBarForm.Close;
   end;
   FastRecordCreator.statusbar1.SimpleText:='Sorting...';
//   l.CustomSort(mycmp2);
   l.Sort;
   FastRecordCreator.statusbar1.SimpleText:='Writing to file...';
   hlp:='';

  try
  Assignfile(f,Savedialog1.FileName);
  b := false;
  if l.Count>0 then
    begin
      Rewrite(f);
      b := true;
    end;

   for j:=0 to l.Count-1 do
   begin
    len:=length(l[j]);
    p := pos('#',reversestring(l[j]));
    p := len-p+1;
    rec := copy(l[j],p+1,len);
    l[j] := copy(l[j],1,p-1);
    if (hlp<>l[j]) then
    begin
     writeln(f);
     writeln(f,'---');
     writeln(f,l[j]);
     write(f,rec);
    end
    else
     write(f,' ',rec);
    hlp:=l[j];
   end;
   if b then
    begin
      Closefile(f);
      ModalResult := mrOk;
    end;
  except
    ShowMessage('Error...');
  end;
   Screen.Cursor:=crDefault;
   l.Free;
   FastRecordCreator.statusbar1.SimpleText:='Finished!';
  end;
 fastrecordcreator.SetFocus;
end;


procedure TReportsForm.BitBtn4Click(Sender: TObject);
begin
 OpenDialog1.FileName := '';
 OpenDialog1.Filter := 'TXT files (*.txt)|*.txt|All Files (*.*)|*.*';
 OpenDialog1.FilterIndex := 0; { start the dialog showing all files }
 if opendialog1.Execute then Edit2.Text := OpenDialog1.FileName;
end;

procedure TReportsForm.FormActivate(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';
end;

procedure TReportsForm.Edit1Change(Sender: TObject);
begin
  RadioButton4.Checked := true;
end;

procedure TReportsForm.Edit2Change(Sender: TObject);
begin
  RadioButton5.Checked := true;
end;

procedure TReportsForm.Edit3Change(Sender: TObject);
begin
  RadioButton6.Checked := true;
end;

procedure TReportsForm.RadioButton4Click(Sender: TObject);
begin
  Edit2.OnChange := nil;
  Edit2.Text := '';
  Edit2.OnChange := Edit2Change;
end;

procedure TReportsForm.RadioButton5Click(Sender: TObject);
begin
  Edit1.OnChange := nil;
  Edit1.Text := '';
  Edit1.OnChange := Edit1Change;
end;

procedure TReportsForm.RadioButton6Click(Sender: TObject);
begin
  Edit1.OnChange := nil;
  Edit2.OnChange := nil;
  Edit1.Text := '';
  Edit2.Text := '';
  Edit1.OnChange := Edit1Change;
  Edit2.OnChange := Edit2Change;
end;

procedure TReportsForm.RadioButton1Click(Sender: TObject);
begin
  Edit1.OnChange := nil;
  Edit2.OnChange := nil;
  Edit1.Text := '';
  Edit2.Text := '';
  Edit1.OnChange := Edit1Change;
  Edit2.OnChange := Edit2Change;
end;

procedure TReportsForm.RadioButton2Click(Sender: TObject);
begin
  Edit1.OnChange := nil;
  Edit2.OnChange := nil;
  Edit1.Text := '';
  Edit2.Text := '';
  Edit1.OnChange := Edit1Change;
  Edit2.OnChange := Edit2Change;
end;

procedure TReportsForm.RadioButton3Click(Sender: TObject);
begin
  Edit1.OnChange := nil;
  Edit2.OnChange := nil;
  Edit1.Text := '';
  Edit2.Text := '';
  Edit1.OnChange := Edit1Change;
  Edit2.OnChange := Edit2Change;
end;

end.
