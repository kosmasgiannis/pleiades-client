unit UserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, TntButtons, TntDBGrids,
  TntStdCtrls, TntForms;

type
  TUserForm = class(TTntForm)
    DBGrid1: TTntDBGrid;
    ExitButon: TTntBitBtn;
    BitBtn1: TTntBitBtn;
    Label3: TTntLabel;
    TntBitBtn1: TTntBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserForm: TUserForm;

implementation

Uses NewUserUnit, DataUnit, UserSettingsUnit, GlobalProcedures;

{$R *.dfm}

procedure TUserForm.BitBtn1Click(Sender: TObject);
begin
   Data.Users.Append;
   Data.Users.FieldByName('useractive').AsBoolean := true;
   NewUserForm.ShowModal;
   Data.Users.Refresh;
end;

procedure TUserForm.DBGrid1DblClick(Sender: TObject);
begin
   UserSettingsForm.ShowModal;
   Data.Users.Refresh;
end;

procedure TUserForm.TntBitBtn1Click(Sender: TObject);
begin
 if MessYesNo('Are you sure you want to remove this user : ' + Data.Users.fieldbyname('username').asvariant+' ? ') then
   Data.Users.Delete;
end;

end.
