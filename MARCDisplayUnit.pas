unit MARCDisplayUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntButtons, TntStdCtrls, Grids, DBGrids,
  TntDBGrids, Mask, DBCtrls, TntDBCtrls, dbcgrids, ExtCtrls, MyDump, TntForms,
  TntDialogs, TntExtCtrls, ComCtrls, TntComCtrls, DADump;


type
  TMARCDisplayForm = class(TTntForm)
    TntComboBox1: TTntComboBox;
    TntComboBox2: TTntComboBox;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntBitBtn1: TTntBitBtn;
    Button4: TTntBitBtn;
    SaveDialog1: TTntSaveDialog;
    MyDump1: TMyDump;
    Panel14: TPanel;
    DBCtrlGrid1: TDBCtrlGrid;
    TntDBEdit1: TTntDBEdit;
    TntDBEdit2: TTntDBEdit;
    TntDBEdit3: TTntDBEdit;
    TntDBEdit4: TTntDBEdit;
    TntDBEdit5: TTntDBEdit;
    TntDBEdit6: TTntDBEdit;
    TntDBEdit7: TTntDBEdit;
    TntDBEdit9: TTntDBEdit;
    TntDBEdit10: TTntDBEdit;
    Panel12: TPanel;
    Panel11: TTntPanel;
    Panel10: TTntPanel;
    Panel9: TTntPanel;
    Panel8: TTntPanel;
    Panel7: TTntPanel;
    Panel6: TTntPanel;
    Panel5: TTntPanel;
    Panel4: TTntPanel;
    Panel3: TTntPanel;
    Panel2: TTntPanel;
    Panel1: TTntPanel;
    Panel13: TTntPanel;
    TntBitBtn2: TTntBitBtn;
    TntBitBtn3: TTntBitBtn;
    DBCheckBox2: TTntDBCheckBox;
    TntBitBtn4: TTntBitBtn;
    TntGroupBox1: TTntGroupBox;
    TntLabel3: TTntLabel;
    TntEdit1: TTntEdit;
    TntBitBtn5: TTntBitBtn;
    TntRichEdit1: TTntRichEdit;
    TntGroupBox2: TTntGroupBox;
    TntLabel4: TTntLabel;
    TntLabel5: TTntLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    TntDBComboBox1: TTntDBComboBox;
    TntDBComboBox2: TTntDBComboBox;
    TntGroupBox3: TTntGroupBox;
    TntLabel6: TTntLabel;
    TntLabel7: TTntLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    TntDBComboBox3: TTntDBComboBox;
    TntDBComboBox4: TTntDBComboBox;
    TntDBEdit8: TTntDBEdit;
    TntDBEdit11: TTntDBEdit;
    TntPanel1: TTntPanel;
    TntDBEdit12: TTntDBEdit;
    TntPanel2: TTntPanel;
    TntDBCheckBox1: TTntDBCheckBox;
    procedure Button4Click(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntDBEdit1Change(Sender: TObject);
    procedure TntDBEdit2Change(Sender: TObject);
    procedure TntDBEdit3Change(Sender: TObject);
    procedure TntComboBox1Change(Sender: TObject);
    procedure TntDBEdit4Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntBitBtn3Click(Sender: TObject);
    procedure ck(Sender: TObject);
    procedure TntBitBtn4Click(Sender: TObject);
    procedure TntBitBtn5Click(Sender: TObject);
    procedure TntEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private declarations }
    Procedure GetNameFromMarcdisplay;
  public
    { Public declarations }
  end;

var
  MARCDisplayForm: TMARCDisplayForm;

implementation

uses DataUnit, MyAccess, DB, NewGroupUnit, DBAccess, common, utility,
  GlobalProcedures;

{$R *.dfm}


Procedure TMARCDisplayForm.GetNameFromMarcdisplay;
begin

    // Write in Combobox's dropdown list the distinct values from  column Vocabulary.Name
  TntComboBox1.Items.Clear;
  with data.Query1 do
  begin
    Close;
    SQL.Text :='SELECT DISTINCT  Name FROM marcdisplay';
    Open;
    First;
    while Not Eof do
    begin
      TntComboBox1.Items.Add(FieldByName('Name').AsString);
      Next;
    end;
    Close;
  end;
  TntComboBox1.ItemIndex := 0;
  TntComboBox2.ItemIndex := 0;

