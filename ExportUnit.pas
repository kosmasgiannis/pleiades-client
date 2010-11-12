unit ExportUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MyAccess, Dialogs, StdCtrls, Buttons, DB, TntDialogs, TntStdCtrls, TntButtons, TntForms;

type
  TExportForm = class(TTntForm)
    GroupBox1: TTntGroupBox;
    RadioButton1: TTntRadioButton;
    RadioButton2: TTntRadioButton;
    Edit1: TTntEdit;
    Edit2: TTntEdit;
    Label2: TTntLabel;
    RadioButton3: TTntRadioButton;
    Edit3: TTntEdit;
    BitBtn1: TTntBitBtn;
    Label3: TTntLabel;
    ComboBox1: TTntComboBox;
    CheckBox1: TTntCheckBox;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    F, FLst: TextFile;

    function CheckValidity : boolean;
    function ExportRecords : boolean;
    procedure ExportRecordsRange(FileName: string; FromRec, ToRec: integer);
    procedure ExportRecordsFromList(FileName, ListFileName: string);
  public
    { Public declarations }
  end;

var
  ExportForm: TExportForm;

implementation

uses MainUnit, DataUnit, common, ProgresBarUnit, GlobalProcedures;

{$R *.dfm}

procedure TExportForm.Edit1Change(Sender: TObject);
begin
  RadioButton2.Checked := True;
end;

procedure TExportForm.Edit2Change(Sender: TObject);
begin
  RadioButton2.Checked := True;
end;

procedure TExportForm.Edit3Change(Sender: TObject);
begin
  RadioButton3.Checked := True;
end;

procedure TExportForm.BitBtn1Click(Sender: TObject);
begin
  FastRecordCreator.OpenDialog1.FileName := '';
  FastRecordCreator.OpenDialog1.Filter := 'LST files (*.lst)|*.lst';
  FastRecordCreator.OpenDialog1.FilterIndex := 1; { start the dialog showing all files }
  if FastRecordCreator.OpenDialog1.Execute then
      Edit3.Text := FastRecordCreator.OpenDialog1.FileName;
end;

procedure TExportForm.RadioButton2Click(Sender: TObject);
begin
  Edit3.OnChange := nil;
  Edit3.Text := '';
  Edit3.OnChange := Edit3Change;
end;

procedure TExportForm.RadioButton3Click(Sender: TObject);
begin
  Edit1.OnChange := nil;
  Edit2.OnChange := nil;

  Edit1.Text := '';
  Edit2.Text := '';

  Edit1.OnChange := Edit1Change;
  Edit2.OnChange := Edit2Change;
end;

procedure TExportForm.RadioButton1Click(Sender: TObject);
begin
  Edit1.OnChange := nil;
  Edit2.OnChange := nil;
  Edit3.OnChange := nil;

  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';

  Edit1.OnChange := Edit1Change;
  Edit2.OnChange := Edit2Change;
  Edit3.OnChange := Edit3Change;
end;

procedure TExportForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not ((key in ['0'..'9'])or(key=chr(8))) then key := #0;
end;

function TExportForm.CheckValidity: boolean;
var
  s: string;
begin
  s := '';

  if RadioButton2.Checked Then
    if StrToIntDef(Edit1.Text, 0) > StrToIntDef(Edit2.Text, -1) Then
      s := 'Specify a valid range';

  if RadioButton3.Checked Then
    if not FileExists(Edit3.Text) Then
      s := 'List file does not exist';

  if s <> '' Then WideShowMessage(s);

  Result := s = '';
end;

procedure TExportForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ExportForm.Enabled := False;

  try
    case ModalResult of
      mrOk: if CheckValidity Then
               begin
                 if not ExportRecords Then Action := caNone;
               end
               Else Action := caNone;
    end;
  finally
    ExportForm.Enabled := True;
  end;

end;

function TExportForm.ExportRecords : boolean;
var
  FromRec, ToRec :integer;
  tab : Tmyquery;
