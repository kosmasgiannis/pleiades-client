unit zlookup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ComCtrls, inifiles,zoomit,common,
  TntStdCtrls, TntGrids, Buttons, TntComCtrls, TntForms, TntButtons,
  WideIniClass, mycharconversion, DateUtils, TntDialogs, TntClasses, ImgList,
  TntExtCtrls,
  ActnList, TntActnList;

type
  Tzlookupform = class(TTntForm)
    browseresults: TTntStringGrid;
    scanfield: TTntComboBox;
    scanterm: TTntEdit;
    nextscan: TTntBitBtn;
    prevscan: TTntBitBtn;
    browseerrors: TTntMemo;
    Scan: TTntBitBtn;
    TntActionList1: TTntActionList;
    Action1: TTntAction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure prevscanClick(Sender: TObject);
    procedure nextscanClick(Sender: TObject);
    procedure ScanClick(Sender: TObject);
    procedure ScanClick2(Sender: TObject);
    procedure browsepageEnter(Sender: TObject);
    procedure GenericScan(scanquery : Widestring; start: integer);
    procedure browseresultsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure browseresultsDblClick(Sender: TObject);
  private
    { Private declarations }
    mouseposx, mouseposy : integer;
  public
    { Public declarations }
    cmdnames, // Commands as displayed in comboboxes.
    cmds,     // RPN commands attributes.
    zcmdkeys // internal presentation of search commands.
             : TStrings;
  scanset, recordset : TTntStrings;
  myzprofile, myzhost, myzproxy, myzport,myzdatabase,myzcharset : string;
  displayedrecords : integer;
  recordd : integer;
  lookupcommand : string;
  selected_term : Widestring;
 
  end;

var
  zlookupform: Tzlookupform;


const MAXSEARCHFIELDS = 9;
      MAXSORTFIELDS = 3;
      RECORDS_PER_REQUEST = 1000;
      SCAN_RESULTS_PER_PAGE = 25;

implementation

uses MainUnit, DataUnit, MARCEditor, MyAccess;


{$R *.dfm}

procedure Tzlookupform.FormCreate(Sender: TObject);
begin
 KeyPreview := True;
 recordset :=TTntstringlist.Create;
 scanset :=TTntstringlist.Create;
end;

procedure Tzlookupform.FormActivate(Sender: TObject);
var path, myinifname,
    langcode : string;
    myIniFile : TIniFile;
    p : integer;
begin
  path:=extractfilepath(paramstr(0));
  myinifname := path+'pleiades.ini';
  MyIniFile := TIniFile.Create(myinifname);
  with MyIniFile do
  begin
   myzhost := ReadString(FastRecordCreator.currentdatabase,'myzhost', '');
   myzport := ReadString(FastRecordCreator.currentdatabase,'myzport', '');
   myzdatabase := ReadString(FastRecordCreator.currentdatabase,'myzdatabase', '');
   myzcharset := ReadString(FastRecordCreator.currentdatabase,'myzcharset', 'UTF8');
   myzprofile := ReadString(FastRecordCreator.currentdatabase,'myzprofile', 'myzebcommands');
   myzproxy := ReadString(FastRecordCreator.currentdatabase,'myzproxy', '');
  end;
  MyIniFile.Free;


 path:=extractfilepath(paramstr(0));
 myinifname := path+'zparams.ini';

 zcmdkeys:=Tstringlist.Create;
 zcmdkeys.Clear;
 cmdnames:=Tstringlist.Create;
 cmdnames.Clear;

 langcode:='en';
 MyIniFile := TIniFile.Create(myinifname);
 with MyIniFile do
 begin
  ReadSectionValues('myzebcommands_descr.'+langcode,zcmdkeys);
  for p:=0 to zcmdkeys.Count -1 do
   cmdnames.Add(zcmdkeys.ValueFromIndex[p]);
 end;

 myinifile.free;

 if findcomponent('scanfield') <> nil then
 begin
  with Tcombobox(findcomponent('scanfield')) do
  begin
   items.Clear;
   items.Assign(cmdnames);
   itemindex:=0;
  end;
 end;

 cmdnames.Free;
