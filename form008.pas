unit form008;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, TntStdCtrls, TntForms, TntComCtrls,
  Buttons, TntButtons, common, TntDialogs, ShellApi;

type
  Teight = class(TTntForm)
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
    MaskEdit9: TMaskEdit;
    MaskEdit10: TMaskEdit;
    Label10: TTntLabel;
    MaskEdit11: TMaskEdit;
    Label11: TTntLabel;
    MaskEdit12: TMaskEdit;
    Label12: TTntLabel;
    MaskEdit13: TMaskEdit;
    Label13: TTntLabel;
    MaskEdit14: TMaskEdit;
    Label14: TTntLabel;
    MaskEdit15: TMaskEdit;
    Label9: TTntLabel;
    Label15: TTntLabel;
    MaskEdit16: TMaskEdit;
    Label16: TTntLabel;
    Label17: TTntLabel;
    MaskEdit17: TMaskEdit;
    MaskEdit18: TMaskEdit;
    Label18: TTntLabel;
    MaskEdit19: TMaskEdit;
    Label19: TTntLabel;
    PageControl1: TPageControl;
    TabSheet1: TTntTabSheet;
    TabSheet2: TTntTabSheet;
    Label20: TTntLabel;
    MaskEdit20: TMaskEdit;
    Label21: TTntLabel;
    Label22: TTntLabel;
    Label23: TTntLabel;
    Label24: TTntLabel;
    Label25: TTntLabel;
    MaskEdit21: TMaskEdit;
    MaskEdit22: TMaskEdit;
    MaskEdit23: TMaskEdit;
    MaskEdit24: TMaskEdit;
    MaskEdit25: TMaskEdit;
    Label26: TTntLabel;
    MaskEdit26: TMaskEdit;
    Label27: TTntLabel;
    MaskEdit27: TMaskEdit;
    Label28: TTntLabel;
    MaskEdit28: TMaskEdit;
    Label29: TTntLabel;
    MaskEdit29: TMaskEdit;
    Label30: TTntLabel;
    MaskEdit30: TMaskEdit;
    Label31: TTntLabel;
    MaskEdit31: TMaskEdit;
    MaskEdit32: TMaskEdit;
    Label32: TTntLabel;
    Edit2: TEdit;
    TabSheet3: TTntTabSheet;
    Label33: TTntLabel;
    MaskEdit33: TMaskEdit;
    MaskEdit34: TMaskEdit;
    Label34: TTntLabel;
    Label35: TTntLabel;
    MaskEdit35: TMaskEdit;
    Label36: TTntLabel;
    MaskEdit36: TMaskEdit;
    Label37: TTntLabel;
    MaskEdit37: TMaskEdit;
    Label38: TTntLabel;
    MaskEdit38: TMaskEdit;
    TabSheet4: TTntTabSheet;
    MaskEdit39: TMaskEdit;
    Label39: TTntLabel;
    Label40: TTntLabel;
    MaskEdit40: TMaskEdit;
    Label41: TTntLabel;
    MaskEdit41: TMaskEdit;
    Label42: TTntLabel;
    MaskEdit42: TMaskEdit;
    Label43: TTntLabel;
    MaskEdit43: TMaskEdit;
    Label44: TTntLabel;
    MaskEdit44: TMaskEdit;
    Label45: TTntLabel;
    MaskEdit45: TMaskEdit;
    Label46: TTntLabel;
    MaskEdit46: TMaskEdit;
    TabSheet5: TTntTabSheet;
    MaskEdit47: TMaskEdit;
    Label47: TTntLabel;
    Label48: TTntLabel;
    Label49: TTntLabel;
    Label50: TTntLabel;
    Label51: TTntLabel;
    MaskEdit48: TMaskEdit;
    MaskEdit49: TMaskEdit;
    MaskEdit50: TMaskEdit;
    MaskEdit51: TMaskEdit;
    MaskEdit52: TMaskEdit;
    Label52: TTntLabel;
    MaskEdit54: TMaskEdit;
    Label54: TTntLabel;
    Label55: TTntLabel;
    MaskEdit55: TMaskEdit;
    Label56: TTntLabel;
    MaskEdit56: TMaskEdit;
    Label53: TTntLabel;
    MaskEdit53: TMaskEdit;
    Label57: TTntLabel;
    MaskEdit57: TMaskEdit;
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
    { Public declarations }
    typeofmaterial : string;
  end;

var
  eight: Teight;

implementation

{$R *.dfm}

