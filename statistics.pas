unit statistics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntStdCtrls, ComCtrls, Grids, TntGrids;

type
  TstatisticsForm = class(TForm)
    stat_results: TTntStringGrid;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker1: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure stat_resultsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    function makequery(tab:string; which : integer):string;
  public
    { Public declarations }
  end;

  stat_rec = record
      usercode : integer;
      username : widestring;
      sb, si: integer;
  end;

var
  statisticsForm: TstatisticsForm;
  user_stat : array[1..256] of stat_rec;
  user_stat_dim : integer;
implementation

uses DataUnit, MainUnit, utility;

{$R *.dfm}

function load_users:integer;
var b:integer;
begin
  b:=0;
  with data.query1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select usercode,concat(users.userfirstname," ", users.userlastname) FROM users Order by usercode');
    Execute;
    First;
    while not Eof do
    begin
      b:=b+1;
      user_stat[b].usercode:=Fields[0].AsInteger;
      user_stat[b].username:=Fields[1].AsString;
      user_stat[b].sb:=0;
      user_stat[b].si:=0;
      Next;
    end;
  end;
  user_stat_dim:=b;
  result:=b;
end;

procedure update_user_stat(usercode : integer; key:string; value:integer);
var i : integer;
begin
  for i:=1 to user_stat_dim do
  begin
    if user_stat[i].usercode = usercode then
    begin
      if key = 'bib' then user_stat[i].sb:=value
      else if key = 'item' then user_stat[i].si := value;
      break;
    end;
  end;
end;

function TstatisticsForm.makequery(tab:string; which : integer):string;
var  s, dd: string;
     todadat : TDate;
     TempDateFormat : string;
begin
  result := '';
  if tab = 'basket' then dd := 'created'
  else dd := 'datecreated';
  TempDateFormat := ShortDateFormat;
  ShortDateFormat := 'yyyy-mm-dd';
  if which = 1 then
    s := ' WHERE users.usercode='+tab+'.creator '
  else
    s := ' WHERE 1=1';

  if DateTimePicker1.Checked Then
  begin
    todadat := DateTimePicker1.Date;
    s:= s + ' and ('+dd+' >= "'+DateToStr(todadat)+'")';
  end;

  if DateTimePicker2.Checked Then
  begin
    todadat := DateTimePicker2.Date;
    s:= s + ' and ('+dd+' <= "'+DateToStr(todadat)+'")';
  end;

  if which = 1 then
    result := 'SELECT count('+tab+'.recno), users.usercode, concat(users.userfirstname," ", users.userlastname) FROM users, '+tab+' ' + s+' Group by '+tab+'.creator'
  else
    result := 'SELECT count(distinct '+dd+') FROM '+tab+' ' + s;
end;

procedure TstatisticsForm.BitBtn1Click(Sender: TObject);
var  nod, sb,si, b, e : integer;
x : TRect;
begin
  Clear_String_Grid(stat_results);
  load_users;
  sb:=0;
  si:=0;
  nod := 0;
  with data.query1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(makequery('basket',2));
    Execute;
    First;
    while not Eof do
    begin
      nod:=Fields[0].asinteger;
      Next;
    end;
  end;

  with data.query1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(makequery('basket',1));
    //showmessage(sql.Text);
    Execute;
    First;
    while not Eof do
    begin
      update_user_stat(Fields[1].AsInteger, 'bib', Fields[0].AsInteger);
      sb:=sb+Fields[0].asinteger;
      Next;
    end;
    Close;
    SQL.Clear;
    SQL.Add(makequery('items',1));
    //showmessage(sql.Text);
    Execute;
    First;
    while not Eof do
    begin
      update_user_stat(Fields[1].AsInteger, 'item', Fields[0].AsInteger);
      si:=si+Fields[0].asinteger;
      Next;
    end;

    stat_results.Cells[0,1] :=' ';
    stat_results.Cells[1,1] :='Total';
    stat_results.Cells[2,1] :=inttostr(sb);
    stat_results.Cells[3,1] :=inttostr(si);
    if (nod > 0) then
    begin
      stat_results.Cells[0,2] :=' ';
      stat_results.Cells[1,2] :='Average in '+inttostr(nod)+' days';
      stat_results.Cells[2,2] :=inttostr(sb div nod);
      stat_results.Cells[3,2] :=inttostr(si div nod);
    end;
    e:=3;
    for b:=1 to user_stat_dim do
    begin
      if (( user_stat[b].sb <> 0) or (user_stat[b].si <> 0)) then
      begin
        stat_results.Cells[0,e] :=inttostr(e-2);
        stat_results.Cells[1,e] :=user_stat[b].username;
        stat_results.Cells[2,e] :=inttostr(user_stat[b].sb);
        stat_results.Cells[3,e] :=inttostr(user_stat[b].si);
        x := stat_results.CellRect(2,e);
        e:=e+1;
      end;
    end;
  end;
  bitbtn2.Enabled := true;
