unit FinalExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, Dialogs, StdCtrls, Buttons, common, mycharconversion,
  TntStdCtrls, TntGrids, DateUtils, TntDialogs, TntClasses,

  Consts, ExtCtrls, ComCtrls,
  GlobalProcedures,
  TntComCtrls, TntExtCtrls, TntForms, cUnicodeCodecs;

type
  TFinalExportForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    F: TextFile;
    snf : integer;
  public
    { Public declarations }
procedure FinalExportRecordsRange(FileName: string; FromRec, ToRec: integer);
function  FinalExportRecords : boolean;
  end;

var
  FinalExportForm: TFinalExportForm;

implementation

uses DataUnit, MainUnit, ProgresBarUnit;

{$R *.dfm}

procedure TFinalExportForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FinalExportForm.Enabled := False;
  try
    if ModalResult = mrOk then
     if not FinalExportRecords Then Action := caNone;
  finally
    FinalExportForm.Enabled := True;
  end;
end;

function TFinalExportForm.FinalExportRecords : boolean;
var
  FromRec, ToRec :integer;
  Book: TBookMark;
begin

  snf := strtointdef(edit1.Text,-1);
  if snf < 0 then
  begin
      ShowMessage('Starting number should be integer greater than zero.');
      result := false;
  end
  else
  begin
  if not data.basket.IsEmpty then
  begin
    FastRecordCreator.SaveDialog1.FileName := '';
    // FIXME
    if false Then FastRecordCreator.SaveDialog1.Filter := 'XML files (*.xml)|*.xml'
                               Else FastRecordCreator.SaveDialog1.Filter := 'MRC files (*.mrc)|*.mrc';
    FastRecordCreator.SaveDialog1.FilterIndex := 1; { start the dialog showing all files }

    if FastRecordCreator.SaveDialog1.Execute then
    begin
      Screen.Cursor:=crHourGlass;
      data.basket.DisableControls;
      Book := data.basket.GetBookmark;
      try
        data.basket.First;

        if true Then    //Export all records
        begin
            data.Query1.Close;
            data.Query1.SQL.Clear;
            data.Query1.SQL.Add('SELECT min(recno) FROM basket');
            data.Query1.Execute;

            FromRec := data.Query1.Fields[0].AsInteger;

            data.Query1.Close;
            data.Query1.SQL.Clear;
            data.Query1.SQL.Add('SELECT max(recno) FROM basket');
            data.Query1.Execute;

            ToRec := data.Query1.Fields[0].AsInteger;

            FinalExportRecordsRange(FastRecordCreator.SaveDialog1.FileName, FromRec, ToRec);
        end;
      finally
        Screen.Cursor := crDefault;
        data.basket.EnableControls;
        data.basket.GotoBookmark(Book);
        Result := True;
      end;
    end
    Else Result := False;
  end
  Else
    begin
      ShowMessage('There are no records to export.');
      Result := True;
    end;
 end;
end;

procedure TFinalExportForm.FinalExportRecordsRange(FileName: string; FromRec, ToRec: integer);
var
  xx,holdon,k,hcnt,j, icnt, recno, cr, exported , rc: integer;
  marcrec : UTF8String;
  temp, junk : Widestring;
  sq ,  hfilename, ifilename : string;
  Ho
  //, Io
  : TextFile;
begin
  cr:=snf;
  exported := 0;
  sq := data.basket.SQL.Text;
  data.basket.Close;
  data.basket.SQL.Text := 'SELECT * FROM basket ORDER BY recno';
  data.basket.Open;
  data.basket.Filter := '(recno>='+QuotedStr(inttostr(FromRec))+')and(recno<='+QuotedStr(inttostr(ToRec))+')';
  Data.basket.Filtered := true;

  if Data.basket.RecordCount < 1 then
    begin
      ShowMessage('No records matched your criteria');
      data.basket.Filtered := false;
      ModalResult := mrNone;
      Exit;
    end;

  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := data.basket.RecordCount;
  ProgresBarForm.ProgressBar1.Visible := True;

//  showmessage(filename);
  hfilename := changefileext(filename,'_holdings.txt');
  //showmessage(hfilename);
  ifilename := changefileext(filename,'_items.txt');

  //Position the cursor to the start record
{  while (data.basket.FieldByName('recno').AsInteger < FromRec)and(not data.basket.Eof)
    do data.basket.Next;}
  data.basket.First;
  try
