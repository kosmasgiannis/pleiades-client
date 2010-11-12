unit OrganisationCodeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, WideIniClass, TntButtons, TntStdCtrls, TntForms;

type
  TOrganisationCodeForm = class(TTntForm)
    GroupBox1: TTntGroupBox;
    Edit1: TTntEdit;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrganisationCodeForm: TOrganisationCodeForm;

implementation

uses MainUnit, IniFiles;

{$R *.dfm}

procedure TOrganisationCodeForm.FormActivate(Sender: TObject);
var
  path, myinifname : string;
  MyIniFile : TWideIniFile;

begin
  path:=extractfilepath(paramstr(0));
  myinifname := path+'pleiades.ini';
  MyIniFile := TWideIniFile.Create(myinifname);
  with MyIniFile do
  begin

   FastRecordCreator.OrganisationCode := ReadString(FastRecordCreator.currentdatabase,'OrgCode', '');

  end;
  MyIniFile.Free;

  Edit1.Text := FastRecordCreator.OrganisationCode;

end;

procedure TOrganisationCodeForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  path, myinifname : string;
  MyIniFile : TWideIniFile;
begin
  if ModalResult = mrOk then
    begin

      path:=extractfilepath(paramstr(0));
      myinifname := path+'pleiades.ini';
      MyIniFile := TWideIniFile.Create(myinifname);
      with MyIniFile do
        begin
          WriteString(FastRecordCreator.currentdatabase,'OrgCode', Edit1.Text);
        end;
      MyIniFile.Free;

      if FastRecordCreator.OrganisationCode <> Edit1.Text then FastRecordCreator.OrganisationCode := Edit1.Text;
    end;

end;

end.