procedure Teight.FormActivate(Sender: TObject);
begin
 TabSheet1.TabVisible:=true;
 TabSheet2.TabVisible:=true;
 TabSheet3.TabVisible:=true;
 TabSheet4.TabVisible:=true;
 TabSheet5.TabVisible:=true;
 maskedit1.SetFocus;
 if ((typeofmaterial='BK')or (typeofmaterial='AM')) then
 begin
  TabSheet2.TabVisible:=false;
  TabSheet3.TabVisible:=false;
  TabSheet4.TabVisible:=false;
  TabSheet5.TabVisible:=false;
 end
 else if (typeofmaterial='VM') then
 begin
  TabSheet1.TabVisible:=false;
  TabSheet2.TabVisible:=false;
  TabSheet4.TabVisible:=false;
  TabSheet5.TabVisible:=false;
 end
 else if (typeofmaterial='MP') then
 begin
  TabSheet1.TabVisible:=false;
  TabSheet2.TabVisible:=false;
  TabSheet3.TabVisible:=false;
  TabSheet4.TabVisible:=false;
 end
 else if ((typeofmaterial='MU') or (typeofmaterial='MA')) then
 begin
  TabSheet1.TabVisible:=false;
  TabSheet2.TabVisible:=false;
  TabSheet3.TabVisible:=false;
  TabSheet5.TabVisible:=false;
 end
 else
 begin
  Tabsheet1.TabVisible:=false;
  TabSheet3.TabVisible:=false;
  TabSheet4.TabVisible:=false;
  TabSheet5.TabVisible:=false;
 end;
 maskedit1.Text := copy(edit1.Text,1,6); // Date Entered
 maskedit2.Text := copy(Edit1.Text,7,1); // Type of Date
 maskedit3.Text := copy(Edit1.Text,8,4); // Date 1
 maskedit4.Text := copy(Edit1.Text,12,4); // Date 2
 maskedit5.Text := copy(Edit1.Text,16,3); // Place of publication
 maskedit6.Text := copy(Edit1.Text,36,3); // Language
 maskedit7.Text := copy(Edit1.Text,39,1); // Modified Record
 maskedit8.Text := copy(Edit1.Text,40,1); // Cataloguing Source
 if ((typeofmaterial='BK')or (typeofmaterial='AM')) then begin
  maskedit9.Text := copy(Edit1.Text,19,4); // Illustrations
  maskedit10.Text:= copy(edit1.Text,23,1); // Target audience
  maskedit11.Text:= copy(edit1.Text,24,1); // Form of Item
  maskedit12.Text:= copy(edit1.Text,25,4); // Nature of contents
  maskedit13.Text:= copy(edit1.Text,29,1); // Government Publication
  maskedit14.Text:= copy(edit1.Text,30,1); // Conference Publication
  maskedit15.Text:= copy(edit1.Text,31,1); // Festschrift
  maskedit16.Text:= copy(edit1.Text,32,1); // Index
  maskedit17.Text:= copy(edit1.Text,33,1); // Undefined
  maskedit18.Text:= copy(edit1.Text,34,1); // Literary Form
  maskedit19.Text:= copy(edit1.Text,35,1); // Biography
 end
 else if (typeofmaterial='VM') then begin
  maskedit33.Text:= copy(Edit1.Text,19,3); // Running time
  maskedit34.Text:= copy(Edit1.Text,23,1); // Target audience
  maskedit35.Text:= copy(edit1.Text,29,1); // Gov Publication
  maskedit36.Text:= copy(edit1.Text,30,1); // Form of Item
  maskedit37.Text:= copy(edit1.Text,34,1); // Type of Visual Material
  maskedit38.Text:= copy(edit1.Text,35,1); // Technique
 end
 else if (typeofmaterial='MP') then begin
  maskedit51.Text:= copy(Edit1.Text,19,4); // Relief
  maskedit50.Text:= copy(Edit1.Text,23,2); // Projection
  maskedit49.Text:= copy(edit1.Text,25,1); // Undefined
  maskedit48.Text:= copy(edit1.Text,26,1); // Type of cartographic material
  maskedit55.Text:= copy(edit1.Text,27,2); // Undefined
  maskedit56.Text:= copy(edit1.Text,29,1); // Government Publication
  maskedit47.Text:= copy(edit1.Text,30,1); // Form of Item
  maskedit53.Text:= copy(edit1.Text,31,1); // Undefined
  maskedit52.Text:= copy(edit1.Text,32,1); // Index
  maskedit57.Text:= copy(edit1.Text,33,1); // Undefined
  maskedit54.Text:= copy(edit1.Text,34,2); // Special Format Characteristics
 end
 else if ((typeofmaterial='MU') or (typeofmaterial='MA')) then begin
  maskedit39.Text:= copy(Edit1.Text,19,2); // Form of composition
  maskedit40.Text:= copy(Edit1.Text,21,1); // Format of music
  maskedit41.Text:= copy(edit1.Text,22,1); // Music parts
  maskedit42.Text:= copy(edit1.Text,23,1); // Target audience
  maskedit43.Text:= copy(edit1.Text,24,1); // Form of Item
  maskedit44.Text:= copy(edit1.Text,25,6); // Accompanying matter
  maskedit45.Text:= copy(edit1.Text,31,2); // Literary text for sound recordings
  maskedit46.Text:= copy(edit1.Text,34,1); // Transposition and arrangement
 end
 else
 begin
  maskedit20.Text := copy(Edit1.Text,19,1); // Frequency
  maskedit21.Text := copy(Edit1.Text,20,1); // Regularity
  maskedit22.Text := copy(Edit1.Text,21,1); // ISSN center
  maskedit23.Text := copy(Edit1.Text,22,1); // Type of Cont resource
  maskedit24.Text := copy(Edit1.Text,23,1); // Form of original item
  maskedit25.Text := copy(Edit1.Text,24,1); // Form of item
  maskedit26.Text := copy(Edit1.Text,25,1); // Nature of entire work
  maskedit27.Text := copy(Edit1.Text,26,3); // Nature of content
  maskedit28.Text := copy(Edit1.Text,29,1); // Government publ
  maskedit29.Text := copy(Edit1.Text,30,1); // Conference publ
  maskedit30.Text := copy(Edit1.Text,31,3); // Undefined
  maskedit31.Text := copy(Edit1.Text,34,1); // Original alphabet
  maskedit32.Text := copy(Edit1.Text,35,1); // Entry convention
 end;
 maskedit1.SetFocus;
 maskedit1.SelectAll;
{ ---
var temp : TControl;
     i: integer;
 for i:=0 to eight.ControlCount-1 do
  if (eight.Controls[i] is TWinControl) then
  begin
   temp := eight.Controls[i];
   if (temp.Name = 'MaskEdit6') then
    with temp as Twincontrol do
    begin
     setfocus;
    end;
  end;
--- }
end;

