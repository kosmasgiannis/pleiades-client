unit ReplaceMARCrecs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TReplaceMARCrecords = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure  Replace_a_record(rec : UTF8String; var recno, cnt : integer);
    { Public declarations }
  end;

var
  ReplaceMARCrecords: TReplaceMARCrecords;

implementation

uses MainUnit, DataUnit, ProgresBarUnit, TntStdCtrls, tntclasses, common, utility,cUnicodeCodecs, GlobalProcedures, DB;

{$R *.dfm}

procedure TReplaceMARCrecords.Replace_a_record(rec : UTF8String; var recno, cnt : integer);
var
  reclen : integer;
  junk : WideString;
  temp : UTF8String;
begin
  reclen := strtointdef(copy(rec,1,5),-1);
  recno:=-1;
  if reclen <> -1 then
  begin
    junk := copy(rec,13,5);

    recno := GetRecno(rec);
    OpenSecureBasketTable(recno);
    if data.SecureBasket.RecordCount > 0 Then
    begin
      //Delete holdings tags first
      temp := RemoveHoldings(rec);
      // Get holdings clns info from database
      Refresh084(recno, temp);
//FIXME :      Refresh856(recno,temp);
      if length(temp) >= 10 then temp[10] := 'a';
      if length(temp) >= 11 then temp[11] := '2';
      if length(temp) >= 12 then temp[12] := '2';

      EditTable(data.SecureBasket);
      data.SecureBasket.GetBlob('text').IsUnicode := True;
      data.SecureBasket.GetBlob('text').AsWideString := StringToWideString(temp, Greek_codepage);
      TBlobField(data.SecureBasket.FieldByName('text')).Modified := True;

      PostTable(Data.SecureBasket);

      // RecordUpdated(myzebrahost, 'update', recno, MakeMRCFromBasket, false);
      cnt := cnt + 1;
    end;
  end;
end;


procedure TReplaceMARCrecords.Button1Click(Sender: TObject);
var
  F : Textfile;
  rec : UTF8String;
  ovr, recno : integer;
  ch : char;
  flag : boolean;
  FSize, BytesRead: integer;
begin
 FastRecordCreator.OpenDialog1.FileName := '';
 FastRecordCreator.OpenDialog1.Filter := 'MRC files (*.mrc)|*.mrc|All Files (*.*)|*.*';
 FastRecordCreator.OpenDialog1.FilterIndex := 1; { start the dialog showing all files }

 if FastRecordCreator.OpenDialog1.Execute = true then
 begin
  Screen.Cursor:=crHourGlass;
  data.basket.DisableControls;
  data.hold.DisableControls;
  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;
  ovr := 0;
  try
    AssignFile(F, FastRecordCreator.OpenDialog1.FileName);
    Reset(F);
    BytesRead := 0;
    FSize := FileSize(f);
    flag := false;
    while not eof(f) do
    begin
     read(f,ch);
     BytesRead := BytesRead + 1;
     if ((ch=#13) or (ch=#10)) then ch:=' ';
     if (flag = false) then
     begin
      if ((ord(ch) >= ord('0')) and (ord(ch)<=ord('9'))) then
      begin
       rec:=ch;
       flag:=true;
      end;
     end
     else
     begin
      rec:=rec+ch;
      if (ch=#29) then
      begin
       flag:=false;

       Replace_a_record(rec, recno, ovr);

       ProgresBarForm.Label2.Caption := 'Importing RecNo:  '+IntToStr(recno);
       ProgresBarForm.ProgressBar1.Position := Round(100*BytesRead/(128*FSize));
       Application.ProcessMessages;

      end;
     end;
    end;
   finally
     CloseFile(F);
     Screen.Cursor := crDefault;
     data.basket.EnableControls;
     data.hold.EnableControls;
     FastRecordCreator.SetFocus;
     memo1.Lines.Clear;
     memo1.Lines.Add(IntToStr(ovr)+' records replaced from file:  '+FastRecordCreator.OpenDialog1.FileName+'.');
     memo1.Lines.Add(' ');
     memo1.Lines.Add('Remember to update Zebra indexes after this operation.');
     Button2.Caption := 'Exit';
     ProgresBarForm.ProgressBar1.Visible := False;
     ProgresBarForm.Close;
   end;
  end;
end;

procedure TReplaceMARCrecords.Button2Click(Sender: TObject);
begin
 ReplaceMARCrecords.Close;
end;

procedure TReplaceMARCrecords.FormShow(Sender: TObject);
begin
  button2.Caption:='Cancel';
  memo1.Lines.Clear;
  memo1.lines.Add('Click Go to select input file with MARC records to replace the records with same record numbers in Database.');
  memo1.Lines.Add(' ');
  memo1.Lines.Add('Remember to update Zebra indexes after this operation.');
end;

end.
