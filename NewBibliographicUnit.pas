unit NewBibliographicUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, TntDBCtrls, TntStdCtrls, Mask, Buttons, DateUtils,
  ExtCtrls, TntButtons, TntForms, DB;

type
  TNewBibliographicForm = class(TTntForm)
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Label4: TTntLabel;
    Label5: TTntLabel;
    Label6: TTntLabel;
    Label7: TTntLabel;
    Label9: TTntLabel;
    Label10: TTntLabel;
    Label11: TTntLabel;
    Label12: TTntLabel;
    Label19: TTntLabel;
    DBEdit1: TTntEdit;
    DBEdit3: TTntEdit;
    DBEdit4: TTntEdit;
    DBEdit5: TTntEdit;
    Langcombobox: TTntComboBox;
    materialComboBox: TTntComboBox;
    DBEdit6: TTntEdit;
    DBMemo1: TTntMemo;
    DBCheckBox1: TTntCheckBox;
    DBEdit7: TTntEdit;
    DBEdit8: TTntEdit;
    DBEdit12: TTntEdit;
    DBMemo3: TTntMemo;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewBibliographicForm: TNewBibliographicForm;

implementation

uses zoomit, common, DataUnit, utility, MainUnit, ProgresBarUnit, GlobalProcedures;

{$R *.dfm}

procedure TNewBibliographicForm.FormShow(Sender: TObject);
begin
  ActiveControl := LangComboBox;

  LangComboBox.ItemIndex := 0;
  MaterialComboBox.ItemIndex := 0;
  DBEdit1.Text := '';
  DBMemo3.Text := '';
  DBEdit3.Text := '';
  DBEdit4.Text := '';
  DBEdit5.Text := '';
  DBEdit6.Text := '';
  DBEdit7.Text := '';
  DBEdit8.Text := '';
  DBEdit12.Text := '';
  DBMemo1.Text := '';
end;

procedure TNewBibliographicForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  temp : UTF8String;
  recno1 : integer;
begin
  if ModalResult = mrOk Then
    begin
      data.MyConnection1.Connected := True;

      recno1 := NewMARCRecord(FastRecordCreator.base_table);


      with data.SecureBasket do
      begin

        EditTable(data.SecureBasket);
        temp := makemrcfromnew;
        if length(temp) >= 10 then temp[10] := 'a';

        EnhanceMARC(recno1, temp);

        GetBlob('text').IsUnicode := True;
        GetBlob('text').AsWideString := StringToWideString(temp, Greek_codepage);
        TBlobField(FieldByName('text')).Modified := True;

        PostTable(data.secureBasket);

        FastRecordCreator.markbook := recno1;
        FastRecordCreator.gotorecno := recno1;

        RecordUpdated(myzebrahost, 'insert', recno1, temp);

      end;

      savedmarc := true;
    end;
end;

procedure TNewBibliographicForm.FormActivate(Sender: TObject);
var
  hlp,s : WideString;
  p : integer;
begin
  Langcombobox.Clear;
  materialComboBox.Clear;
 s := FastRecordCreator.Languages+',';
 while (s <> '') do
 begin
  p := pos(',',s);
  if (p <> 0) then
  begin
   hlp := copy(s,1,p-1);
   s:= copy(s,p+1,length(s));
   langcombobox.Items.Add(hlp);
  end
 end;
 s := fastrecordcreator.Materials+',';
 while (s <> '') do
 begin
  p := pos(',',s);
  if (p <> 0) then
  begin
   hlp := copy(s,1,p-1);
   s:= copy(s,p+1,length(s));
   materialcombobox.Items.Add(hlp);
  end
 end;
  Langcombobox.ItemIndex := 0;
  materialComboBox.ItemIndex := 0;
end;

end.
