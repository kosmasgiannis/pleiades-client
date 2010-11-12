unit ldr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, TntStdCtrls, TntForms, Buttons, TntButtons, common,
  ShellApi, TntDialogs;

type
  TLeaderForm = class(TTntForm)
    Edit1: TTntEdit;
    Label1: TTntLabel;
    MaskEdit1: TMaskEdit;
    Label2: TTntLabel;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    Label3: TTntLabel;
    Label4: TTntLabel;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    Label5: TTntLabel;
    Label6: TTntLabel;
    MaskEdit6: TMaskEdit;
    MaskEdit7: TMaskEdit;
    Label7: TTntLabel;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    record_type : string; // bib, auth
    { Public declarations }
  end;

var
  LeaderForm: TLeaderForm;

implementation

{$R *.dfm}

procedure TLeaderForm.FormActivate(Sender: TObject);
var v : string;
begin
 if record_type = 'bib' Then
 begin
   Label3.Enabled := true;
   MaskEdit3.Enabled := true;
   Label4.Enabled := true;
   MaskEdit4.Enabled := true;
   Label6.Enabled := true;
   MaskEdit6.Enabled := true;
   Label7.Enabled := true;
   MaskEdit7.Enabled := true;

   if length(edit1.Text) < 24 then edit1.Text:= '         a22        4500';
   maskedit1.Text := copy(edit1.Text,6,1);
   maskedit2.Text := copy(Edit1.Text,7,1);
   maskedit3.Text := copy(Edit1.Text,8,1);
   maskedit4.Text := copy(Edit1.Text,9,1);
   maskedit5.Text := copy(Edit1.Text,18,1);
   maskedit6.Text := copy(Edit1.Text,19,1);
   maskedit7.Text := copy(Edit1.Text,20,1);
 end
 else
 begin
   Label3.Enabled := false;
   MaskEdit3.Enabled := false;
   Label4.Enabled := false;
   MaskEdit4.Enabled := false;
   Label6.Enabled := false;
   MaskEdit6.Enabled := false;
   Label7.Enabled := false;
   MaskEdit7.Enabled := false;

   v := copy(edit1.Text,6,1); if (v = '') then v := 'n';
   maskedit1.Text := v;
   maskedit2.Text := 'z';
   v := copy(edit1.Text,18,1); if (v = '') then v := 'n';
   maskedit5.Text := v;

 end;
end;

procedure TLeaderForm.BitBtn2Click(Sender: TObject);
begin
 close;
end;

procedure TLeaderForm.BitBtn1Click(Sender: TObject);
var etc : string;
begin
 etc:=edit1.Text;
 if record_type = 'bib' then
 begin
   edit1.Text:=copy(etc,1,5)+maskedit1.Text+maskedit2.Text+maskedit3.Text+maskedit4.Text;
   edit1.Text:=edit1.Text+copy(etc,10,8)+maskedit5.Text+maskedit6.Text+maskedit7.Text;
   edit1.Text:=edit1.Text+'4500';
 end
 else
 begin
   edit1.Text:='     '+maskedit1.Text+'z';
   edit1.Text:=edit1.Text+' a22     '+maskedit5.Text;
   edit1.Text:=edit1.Text+'  4500';
 end;
end;

procedure TLeaderForm.TntBitBtn2Click(Sender: TObject);
var i : integer;
    url : Widestring;
begin
  url := '';
  for i:=0 to 1000 do
  begin
   if record_type='bib' then
   begin
     if BibUsmarcstx[i].tag = 'LDR' then
     begin
      url:=BibUsmarcstx[i].marc_help_url;
      break;
     end;
   end
   else
   begin
     if AuthUsmarcstx[i].tag = 'LDR' then
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
