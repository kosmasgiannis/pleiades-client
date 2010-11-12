unit PrettyMARCUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, Buttons, Grids, TntStdCtrls,
  TntGrids, TntButtons, TntForms, cUnicodeCodecs;

type
  TPrettyMARCForm = class(TTntForm)
    go: TTntButton;
    BitBtn1: TTntBitBtn;
    GroupBox1: TTntGroupBox;
    Label5: TTntLabel;
    Label6: TTntLabel;
    maxlen: TTntEdit;
    separator: TTntEdit;
    StringGrid1: TTntStringGrid;
    Edit3: TTntEdit;
    Label1: TTntLabel;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    TntMemo1: TTntMemo;
    BitBtn4: TTntBitBtn;
    CheckBox1: TTntCheckBox;
    CheckBox2: TTntCheckBox;
    procedure goClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure maxlenKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure SetConfig;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrettyMARCForm: TPrettyMARCForm;
  labelval,taginfo : array of string;//[1..1000]
  scnt : integer;

const
 punctuation = ' .,;:\|[]{}-_+=)(*&^%$#@!';

implementation

{$R *.dfm}

uses mycharconversion, DataUnit, common, ReportsUnit, ProgresBarUnit,
  MainUnit, StrUtils, utility;

function get_lenchars(s : string; len: integer) : integer;
var  r:string;
     i:integer;
begin
 if ((length(s) <= len) or (len=0)) then
 begin
  result:=length(s);
  exit;
 end;
 r:=copy(s,1,len);
 for i:=len downto 1 do
 begin
  if (pos(r[i],punctuation)>0) then
  begin
   result := i;
   exit;
  end;
 end;
 result:=len;
end;

function extract_field(s : string; f: string; which : integer; keepsfd : boolean) : string;
var i:integer;
 cf : char;
 flag : boolean;
 r:string;
 current: integer;
begin
 flag:=false;
 r:='';
 i:=1;
 current:=0;
 while i <= length(s) do
 begin
  if s[i] = #31 then
  begin
   i:=i+1;
   cf := s[i];
   if (pos(cf,f)>0) then
   begin
    current :=current+1;
    if ((current=which) or (which=0)) then
    begin
     flag :=true;
     if keepsfd then
      r:=r+#31+cf
     else
      r:=r+' ';
    end;
    if ((which <> 0) and (current>which)) then break;
   end
   else
    flag:=false;
   i:=i+1;
  end
  else
  begin
   if (flag) then
    r:=r+s[i];
   i:=i+1;
  end;
 end;
 if ((r <>'') and (keepsfd=false))
  then r:= copy(r,2,length(r));
 result := r;
end;

procedure TPrettyMARCForm.SetConfig;
var
  i : integer;
  tag, lab : string;
begin
   SetLength(labelval, 0);
   SetLength(taginfo, 0);
  i:=1;
  while i < StringGrid1.RowCount do
    begin
      tag := Trim(StringGrid1.Cells[0, i]);
      tag := tag + trim(StringGrid1.Cells[1, i]);
      tag := tag + trim(StringGrid1.Cells[2, i]);
      tag := tag + trim(StringGrid1.Cells[3, i]);
      lab := trim(StringGrid1.Cells[4, i]);
      SetLength(labelval, i);
      SetLength(taginfo, i);
      labelval[i-1]:=lab;
      taginfo[i-1]:=tag;
      i:=i+1;
    end;
  scnt := i-1;
end;

procedure TPrettyMARCForm.goClick(Sender: TObject);
var
  fo:Textfile; //fi,  fs,
  flag,proc : boolean;
//    labelval,taginfo : array [1..1000] of string;
  hlp,tag,text,indic,elabel,plabel,mrcout,mrcin : String;//
  cnt,p,base, start,just,leng,numoffields : integer;//i, k,,x  scnt,
  count : integer;

procedure PrettyProc;
var
  i, k, x : integer;