end;

procedure TMARCDisplayForm.Button4Click(Sender: TObject);
begin
  PostTable(Data.marcdisplay);
  close;
end;

procedure TMARCDisplayForm.TntBitBtn1Click(Sender: TObject);
begin

 if SaveDialog1.Execute then
  MyDump1.BackupToFile(SaveDialog1.FileName);

end;

procedure TMARCDisplayForm.TntDBEdit1Change(Sender: TObject);
var tfe, tfe1, tfe2 : string;
    i : integer;
begin

  tfe :=  TntDBEdit1.Text;
  tfe1 :='';

  for i := 1 to length(tfe) do
    if tfe[i] in ['0','1','2','3','4','5','6','7','8','9','X','N','U','M'] then
       tfe1 := tfe1 + tfe[i];

   tfe2 :=  tfe1;

   if Length(tfe2) > 3 then
     Delete(tfe2,length(tfe2),1);
     TntDBEdit1.Text :=  tfe2;

end;

procedure TMARCDisplayForm.TntDBEdit2Change(Sender: TObject);
var tfe, tfe1: string;
    i : integer;
begin

  tfe :=  TntDBEdit2.Text;
  tfe1 :='';

  for i := 1 to length(tfe) do
   if tfe[i] in ['0','1','2','3','4','5','6','7','8','9',' ','?'] then
     tfe1 := tfe1 + tfe[i];

   TntDBEdit2.Text :=  tfe1;

end;

procedure TMARCDisplayForm.TntDBEdit3Change(Sender: TObject);
var tfe, tfe1: string;
    i : integer;
begin

  tfe :=  TntDBEdit3.Text;
  tfe1 :='';

  for i := 1 to length(tfe) do
   if tfe[i] in ['0'..'9',' ','?'] then
     tfe1 := tfe1 + tfe[i];

   TntDBEdit3.Text :=  tfe1;
end;

procedure TMARCDisplayForm.TntComboBox1Change(Sender: TObject);
begin

  with Data.marcdisplay do
  begin
    DBCheckBox2.Checked := true;
    PostTable(Data.marcdisplay);
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM marcdisplay WHERE (Name=:Name) and (Lang=:Lang)');
    ParamByName('Name').AsWideString := TntComboBox1.Text;
    ParamByName('Lang').AsWideString := TntComboBox2.Text;
    Execute;
  end;


end;

procedure TMARCDisplayForm.TntDBEdit4Change(Sender: TObject);
var tfe, tfe1: string;
    i : integer;
begin

  tfe :=  TntDBEdit4.Text;
  tfe1 :='';

  for i := 1 to length(tfe) do
   if tfe[i] in ['a'..'z','0'..'9','*','-'] then
     tfe1 := tfe1 + tfe[i];

   TntDBEdit4.Text :=  tfe1;
end;

procedure TMARCDisplayForm.FormActivate(Sender: TObject);
var
  i : integer;
begin

  GetNameFromMarcdisplay;
  TntComboBox1Change(Sender);
  Button4.SetFocus;

  if data.basket.Active Then
    TntEdit1.Text := data.basket.FieldByName('recno').AsString;

  TntRichedit1.Lines.Clear;

  //Populate font list
  TntDBComboBox1.Items.Clear;
  TntDBComboBox4.Items.Clear;
  for i := 0 to Screen.Fonts.Count-1 do
  begin
    TntDBComboBox1.Items.Add(Screen.Fonts[i]);
    TntDBComboBox4.Items.Add(Screen.Fonts[i]);
  end;

end;

procedure TMARCDisplayForm.TntBitBtn2Click(Sender: TObject);
begin

  with Data.marcdisplay do
  begin
    Append;
    FieldByName('Name').AsString := TntComboBox1.Text;
    FieldByName('Lang').AsString := TntComboBox2.Text;
    FieldByName('print').AsBoolean := true;
    FieldByName('linef').AsBoolean := true;
    Post;
  end;

end;

procedure TMARCDisplayForm.TntBitBtn3Click(Sender: TObject);
begin
  NewGroupForm.showModal;
  GetNameFromMarcdisplay;
  TntComboBox1Change(Sender);
end;

procedure TMARCDisplayForm.ck(Sender: TObject);
begin
  Data.marcdisplay.Delete;
