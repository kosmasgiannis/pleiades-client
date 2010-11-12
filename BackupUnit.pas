unit BackupUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TBackupForm = class(TForm)
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ProgressBar1: TProgressBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BackupForm: TBackupForm;

implementation

uses DataUnit, MyAccess;

{$R *.dfm}

procedure TBackupForm.BitBtn1Click(Sender: TObject);
begin

  Data.SaveDialog1.DefaultExt := 'sql';
  Data.SaveDialog1.Title := 'Save SQL File As ';

  if Data.SaveDialog1.Execute then
  begin
   ProgressBar1.Visible := true;
    Data.MyDump1.Backup;
//    Data.MyDump1.Debug := true;
    Data.MyDump1.SQL.SaveToFile(Data.SaveDialog1.FileName);
  ProgressBar1.Visible := false;
 end;
end;

procedure TBackupForm.BitBtn2Click(Sender: TObject);
var
   SThold,
   STQuery1,
   STmoves,
   STusers,
   STbasket,
   STmarcdisplay,
   STvocabulary,
   STSecurebasket : boolean;
begin

  Data.OpenDialog1.DefaultExt := 'sql';
  Data.OpenDialog1.Title := 'Open SQL File ';

  if Data.OpenDialog1.Execute then
  begin
    with Data do
    begin
      SThold := hold.Active;
      STQuery1 := Query1.Active;
      STmoves := moves.Active;
      STusers := users.Active;
      STbasket := basket.Active;
      STmarcdisplay := marcdisplay.Active;
      STvocabulary := vocabulary.Active;
      STSecurebasket := Securebasket.Active;


      ProgressBar1.Visible := true;
      Data.MyConnection1.Connected := false;
      Data.MyScript1.SQL.LoadFromFile(Data.OpenDialog1.FileName);
      Data.MyScript1.Execute;
      Application.ProcessMessages;
      ProgressBar1.Visible := false;
      Data.MyConnection1.Connected := True;

      hold.Active :=   SThold;
      Query1.Active := STQuery1;
      moves.Active := STmoves;
      users.Active := STusers;
      basket.Active := STbasket;
      marcdisplay.Active := STmarcdisplay;
      vocabulary.Active := STvocabulary;
      Securebasket.Active := STSecurebasket;
    end;
 end;

end;

end.
