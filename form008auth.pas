unit form008auth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, TntStdCtrls, TntForms, TntComCtrls,
  Buttons, TntButtons, common, TntDialogs, ShellApi;

type
  Teightauth = class(TTntForm)
    Edit1: TTntEdit;
    Label1: TTntLabel;
    Label2: TTntLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    Label3: TTntLabel;
    Label4: TTntLabel;
    MaskEdit5: TMaskEdit;
    Label5: TTntLabel;
    MaskEdit6: TMaskEdit;
    Label6: TTntLabel;
    MaskEdit7: TMaskEdit;
    MaskEdit8: TMaskEdit;
    Label7: TTntLabel;
    Label8: TTntLabel;
    Edit2: TEdit;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    Label9: TTntLabel;
    MaskEdit9: TMaskEdit;
    Label10: TTntLabel;
    MaskEdit10: TMaskEdit;
    Label11: TTntLabel;
    MaskEdit11: TMaskEdit;
    Label12: TTntLabel;
    MaskEdit12: TMaskEdit;
    Label13: TTntLabel;
    MaskEdit13: TMaskEdit;
    Label14: TTntLabel;
    MaskEdit15: TMaskEdit;
    Label15: TTntLabel;
    MaskEdit16: TMaskEdit;
    Label16: TTntLabel;
    MaskEdit18: TMaskEdit;
    Label17: TTntLabel;
    MaskEdit14: TMaskEdit;
    TntLabel1: TTntLabel;
    MaskEdit17: TMaskEdit;
    Label18: TTntLabel;
    MaskEdit19: TMaskEdit;
    Label19: TTntLabel;
    MaskEdit20: TMaskEdit;
    TntLabel2: TTntLabel;
    MaskEdit21: TMaskEdit;
    TntLabel3: TTntLabel;
    MaskEdit22: TMaskEdit;
    TntLabel4: TTntLabel;
    MaskEdit23: TMaskEdit;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    typeofmaterial : string;
  end;

var
  eightauth: Teightauth;

implementation

{$R *.dfm}

procedure Teightauth.FormActivate(Sender: TObject);
begin
 if (length(Edit1.Text) < 40) then
   Edit1.Text:= '      ||||||||||||||||||||||||||||||||||';
 maskedit1.SetFocus;
 maskedit1.Text := copy(edit1.Text,1,6);
 maskedit2.Text := copy(Edit1.Text,7,1);
 maskedit3.Text := copy(Edit1.Text,8,1);
 maskedit4.Text := copy(Edit1.Text,9,1);
 maskedit5.Text := copy(Edit1.Text,10,1);
 maskedit6.Text := copy(Edit1.Text,11,1);
 maskedit7.Text := copy(Edit1.Text,12,1);
 maskedit8.Text := copy(Edit1.Text,13,1);
 maskedit9.Text := copy(Edit1.Text,14,1);
 maskedit10.Text:= copy(edit1.Text,15,1);
 maskedit11.Text:= copy(edit1.Text,16,1);
 maskedit12.Text:= copy(edit1.Text,17,4);
 maskedit13.Text:= copy(edit1.Text,18,1);
 maskedit14.Text:= copy(edit1.Text,19,10);
 maskedit15.Text:= copy(edit1.Text,29,1);
 maskedit16.Text:= copy(edit1.Text,30,1);
 maskedit17.Text:= copy(edit1.Text,31,1);
 maskedit18.Text:= copy(edit1.Text,32,1);
 maskedit19.Text:= copy(edit1.Text,33,1);
 maskedit20.Text:= copy(edit1.Text,34,1);
 maskedit21.Text:= copy(edit1.Text,35,4);
 maskedit22.Text:= copy(edit1.Text,39,1);
 maskedit22.Text:= copy(edit1.Text,40,1);
 maskedit1.SetFocus;
 maskedit1.SelectAll;
end;

procedure Teightauth.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure Teightauth.BitBtn1Click(Sender: TObject);
begin
 edit1.Text := maskedit1.Text+maskedit2.Text+maskedit3.Text+maskedit4.Text+maskedit5.Text;
 edit1.Text:=edit1.Text+maskedit6.Text+maskedit7.Text+maskedit8.Text;
 edit1.Text:=edit1.Text+maskedit9.Text+maskedit10.Text+maskedit11.Text;
 edit1.Text:=edit1.Text+maskedit12.Text+maskedit13.Text+maskedit14.Text;
 edit1.Text:=edit1.Text+maskedit15.Text+maskedit16.Text+maskedit7.Text;
 edit1.Text:=edit1.Text+maskedit18.Text+maskedit19.Text+maskedit20.Text;
 edit1.Text:=edit1.Text+maskedit21.Text+maskedit22.Text+maskedit23.Text;
end;

procedure Teightauth.TntBitBtn2Click(Sender: TObject);
var i : integer;
    url : Widestring;
begin
  url:='';
  for i:=0 to 1000 do
  begin
   if AuthUsmarcstx[i].tag = '008' then
   begin
    url:=AuthUsmarcstx[i].marc_help_url;
    break;
   end;
  end;
  if url = '' then WideShowMessage('No help available')
  else ShellExecuteW(handle, 'Open', PWideChar(url), NiL, NiL, SW_SHOWNORMAL);
end;

end.
