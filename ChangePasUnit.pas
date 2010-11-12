unit ChangePasUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntStdCtrls, StdCtrls, Buttons, TntButtons, DBCtrls, TntForms,
  TntDBCtrls;

type
  TChangePasForm = class(TTntForm)
    TntGroupBox1: TTntGroupBox;
    DBText1: TTntDBText;
    TntGroupBox2: TTntGroupBox;
    TntEdit1: TEdit;
    TntEdit2: TEdit;
    TntEdit3: TEdit;
    ExitButon: TTntBitBtn;
    BitBtn1: TTntBitBtn;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntLabel3: TTntLabel;
    TntLabel4: TTntLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure ExitButonClick(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangePasForm: TChangePasForm;

implementation

uses DataUnit, GlobalProcedures;

{$R *.dfm}

procedure TChangePasForm.BitBtn1Click(Sender: TObject);
begin

   if CryptPassword(TntEdit1.Text) = data.users.FieldByName('userpassword').asstring then
     if TntEdit2.Text = TntEdit3.Text then
       begin
         EditTable(Data.users);
         data.users.FieldByName('userpassword').asstring := CryptPassword(TntEdit3.Text);
         PostTable(Data.users);
         ModalResult := mrOk;
        end
      else
          MessOK('Passwords don''t match!')
    else
       MessOK('Old password is incorrect!');
 
end;

procedure TChangePasForm.ExitButonClick(Sender: TObject);
begin
  CancelTable(Data.users);
  TntEdit1.Text:='';
  TntEdit2.Text:='';
  TntEdit3.Text:='';
  close;
end;

procedure TChangePasForm.TntFormActivate(Sender: TObject);
begin
  if Not Data.Users.Locate('Usercode',usercode,[]) then MessOK('The user doesn''t exist! Please restart the program.');
end;

end.
