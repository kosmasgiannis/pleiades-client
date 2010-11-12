unit SettingsZebraUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, WideIniClass, TntButtons, TntStdCtrls, TntForms;

type
  TSettingsZebraForm = class(TTntForm)
    GroupBox1: TTntGroupBox;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    Label1: TTntLabel;
    Edit1: TTntEdit;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Edit2: TTntEdit;
    Edit3: TTntEdit;
    TntLabel1: TTntLabel;
    Edit4: TTntEdit;
    TntLabel2: TTntLabel;
    Edit5: TTntEdit;
    TntLabel3: TTntLabel;
    Edit6: TTntEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsZebraForm: TSettingsZebraForm;
{  myzebrahost, myzebraport, myzebradatabase : string; }


implementation

uses MainUnit, IniFiles, Math, zoomit, zoom, DataUnit, common;

{$R *.dfm}

procedure TSettingsZebraForm.FormActivate(Sender: TObject);
var
  path, myinifname : string;
  myIniFile : TWideIniFile;
  myzebradommode, myzebraauthdommode : boolean;
begin
  path:=extractfilepath(paramstr(0));
  myinifname := path+'pleiades.ini';
  MyIniFile := TWideIniFile.Create(myinifname);
  with MyIniFile do
  begin
    with FastRecordCreator do
    begin
      myzebrahostname := ReadString(currentdatabase,'myzhost', 'localhost');
      myzebraport := ReadString(currentdatabase,'myzport', '9999');
      myzebradatabase := ReadString(currentdatabase,'myzdatabase', 'Default');
      myzebradommode := ReadBool(currentdatabase,'myzdommode', false);

      myzebraauthhostname := ReadString(currentdatabase,'myzauthhost', 'localhost');
      myzebraauthport := ReadString(currentdatabase,'myzauthport', '9998');
      myzebraauthdatabase := ReadString(currentdatabase,'myzauthdatabase', 'Default_auth');
      myzebraauthdommode := ReadBool(currentdatabase,'myzauthdommode', false);
    end;
  end;
  MyIniFile.Free;

  Edit1.Text := FastRecordCreator.myzebrahostname;
  Edit2.Text := FastRecordCreator.myzebraport;
  Edit3.Text := FastRecordCreator.myzebradatabase;
  Edit4.Text := FastRecordCreator.myzebraauthhostname;
  Edit5.Text := FastRecordCreator.myzebraauthport;
  Edit6.Text := FastRecordCreator.myzebraauthdatabase;
  Checkbox1.Checked := myzebradommode;
  Checkbox2.Checked := myzebraauthdommode;

end;

procedure TSettingsZebraForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  path, myinifname : string;
  myIniFile : TWideIniFile;
begin
  if ModalResult = mrOk then
  begin
    path:=extractfilepath(paramstr(0));
    myinifname := path+'pleiades.ini';
    MyIniFile := TWideIniFile.Create(myinifname);

    with FastRecordCreator do
    begin
      with MyIniFile do
      begin
        WriteString(currentdatabase,'myzhost', SettingsZebraForm.Edit1.Text);
        WriteString(currentdatabase,'myzport', SettingsZebraForm.Edit2.Text);
        WriteString(currentdatabase,'myzdatabase', SettingsZebraForm.Edit3.Text);
        WriteBool(currentdatabase,'myzdommode', SettingsZebraForm.checkbox1.checked);

        WriteString(currentdatabase,'myzauthhost', SettingsZebraForm.Edit4.Text);
        WriteString(currentdatabase,'myzauthport', SettingsZebraForm.Edit5.Text);
        WriteString(currentdatabase,'myzauthdatabase', SettingsZebraForm.Edit6.Text);
        WriteBool(currentdatabase,'myzauthdommode', SettingsZebraForm.checkbox2.checked);
      end;
      MyIniFile.Free;

      myzebrahostname := SettingsZebraForm.Edit1.Text;
      myzebraport := SettingsZebraForm.Edit2.Text;
      myzebradatabase := SettingsZebraForm.Edit3.Text;
      myzebraauthhostname := SettingsZebraForm.Edit4.Text;
      myzebraauthport := SettingsZebraForm.Edit5.Text;
      myzebraauthdatabase := SettingsZebraForm.Edit6.Text;

      setup_zebra_host(myzebrahost, 'MyZebraDB', myzebrahostname, myzebraport,
                       myzebradatabase, 'Usmarc','UTF-8','UTF-8','',myzprofile, SettingsZebraForm.checkbox1.checked);
      setup_zebra_host(myzebraauthhost, 'MyZebraAuthDB', myzebraauthhostname, myzebraauthport,
                       myzebraauthdatabase, 'Usmarc','UTF-8','UTF-8','',myzauthprofile, SettingsZebraForm.checkbox2.checked);
    end;
  end;
end;

end.