end;

procedure Tzlookupform.FormShow(Sender: TObject);
begin
 displayedrecords:=0;
 SetLength(ZebraRecnos, 0);
 if zlookupform.lookupcommand <> '' then
 begin
   scanfield.Visible := false;
 end;
end;

procedure Tzlookupform.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 zcmdkeys.Free;
end;

procedure Tzlookupform.FormKeyPress(Sender: TObject; var Key: Char);
var acontrol: string;
begin
 if key = #27 then Close
 else if key =#13 then // enter is pressed
 begin
   acontrol := lowercase(activecontrol.Name);
   if ((acontrol='scanterm') or (acontrol = 'scanfield')) then
   begin
    ScanClick(Sender);
    exit;
   end;
 end;
end;

procedure Tzlookupform.GenericScan(scanquery : Widestring; start: integer);
var i, scanrows : integer;
begin
 browseerrors.Lines.Clear;

 screen.Cursor:=crhourglass;
 zoom_hosts[1].lastscanquery:=scanquery;

 scanset.Free;
 scanset:=TTntstringlist.Create;
 browseresults.RowCount:=2;
 browseresults.FixedRows:=1;
 browseresults.Cells[0,1]:='';
 browseresults.Cells[1,1]:='';
 browseresults.Cells[2,1]:='';
 browseerrors.lines.add(zoom_hosts[1].name+' '+zoom_hosts[1].scharset+ ' '+scanquery);

 browseresults.Cells[0,0]:='#';
 browseresults.Cells[1,0]:='Term';
 browseresults.Cells[2,0]:='Hits';
 scanset.Clear;
 scanrows:=zscan(zoom_hosts[1],scanquery,start,SCAN_RESULTS_PER_PAGE,scanset);
 if scanrows <=0 then browseresults.RowCount:=2
 else browseresults.RowCount:=scanrows+1;
 browseresults.FixedRows:=1;
 if scanrows > 0 then
 begin
  for i:=0 to ((scanset.Count div 3)-1) do
  begin
   browseresults.Cells[0,i+1]:=scanset[(i*3)+0];
   browseresults.Cells[1,i+1]:=scanset[(i*3)+1];
   browseresults.Cells[2,i+1]:=scanset[(i*3)+2];
  end;
 end;
 screen.Cursor:=crdefault;
end;

procedure Tzlookupform.ScanClick(Sender: TObject);
var //no,
    itidx : integer;
    //foo: string;
    scanquery,q2 : widestring;
    myinifile2 : TWideIniFile;
begin
 //foo := TTntBitbtn(sender).Name;
 //no:=strtoint(copy(foo,length(foo),1));

 zoom_hosts[1].name:='MyzDatabase';
 zoom_hosts[1].host:=myzhost;
 zoom_hosts[1].port:=myzport;
 zoom_hosts[1].database:=myzdatabase;
 zoom_hosts[1].proxy:=myzproxy;
 zoom_hosts[1].active:=true;
 zoom_hosts[1].errorcode:=0;
 zoom_hosts[1].errorstring:='';
 zoom_hosts[1].format:='Usmarc';
 zoom_hosts[1].scharset:=UpperCase(myzcharset);
 zoom_hosts[1].dcharset:=UpperCase(myzcharset);
 zoom_hosts[1].profile:=myzprofile;
 zoom_hosts[1].mark:=0;
 zoom_hosts[1].hits:=0;

 MyIniFile2 := TWideIniFile.Create(extractfilepath(paramstr(0))+'zparams.ini');
 cmds:=Tstringlist.Create;
 cmds.Clear;

 with MyIniFile2 do
 begin
  ReadSectionValues(zoom_hosts[1].profile,cmds);
 end;
 myinifile2.free;

 scanquery:='';

 if (TTntEdit(FindComponent('scanterm')).Text <> '') then
   scanquery := TTntEdit(FindComponent('scanterm')).Text
 else
   scanquery := '0';
 if zlookupform.lookupcommand <> '' then
 begin
   if cmds.indexofname(zlookupform.lookupcommand) <> -1 then
     scanquery:=cmds.ValueFromIndex[cmds.indexofname(zlookupform.lookupcommand)]+' "'+scanquery+'"';
 end
 else
 begin
   if (FindComponent('scanfield') <> nil) then
   begin
     itidx:=TTntComboBox(FindComponent('scanfield')).ItemIndex;
     q2:=copy(zcmdkeys[itidx],1,pos('=',zcmdkeys[itidx])-1);
