unit LoginUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, Buttons,DB,Math, TntStdCtrls, GlobalProcedures, TntForms,
  TntButtons;



type
  TLoginForm = class(TTntForm)
    Label1: TTntLabel;
    Label2: TTntLabel;
    BitBtn1: TTntBitBtn;
    Edit2: TEdit;
    Edit1: TEdit;
    BitBtn2: TTntBitBtn;
    Label3: TTntLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    login_valid:boolean;
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

uses
  DataUnit,  MainUnit;

{$R *.dfm}

//______________________________________________________________________________

procedure TLoginForm.BitBtn1Click(Sender: TObject);
var UserNick: Widestring;
begin

 username := '';
 UserNick := Edit2.Text;

 if (Edit2.Text <> '') and (Edit1.Text <> '') then
 begin
   with Data.Users do
   begin
     if ControlAdminUser(Edit2.Text,Edit1.Text) then
     begin
       usercode := 0;
       username := Edit2.Text;
       CurrentUserName := 'admin';
       login_valid:=true;
       LoginForm.Close;
     end
     else
      if Locate('username',UserNick,[loCaseInsensitive]) then
        if VerifyPass(FieldByName('userpassword').AsString, Edit1.Text) then
        begin
            usercode := FieldByName('usercode').AsInteger;
            current_user_access := FieldByName('useraccess').AsInteger;
            username := Edit2.Text;

            if not Data.users.FieldByName('userfirstname').IsNull Then
               CurrentUserName := Data.users.FieldByName('userfirstname').Value;
            if not Data.users.FieldByName('userlastname').IsNull Then
               CurrentUserName := CurrentUserName + ' ' + Data.users.FieldByName('userlastname').AsVariant;
            login_valid:=true;
            LoginForm.Close;
        end
        else
        begin
          MessOK('The user name or password does not match!');
        end
      else
        MessOK('The user name or password doesn''t match!');
      edit1.SelectAll;
      edit1.SetFocus;
   end;
 end;
end;

//______________________________________________________________________________

procedure TLoginForm.BitBtn2Click(Sender: TObject);
begin
   Application.Terminate;
end;

procedure TLoginForm.TntFormShow(Sender: TObject);
begin
  LoginForm.Caption := 'Login - '+data.MyConnection1.Database;
  edit1.Text:='';
  edit2.Text:='';
  edit2.SetFocus;
  login_valid:=false;
end;

{

procedure TLoginForm.TntFormCreate(Sender: TObject);
begin
  databases :='';
end;

procedure TLoginForm.TntFormActivate(Sender: TObject);
var db: string;
    p:integer;
begin
  databases := trim(databases)+',';
//  showmessage(databases);
  if databases <> ',' then
  begin
    tntcombobox1.Items.clear;
    p:=pos(',',databases);
    while p > 0 do
    begin
     db := copy(databases,1,p-1);
     if db <> '' then
       tntcombobox1.Items.Add(db);
     databases := copy(databases,p+1,length(databases));
     p:=pos(',',databases);
    end;
    tntlabel1.Visible:=true;
    tntcombobox1.Visible:=true;
  end;
end;

procedure TLoginForm.TntComboBox1Select(Sender: TObject);
begin
//  LoginForm.Caption := 'Login - '+data.MyConnection1.Database;
  LoginForm.Caption := tntcombobox1.Text;
end;
}

procedure TLoginForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
if login_valid = false then Application.Terminate;
end;

end.