end;

procedure TMARCDisplayForm.TntBitBtn4Click(Sender: TObject);
var
   SWTex, SWT : WideString;
begin

  SWTex := 'Are you sure you want to delete the selected tag with the fields:'+ #13+
           '   Name: '+Data.marcdisplay.FieldByName('Name').AsVariant + #13+
           '   Lang: '+ Data.marcdisplay.FieldByName('Lang').AsString + #13+
           '   Tag: '+ Data.marcdisplay.FieldByName('Tag').AsString;
  SWT := 'MARC Display';

  if MessageBoxW(0,PWideChar(SWTex),PWideChar(SWT), MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL) = mrYes then
  begin
    Data.marcdisplay.Delete;
  end;

end;

procedure TMARCDisplayForm.TntBitBtn5Click(Sender: TObject);
var
  grouptext, book : WideString;
  rec : UTF8String;
  i, recno : integer;
begin
  PostTable(Data.marcdisplay);

  recno := StrToIntDef(TntEdit1.Text, -1);
  grouptext:='';
  if recno > 0 Then
  begin
    OpenSecureBasketTable(recno);
    if data.SecureBasket.RecordCount > 0 Then
    begin
      SetLength(LabelPos, 0);
      SetLength(ContentPos, 0);

      rec := MakeMRCFromSecureBasket(recno);
      book := ProcessRecnoForPrinting(rec, 1, -1, False, grouptext, TntComboBox1.Text, TntCombobox2.Text);

      TntRichEdit1.Text := book;

      //Apply Label font
      for i := 0 to length(LabelPos)-1 do
      with TntRichEdit1 do
      begin
        SelStart := LabelPos[i].Start;
        SelLength := LabelPos[i].Len;

        if LabelPos[i].Font.Name <> '' Then
            SelAttributes.Name := LabelPos[i].Font.Name;
        if length(LabelPos[i].Font.Style) = 3 Then
        begin
          if StrToIntDef(LabelPos[i].Font.Style[1], 0) = 1
              Then SelAttributes.Style := SelAttributes.Style + [fsBold]
              Else SelAttributes.Style := SelAttributes.Style - [fsBold];

          if StrToIntDef(LabelPos[i].Font.Style[2], 0) = 1
              Then SelAttributes.Style := SelAttributes.Style + [fsItalic]
              Else SelAttributes.Style := SelAttributes.Style - [fsItalic];

          if StrToIntDef(LabelPos[i].Font.Style[3], 0) = 1
              Then SelAttributes.Style := SelAttributes.Style + [fsUnderline]
              Else SelAttributes.Style := SelAttributes.Style - [fsUnderline];
        end;
        if LabelPos[i].Font.Size > 0 Then
          SelAttributes.Size := LabelPos[i].Font.Size;
      end;

      //Apply Content font
      for i := 0 to length(ContentPos)-1 do
      with TntRichEdit1 do
      begin
        SelStart := ContentPos[i].Start;
        SelLength := ContentPos[i].Len;

        if ContentPos[i].Font.Name <> '' Then
            SelAttributes.Name := ContentPos[i].Font.Name;
        if length(ContentPos[i].Font.Style) = 3 Then
        begin
          if StrToIntDef(ContentPos[i].Font.Style[1], 0) = 1
              Then SelAttributes.Style := SelAttributes.Style + [fsBold]
              Else SelAttributes.Style := SelAttributes.Style - [fsBold];

          if StrToIntDef(ContentPos[i].Font.Style[2], 0) = 1
              Then SelAttributes.Style := SelAttributes.Style + [fsItalic]
              Else SelAttributes.Style := SelAttributes.Style - [fsItalic];

          if StrToIntDef(ContentPos[i].Font.Style[3], 0) = 1
              Then SelAttributes.Style := SelAttributes.Style + [fsUnderline]
              Else SelAttributes.Style := SelAttributes.Style - [fsUnderline];
        end;
        if ContentPos[i].Font.Size > 0 Then
          SelAttributes.Size := ContentPos[i].Font.Size;
      end;
    end;
  end;

end;

procedure TMARCDisplayForm.TntEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 Then TntBitBtn5Click(Sender);
end;

procedure TMARCDisplayForm.SpeedButton1Click(Sender: TObject);
var
  style : string[3];
  enabled : char;
