unit NewUserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, Buttons, TntStdCtrls,
  TntDBCtrls, TntButtons, TntForms, TntExtCtrls,DB, ComCtrls, TntComCtrls;

type
  TNewUserForm = class(TTntForm)
    ExitButon: TTntBitBtn;
    BitBtn1: TTntBitBtn;
    Panel1: TTntPanel;
    Label1: TTntLabel;
    DBEdit1: TTntDBEdit;
    Label5: TTntLabel;
    Panel2: TTntPanel;
    Label7: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TTntLabel;
    DBEdit2: TTntDBEdit;
    Label6: TTntLabel;
    DBEdit3: TTntDBEdit;
    DBEdit5: TTntDBEdit;
    Label3: TTntLabel;
    ComboBox1: TTntComboBox;
    TntPanel1: TTntPanel;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntLabel3: TTntLabel;
    TntDateTimePicker1: TTntDateTimePicker;
    TntDBEdit1: TTntDBEdit;
    DBText1: TTntDBText;
    TntDBRichEdit1: TTntDBRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure TntDateTimePicker1Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewUserForm: TNewUserForm;

implementation

Uses DataUnit, GlobalProcedures, MyAccess, DBAccess;

{$R *.dfm}


function locate_user_name(user_name : widestring): boolean;
var
    query : TMyQuery;
begin

  query := TMyQuery.Create(Data);

  with query do
  begin
    Connection := Data.MyConnection1;
    SQL.Add('select usercode from users where (username =:username)');
    ParamByName('username').AsWideString := user_name;
    Execute;

    if RecordCount = 0 then Result := True
      else Result := false;
  end;

end;



procedure TNewUserForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
   if (DBEdit1.Text <> '') and (DBEdit2.Text <> '') and (Edit1.Text <> '') and (Edit2.Text <> '')
   then
    if locate_user_name(DBEdit1.Text)
    then
      begin
        if Edit1.Text = Edit2.Text
        then
          begin       //Guest, User, Manager, admin which is equal to  0, 6, 8,10
             case ComboBox1.ItemIndex of
             0: Data.users.FieldByName('Useraccess').AsInteger := 0;
             1: Data.users.FieldByName('Useraccess').AsInteger := 6;
             2: Data.users.FieldByName('Useraccess').AsInteger := 8;
             3: Data.users.FieldByName('Useraccess').AsInteger := 10;
             end;

             Data.Users.FieldByName('UserPassword').AsString := CryptPassword(Edit1.Text);
             Data.Users.Post;
             close;
          end
        else
          begin
            MessOK('The password doesn''t match!');
            NewUserForm.ModalResult := mrNone;
          end
      end
    else
      begin
        MessOK('The user name exists! Please choose another one!');
        NewUserForm.ModalResult := mrNone;
      end
    else
      begin
         MessOK('Complete all the fields!');
         NewUserForm.ModalResult := mrNone;
      end
  end
  else Data.Users.Cancel;
end;

procedure TNewUserForm.FormActivate(Sender: TObject);
begin
  Data.users.FieldByName('cdate').AsDateTime := now;
  ComboBox1.ItemIndex := 1;
  Edit1.Text := '';
  Edit2.Text := '';

  if Data.users.FieldByName('endactive').IsNull then
      TntDateTimePicker1.Format := ' '
   else
      TntDateTimePicker1.Date := Data.users.FieldByName('endactive').AsDateTime;
end;

procedure TNewUserForm.TntDateTimePicker1Change(Sender: TObject);
begin
  EditTable(Data.Users);
  TntDateTimePicker1.Format := '';
  Data.Users.FieldByName('endactive').AsDateTime := TntDateTimePicker1.Date;
end;

end.


