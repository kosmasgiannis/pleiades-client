unit SettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntButtons, globalprocedures, TntStdCtrls, DateUtils,
  TntDialogs, TntForms;

type
  TSettingsForm = class(TTntForm)
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntBitBtn3: TTntBitBtn;
    TntBitBtn4: TTntBitBtn;
    TntBitBtn10: TTntBitBtn;
    TntBitBtn5: TTntBitBtn;
    TntBitBtn6: TTntBitBtn;
    TntBitBtn7: TTntBitBtn;
    TntBitBtn8: TTntBitBtn;
    TntSaveDialog1: TTntSaveDialog;
    TntBitBtn9: TTntBitBtn;
    TntMemo1: TTntMemo;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntBitBtn10Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntBitBtn3Click(Sender: TObject);
    procedure TntBitBtn4Click(Sender: TObject);
    procedure TntBitBtn5Click(Sender: TObject);
    procedure TntBitBtn6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TntBitBtn8Click(Sender: TObject);
    procedure TntBitBtn9Click(Sender: TObject);
    procedure TntBitBtn7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  SettingsForm: TSettingsForm;

implementation

uses SetlangUnit, VocabUnit, ToolsUnit, MovesUnit, UserUnit,
  DataUnit, MyAccess, UpdateSettingsUnit, ChangePasUnit;

{$R *.dfm}

Procedure Write_Memo;
begin

  with SettingsForm do
  begin
    TntMemo1.Clear;
    TntMemo1.Lines.Add('Application code: ' + AppName);
    TntMemo1.Lines.Add('Application version: ' + AppVersion);
    TntMemo1.Lines.Add('Application release date: ' + AppReleaseDate);
    TntMemo1.Lines.Add('User name: '+ UserName);
//    TntMemo1.Lines.Add('Today''s date: '+ DateToStr(today));
    TntMemo1.Lines.Add('Last back up: '+ GetContent(1101));
    TntMemo1.Lines.Add('Preferred language: '+ GetContent(1000));
  end;

end;

procedure TSettingsForm.TntBitBtn1Click(Sender: TObject);
begin
  SetLangForm.ShowModal;
end;

procedure TSettingsForm.TntBitBtn10Click(Sender: TObject);
begin
  close;
end;

procedure TSettingsForm.TntBitBtn2Click(Sender: TObject);
begin
  VocabForm.ShowModal;
end;

procedure TSettingsForm.TntBitBtn3Click(Sender: TObject);
begin
  toolsForm.ShowModal;
end;

procedure TSettingsForm.TntBitBtn4Click(Sender: TObject);
begin
  MovesForm.ShowModal;
end;

procedure TSettingsForm.TntBitBtn5Click(Sender: TObject);
begin
  UserForm.ShowModal;
end;

procedure TSettingsForm.TntBitBtn6Click(Sender: TObject);
begin
  add_components;
end;

procedure TSettingsForm.FormActivate(Sender: TObject);
begin
 Write_Memo;
 if current_user_access=10 then            
  begin
    TntBitBtn4.Enabled := true;
    TntBitBtn5.Enabled := true;
    TntBitBtn6.Enabled := true;
    TntBitBtn7.Enabled := false;
  end;
end;

procedure TSettingsForm.TntBitBtn8Click(Sender: TObject);
var
   TempSeparator : char;
   TempShortDateFormat: string;
begin
  if Data.MyConnection1.Connected then
    with Data do
     begin
             //
      TempSeparator := DateSeparator;
      DateSeparator := '-';
             //
      TempShortDateFormat := ShortDateFormat;
      ShortDateFormat := 'dd-MM-yyyy';

      TntSaveDialog1.FileName := MyConnection1.Database+'_'+DateToStr(Today);
      TntSaveDialog1.InitialDir:=GetContent(1100);

      if TntSaveDialog1.Execute then
       begin
         Save_Content(1100,ExtractFileDir(TntSaveDialog1.FileName));
         Backup_Data(TntSaveDialog1.FileName);
         MessageBox(0,PAnsiChar('You made backup successfully!'),PAnsiChar(Application.Title), MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
         Write_Memo;
       end;

      DateSeparator := TempSeparator;
      ShortDateFormat := TempShortDateFormat;

      Save_Content(1101,datetostr(today));
     end;
end;

procedure TSettingsForm.TntBitBtn9Click(Sender: TObject);
begin
  UpdateSettingsForm.ShowModal;
end;

procedure TSettingsForm.TntBitBtn7Click(Sender: TObject);
begin
  ChangePasForm.ShowModal;
end;

end.