end;

procedure TstatisticsForm.FormActivate(Sender: TObject);
begin
    datetimepicker1.DateTime := now;
    datetimepicker2.DateTime := now;
    Clear_String_Grid(stat_results);
    stat_results.Cells[0,0] := '#';
    stat_results.Cells[1,0] := 'UserName';
    stat_results.Cells[2,0] := 'Bibliographic';
    stat_results.Cells[3,0] := 'Items';
    bitbtn2.Enabled := false;
end;

procedure TstatisticsForm.stat_resultsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);


  procedure WriteText(StringGrid: TTntStringGrid; ACanvas: TCanvas; const ARect: TRect;
    const Text: WideString; Format: Word; acolor, bcolor : TColor);
  const
    DX = 2;
    DY = 2;
  var
    S: array[0..255] of Char;
//    B, R: TRect;
  begin
    with Stringgrid, ACanvas, ARect do
    begin
      Font.Color := acolor;
      Brush.Color := bcolor;
      case Format of
        DT_LEFT: ExtTextOut(Handle, Left + DX, Top + DY,
            ETO_OPAQUE or ETO_CLIPPED, @ARect, StrPCopy(S, Text), Length(Text), nil);

        DT_RIGHT: ExtTextOut(Handle, Right - TextWidth(Text) - 3, Top + DY,
            ETO_OPAQUE or ETO_CLIPPED, @ARect, StrPCopy(S, Text),
            Length(Text), nil);

        DT_CENTER: ExtTextOut(Handle, Left + (Right - Left - TextWidth(Text)) div 2,
            Top + DY, ETO_OPAQUE or ETO_CLIPPED, @ARect,
            StrPCopy(S, Text), Length(Text), nil);
      end;
    end;
  end;

  procedure Display(StringGrid: TTntStringGrid; const S: WideString; Alignment: TAlignment; Acolor, Bcolor : TColor);
  const
    Formats: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  begin
    WriteText(StringGrid, StringGrid.Canvas, Rect, S, Formats[Alignment], AColor, Bcolor);
  end;

var bgcolor : Tcolor;
begin

 if ((Arow = 0) or (ACol = 0)) then bgcolor:=clMedGray
 else
 begin
   if gdSelected in State then bgcolor := clLtGray
   else bgcolor:= clWhite;
 end;

 if ARow = 0 then
    Display(stat_results, stat_results.Cells[ACol, ARow], taCenter, CLBLUE, bgcolor)
 else if ARow in  [1..2] then
 begin
    if ACol in [2..3] then
       Display(stat_results, stat_results.Cells[ACol, ARow], taRightJustify, ClRed, bgcolor)
    else
       Display(stat_results, stat_results.Cells[ACol, ARow], taLeftJustify, ClRed,bgcolor)
 end
 else
 begin
   if ACol in [2..3] then
      Display(stat_results, stat_results.Cells[ACol, ARow], taRightJustify, ClGreen,bgcolor)
   else
      Display(stat_results, stat_results.Cells[ACol, ARow], taLeftJustify, ClOlive,bgcolor);
 end;
end;

procedure TstatisticsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if (key = #27) then Close;
end;

procedure TstatisticsForm.BitBtn2Click(Sender: TObject);
var F : TextFile;
begin
//
with fastrecordcreator do
begin
    SaveDialog1.FileName := '';
    SaveDialog1.Filter := 'TXT files (*.txt)|*.txt';
    SaveDialog1.FilterIndex := 1; { start the dialog showing all files }
    if SaveDialog1.Execute then
    begin
      AssignFile(FList,Savedialog1.FileName);
      ReWrite(F);

      CloseFile(F);
    end;
  end;
end;

end.