procedure Teight.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure Teight.BitBtn1Click(Sender: TObject);
var etc: WideString;
begin
 edit1.Text:=maskedit1.Text+maskedit2.Text+maskedit3.Text+maskedit4.Text+maskedit5.Text;
 if ((typeofmaterial='BK') or (typeofmaterial='AM')) then begin

  etc:=maskedit9.Text+maskedit10.Text+maskedit11.Text+maskedit12.Text;
  etc:=etc+maskedit13.Text+maskedit14.Text+maskedit15.Text+maskedit16.Text;
  etc:=etc+maskedit17.Text+maskedit18.Text+maskedit19.Text;

 end
 else if ((typeofmaterial='MA') or (typeofmaterial='MU')) then begin

  etc:=maskedit39.Text+maskedit40.Text+maskedit41.Text+maskedit42.Text;
  etc:=etc+maskedit43.Text+maskedit44.Text+maskedit45.Text;
  etc:=etc+' '+maskedit46.Text+' ';

 end
 else if (typeofmaterial='VM') then begin

  etc:=maskedit33.Text+' '+maskedit34.Text+'     '+maskedit35.Text+maskedit36.Text;
  etc:=etc+'   '+maskedit37.Text+maskedit38.Text;

 end
 else if (typeofmaterial='MP') then begin

  etc:=maskedit51.Text + maskedit50.Text + maskedit49.Text + maskedit48.Text +
  maskedit55.Text + maskedit56.Text + maskedit47.Text + maskedit53.Text +
  maskedit52.Text + maskedit57.Text + maskedit54.Text;

 end
 else
 begin

  etc:=maskedit20.Text+maskedit21.Text+maskedit22.Text+maskedit23.Text;
  etc:=etc+maskedit24.Text+maskedit25.Text+maskedit26.Text+maskedit27.Text;
  etc:=etc+maskedit28.Text+maskedit29.Text+maskedit30.Text;
  etc:=etc+maskedit31.Text+maskedit32.Text;

 end;
 edit1.Text:=edit1.Text+etc+maskedit6.Text+maskedit7.Text+maskedit8.Text;
end;

procedure Teight.TntBitBtn2Click(Sender: TObject);
var i : integer;
    url : Widestring;
begin
  url:='';
  for i:=0 to 1000 do
  begin
   if BibUsmarcstx[i].tag = '008' then
   begin
    url:=BibUsmarcstx[i].marc_help_url;
    break;
   end;
  end;
  if url = '' then WideShowMessage('No help available')
  else ShellExecuteW(handle, 'Open', PWideChar(url), NiL, NiL, SW_SHOWNORMAL);
end;

end.
