unit UserSettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, 
  Dialogs, StdCtrls, Buttons, Mask, DBCtrls, ExtCtrls, TntStdCtrls,
  TntDBCtrls,DateUtils, TntButtons, Forms, TntForms, TntExtCtrls, ComCtrls,
  TntComCtrls;

type
  TUserSettingsForm = class(TTntForm)
    BitBtn1: TTntBitBtn;
    ExitButon: TTntBitBtn;
    Label3: TTntLabel;
    Panel3: TTntPanel;
    Panel2: TTntPanel;
    Label4: TTntLabel;
    Label6: TTntLabel;
    DBEdit5: TTntDBEdit;
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label5: TTntLabel;
    DBEdit1: TTntDBEdit;
    DBEdit2: TTntDBEdit;
    ComboBox1: TTntComboBox;
    TntDBEdit1: TTntDBEdit;
    TntPanel1: TTntPanel;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntLabel3: TTntLabel;
    TntDateTimePicker1: TTntDateTimePicker;
    TntDBEdit2: TTntDBEdit;
    TntDBRichEdit1: TTntDBRichEdit;
    TntDBCheckBox1: TTntDBCheckBox;
    BitBtn3: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure TntDateTimePicker1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserSettingsForm: TUserSettingsForm;
  useraccess : integer;
  userchangename : WideString;


implementation

uses DataUnit, GlobalProcedures,  DB, ChangePasUnit, SetPasswordUnit;

{$R *.dfm}


procedure TUserSettingsForm.FormActivate(Sender: TObject);
begin

 try
   Data.Users.refresh;
   case Data.users.FieldByName('Useraccess').AsInteger of
     0: ComboBox1.ItemIndex := 0;
     6: ComboBox1.ItemIndex := 1;
     8: ComboBox1.ItemIndex := 2;
    10: ComboBox1.ItemIndex := 3;
   end;
   useraccess := Data.users.FieldByName('Useraccess').AsInteger;
   if Data.users.FieldByName('endactive').IsNull then
       TntDateTimePicker1.Format := ' '
     else
       TntDateTimePicker1.Date := Data.users.FieldByName('endactive').AsDateTime;
 finally
 end;

end;

procedure TUserSettingsForm.BitBtn3Click(Sender: TObject);
begin
  SetPasswordForm.ShowModal;
end;

procedure TUserSettingsForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if IsEditMode(Data.Users)
      then ShowSaveDialog(Data.Users);
end;

procedure TUserSettingsForm.BitBtn1Click(Sender: TObject);
begin
  //Guest, User, Manager, admin which is equal to  0, 6, 8,10
  EditTable(Data.users);
  case ComboBox1.ItemIndex of
    0: Data.users.FieldByName('Useraccess').AsInteger := 0;
    1: Data.users.FieldByName('Useraccess').AsInteger := 6;
    2: Data.users.FieldByName('Useraccess').AsInteger := 8;
    3: Data.users.FieldByName('Useraccess').AsInteger := 10;
  end;
  PostTable(Data.Users);
  Close;
end;

procedure TUserSettingsForm.TntDateTimePicker1Change(Sender: TObject);
begin
  EditTable(Data.Users);
  TntDateTimePicker1.Format := '';
  Data.Users.FieldByName('endactive').AsDateTime := TntDateTimePicker1.Date;
end;

end.