begin
     mrcin:=MakeMRCFromBasket;
      flag:=false;
      cnt:=cnt+1;
      if CheckBox1.Checked then writeln(fo,'- ',cnt,'. -');
      
       plabel:='';
       elabel:='';
       for i := 0 to scnt-1 do
       begin
        if plabel<>labelval[i] then
        begin
         plabel:=labelval[i];
         elabel:=plabel;
        end;
        hlp := copy(mrcin,13,5);
        base := strtoint(hlp);
        numoffields := (base - 1 -24) div 12;
        p := 25;
        for k:=1 to numoffields do
        begin
         hlp := copy(mrcin,p,12);
         tag := copy(hlp,1,3);
         leng:=strtoint(copy(hlp,4,4));
         start:=base+strtoint(copy(hlp,8,5));
         text := copy(mrcin,start+1,leng-1);
         proc:=false;
         if (tag = copy(taginfo[i],1,3)) then proc:=true;
         if (not proc) then
          for x:=3 downto 1 do
          begin
           tag[x]:='X';
           if (tag = copy(taginfo[i],1,3)) then begin proc:=true; break; end;
          end;
         tag := copy(hlp,1,3);
         if proc then
         begin
          if strtointdef(tag,0)>=10 then
          begin
           proc:=false;
           indic:=copy(text,1,2);
//          text:=copy(text,3,length(text));
           if (indic = copy(taginfo[i],4,2)) then proc:=true;
           if (not proc) then
            for x:=2 downto 1 do
            begin
             indic[x]:='?';
             if (indic = copy(taginfo[i],4,2)) then begin proc:=true; break; end;
            end;
          end;
          if proc then
          begin
           if plabel = elabel then
           begin
            write(fo,plabel,':');
            elabel:='';
            for x:=1 to length(plabel) do elabel:=elabel+' ';
           end
           else write(fo,elabel,' ');
           hlp:=copy(taginfo[i],6,length(taginfo[i]));
           if hlp='*' then hlp:='abcdefghijklmnopqrstuvwxyz0123456789';
           if strtointdef(tag,0)>=10 then
            text:=extract_field(text,hlp,0,false);
           just := get_lenchars(text,strtointdef(maxlen.Text,0));
           writeln(fo,copy(text,1,just));
           text:=copy(text,just+1,length(text));
           while (text <> '') do
           begin
            just := get_lenchars(text,strtointdef(maxlen.Text,0));
            writeln(fo,elabel,' ',copy(text,1,just));
            text:=copy(text,just+1,length(text));
           end;
          end;
         end;
         p:=p+12;
        end;
       end;
       writeln(fo,separator.text);
end;
begin
  if Edit3.Text = '' then
    begin
      ShowMessage('Configuration is empty...');
      ModalResult := mrNone;
      exit;
    end;

  SetConfig;

 FastRecordCreator.SaveDialog1.FileName := '';
 FastRecordCreator.SaveDialog1.Filter := 'TXT files (*.txt)|*.txt|All Files (*.*)|*.*';
 FastRecordCreator.SaveDialog1.FilterIndex := 1;
 FastRecordCreator.SaveDialog1.DefaultExt := 'txt';
 if (FastRecordCreator.savedialog1.Execute) then
   begin
    AssignFile(fo,FastRecordCreator.savedialog1.FileName);
    if scnt <> 0 then Rewrite(fo)
    else
      begin
        ShowMessage('No records matc');
        ModalResult := mrCancel;
        Exit;
      end;
   end
 else
   begin
    showmessage('Specify a valid file for output');
    ModalResult := mrNone;
    Exit;
   end;

 mrcin:='';
  data.basket.First;
   mrcin:='';
   mrcout:='';
   cnt:=0;
   Screen.Cursor:=crHourGlass;
   flag := false;

   ProgresBarForm.Show;
   ProgresBarForm.ProgressBar1.Position := 0;
   ProgresBarForm.ProgressBar1.Visible := true;
   ProgresBarForm.ProgressBar1.Min := 0;
   if ReportsForm.IfList then ProgresBarForm.ProgressBar1.Max := Length(FastRecordCreator.List)
   else ProgresBarForm.ProgressBar1.Max :=  Data.basket.RecordCount;

   if ReportsForm.IfList then
    for count := 0 to Length(FastRecordCreator.List)-1 do
      begin
        if not Data.basket.Locate('recno', FastRecordCreator.List[count], [])then continue;
        PrettyProc;
        ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+IntToStr(FastRecordCreator.List[count]);
        ProgresBarForm.ProgressBar1.Position := count + 1;
        Application.ProcessMessages;
      end
   else
    while not data.basket.Eof do
      begin
        PrettyProc;
        ProgresBarForm.Label2.Caption := 'Exporting RecNo:  '+data.basket.fieldbyname('recno').AsString;
        ProgresBarForm.ProgressBar1.Position := Data.basket.RecNo;
        Application.ProcessMessages;
        Data.basket.Next;
      end;

   ProgresBarForm.Close;
   Screen.Cursor:=crdefault;
   CloseFile(fo);