begin

  if FastRecordCreator.bib_auth_status = 'bib' then
    tab:=data.basket
  else
    tab:= data.auth;

    FastRecordCreator.SaveDialog1.FileName := '';
    if ComboBox1.ItemIndex <> 0 Then
     FastRecordCreator.SaveDialog1.Filter := 'XML files (*.xml)|*.xml'
    Else
     FastRecordCreator.SaveDialog1.Filter := 'MRC files (*.mrc)|*.mrc';
    FastRecordCreator.SaveDialog1.FilterIndex := 1; { start the dialog showing all files }

    if FastRecordCreator.SaveDialog1.Execute then
    begin
      Screen.Cursor:=crHourGlass;
      tab.DisableControls;
      try
        FromRec := StrToIntDef(Edit1.Text, 0);
        ToRec := StrToIntDef(Edit2.Text, 0);

        if RadioButton1.Checked Then    //Export all records
          begin

            data.Query1.Close;
            data.Query1.SQL.Clear;
            data.Query1.SQL.Add('SELECT min(recno) FROM '+FastRecordCreator.base_table);
            data.Query1.Execute;

            FromRec := data.Query1.Fields[0].AsInteger;

            data.Query1.Close;
            data.Query1.SQL.Clear;
            data.Query1.SQL.Add('SELECT max(recno) FROM '+FastRecordCreator.base_table);
            data.Query1.Execute;

            ToRec := data.Query1.Fields[0].AsInteger;

            ExportRecordsRange(FastRecordCreator.SaveDialog1.FileName, FromRec, ToRec);
          end
          Else
          if RadioButton2.Checked Then  //Export records from a range
            ExportRecordsRange(FastRecordCreator.SaveDialog1.FileName, FromRec, ToRec)
            Else
            if RadioButton3.Checked Then //Export records form a list
               ExportRecordsFromList(FastRecordCreator.SaveDialog1.FileName, Edit3.Text);

      finally
        Screen.Cursor := crDefault;
        tab.EnableControls;
      end;
    end;

    Result := True;
end;

procedure TExportForm.ExportRecordsRange(FileName: string; FromRec, ToRec: integer);
var
  exported , i, rc, expected_total: integer;
  marcrec : UTF8String;
  ExpRecnos : array of integer;
begin

  exported := 0;
  SetLength(ExpRecnos, 0);

  data.Query1.Close;
  data.Query1.SQL.Clear;
  data.Query1.SQL.Add('SELECT count(distinct recno) FROM '+FastRecordCreator.base_table+' where recno >='+inttostr(FromRec)+' AND recno <='+inttostr(toRec));
  data.Query1.Execute;

  expected_total := data.Query1.Fields[0].AsInteger;
  if expected_total < 1 then
  begin
      WideShowMessage('No records matched your criteria');
      ModalResult := mrNone;
      Exit;
  end;

  SetLength(ExpRecnos, expected_total);

  data.Query1.Close;
  data.Query1.SQL.Clear;
  data.Query1.SQL.Add('SELECT distinct recno FROM '+FastRecordCreator.base_table+' WHERE recno >='+inttostr(FromRec)+' AND recno <='+inttostr(toRec));
  data.Query1.Execute;

  data.Query1.First;
  i:=0;
  while not data.Query1.Eof do
  begin
    ExpRecnos[i] := data.Query1.Fields[0].AsInteger;
    i:=i+1;
    data.Query1.Next;
  end;

  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := expected_total;
  ProgresBarForm.ProgressBar1.Visible := True;

  //Position the cursor to the start record
  for i:=0 to expected_total-1 do
  begin
    if exported = 0 Then
    begin
      AssignFile(F, FileName); { File selected in dialog }
      Rewrite(F);
      if ((ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2)) Then
      begin
        writeln(f,'<?xml version="1.0" encoding="UTF-8"?>');
        write(F, '<collection');
        if (ComboBox1.ItemIndex = 1) then
          write(f,' xmlns="http://www.loc.gov/MARC21/slim"');
        writeln(F,'>');
      end;
    end;

    rc:=0;
    exported := exported + 1;
    if FastRecordCreator.bib_auth_status = 'bib' then
    begin
      if CheckBox1.Checked Then
        rc := MakeMRCFromSecureBasket(ExpRecnos[i],marcrec)
      Else
        marcrec := GetLastDataFromBasket(ExpRecnos[i]);
    end
    else
    begin
      marcrec := GetLastDataFromAuth(ExpRecnos[i]);
    end;

    if rc <> 0 then
      wideshowmessage('Record '+inttostr(ExpRecnos[i])+' exceeds MARC length limits');

    ReplaceOrgCode(marcrec);
    ReplaceRecno(ExpRecnos[i], marcrec);
    if length(marcrec) >= 10 then marcrec[10] := 'a';
    if length(marcrec) >= 11 then marcrec[11] := '2';
    if length(marcrec) >= 12 then marcrec[12] := '2';

    if ComboBox1.ItemIndex = 1 Then marcrec := marc2marcxml(marcrec,true);
    if ComboBox1.ItemIndex = 2 Then marcrec := ExportXMLInternal(true);

    write(F,marcrec);

    ProgresBarForm.ProgressBar1.Position := exported;
    ProgresBarForm.Label2.Caption := 'Exporting Recno:  '+inttostr(ExpRecnos[i]);
    Application.ProcessMessages;

  end;

  if (exported > 0) then
  begin
    if exported = 1 then
      WideShowMessage(IntToStr(exported)+' record has been exported.')
    else
      WideShowMessage(IntToStr(exported)+' records have been exported.');
  end
  else
    WideShowMessage('No records matched your criteria');

  ProgresBarForm.ProgressBar1.Position := ProgresBarForm.ProgressBar1.Max;
  ProgresBarForm.ProgressBar1.Visible := False;
  ProgresBarForm.Close;
  if exported > 0 Then
  begin
    if ((ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2)) Then
      writeln(F, '</collection>');
    CloseFile(F);
  end;
