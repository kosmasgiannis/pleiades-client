unit DefClnSettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, TntStdCtrls, TntForms;

type
  TDefClnSettingsForm = class(TTntForm)
    Label1: TTntLabel;
    Edit1: TTntEdit;
    Button1: TTntButton;
    Button2: TTntButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DefClnSettingsForm: TDefClnSettingsForm;

implementation

uses MainUnit, common, WideIniClass;

{$R *.dfm}

procedure TDefClnSettingsForm.FormActivate(Sender: TObject);
var
  myinifname,path : string;
  myIniFile : TWideIniFile;
begin
 path:=extractfilepath(paramstr(0));
 myinifname := path+'pleiades.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 with MyIniFile do
 begin
  FastRecordCreator.defcln :=ReadWideString(FastRecordCreator.currentdatabase,'DefCln', '');
 end;
 MyIniFile.Free;
 Edit1.Text := FastRecordCreator.defcln;

end;

procedure TDefClnSettingsForm.Button1Click(Sender: TObject);
var myinifname,path : string;
    myIniFile : TWideIniFile;
begin
 path:=extractfilepath(paramstr(0));
 myinifname := path+'pleiades.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 with MyIniFile do
 begin
  WriteWideString(FastRecordCreator.currentdatabase,'DefCln', Edit1.Text);
 end;
 FastRecordCreator.defcln :=Edit1.Text;
 MyIniFile.Free;
end;

procedure TDefClnSettingsForm.Button2Click(Sender: TObject);
begin
//
end;

end.