//wideshowmessage(q2);
     if cmds.indexofname(q2) <> -1 then
      scanquery:=cmds.ValueFromIndex[cmds.indexofname(q2)]+' "'+scanquery+'"';
   end;
 end;
 zoom_hosts[1].lastscanquery:=scanquery;

 Genericscan(scanquery,1);
 cmds.Free;

end;

procedure Tzlookupform.ScanClick2(Sender: TObject);
var //no,
    i, scanrows, itidx : integer;
    //foo: string;
    scanquery,q2 : widestring;
    myinifile2 : TWideIniFile;
begin
 //foo := TTntBitbtn(sender).Name;
 //no:=strtoint(copy(foo,length(foo),1));

 zoom_hosts[1].name:='MyzDatabase';
 zoom_hosts[1].host:=myzhost;
 zoom_hosts[1].port:=myzport;
 zoom_hosts[1].database:=myzdatabase;
 zoom_hosts[1].proxy:=myzproxy;
 zoom_hosts[1].active:=true;
 zoom_hosts[1].errorcode:=0;
 zoom_hosts[1].errorstring:='';
 zoom_hosts[1].format:='Usmarc';
 zoom_hosts[1].scharset:=UpperCase(myzcharset);
 zoom_hosts[1].dcharset:=UpperCase(myzcharset);
 zoom_hosts[1].profile:=myzprofile;
 zoom_hosts[1].mark:=0;
 zoom_hosts[1].hits:=0;

 MyIniFile2 := TWideIniFile.Create(extractfilepath(paramstr(0))+'zparams.ini');
 cmds:=Tstringlist.Create;
 cmds.Clear;

 with MyIniFile2 do
 begin
  ReadSectionValues(zoom_hosts[1].profile,cmds);
 end;
 myinifile2.free;

 scanquery:='';
 zoom_hosts[1].lastscanquery:=scanquery;

 browseerrors.Lines.Clear;

 if (TTntEdit(FindComponent('scanterm')).Text <> '') then
 begin
   screen.Cursor:=crhourglass;
   scanquery := TTntEdit(FindComponent('scanterm')).Text;
   if (FindComponent('scanfield') <> nil) then
   begin
     itidx:=TTntComboBox(FindComponent('scanfield')).ItemIndex;
     q2:=copy(zcmdkeys[itidx],1,pos('=',zcmdkeys[itidx])-1);
     if cmds.indexofname(q2) <> -1 then
      scanquery:=cmds.ValueFromIndex[cmds.indexofname(q2)]+' "'+scanquery+'"';
   end;

   zoom_hosts[1].lastscanquery:=scanquery;

   scanset.Free;
   scanset:=TTntstringlist.Create;
   browseresults.RowCount:=2;
   browseresults.FixedRows:=1;
   browseresults.Cells[0,1]:='';
   browseresults.Cells[1,1]:='';
   browseresults.Cells[2,1]:='';
   browseerrors.lines.add(zoom_hosts[1].name+' '+zoom_hosts[1].scharset+ ' '+scanquery);

  browseresults.Cells[0,0]:='#';
  browseresults.Cells[1,0]:='Term';
  browseresults.Cells[2,0]:='Hits';
  scanset.Clear;
  scanrows:=zscan(zoom_hosts[1],scanquery,1,SCAN_RESULTS_PER_PAGE,scanset);
  if scanrows = 0 then browseresults.RowCount:=scanrows+2
  else browseresults.RowCount:=scanrows+1;
  browseresults.FixedRows:=1;
  if scanrows > 0 then
  begin
   for i:=0 to ((scanset.Count div 3)-1) do
   begin
    browseresults.Cells[0,i+1]:=scanset[(i*3)+0];
    browseresults.Cells[1,i+1]:=scanset[(i*3)+1];
    browseresults.Cells[2,i+1]:=scanset[(i*3)+2];
   end;

  end;
  cmds.Free;
  screen.Cursor:=crdefault;
 end
 else
 begin
  wideshowmessage('Please specify a starting term');
 end;