end;

procedure TExportForm.ExportRecordsFromList(FileName, ListFileName: string);
var
  i, n, recno, exported,rc : integer;
  marcrec : UTF8String;
  temp : string;
begin
  exported := 0; n := 0; i := 0;
  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Visible := True;

  Assignfile(FLst, ListFileName);
  Reset(FLst);

  while not Eof(FLst) do
  begin
    ReadLn(FLst, temp);
    n := n + 1;
  end;

  CloseFile(FLst);
  Reset(FLst);

  try

    while not Eof(FLst) do
    begin
      i := i + 1;

      ReadLn(FLst, temp);
      if pos(' ',temp) > 0 then temp := copy(temp, 1, pos(' ',temp)-1);
      recno := StrToIntDef(temp, -1);

      if (recno <> -1) Then
      begin
        rc:=0;
        if FastRecordCreator.bib_auth_status = 'bib' then
        begin
          if CheckBox1.Checked Then
            rc := MakeMRCFromSecureBasket(recno,marcrec)
          Else
            marcrec := GetLastDataFromBasket(recno);
        end
        else
            marcrec := GetLastDataFromAuth(recno);

        if marcrec <> '' then
        begin
          if rc <> 0 then
           wideshowmessage('Record '+inttostr(recno)+' exceeds MARC length limits');
          exported := exported + 1;

          if exported = 1 Then
          begin
            AssignFile(F, FileName); { File selected in dialog }
            Rewrite(F);
            if ((ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2)) Then
            begin
             writeln(f,'<?xml version="1.0" encoding="UTF-8"?>');
             write(F, '<collection');
              if (ComboBox1.ItemIndex = 1) then
               write(f,' xmlns="http://www.loc.gov/MARC21/slim"');
             writeln(F,'>');
            end;
          end;
          if FastRecordCreator.bib_auth_status = 'bib' then
          begin
            ReplaceOrgCode(marcrec);
            ReplaceRecno(recno, marcrec);
          end;
          if length(marcrec) >= 10 then marcrec[10] := 'a';
          if length(marcrec) >= 11 then marcrec[11] := '2';
          if length(marcrec) >= 12 then marcrec[12] := '2';
          if ComboBox1.ItemIndex = 1 Then marcrec := marc2marcxml(marcrec,true);
          if ComboBox1.ItemIndex = 2 Then marcrec := ExportXMLInternal(true);

          write(F, marcrec);
        end;
      end;

      ProgresBarForm.ProgressBar1.Position := Round(i*100/n);
      ProgresBarForm.Label2.Caption := 'Exporting Recno:  '+IntToStr(recno);

      Application.ProcessMessages;
    end;

        ProgresBarForm.ProgressBar1.Visible := False;
        ProgresBarForm.Close;

    if (exported > 0) then
      begin
        if exported = 1 then
          WideShowMessage(IntToStr(exported)+' record has been exported.')
        else
          WideShowMessage(IntToStr(exported)+' records have been exported.');
      end
      else
        WideShowMessage('No records matched your criteria');
  finally
    ProgresBarForm.ProgressBar1.Position := ProgresBarForm.ProgressBar1.Max;
    ProgresBarForm.ProgressBar1.Visible := false;
    ProgresBarForm.Close;
    if exported > 0 Then
    begin
      if ((ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2)) Then
        writeln(F, '</collection>');
      CloseFile(F);
    end;
    CloseFile(FLst);
  end;

end;

end.
