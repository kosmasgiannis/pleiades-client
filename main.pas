unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, Buttons;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    go: TButton;
    language: TComboBox;
    Label4: TLabel;
    rdmarc: TRadioButton;
    rdlabels: TRadioButton;
    maxlen: TEdit;
    Label5: TLabel;
    separator: TEdit;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    procedure goClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure maxlenKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
 punctuation = ' .,;:\|[]{}-_+=)(*&^%$#@!';

implementation

{$R *.dfm}

uses mycharconversion, DataUnit, common, ReportsUnit, ProgresBarUnit,
  MainUnit;

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

procedure dump_marcrecord(marcrec : string; var f : Textfile; len:integer);
var
 i,p,base, start, leng : integer;
 hlp,tag,text : string;
 numoffields,j,just : integer;
begin
  writeln(f,'[LDR] ',copy(marcrec,1,24));
  hlp := copy(marcrec,13,5);
  base := strtoint(hlp);
  numoffields := (base - 1 -24) div 12;
  p := 25;
  for i:=1 to numoffields do
  begin
   hlp := copy(marcrec,p,12);
   tag := copy(hlp,1,3);
   leng:=strtoint(copy(hlp,4,4));
   start:=base+strtoint(copy(hlp,8,5));
   text := copy(marcrec,start+1,leng);
   for j:=1 to length(text) do
   begin
    if text[j] = #31 then text[j]:='$'
    else
     if text[j] = #30 then text[j] := ' ';
   end;
   text:=copy(text,1,length(text)-1);
   if len = 0 then
    writeln(f,'['+tag+'] ',text)
   else
   begin
    tag:='['+tag+'] ';
    just:=get_lenchars(text,len);

    writeln(f,tag,copy(text,1,just));
    text:=copy(text,just+1,length(text));
    tag:='      ';
    while (text<>'') do
    begin
     just:=get_lenchars(text,len);
     writeln(f,tag,copy(text,1,just));
     text:=copy(text,just+1,length(text));
    end;
   end;
   p:=p+12;
  end;
end;

procedure TForm1.goClick(Sender: TObject);
var fs,fo:Textfile; //fi,
    ch : char;
    flag,proc:boolean;
    labelval,taginfo : array [1..1000] of string;
    hlp,tag,text,indic,elabel,plabel,mrcin,mrcout : String;
    scnt,cnt,p,base, start,just,leng,numoffields : integer;//i, k,,x
    count : integer;
procedure PrettyProc;
var
  i, k, x : integer;
begin
     mrcin:=MakeMRCFromBasket;
      flag:=false;
      cnt:=cnt+1;
      writeln(fo,'- ',cnt,'. -');

{      Application.ProcessMessages;
      ProgresBarForm.ProgressBar1.Position := cnt;}

      if (rdmarc.Checked) then
      begin
       dump_marcrecord(mrcin,fo,100);
       writeln(fo,separator.text);
      end
      else
      begin
       plabel:='';
       elabel:='';
       for i := 1 to scnt do
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
end;
begin
 scnt:=0;
  AssignFile(fs,ReportsForm.edit3.Text);
  Reset(fs);
  while(eof(fs)=false) do
  begin
   readln(fs,mrcin);
   if ((mrcin[1] = '#') or (copy(mrcin,1,2) <> language.Text)) then
    continue;
   scnt:=scnt+1;
   mrcin:=copy(mrcin,4,length(mrcin));
   labelval[scnt]:=copy(mrcin,1,pos(':',mrcin)-1);
   taginfo[scnt]:=copy(mrcin,pos(':',mrcin)+1,length(mrcin));
  end;
  Closefile(fs);

 SaveDialog1.FileName := '';
 SaveDialog1.Filter := 'TXT files (*.txt)|*.txt|All Files (*.*)|*.*';
 SaveDialog1.FilterIndex := 1;
 if (savedialog1.Execute) then
   begin
    AssignFile(fo,savedialog1.FileName);
    Rewrite(fo);
   end
 else
   begin
    showmessage('Specify a valid file for output');
    ModalResult := mrNone;
    Exit;
   end;

 mrcin:='';
 //////////////////bayer///////bayer////////bayer//////////////////////////
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

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm1.maxlenKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((key in ['0'..'9'])or(key=#8)) then key := #0;//key=chr(8)
end;

end.