end;


procedure Tzlookupform.prevscanClick(Sender: TObject);
var lastterm, scanquery : widestring;
begin
 zoom_hosts[1].name:='MyzDatabase';
 zoom_hosts[1].host:=myzhost;
 zoom_hosts[1].port:=myzport;
 zoom_hosts[1].database:=myzdatabase;
 zoom_hosts[1].proxy:=myzproxy;
 zoom_hosts[1].active:=true;
 zoom_hosts[1].errorcode:=0;
 zoom_hosts[1].errorstring:='';
 zoom_hosts[1].format:='Usmarc';
 zoom_hosts[1].scharset:=UpperCase(myzcharset);
 zoom_hosts[1].dcharset:=UpperCase(myzcharset);
 zoom_hosts[1].profile:=myzprofile;
 zoom_hosts[1].mark:=0;
 zoom_hosts[1].hits:=0;

 scanquery:=zoom_hosts[1].lastscanquery;
 if scanquery<> '' then
 begin
  lastterm :=browseresults.Cells[1,1];
  if lastterm <> '' then
  begin
   scanquery:=copy(scanquery,1,pos('"',scanquery)-1);
   scanquery := scanquery+'"'+lastterm+'"';
   zoom_hosts[1].lastscanquery:=scanquery;
   Genericscan(scanquery,SCAN_RESULTS_PER_PAGE);
  end
  else
  begin
   wideshowmessage('Please specify a starting term and click the Scan button.');
  end;
 end
 else
  begin
   wideshowmessage('Please specify a starting term and click the Scan button.');
  end;
end;

procedure Tzlookupform.nextscanClick(Sender: TObject);
var lastrow : integer;
    lastterm, scanquery : widestring;
begin

 zoom_hosts[1].name:='MyzDatabase';
 zoom_hosts[1].host:=myzhost;
 zoom_hosts[1].port:=myzport;
 zoom_hosts[1].database:=myzdatabase;
 zoom_hosts[1].proxy:=myzproxy;
 zoom_hosts[1].active:=true;
 zoom_hosts[1].errorcode:=0;
 zoom_hosts[1].errorstring:='';
 zoom_hosts[1].format:='Usmarc';
 zoom_hosts[1].scharset:=UpperCase(myzcharset);
 zoom_hosts[1].dcharset:=UpperCase(myzcharset);
 zoom_hosts[1].profile:=myzprofile;
 zoom_hosts[1].mark:=0;
 zoom_hosts[1].hits:=0;

 scanquery:=zoom_hosts[1].lastscanquery;
 if scanquery<> '' then
 begin
  lastrow:=browseresults.RowCount-1;
  if lastrow = SCAN_RESULTS_PER_PAGE then
  lastterm :=browseresults.Cells[1,lastrow];
  if lastterm <> '' then
  begin
   scanquery:=copy(scanquery,1,pos('"',scanquery)-1);
   scanquery := scanquery+'"'+lastterm+'"';
   zoom_hosts[1].lastscanquery:=scanquery;
   Genericscan(scanquery,1);
  end
  else
  begin
   wideshowmessage('No more results.');
  end;
 end
 else
  begin
   wideshowmessage('Please specify a starting term and click the Scan button.');
  end;
end;

procedure Tzlookupform.browsepageEnter(Sender: TObject);
begin
 Activecontrol:=scanterm;
end;

procedure Tzlookupform.browseresultsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 mouseposx := x;
 mouseposy := y;
end;

procedure Tzlookupform.browseresultsDblClick(Sender: TObject);
var
  Column, Row: Longint;
begin
// showmessage(inttostr(mouseposx)+' '+inttostr(mouseposy));
 browseresults.MouseToCell(mouseposX, mouseposY, Column, Row);
 if Row > 0 then
  selected_term:=browseresults.Cells[1, Row];
 Close;
end;

end.