//    while (data.basket.FieldByName('recno').AsInteger <= ToRec)and(not data.basket.Eof) do
   while not data.basket.Eof do
    begin
      if exported = 0 Then
        begin
          AssignFile(F, FileName); { File selected in dialog }
          if checkbox1.checked=false then Rewrite(F)
          else Append(f);
          AssignFile(ho, hFileName); { File selected in dialog }
          if checkbox1.checked=false then Rewrite(ho)
          else Append(ho);
//          AssignFile(io, iFileName); { File selected in dialog }
//          if checkbox1.checked=false then Rewrite(io)
//          else Append(io);

//          if ((ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2)) Then
//          begin
//           writeln(f,'<?xml version="1.0" encoding="UTF-8"?>');
//           write(F, '<collection');
//            if (ComboBox1.ItemIndex = 1) then
//             write(f,' xmlns="http://www.loc.gov/MARC21/slim"');
//           writeln(F,'>');
//          end;
        end;
      rc:=0;
      exported := exported + 1;
      recno := data.basket.FieldByName('recno').AsInteger;
      // FIXME  : do not add holdings in marc record.
      if false Then rc := MakeMRCFromBasket(marcrec)
               Else marcrec := WideStringToString(data.Basket.GetBlob('text').AsWideString, Greek_codepage);

      if rc <> 0 then
       showmessage('Record '+inttostr(recno)+' exceeds MARC length limits');


      ReplaceOrgCode(marcrec);
      refresh084(recno, marcrec);
      zap_tag(marcrec,'936');
      if snf = 0 then cr := recno;

      ReplaceRecno(recno, marcrec);

      ADDDBInfo(marcrec,recno);
      if length(marcrec) >= 10 then marcrec[10] := 'a';
      if length(marcrec) >= 11 then marcrec[11] := '2';
      if length(marcrec) >= 12 then marcrec[12] := '2';

      //FIXME for XML
      //if ComboBox1.ItemIndex = 1 Then marcrec := marc2marcxml(marcrec,true);
      //if ComboBox1.ItemIndex = 2 Then marcrec := ExportXMLInternal(true);

      write(F,marcrec);

      Data.HoldQuery.Close;
      Data.HoldQuery.ParamByName('recno').AsInteger := recno;
      Data.HoldQuery.Open;
      hcnt := Data.HoldQuery.RecordCount;
      Data.HoldQuery.First;

      for xx:= 1 to hcnt do
      begin
        holdon := data.HoldQuery.FieldByName('holdon').AsInteger;

        Data.ItemsQuery.Close;
        Data.ItemsQuery.ParamByName('holdon').AsInteger := holdon;
        Data.ItemsQuery.Open;
        icnt := data.ItemsQuery.RecordCount;
        Data.ItemsQuery.First;
        if icnt > 0 then
        begin
        for k := 1 to icnt do
        begin
        write(ho,cr,#9,fastrecordcreator.currentdatabase,#9,recno,#9,holdon);

        if (not Data.HoldQuery.FieldByName('branch').IsNull) and
           (trim(Data.HoldQuery.FieldByName('branch').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('branch').Value);
        end else write(ho,#9);
        if (not Data.HoldQuery.FieldByName('collection').IsNull) and
           (trim(Data.HoldQuery.FieldByName('collection').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('collection').Value);
        end else write(ho,#9);

        if (not Data.HoldQuery.FieldByName('cln').IsNull) and
           (trim(Data.HoldQuery.FieldByName('cln').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('cln').Value);
        end else write(ho,#9);

        if (not Data.HoldQuery.FieldByName('cln_ip').IsNull) and
           (trim(Data.HoldQuery.FieldByName('cln_ip').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('cln_ip').Value);
        end else write(ho,#9);

        if (not Data.HoldQuery.FieldByName('f866').IsNull) and
           (trim(Data.HoldQuery.FieldByName('f866').Value)<>'')  then
        begin
          junk := Data.HoldQuery.GetBlob('f866').AsWideString;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);
        if (not Data.HoldQuery.FieldByName('f867').IsNull) and
           (trim(Data.HoldQuery.FieldByName('f867').Value)<>'')  then
        begin
          junk := Data.HoldQuery.GetBlob('f867').AsWideString;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);
        if (not Data.HoldQuery.FieldByName('f868').IsNull) and
           (trim(Data.HoldQuery.FieldByName('f868').Value)<>'')  then
        begin
          junk := Data.HoldQuery.GetBlob('f868').AsWideString;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);

        if (not Data.ItemsQuery.FieldByName('barcode').IsNull) and
           (trim(Data.ItemsQuery.FieldByName('barcode').Value)<>'')  then
        begin
          junk := Data.ItemsQuery.fieldbyname('barcode').Value;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);

        if (not Data.ItemsQuery.FieldByName('copy').IsNull) and
           (trim(Data.ItemsQuery.FieldByName('copy').Value)<>'')  then
        begin
          junk := Data.ItemsQuery.fieldbyname('copy').Value;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);

        if (not Data.ItemsQuery.FieldByName('loan_category').IsNull) and
           (trim(Data.ItemsQuery.FieldByName('loan_category').Value)<>'')  then
        begin
          junk := Data.ItemsQuery.fieldbyname('loan_category').Value;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);

        if (not Data.ItemsQuery.FieldByName('process_status').IsNull) and
           (trim(Data.ItemsQuery.FieldByName('process_status').Value)<>'')  then
        begin
          junk := Data.ItemsQuery.fieldbyname('process_status').Value;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);

        if (not Data.ItemsQuery.FieldByName('note_opac').IsNull) and
           (trim(Data.ItemsQuery.FieldByName('note_opac').Value)<>'')  then
        begin
          junk := Data.ItemsQuery.fieldbyname('note_opac').Value;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);

        writeln(ho);
        Data.ItemsQuery.Next;
      end;
      end else
      begin
        write(ho,cr,#9,fastrecordcreator.currentdatabase,#9,recno,#9,holdon);

        if (not Data.HoldQuery.FieldByName('branch').IsNull) and
           (trim(Data.HoldQuery.FieldByName('branch').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('branch').Value);
        end else write(ho,#9);
        if (not Data.HoldQuery.FieldByName('collection').IsNull) and
           (trim(Data.HoldQuery.FieldByName('collection').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('collection').Value);
        end else write(ho,#9);
        if (not Data.HoldQuery.FieldByName('cln').IsNull) and
           (trim(Data.HoldQuery.FieldByName('cln').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('cln').Value);
        end else write(ho,#9);

        if (not Data.HoldQuery.FieldByName('cln_ip').IsNull) and
           (trim(Data.HoldQuery.FieldByName('cln_ip').Value)<>'') then
        begin
          write(ho,#9,Data.HoldQuery.fieldbyname('cln_ip').Value);
        end else write(ho,#9);

        if (not Data.HoldQuery.FieldByName('f866').IsNull) and
           (trim(Data.HoldQuery.FieldByName('f866').Value)<>'')  then
        begin
          junk := Data.HoldQuery.GetBlob('f866').AsWideString;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);
        if (not Data.HoldQuery.FieldByName('f867').IsNull) and
           (trim(Data.HoldQuery.FieldByName('f867').Value)<>'')  then
        begin
          junk := Data.HoldQuery.GetBlob('f867').AsWideString;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);
        if (not Data.HoldQuery.FieldByName('f868').IsNull) and
           (trim(Data.HoldQuery.FieldByName('f868').Value)<>'')  then
        begin
          junk := Data.HoldQuery.GetBlob('f868').AsWideString;
          temp:='';
          for j:=1 to length(junk) do
            if (ord(junk[j])>31) then temp:=temp+junk[j];
          write(ho,#9,temp);
        end else write(ho,#9);
        //  FIXME : missing enum and chrono fields...
        writeln(ho);
      end;

        Data.HoldQuery.Next;
      end;

      cr :=cr +1;
      if ToRec>recno Then
      begin
            ProgresBarForm.ProgressBar1.Position := exported;
            ProgresBarForm.Label2.Caption := 'Exporting Recno:  '+data.basket.fieldbyname('recno').AsString;
      end
      Else
      begin
            ProgresBarForm.ProgressBar1.Position := Data.basket.RecordCount;
            ProgresBarForm.Label2.Caption := 'Exporting Recno:  '+data.basket.fieldbyname('recno').AsString;
      end;
      Application.ProcessMessages;

      data.basket.Next;
    end;

    data.basket.first;

    if (exported > 0) then
      begin

        if exported = 1 then
          ShowMessage(IntToStr(exported)+' record has been exported.')
        else
          ShowMessage(IntToStr(exported)+' records have been exported.');
      end
      else
        ShowMessage('No records matched your criteria');
  finally
    ProgresBarForm.ProgressBar1.Position := ProgresBarForm.ProgressBar1.Max;
    ProgresBarForm.ProgressBar1.Visible := False;
    ProgresBarForm.Close;
    if exported > 0 Then
    begin
      //if ((ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2)) Then
      //  writeln(F, '</collection>');
      CloseFile(F);
      CloseFile(ho);
      // CloseFile(io);
    end;
    Data.basket.Filtered := false;
    data.basket.Close;
    data.basket.SQL.Text := sq;
    data.basket.Open;

  end;
end;

end.
