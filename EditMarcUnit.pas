unit EditMarcUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntStdCtrls, TntDBCtrls, ComCtrls,
  TntDialogs, TntComCtrls, TntButtons, TntForms, ShellApi;

type
  TEditMarcForm = class(TTntForm)
    TntMemo1: TTntMemo;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    StatusBar1: TTntStatusBar;
    TntBitBtn2: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TntMemo1KeyPress(Sender: TObject; var Key: Char);
    procedure TntBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  str : WideString;
  record_type : string;
  end;

var
  EditMarcForm: TEditMarcForm;

implementation

uses common, MARCEditor;

{$R *.dfm}

procedure TEditMarcForm.FormActivate(Sender: TObject);
begin
  TntMemo1.Clear;
  TntMemo1.Lines.Add(str);
  TntMemo1.SetFocus;
  TntMemo1.SelStart := length(str);
end;

procedure TEditMarcForm.BitBtn1Click(Sender: TObject);
begin
  str := TntMemo1.Lines.Text;
  while pos(#13#10, str)>0 do
     delete(str, pos(#13#10, str), 2);
end;

procedure TEditMarcForm.TntMemo1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then ModalResult := mrCancel;
end;

procedure TEditMarcForm.TntBitBtn2Click(Sender: TObject);
var i : integer;
    url : Widestring;
begin
  url:='';
  for i:=0 to 1000 do
  begin
   if (record_type = 'bib') Then
   begin
     if BibUsmarcstx[i].tag = copy(tntmemo1.Lines.Text,2,3) then
     begin
      url:=BibUsmarcstx[i].marc_help_url;
      break;
     end;
   end
   else
   begin
     if AuthUsmarcstx[i].tag = copy(tntmemo1.Lines.Text,2,3) then
     begin
      url:=AuthUsmarcstx[i].marc_help_url;
      break;
     end;
   end;
  end;
  if url = '' then WideShowMessage('No help available')
  else ShellExecuteW(handle, 'Open', PWideChar(url), NiL, NiL, SW_SHOWNORMAL);
end;

end.