end;

procedure TPrettyMARCForm.Exit1Click(Sender: TObject);
begin
Terminate_Program;
end;

procedure TPrettyMARCForm.maxlenKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((key in ['0'..'9'])or(key=#8)) then key := #0;//key=chr(8)
end;

procedure TPrettyMARCForm.BitBtn2Click(Sender: TObject);
var
//  scnt : integer;
  fs : TextFile;
  mrcin, temp : String;
  lab, tag, s : string;
  i : integer;
begin
  StringGrid1.RowCount := 2;
  StringGrid1.Cells[0,1] := '';
  StringGrid1.Cells[1,1] := '';
  StringGrid1.Cells[2,1] := '';
  StringGrid1.Cells[3,1] := '';
  StringGrid1.Cells[4,1] := '';
  StringGrid1.Cells[5,1] := '';
  StringGrid1.Cells[6,1] := '';
  StringGrid1.Cells[7,1] := '';
 FastRecordCreator.OpenDialog1.FileName := '';
 FastRecordCreator.OpenDialog1.Filter := 'TXT files (*.txt)|*.txt|All Files (*.*)|*.*';
 FastRecordCreator.OpenDialog1.FilterIndex := 0; { start the dialog showing all files }
 if FastRecordCreator.opendialog1.Execute then Edit3.Text := FastRecordCreator.OpenDialog1.FileName;
  i:=0;
  AssignFile(fs,edit3.Text);
  Reset(fs);
  while(eof(fs)=false) do
  begin
   i:=i+1; tag := '';
   readln(fs,mrcin);
   temp := mrcin;
   delete(temp, 1, 1);

   s := LeftStr(temp, pos('|', temp)-1);
   tag := tag + trim(s);
   delete(temp, 1, pos('|', temp));
   StringGrid1.Cells[0, i] := s;
   s := LeftStr(temp, pos('|', temp)-1);
   tag := tag + trim(s);
   delete(temp, 1, pos('|', temp));
   StringGrid1.Cells[1, i] := s;
   s := LeftStr(temp, pos('|', temp)-1);
   tag := tag + trim(s);
   delete(temp, 1, pos('|', temp));
   StringGrid1.Cells[2, i] := s;
   s := LeftStr(temp, pos('|', temp)-1);
   tag := tag + trim(s);
   delete(temp, 1, pos('|', temp));
   StringGrid1.Cells[3, i] := s;
   s := LeftStr(temp, pos('|', temp)-1);
   lab := trim(s);
   StringGrid1.Cells[4, i] := lab;
   StringGrid1.RowCount := 1+i;

   delete(temp, 1, pos('|', temp));
   s := LeftStr(temp, pos('|', temp)-1);
   StringGrid1.Cells[5, i] := s;;

   delete(temp, 1, pos('|', temp));
   s := LeftStr(temp, pos('|', temp)-1);
   StringGrid1.Cells[6, i] := s;

   delete(temp, 1, pos('|', temp));
   s := LeftStr(temp, pos('|', temp)-1);
   StringGrid1.Cells[7, i] := s;
  end;
  Closefile(fs);
end;

procedure TPrettyMARCForm.FormActivate(Sender: TObject);
begin
  StringGrid1.Cells[0,0] := 'TAG';
  StringGrid1.Cells[1,0] := 'IND1';
  StringGrid1.Cells[2,0] := 'IND2';
  StringGrid1.Cells[3,0] := 'Subfields';
  StringGrid1.Cells[4,0] := 'Label';
  StringGrid1.Cells[5,0] := 'Prefix';
  StringGrid1.Cells[6,0] := 'Suffix';
  StringGrid1.Cells[7,0] := 'Newline';

end;

procedure TPrettyMARCForm.BitBtn3Click(Sender: TObject);
var
  fs : TextFile;
  i : integer;
  temp : string;
begin
 FastRecordCreator.SaveDialog1.FileName := '';
 FastRecordCreator.SaveDialog1.Filter := 'TXT files (*.txt)|*.txt|All Files (*.*)|*.*';
 FastRecordCreator.SaveDialog1.FilterIndex := 0; { start the dialog showing all files }
 FastRecordCreator.SaveDialog1.DefaultExt := 'txt';
 if FastRecordCreator.SaveDialog1.Execute then Edit3.Text := FastRecordCreator.SaveDialog1.FileName;
  AssignFile(fs,edit3.Text);
  Rewrite(fs);
  for i := 1 to StringGrid1.RowCount-1 do
  begin
    temp := '|' + StringGrid1.Cells[0, i] + '|';
    temp := temp + StringGrid1.Cells[1, i] + '|';
    temp := temp + StringGrid1.Cells[2, i] + '|';
    temp := temp + StringGrid1.Cells[3, i] + '|';
    temp := temp + StringGrid1.Cells[4, i] + '|';
    temp := temp + StringGrid1.Cells[5, i] + '|';
    temp := temp + StringGrid1.Cells[6, i] + '|';
    temp := temp + StringGrid1.Cells[7, i] + '|';
    Writeln(fs, temp);
  end;
  Closefile(fs);

end;

procedure TPrettyMARCForm.BitBtn4Click(Sender: TObject);
var
  i, k, cc, x : integer;
  mrcin, plabel, elabel, hlp, tag, indic : WideString;
  proc : boolean;
  cnt, base, numoffields, p, leng, start, just : integer;
  temp : WideString;
begin
  SetConfig;
  TntMemo1.Clear;
  Data.basket.First;
  cnt := 0;
  for cc := 1 to 4 do
    begin
     mrcin:=MakeMRCFromBasket;
      cnt:=cnt+1;
      if CheckBox1.Checked then
        TntMemo1.Lines.Add('- '+inttostr(cnt)+'. -');

       plabel:='';
       elabel:='';
       for i := 0 to scnt-1 do
       begin
        if plabel<>labelval[i] then
        begin
         plabel:=labelval[i];
         elabel:=plabel;
        end;
        hlp := copy(mrcin,13,5);
        base := strtoint(hlp);
        numoffields := (base - 1 -24) div 12;
        p := 25;
        for k:=1 to numoffields do
        begin
         hlp := copy(mrcin,p,12);
         tag := copy(hlp,1,3);
         leng:=strtoint(copy(hlp,4,4));
         start:=base+strtoint(copy(hlp,8,5));
         text := copy(mrcin,start+1,leng-1);
         proc:=false;
         if (tag = copy(taginfo[i],1,3)) then proc:=true;
         if (not proc) then
          for x:=3 downto 1 do
          begin
           tag[x]:='X';
           if (tag = copy(taginfo[i],1,3)) then begin proc:=true; break; end;
          end;
         tag := copy(hlp,1,3);
         if proc then
         begin
          if strtointdef(tag,0)>=10 then
          begin
           proc:=false;
           indic:=copy(text,1,2);
           if (indic = copy(taginfo[i],4,2)) then proc:=true;
           if (not proc) then
            for x:=2 downto 1 do
            begin
             indic[x]:='?';
             if (indic = copy(taginfo[i],4,2)) then begin proc:=true; break; end;
            end;
          end;
          if proc then
          begin
           if plabel = elabel then
           begin
            temp := plabel+':';
            elabel:='';
            for x:=1 to length(plabel) do elabel:=elabel+' ';
           end
           else temp := elabel+' ';//write(fo,elabel,' ');
           hlp:=copy(taginfo[i],6,length(taginfo[i]));
           if hlp='*' then hlp:='abcdefghijklmnopqrstuvwxyz0123456789';
           if strtointdef(tag,0)>=10 then
            text:=extract_field(text,hlp,0,false);
           just := get_lenchars(text,strtointdef(maxlen.Text,0));
            TntMemo1.Lines.Add(UTF8StringToWideString(temp+copy(text,1,just)));
           text:=copy(text,just+1,length(text));
           while (text <> '') do
           begin
            just := get_lenchars(text,strtointdef(maxlen.Text,0));
            TntMemo1.Lines.Add(UTF8StringToWideString(elabel+' '+copy(text,1,just)));
            text:=copy(text,just+1,length(text));
           end;
          end;
         end;
         p:=p+12;
        end;
       end;
        TntMemo1.Lines.Add(separator.text);

      Data.basket.Next;
    end;
end;

procedure TPrettyMARCForm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  style : integer;
//  b : boolean;
//  chk : TCheckBox;
begin
  CheckBox2.Visible := false;
  if (gdFocused in State) then
    begin
      if (ACol=7)and(ARow>0) then
        begin
          if StrToBool(StringGrid1.Cells[ACol, ARow]) then
            Style := DFCS_CHECKED
          else style := DFCS_BUTTONCHECK;
          StringGrid1.Canvas.FillRect(Rect);

          DrawFrameControl(TStringGrid(Sender).Canvas.Handle, Rect, DFC_BUTTON, Style);
        end;
    end;
end;

end.