begin
  if (Sender as TSpeedButton).Down Then enabled := '1'
                                   Else enabled := '0';

  if IsEmptyField(data.marcdisplay, 'l_style') Then
  begin
    EditTable(data.marcdisplay);
    style := enabled + '00';
    data.marcdisplay['l_style'] := style;
  end
  Else
  begin
    style := data.marcdisplay.FieldByName('l_style').AsString;
    EditTable(data.marcdisplay);
    if length(style)<>3 Then style := enabled + '00'
                        Else style[1] := enabled;
    data.marcdisplay['l_style'] := style;
  end;

end;

procedure TMARCDisplayForm.SpeedButton2Click(Sender: TObject);
var
  style : string[3];
  enabled : char;
begin
  if (Sender as TSpeedButton).Down Then enabled := '1'
                                   Else enabled := '0';

  if IsEmptyField(data.marcdisplay, 'l_style') Then
  begin
    EditTable(data.marcdisplay);
    style := '0' + enabled + '0';
    data.marcdisplay['l_style'] := style;
  end
  Else
  begin
    style := data.marcdisplay.FieldByName('l_style').AsString;
    EditTable(data.marcdisplay);
    if length(style)<>3 Then style := '0' + enabled + '0'
                        Else style[2] := enabled;
    data.marcdisplay['l_style'] := style;
  end;

end;

procedure TMARCDisplayForm.SpeedButton3Click(Sender: TObject);
var
  style : string[3];
  enabled : char;
begin
  if (Sender as TSpeedButton).Down Then enabled := '1'
                                   Else enabled := '0';

  if IsEmptyField(data.marcdisplay, 'l_style') Then
  begin
    EditTable(data.marcdisplay);
    style := '00' + enabled;
    data.marcdisplay['l_style'] := style;
  end
  Else
  begin
    style := data.marcdisplay.FieldByName('l_style').AsString;
    EditTable(data.marcdisplay);
    if length(style)<>3 Then style := '00' + enabled
                        Else style[3] := enabled;
    data.marcdisplay['l_style'] := style;
  end;

end;

procedure TMARCDisplayForm.SpeedButton4Click(Sender: TObject);
var
  style : string[3];
  enabled : char;
begin
  if (Sender as TSpeedButton).Down Then enabled := '1'
                                   Else enabled := '0';

  if IsEmptyField(data.marcdisplay, 'c_style') Then
  begin
    EditTable(data.marcdisplay);
    style := enabled + '00';
    data.marcdisplay['c_style'] := style;
  end
  Else
  begin
    style := data.marcdisplay.FieldByName('c_style').AsString;
    EditTable(data.marcdisplay);
    if length(style)<>3 Then style := enabled + '00'
                        Else style[1] := enabled;
    data.marcdisplay['c_style'] := style;
  end;


end;

procedure TMARCDisplayForm.SpeedButton5Click(Sender: TObject);
var
  style : string[3];
  enabled : char;
begin
  if (Sender as TSpeedButton).Down Then enabled := '1'
                                   Else enabled := '0';

  if IsEmptyField(data.marcdisplay, 'c_style') Then
  begin
    EditTable(data.marcdisplay);
    style := '0' + enabled + '0';
    data.marcdisplay['c_style'] := style;
  end
  Else
  begin
    style := data.marcdisplay.FieldByName('c_style').AsString;
    EditTable(data.marcdisplay);
    if length(style)<>3 Then style := '0' + enabled + '0'
                        Else style[2] := enabled;
    data.marcdisplay['c_style'] := style;
  end;

end;

procedure TMARCDisplayForm.SpeedButton6Click(Sender: TObject);
var
  style : string[3];
  enabled : char;
begin
  if (Sender as TSpeedButton).Down Then enabled := '1'
                                   Else enabled := '0';

  if IsEmptyField(data.marcdisplay, 'c_style') Then
  begin
    EditTable(data.marcdisplay);
    style := '00' + enabled;
    data.marcdisplay['c_style'] := style;
  end
  Else
  begin
    style := data.marcdisplay.FieldByName('c_style').AsString;
    EditTable(data.marcdisplay);
    if length(style)<>3 Then style := '00' + enabled
                        Else style[3] := enabled;
    data.marcdisplay['c_style'] := style;
  end;


end;

end.
