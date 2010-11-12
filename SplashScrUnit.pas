unit SplashScrUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, TntExtCtrls, TntForms, TntStdCtrls;

type
  TSplashScrForm = class(TTntForm)
    Image1: TTntImage;
    Timer1: TTimer;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    FromAbout : boolean;
  end;

var
  SplashScrForm: TSplashScrForm;
implementation

uses MainUnit, DataUnit, LoginUnit, GlobalProcedures;

{$R *.dfm}

procedure TSplashScrForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Close;
end;

procedure TSplashScrForm.FormActivate(Sender: TObject);
begin
  Label1.Caption := 'Version: '+Appversion;

  Application.ProcessMessages;
  if not FromAbout then
  begin
    FastRecordCreator.changedb(FastRecordCreator.currentdatabase);
    Timer1.Enabled := True;     //It is used only to close the SplashScreen form
  end;

end;

procedure TSplashScrForm.FormDeactivate(Sender: TObject);
begin
  timer1.Enabled:=false;
  FromAbout := True;
end;

procedure TSplashScrForm.Image1Click(Sender: TObject);
begin
  if FromAbout Then
  begin
    timer1.Enabled:=false;
    Close;
  end;
end;

procedure TSplashScrForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if FromAbout Then
  begin
    timer1.Enabled:=false;
    Close;
  end;
end;

end.
