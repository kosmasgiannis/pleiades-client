unit SetPasswordUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, TntButtons, TntStdCtrls, TntForms,
  TntExtCtrls;

type
  TSetPasswordForm = class(TTntForm)
    Panel2: TTntPanel;
    Label3: TTntLabel;
    Label2: TTntLabel;
    DBEdit3: TEdit;
    DBEdit2: TEdit;
    ExitButon: TTntBitBtn;
    BitBtn1: TTntBitBtn;
    Label1: TTntLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetPasswordForm: TSetPasswordForm;

implementation

uses DataUnit, GlobalProcedures;

{$R *.dfm}

procedure TSetPasswordForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  if ModalResult=mrOK then
   if (DBEdit3.Text <> '') or (DBEdit2.Text <> '')
   then  if (DBEdit2.Text = DBEdit3.Text)
         then if MessageBox(0,'Do you want to save the changes?','New Entity', MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL) =  mrYes
            then begin
             EditTable(Data.Users);
             Data.Users.FieldByName('UserPassword').AsString := CryptPassword(DBEdit2.Text);
             PostTable(Data.Users);
             close;
              end
              else

         else
            MessageBox(0,'The password doesn''t match!','Set password', MB_OK + MB_ICONEXCLAMATION + MB_TASKMODAL)
         else
            MessageBox(0,'Complete all the fields!','Set password', MB_OK + MB_ICONEXCLAMATION + MB_TASKMODAL);

           DBEdit2.Text := '';
           DBEdit3.Text := '';
end;

procedure TSetPasswordForm.BitBtn1Click(Sender: TObject);
begin
   if (DBEdit3.Text <> '') or (DBEdit2.Text <> '')
   then  if (DBEdit2.Text = DBEdit3.Text)
         then
           begin
             EditTable(Data.Users);
             Data.Users.FieldByName('UserPassword').AsString := CryptPassword(DBEdit2.Text);
             PostTable(Data.Users);
             close
           end
         else
            MessOK('The password doesn''t match!')
    else
       MessOK('Complete all the fields!')

end;

end.
