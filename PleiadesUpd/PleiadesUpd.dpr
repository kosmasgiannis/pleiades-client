program PleiadesUpd;

uses
  Forms,
  main in 'main.pas' {Form1},
  utils in 'utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
