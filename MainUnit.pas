unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Math, Dialogs, ExtCtrls, DB, MyAccess, ActnList, Menus, DateUtils,
  StdCtrls, ComCtrls, Registry, Buttons, CRGrid, MemData, cUnicodeCodecs,
  TntStdCtrls, TntClasses, TntDialogs, TntExtCtrls, TntButtons, TntActnList,
  TntMenus, TntComCtrls, TntGrids,  WordXP,
  xmldom, XMLIntf, msxmldom, XMLDoc, MemDS, common, zoomit, utility, Grids;

const
  AppName_ = 'Pleiades';
  AppVersion_ = '2.2.17';         // Change this immediately after the new version is released.
  AppReleaseDate_ = '2010-11-12'; // Change this just before the new version is about to be released.

type
  TFastRecordCreator = class(TForm)
    StatusBar1: TTntStatusBar;
    full: TTntMemo;
    SaveDialog1: TTntSaveDialog;
    PopupMenu1: TTntPopupMenu;
    ShowMARC1: TTntMenuItem;
    Locate1: TTntMenuItem;
    Addtolist1: TTntMenuItem;
    MainMenu1: TTntMainMenu;
    File1: TTntMenuItem;
    FinalExport1: TTntMenuItem;
    Import1: TTntMenuItem;
    Configure: TTntMenuItem;
    Languages1: TTntMenuItem;
    DefaultClassification1: TTntMenuItem;
    Ztargets1: TTntMenuItem;
    Exit1: TTntMenuItem;
    ChangeDatabase1: TTntMenuItem;
    Edit1: TTntMenuItem;
    Utitlities1: TTntMenuItem;
    Lists1: TTntMenuItem;
    NewList1: TTntMenuItem;
    OpenList1: TTntMenuItem;
    OpenReviewList1: TTntMenuItem;
    CreateListByCollection1: TTntMenuItem;
    N8: TTntMenuItem;
    Deleterecords1: TTntMenuItem;
    Help1: TTntMenuItem;
    About: TTntMenuItem;
    ActionList1: TTntActionList;
    ExitAction: TTntAction;
    gotoaction: TTntAction;
    OpenDialog1: TTntOpenDialog;
    AddToListAction: TTntAction;
    RemoveFromListAction: TTntAction;
    RemoveFromList1: TTntMenuItem;
    N1: TTntMenuItem;
    N2: TTntMenuItem;
    N3: TTntMenuItem;
    N4: TTntMenuItem;
    N5: TTntMenuItem;
    N6: TTntMenuItem;
    N7: TTntMenuItem;
    CloseList1: TTntMenuItem;
    LocateAction: TTntAction;
    Materials1: TTntMenuItem;
    LocalZebraServer1: TTntMenuItem;
    OrganisationCode1: TTntMenuItem;
    Settings1: TTntMenuItem;
    BranchesList1: TTntMenuItem;
    CollectionList1: TTntMenuItem;
    LoancategoryList1: TTntMenuItem;
    ProcessstatusList1: TTntMenuItem;
    SetDefaultBranch1: TTntMenuItem;
    DigitalObjects1: TTntMenuItem;
    FinalExport2: TTntMenuItem;
    NewRecord1: TTntMenuItem;
    NewRecordFromTemplate1: TTntMenuItem;
    CopyRecord1: TTntMenuItem;
    PageControl2: TTntPageControl;
    advsearchpage: TTntTabSheet;
    TntMemo3: TTntMemo;
    TntGroupBox2: TTntGroupBox;
    errors: TTntMemo;
    TntGroupBox3: TTntGroupBox;
    truncationcheckbox2: TTntCheckBox;
    truncationCheckBox5: TTntCheckBox;
    truncationCheckBox4: TTntCheckBox;
    truncationCheckBox3: TTntCheckBox;
    truncationcheckbox1: TTntCheckBox;
    term2: TTntEdit;
    term3: TTntEdit;
    term4: TTntEdit;
    term5: TTntEdit;
    term1: TTntEdit;
    opsComboBox4: TTntComboBox;
    opsComboBox3: TTntComboBox;
    opsComboBox2: TTntComboBox;
    opscombobox1: TTntComboBox;
    fieldscombobox5: TTntComboBox;
    fieldscombobox4: TTntComboBox;
    fieldscombobox3: TTntComboBox;
    fieldscombobox2: TTntComboBox;
    fieldscombobox1: TTntComboBox;
    browsepage: TTntTabSheet;
    browseresults: TTntStringGrid;
    scanfield: TTntComboBox;
    scanterm: TTntEdit;
    nextscan: TTntBitBtn;
    prevscan: TTntBitBtn;
    browseerrors: TTntMemo;
    Scan: TTntBitBtn;
    Search: TTntBitBtn;
    TntGroupBox1: TTntGroupBox;
    sortComboBox1: TTntComboBox;
    TntRadioGroup1: TTntRadioGroup;
    TntBitBtn2: TTntBitBtn;
    LocateBtn: TTntBitBtn;
    ShowBtn: TTntBitBtn;
    MyRecords: TTntCheckBox;
    gotolevel: TTntComboBox;
    gotono: TTntEdit;
    TntLabel1: TTntLabel;
    TntLabel4: TTntLabel;
    ScrollBar1: TScrollBar;
    searchresults: TTntStringGrid;
    HitsLabel: TTntLabel;
    DateTimePicker1: TDateTimePicker;
    newtmpl: TTntBitBtn;
    CopyRecBtn: TTntBitBtn;
    New: TTntBitBtn;
    Button4: TTntBitBtn;
    UsersCombo: TTntComboBox;
    TntLabel2: TTntLabel;
    MARCDisp: TTntMenuItem;
    BibAuthSwitch: TTntButton;
    ExportToWordBtn: TTntBitBtn;
    statistics_button: TTntBitBtn;
    TntLabel3: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure newtmplClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure FinalExport1Click(Sender: TObject);
    procedure ChangeDatabase1Click(Sender: TObject);
    procedure transferHoldings1Click(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure NewList1Click(Sender: TObject);
    procedure OpenList1Click(Sender: TObject);
    procedure Addtolist1Click(Sender: TObject);
    procedure OpenReviewList1Click(Sender: TObject);
    procedure CreateListByCollection1Click(Sender: TObject);
    procedure RemoveFromListActionExecute(Sender: TObject);
    procedure CloseList1Click(Sender: TObject);
    procedure Deleterecords1Click(Sender: TObject);
    procedure ChangeDB(DB: string);
    procedure FormShow(Sender: TObject);
    procedure LocateActionExecute(Sender: TObject);
    procedure Languages1Click(Sender: TObject);
    procedure Materials1Click(Sender: TObject);
    procedure DefaultClassification1Click(Sender: TObject);
    procedure Ztargets1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocalZebraServer1Click(Sender: TObject);
    procedure OrganisationCode1Click(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure Users1Click(Sender: TObject);
    procedure StatusBarUserName;
    procedure Moves1Click(Sender: TObject);
{
    procedure TntDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
}
    procedure BitBtn2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MARCDispClick(Sender: TObject);
    procedure Vocabulary1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BranchesList1Click(Sender: TObject);
    procedure CollectionList1Click(Sender: TObject);
    procedure LoancategoryList1Click(Sender: TObject);
    procedure ProcessstatusList1Click(Sender: TObject);
    procedure CopyRecBtnClick(Sender: TObject);
    procedure SetDefaultBranch1Click(Sender: TObject);
    procedure DigitalObjects1Click(Sender: TObject);
    procedure NewRecord1Click(Sender: TObject);
    procedure NewRecordFromTemplate1Click(Sender: TObject);
    procedure CopyRecord1Click(Sender: TObject);
    procedure clear_criteria;
    procedure SearchClick(Sender: TObject);
    function GenericLocate(var azoomhost : ZOOM_HOST; querystring, sortprefix, sortsuffix : widestring) : integer;
    procedure GenericScan(var azoomhost: ZOOM_HOST; scanquery : Widestring; start: integer);

    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure searchresultsDblClick(Sender: TObject);
    procedure searchresultsKeyPress(Sender: TObject; var Key: Char);
    procedure ScanClick(Sender: TObject);
    procedure prevscanClick(Sender: TObject);
    procedure nextscanClick(Sender: TObject);
    procedure browsepageEnter(Sender: TObject);
    procedure advsearchpageEnter(Sender: TObject);
    procedure browseresultsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure browseresultsDblClick(Sender: TObject);
    procedure BibAuthSwitchClick(Sender: TObject);
    procedure ExportToWordBtnClick(Sender: TObject);
    procedure statistics_buttonClick(Sender: TObject);
  private
    { Private declarations }
//    OldWindProc: TWndMethod;  //Old Window Procedure

    mouseposx, mouseposy : integer;
    dgrecno : integer;

    procedure SearchBaseTable(which_table : string);

    function TntStringGrid1GetRecno(var index:integer) : integer;
    procedure NewBibliographicRecord;
    procedure CopyBibliographicRecord;
    procedure NewBibliographicRecordFromTemplate;
    procedure PrintRecords;
    procedure ExportBasketToWord;
    procedure ExportBasketToFile;
    procedure PopulateSearchComponents(inifname, langcode, profile :string);
  public
    { Public declarations }
    Languages, Materials, Greek_charset,
    Collections, defcln, OrganisationCode : WideString;

    gotorecno, gotoauthrecno, setbranches,
    hits, recordd, markbook : integer;

    FList, RList : TextFile;

    otherdatabases, currentdatabase, form5action,
    FNameList, FReviewList,
    mysqlhost, mysqlport, mysqldb, mysqluser, mysqlpass,
    SortingColumn,
    myzebrahostname, myzebraport, myzebradatabase,
    myzebraauthhostname, myzebraauthport, myzebraauthdatabase,
    myzprofile, myzauthprofile, myzproxy, myzcharset : string;

    SortAscending : Boolean;

    usercodes, List, ReviewList : array of integer;

    cmdnames, // Commands as displayed in comboboxes.
    cmds,     // RPN commands attributes.
    ops,      // boolean operands names.
    zcmdkeys, // internal presentation of search commands.
    sortcmds,
    zsortcmdkeys,
    sortcmdnames : Tstrings;
    scanset,
    recordset : TTntStrings;
    bib_auth_status, base_table : string;
    BibSearchResultColWidths, AuthSearchResultColWidths : integerArray;
  end;

var FastRecordCreator: TFastRecordCreator;
    img : TBitmap; 
    WidthStrGrid : integer;

implementation

uses DataUnit, mycharconversion, NewBibliographicUnit,
     MARCEditor, ImportUnit, ExportUnit, seldatabase,
     transferholdings, CreateListUnit, WideIniClass,
     SettingsUnit, DefClnSettingsUnit, ZTargetsSettingsUnit, ProgresBarUnit,
     SettingsZebraUnit, OrganisationCodeUnit, IniFiles, PrettyMARCUnit,
     UserUnit, MovesUnit, VocabUnit, ChangePasUnit, ChoosePrintGroupUnit,
     BackupUnit, MARCDisplayUnit, GlobalProcedures, SetPasswordUnit,
     SplashScrUnit, BranchUnit, CollectionUnit,
     LoancatUnit, ProcessStatusUnit, LoanCategoryUnit, ConfigurationUnit,
     LoginUnit, DigitalSettings, ReportsUnit, zlocate, zoom, MARCAuthEditor,
  statistics;

{$R *.dfm}

const MAXSEARCHFIELDS = 5;
      MAXSORTFIELDS = 1;
      SCAN_RESULTS_PER_PAGE = 20;

      ListColor = clMoneyGreen;
      ReviewListColor = clSilver;

procedure TFastRecordCreator.PopulateSearchComponents(inifname, langcode, profile :string);
var p : integer;
    hlp : string;
    myIniFile : TWideIniFile;
begin
 cmdnames.Clear;
 sortcmdnames.Clear;
 ops.Clear;

 zcmdkeys.Clear;
 zsortcmdkeys.Clear;

 cmds.Clear;
 sortcmds.Clear;

 MyIniFile := TWideIniFile.Create(inifname);
 with MyIniFile do
 begin
  ReadSectionValues(profile+'commands_descr.'+langcode,zcmdkeys);
  for p:=0 to zcmdkeys.Count -1 do
   cmdnames.Add(zcmdkeys.ValueFromIndex[p]);

  ReadSectionValues(profile+'sort_descr.'+langcode,zsortcmdkeys);
  ReadSectionValues(profile+'commands',cmds);
  ReadSectionValues(profile+'sort',sortcmds);
  Zsortcmdkeys.Insert(0,'');
  sortcmdnames.Add('-');
  for p:=1 to zsortcmdkeys.Count -1 do
   sortcmdnames.Add(zsortcmdkeys.ValueFromIndex[p]);
// Add operators
  hlp:=ReadString('Zops.'+langcode,'@and','And');
  ops.Add(hlp);
  hlp:=ReadString('Zops.'+langcode,'@or','Or');
  ops.Add(hlp);
  hlp:=ReadString('Zops.'+langcode,'@not','And Not');
  ops.Add(hlp);
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

 for p:=1 to MAXSEARCHFIELDS do
 begin
  if findcomponent('fieldscombobox'+inttostr(p)) <> nil then
  begin
   with Tcombobox(findcomponent('fieldscombobox'+inttostr(p))) do
   begin
    items.Clear;
    items.Assign(cmdnames);
    if cmdnames.Count > p-1 then itemindex:=p-1
    else itemindex:=0;
   end;
  end;
  if findcomponent('opscombobox'+inttostr(p)) <> nil then
  begin
   with Tcombobox(findcomponent('opscombobox'+inttostr(p))) do
   begin
    items.Clear;
    items.Assign(ops);
    itemindex:=0;
   end;
  end;
  if findcomponent('term'+inttostr(p)) <> nil then
  begin
   with Tedit(findcomponent('term'+inttostr(p))) do
   begin
    text:='';
   end;
  end;
  if findcomponent('truncationcheckbox'+inttostr(p)) <> nil then
  begin
   with Tcheckbox(findcomponent('truncationcheckbox'+inttostr(p))) do
   begin
    checked:=false;
   end;
  end;
 end;

 for p:=1 to MAXSORTFIELDS do
 begin
  if findcomponent('sortcombobox'+inttostr(p)) <> nil then
  begin
   with Tcombobox(findcomponent('sortcombobox'+inttostr(p))) do
   begin
    items.Clear;
    items.Assign(sortcmdnames);
    itemindex:=0;
   end;
  end;
  if findcomponent('tntradiogroup'+inttostr(p)) <> nil then
  begin
   with Ttntradiogroup(findcomponent('tntradiogroup'+inttostr(p))) do
   begin
    itemindex:=0;
   end;
  end;
 end;

// cmdnames.Free;
// sortcmdnames.Free;
// ops.Free;
end;

procedure TFastRecordCreator.FormCreate(Sender: TObject);
var
  langcode, path, myinifname, lastdb : string;
  myIniFile : TWideIniFile;
  myreginifile : TRegistryinifile;
  rc,i : integer;
begin
  AppName := AppName_;
  AppVersion := AppVersion_;
  AppReleaseDate := AppReleaseDate_;

  bib_auth_status:='bib';
  base_table := 'basket';
  img := TBitmap.Create;

  zoom_initialized:=false;
  loadsyntaxdef('usmarc.stx', BibUsmarcStx);
  loadsyntaxdef('auth.stx', AuthUsmarcStx);

  SetLength(BibSearchResultColWidths,9);
  SetLength(AuthSearchResultColWidths,5);
  BibSearchResultColWidths[0] := 31;
  BibSearchResultColWidths[1] := 41;
  BibSearchResultColWidths[2] := 44;
  BibSearchResultColWidths[3] := 296;
  BibSearchResultColWidths[4] := 398;
  BibSearchResultColWidths[5] := 43;
  BibSearchResultColWidths[6] := 86;
  BibSearchResultColWidths[7] := 65;
  BibSearchResultColWidths[8] := 48;

  AuthSearchResultColWidths[0] := 31;
  AuthSearchResultColWidths[1] := 41;
  AuthSearchResultColWidths[2] := 44;
  AuthSearchResultColWidths[3] := 50;
  AuthSearchResultColWidths[4] := 889;

  rc := InitZoom;
  if rc <> 0 then Zoom_initialized := true;

  fastrecordcreator.Caption :='Pleiades';
  path:=extractfilepath(paramstr(0));
  datetimepicker1.DateTime := now;
  load_utf8fixcodes(path+'ucodes.txt');
  myinifname := path+'pleiades.ini';
  MyIniFile := TWideIniFile.Create(myinifname);

  myreginifile := TRegistryinifile.Create('\Software\pleiades',KEY_READ or KEY_WRITE);
  lastdb:=myreginifile.ReadString('pleiades','LastDB','');

  with MyIniFile do
  begin
   otherdatabases:=ReadString('FastRecordCreator','databases','');
   if pos(lastdb,otherdatabases) <= 0 then lastdb:='';
   if lastdb = '' then
     currentdatabase := ReadString('FastRecordCreator','defaultdatabase','')
   else
     currentdatabase := lastdb;
   Languages := ReadWideString('FastRecordCreator','Languages', 'gre,eng');
   Materials := ReadWideString('FastRecordCreator','Materials', 'bk,se,ma,vm,mu,ma');
   OrganisationCode := ReadString(FastRecordCreator.currentdatabase,'OrgCode', '');
   Greek_charset := ReadWideString('FastRecordCreator','greek_charset', '');

   myzebrahostname := ReadString(currentdatabase,'myzhost', 'localhost');
   myzebraport := ReadString(currentdatabase,'myzport', '9999');
   myzebradatabase := ReadString(currentdatabase,'myzdatabase', 'Default');

   myzebraauthhostname := ReadString(currentdatabase,'myzauthhost', 'localhost');
   myzebraauthport := ReadString(currentdatabase,'myzauthport', '9998');
   myzebraauthdatabase := ReadString(currentdatabase,'myzauthdatabase', 'Default_auth');

   myzcharset := ReadString(currentdatabase,'myzcharset', 'UTF8');
   myzprofile := ReadString(currentdatabase,'myzprofile', 'myzeb');
   myzauthprofile := ReadString(currentdatabase,'myzauthprofile', 'myzebauth');
   myzproxy := ReadString(currentdatabase,'myzproxy', '');

  end;
  MyIniFile.Free;

  myinifname := path+'zparams.ini';

  zcmdkeys:=Tstringlist.Create;

  cmdnames:=Tstringlist.Create;
  zsortcmdkeys:=Tstringlist.Create;
  sortcmdnames:=Tstringlist.Create;
  ops:=Tstringlist.Create;
  cmds:=Tstringlist.Create;
  sortcmds:=Tstringlist.Create;

 langcode:='en';

 PopulateSearchComponents(myinifname, langcode, myzprofile);

  if otherdatabases = '' then
  begin
   WideShowMessage('No databases defined in ini file');
   Application.Terminate;
  end;

  if otherdatabases = '' then  Changedatabase1.Enabled:=false;

  freviewlist:='';
  fnamelist:='';

  Lines := TTntStringList.Create;

// Was like this in order to support loancategories and process statuses from ini file.
  SetLength(IniMappings, 6);
  for i := 0 to 5 do
    IniMappings[i] := TTntStringList.Create;

//  SetLength(IniMappings, 1);
//  IniMappings[0] := TTntStringList.Create;

  PopulateComboFromIni('RecordLevel',gotolevel);
  gotolevel.Items.Insert(0,'All Levels');
  gotolevel.ItemIndex:=gotolevel.Items.Count-1;
//  gotolevel.Text:=gotolevel.Items[gotolevel.ItemIndex];
//  gotolevel.Refresh;

  dgrecno := -1;
  if lastdb <> currentdatabase then
  myreginifile.WriteString('pleiades','LastDB',currentdatabase);
  lastdb:=currentdatabase;
  myreginifile.Free;

 KeyPreview := True;
 recordset :=TTntstringlist.Create;
 scanset :=TTntstringlist.Create;

end;

procedure TFastRecordCreator.ChangeDB(DB: string);
var
  host, ip, err, path, myinifname : string;
  myIniFile : TWideIniFile;
  myreginifile : TRegistryinifile;
  myzebradommode, myzebraauthdommode : boolean;
begin
  path := ExtractFilePath(paramstr(0));
  myinifname := path + 'pleiades.ini';
  bib_auth_status:='bib';
  base_table := 'basket';
  bibauthswitch.Caption:='Switch to Authority';
  MyIniFile := TWideIniFile.Create(myinifname);
  try
    Screen.Cursor := crHourGlass;
    with MyIniFile do
    begin
     OrganisationCode := ReadString(db,'OrgCode', '');
     mysqlhost := ReadString(db,'mysqlhost','localhost');
     mysqlport := ReadString(db,'mysqlport','3306');
     mysqluser := ReadString(db,'mysqluser','');
     mysqlpass := ReadString(db,'mysqlpass','');
     mysqldb := ReadString(db,'mysqldb','');
     myzebrahostname := ReadString(db,'myzhost', 'localhost');
     myzebraport := ReadString(db,'myzport', '9999');
     myzebradatabase := ReadString(db,'myzdatabase', 'Default');
     myzebradommode := ReadBool(db,'myzdommode', false);

     myzebraauthhostname := ReadString(db,'myzauthhost', 'localhost');
     myzebraauthport := ReadString(db,'myzauthport', '9998');
     myzebraauthdatabase := ReadString(db,'myzauthdatabase', 'Default_auth');
     myzebraauthdommode := ReadBool(db,'myzauthdommode', false);

     //Load Mappings from Ini file

     IniMappings[0].Clear;
     ReadWideSectionValues('RecordLevel',IniMappings[0]);

     IniMappings[1].Clear;
     ReadWideSectionValues('LoanCategory',IniMappings[1]);

     IniMappings[2].Clear;
     ReadWideSectionValues('ProcessStatus',IniMappings[2]);

     IniMappings[3].Clear;
     ReadWideSectionValues('Enumeration',IniMappings[3]);

     IniMappings[4].Clear;
     ReadWideSectionValues('Chronology',IniMappings[4]);

     IniMappings[5].Clear;
     ReadWideSectionValues('AuthRecordLevel',IniMappings[5]);

    end;

    // Append move only if it is called from database change menu and not from splash screen.
    if data.MyConnection1.Connected then
    begin
      append_move(UserCode, 2,Today, CurrentUserName + ' logged out');
    end;

    Data.hold.Close;
    Data.basket.Close;
    data.Securebasket.close;
    data.auth.close;
    Data.users.Close;
    Data.moves.Close;
    Data.vocabulary.Close;
    Data.marcdisplay.Close;
    Data.Tools.Close;
    Data.Items.Close;
    Data.Languages.Close;
    Data.loancat.Close;
    Data.loancategory.Close;
    Data.branch.close;
    Data.collection.close;
    Data.digital.Close;
    Data.patroncat.Close;
    Data.processstatus.Close;

    data.hold.Filtered := False;
    data.auth.Filtered := False;
    data.items.Filtered := False;
    Data.users.Filtered := False;
    Data.moves.Filtered := true;
    data.moves.Filter:='usercode='+inttostr(UserCode)+' and date="'+datetostr(today)+'"';
    Data.vocabulary.Filtered := false;
    data.marcdisplay.Filtered := false;

    if data.MyConnection1.Connected then  data.MyConnection1.Disconnect;

    //Conect to the server
    try
      Data.MyConnection1.Server := mysqlhost;
      Data.MyConnection1.Port := StrToIntDef(mysqlport, 3306);
      Data.MyConnection1.Username := mysqluser;
      Data.MyConnection1.Password := mysqlpass;
      Data.MyConnection1.Database := mysqldb;

      Data.MyConnection1.Connect;
    except
      if Not Data.MyConnectDialog1.Execute then
        Application.Terminate;
    end;

    if Data.MyConnection1.Connected Then
    begin
      data.basket.DisableControls;
//      Data.basket.FetchAll := FetchAll;
//       data.basket.SQL.Text := 'SELECT * FROM basket ORDER BY recno DESC LIMIT 0,50';

      Data.hold.Open;
      Data.basket.Open;
      Data.auth.Open;
      Data.Items.Open;
      Data.marcdisplay.Open;
      Data.loancat.Open;
      Data.loancategory.Open;
      Data.branch.Open;
      Data.collection.Open;
      Data.digital.Open;
      Data.patroncat.Open;
      Data.processstatus.Open;

      Data.vocabulary.Open;
      Data.users.Open;
      Data.moves.Open;
      Data.Tools.Open;
      Data.Languages.Open;

      LoginForm.ShowModal;
      if (loginForm.login_valid = false) then
      begin
        Application.Terminate;
        exit;
      end;

      //set_vocabulary;
      FastRecordCreator.Caption :='Pleiades - ' + FastRecordCreator.currentdatabase;

      // The lines bellow were in FormShow
      gotolevel.ItemIndex:=0;

      pagecontrol2.ActivePageIndex:=0;
      ActiveControl := pagecontrol2.Pages[0];

      StatusBarUserName;
//      Label1.Caption :=' User Access: ' + IntToStr(current_user_access);
      if GetIPFromHost(Host, IP, Err) then
       host:=' from:'+host+'['+ip+'] '
      else host:='';

      append_move(UserCode, 2,Today, CurrentUserName + ' logged in'+host+'('+Appname+' '+Appversion+')');

      ApplyUserAccess;
      WidthStrGrid := searchresults.Width;

      load_user_settings(UserCode);

      DO_Windows_storage_location :=GetContent(1,UserCode);
      DO_BaseURL := GetContent(2,UserCode);

      data.basket.EnableControls;
    end
    else
    begin
      showmessage('Could not connect to database server');
      Application.Terminate;
    end;

    Caption :='Pleiades - '+db;

    CloseList;
    SetLength(ZebraRecnos,0);
    gotono.Text := '';

    currentdatabase := db;

    myreginifile := TRegistryinifile.Create('\Software\pleiades');
    myreginifile.WriteString('pleiades','LastDB',db);
    myreginifile.Free;

    path:=extractfilepath(paramstr(0));
    myinifname := path+'pleiades.ini';
    with MyIniFile do
    begin
      DefCln := ReadWideString(currentdatabase,'DefCln', '');
    end;
    setup_zebra_host(myzebrahost, 'MyZebraDB', myzebrahostname,myzebraport,myzebradatabase, 'Usmarc','UTF-8','UTF-8','',myzprofile, myzebradommode);
    setup_zebra_host(myzebraauthhost, 'MyZebraAuthDB', myzebraauthhostname,myzebraauthport,myzebraauthdatabase, 'Usmarc','UTF-8','UTF-8','',myzauthprofile, myzebraauthdommode);

    setlength(Usercodes,0);
    UsersCombo.Items.Clear;
    with data.users do
    begin
      First;
      UsersCombo.Items.Add('All users');
      UsersCombo.Items.Add('admin');
      while Not Eof do
      begin
        UsersCombo.Items.Add(fieldByName('Username').AsVariant);
        SetLength(Usercodes, length(Usercodes)+1);
        Usercodes[length(Usercodes)-1] := fieldByName('Usercode').AsInteger;
        Next;
      end;
    end;
    UsersCombo.ItemIndex := 0;
  finally
    MyIniFile.Free;
    Screen.Cursor := crDefault;
  end;

end;

procedure TFastRecordCreator.ExitActionExecute(Sender: TObject);
begin
 if screen.Cursor=crDefault then
  Terminate_Program;
end;

procedure TFastRecordCreator.AboutClick(Sender: TObject);
begin
  SplashScrForm.ShowModal;
end;

procedure TFastRecordCreator.Import1Click(Sender: TObject);
begin
  //ImportForm.ShowModal;
  showmessage('Operation not permitted.');
end;

procedure TFastRecordCreator.FinalExport1Click(Sender: TObject);
begin
  ExportForm.ShowModal;
  fastrecordcreator.SetFocus;
end;

procedure TFastRecordCreator.ChangeDatabase1Click(Sender: TObject);
var cdb:string;
begin
 cdb:=currentdatabase;
 seldatabaseform.showmodal;
 if cdb <> currentdatabase then
   changedb(currentdatabase);
end;


procedure TFastRecordCreator.TransferHoldings1Click(Sender: TObject);
begin
  xferHoldings.ShowModal;
end;

procedure TFastRecordCreator.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  TempColor : TColor;
  TempRect : TRect;
begin
  if Panel.Index = 1 Then
    if Panel.Text <> '' Then
      with StatusBar.Canvas do
      begin
        Font.Style := [fsBold];
        Font.Color := clRed;

        TextRect(Rect, Rect.Left+2, Rect.Top, Panel.Text);
      end;

  if Panel.Index = 2 Then
    if Panel.Text <> '' Then
      with StatusBar.Canvas do
      begin
        Font.Style := [fsBold];
        TempRect := Rect;
        TempRect.Left := Rect.Left+Rect.Bottom;

        TempColor := Brush.Color;
        Brush.Color := ListColor;
        Rectangle(Rect.Left+2, Rect.Top+2, Rect.Left+Rect.Bottom-6 , Rect.Bottom-Rect.Top+1);

        Brush.Color := TempColor;
        TextRect(TempRect, TempRect.Left, Rect.Top, Panel.Text);
      end;

  if Panel.Index = 3 Then
    if Panel.Text <> '' Then
      with StatusBar.Canvas do
      begin
        Font.Style := [fsBold];
        TempRect := Rect;
        TempRect.Left := Rect.Left+Rect.Bottom;

        TempColor := Brush.Color;
        Brush.Color := ReviewListColor;
        Rectangle(Rect.Left+2, Rect.Top+2, Rect.Left+Rect.Bottom-6 , Rect.Bottom-Rect.Top+1);

        Brush.Color := TempColor;
        TextRect(TempRect, TempRect.Left, Rect.Top, Panel.Text);
      end;


 if Panel.Index = 4 Then
    if Panel.Text <> '' Then
      with StatusBar.Canvas do
      begin
        Font.Style := [fsBold];
        TempRect := Rect;
        TempRect.Left := Rect.Left+Rect.Bottom;

        TempColor := Brush.Color;
        Brush.Color := ReviewListColor;

        Brush.Color := TempColor;
        TextRect(TempRect, TempRect.Left, Rect.Top, 'User: ' + UserName);
      end;


end;

procedure TFastRecordCreator.NewList1Click(Sender: TObject);
begin
  SaveDialog1.FileName := '';
  SaveDialog1.Filter := 'LST files (*.lst)|*.lst';
  SaveDialog1.FilterIndex := 1; { start the dialog showing all files }
  if SaveDialog1.Execute then
  begin
    FNameList := Savedialog1.FileName;
    AssignFile(FList,FNameList);
    ReWrite(FList);
    CloseFile(FList);
    SetLength(List, 0);
    SetCurrentList(FNameList);
  end;
end;

procedure TFastRecordCreator.OpenList1Click(Sender: TObject);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'LST files (*.lst)|*.lst';
  OpenDialog1.FilterIndex := 1; { start the dialog showing all files }
  if OpenDialog1.Execute then
  begin
    FNameList := Opendialog1.FileName;
    //Populate the array
    PopulateArrayWithListRecno(FNameList);
    SetCurrentList(FNameList);
  end;
end;

procedure TFastRecordCreator.Addtolist1Click(Sender: TObject);
var recno, index:integer;
begin
  recno := TntStringGrid1GetRecno(index);
  if recno <> -1 then
  begin
    if FNameList <> '' Then AddToList(FNameList, recno)
    Else WideShowMessage('No active list.');
  end;
  SetFocus;
end;

procedure TFastRecordCreator.OpenReviewList1Click(Sender: TObject);
var
  recnolist : Tstringlist;
  i, k, temp : integer;
begin

  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'LST files (*.lst)|*.lst';
  OpenDialog1.FilterIndex := 1; { start the dialog showing all files }

  if OpenDialog1.Execute then
  begin
    FReviewList := Opendialog1.FileName;

    recnolist:=Tstringlist.Create;
    loadrecnolist(recnolist, FReviewList, False);

    SetLength(ZebraRecnos, recnolist.Count);
    for i := 0 to recnolist.Count-1 do
      ZebraRecnos[i] := StrToInt(recnolist[i]);
    k := 0;
    while k < recnolist.Count - 1 do
    begin
      for i := k+1 to recnolist.Count-1 do
        if ZebraRecnos[k]>ZebraRecnos[i] then
        begin
          temp := ZebraRecnos[k];
          ZebraRecnos[k] := ZebraRecnos[i];
          ZebraRecnos[i] := temp;
        end;
      inc(k);
    end;

    scrollbar1.Enabled := true;
    scrollbar1.Position:=0;
    scrollbar1.Max := recnolist.Count;
    scrollbar1.LargeChange := searchresults.RowCount-1;
    scrollbar1.SmallChange := searchresults.RowCount-1;
    ScrollBar1Change(FastRecordCreator);
    HitsLabel.Caption:='Total hits : '+inttostr(recnolist.Count);

    recnolist.Free;
    SetCurrentReviewList(FReviewList);

    SetFocus;
  end;
end;

procedure TFastRecordCreator.CreateListByCollection1Click(Sender: TObject);
begin
  if FNameList <> '' Then
    begin
      CreateListForm.ShowModal;
    end
  Else WideShowMessage('No active list.');
end;

procedure TFastRecordCreator.RemoveFromListActionExecute(Sender: TObject);
var recno,index:integer;
begin
  recno := TntStringGrid1GetRecno(index);
  if recno <> -1 then
  begin
    if FNameList <> '' Then RemoveFromList(FNameList, recno)
      Else WideShowMessage('No active list.');
  end;
end;

procedure TFastRecordCreator.CloseList1Click(Sender: TObject);
begin
  CloseList;
end;

procedure TFastRecordCreator.Deleterecords1Click(Sender: TObject);
var
  i, n, res, nr: integer;
  text : UTF8String;
begin
  if FNameList <> '' Then
  begin
    res := WideMessageDlg('Do you want to delete these records from the database?',
                mtConfirmation, [mbYes, mbNo], 0);
    if res = mrYes Then
    begin
      n := length(List)-1;
      nr := 0;

      ProgresBarForm.Show;
      ProgresBarForm.ProgressBar1.Min := 0;
      ProgresBarForm.ProgressBar1.Max := n+1;
      ProgresBarForm.ProgressBar1.Visible := true;
      ProgresBarForm.ProgressBar1.Position := 0;
      ProgresBarForm.Label2.Caption := 'Deleting records from list...';
      Application.ProcessMessages;

      data.Query1.Close;
      data.Query1.SQL.Clear;

      data.Query1.SQL.Add('DELETE FROM basket WHERE recno = :recno;');

      for i := 0 to n do
      begin
        text := MakeMRCFromSecureBasket(List[i]);
        data.Query1.ParamByName('recno').AsInteger := List[i];
        data.Query1.Execute;

        if data.Query1.RowsAffected > 0 Then nr := nr + data.Query1.RowsAffected;

        ProgresBarForm.ProgressBar1.Position := i;
        RecordUpdated(myzebrahost, 'delete', List[i], text, false);
      end;

      ProgresBarForm.ProgressBar1.Visible := false;
      ProgresBarForm.ProgressBar1.Position := 100;
      ProgresBarForm.Close;

      CloseList;
      WideShowMessage(IntToStr(nr)+' records have been deleted');
    end;
  end
  else WideShowMessage('No active list.');
end;

procedure TFastRecordCreator.FormShow(Sender: TObject);
begin
  SplashScrForm.FromAbout := False;   //This is done because SplashForm can be accessed from About menu too
  SplashScrForm.ShowModal;    //Here the connection to DB is made and authentication to the program
end;

procedure TFastRecordCreator.LocateActionExecute(Sender: TObject);
var recno,index:integer;
begin
  recno := TntStringGrid1GetRecno(index);
  if recno = -1 then
  begin
    WideShowMessage('You have to be viewing a record to use this function.');
    exit;
  end;
  if data.basket.Active Then
  begin
    zlocateform.myrecno := -1;
    zlocateform.source_record := '';
    zlocateform.myrecno := recno;
    zlocateform.calledfrom:='main';
    zlocateform.source_record := GetLastDataFromBasket(recno);
    zlocateform.ShowModal;
  end;
end;

procedure TFastRecordCreator.Languages1Click(Sender: TObject);
begin
  setbranches := 2;
  ConfigurationForm.Caption := 'Configuration - Languages';
  ConfigurationForm.ShowModal;
end;

procedure TFastRecordCreator.Materials1Click(Sender: TObject);
begin
  setbranches := 3;
  ConfigurationForm.Caption := 'Configuration - Materials';
  ConfigurationForm.ShowModal;
end;

procedure TFastRecordCreator.DefaultClassification1Click(Sender: TObject);
begin
  DefClnSettingsForm.ShowModal;
end;

procedure TFastRecordCreator.Ztargets1Click(Sender: TObject);
begin
  ZTargetsSettingsForm.ShowModal;
end;

procedure TFastRecordCreator.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  img.Free;
  append_move(UserCode, 2,Today, CurrentUserName + ' logged out');
end;

procedure TFastRecordCreator.LocalZebraServer1Click(Sender: TObject);
begin
  SettingsZebraForm.ShowModal;
end;

procedure TFastRecordCreator.OrganisationCode1Click(Sender: TObject);
begin
  OrganisationCodeForm.ShowModal;
end;

procedure TFastRecordCreator.ShowBtnClick(Sender: TObject);
begin
  SetLength(ZebraRecnos, 0);
  scrollbar1.Enabled:=false;
  Clear_String_Grid(searchresults);
  SearchBaseTable(base_table);
end;

procedure TFastRecordCreator.clear_criteria;
var pp : integer;
begin
  fastrecordcreator.gotono.Text := '';
  fastrecordcreator.gotolevel.ItemIndex := 0;
  fastrecordcreator.MyRecords.Checked := True;
  fastrecordcreator.DateTimePicker1.Checked := True;
  fastrecordcreator.UsersCombo.ItemIndex := 0;

  for pp:=1 to MAXSEARCHFIELDS do
  begin
   if (FindComponent('term'+IntToStr(pp)) <> nil) then
    TTntEdit(FindComponent('term'+IntToStr(pp))).Text:= '';
   if (FindComponent('truncationcheckbox'+IntToStr(pp)) <> nil) then
    TTntcheckbox(FindComponent('truncationcheckbox'+IntToStr(pp))).Checked := false;
   if (FindComponent('fieldscombobox'+IntToStr(pp)) <> nil) then
    TTntcombobox(FindComponent('fieldscombobox'+IntToStr(pp))).ItemIndex := pp-1;
   if pp <> MAXSEARCHFIELDS then
     if (FindComponent('opscombobox'+IntToStr(pp)) <> nil) then
      TTntcombobox(FindComponent('opscombobox'+IntToStr(pp))).ItemIndex := 0;
  end;
end;

procedure TFastRecordCreator.Users1Click(Sender: TObject);
begin
   UserForm.ShowModal;
end;

procedure TFastRecordCreator.StatusBarUserName;
begin
  with StatusBar1.Canvas do
  begin
    Font.Style := [fsBold];
    Brush.Color := clBlue;
    StatusBar1.Panels.Items[4].Text := 'User: '+UserName;
  end;
end;

procedure TFastRecordCreator.Moves1Click(Sender: TObject);
begin
  MovesForm.Showmodal;
end;

{
procedure TFastRecordCreator.TntDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  s: WideString;
  dgauthor,dgtitle,dgedition,dgyear,dglang,dgpublisher,dgmaterial,dgplace : WideString;
  s1 : UTF8String;
  TempRect : TRect;
  i, fl,ind, base,nf : integer;
  text, direntry, junk, level : WideString;
begin
if Data.Basket.Active and not data.basket.ControlsDisabled Then
begin
  with (Sender as TTntDBGrid).Canvas do
  begin

    if IsInList(Column.Field.DataSet.FieldByName('recno').AsInteger) Then
      begin
       (Sender as TTntDBGrid).Canvas.Brush.Color := ListColor;
       (Sender as TTntDBGrid).Canvas.Font.Color := clWhite;
      end;

    if gdSelected in State Then
    begin
       (Sender as TTntDBGrid).Canvas.Brush.Color := clHighLight;
       (Sender as TTntDBGrid).Canvas.Font.Color := clWhite;
    end;

    FillRect(Rect);

    if Column.Field.DataSet.IsEmpty then  Exit;

    if Column.Field.DataSet.FieldByName('recno').asinteger <> dgrecno then
    begin
      dgrecno:=Column.Field.DataSet.FieldByName('recno').asinteger;
      S1 := WideStringToString(TCustomDADataSet(Column.Field.DataSet).GetBlob('Text').AsWideString, Greek_codepage);
      while Pos(#13, S1) > 0 do //remove carriage returns and
       S1[Pos(#13, S1)] := ' ';
      while Pos(#10, S1) > 0 do //line feeds
       S1[Pos(#10, S1)] := ' ';


      dgauthor:=''; dgtitle:=''; dgpublisher :='';
      dglang:='';  dgedition:=''; dgyear:=''; dgplace:='';

      junk := copy(s1,13,5);
      if TryStrToInt(junk, base) Then
      begin
       nf := (base-1-24)div 12;
       for i:=1 to nf do
       begin
        direntry:=copy(s1,25+(i-1)*12,12);
        fl := strtointdef(copy(direntry,4,4), -1);
        ind := strtointdef(copy(direntry,8,5), -1);
        if (fl=-1) or (ind=-1) Then Break;

        if (copy(direntry,1,3) = '008') then
        begin
         text := UTF8StringToWideString(copy(s1,base+ind+1,fl-1));
         if text <> '' then dglang := copy(text,36,3);
        end
        else
          if ((copy(direntry,1,3) = '100') or (copy(direntry,1,3) = '110') or (copy(direntry,1,3) = '111')) then
          begin
           text := UTF8StringToWideString(copy(s1,base+ind+3,fl-3));
           if text <> '' then dgauthor := extract_field(text,'ad',0,false);
          end
          else
          begin
           if (copy(direntry,1,3) = '245') then
           begin
            text := UTF8StringToWideString(copy(s1,base+ind+3,fl-3));
            if text <> '' then dgtitle := extract_field(text,'ab',0,false);
           end
           else
           begin
            if (copy(direntry,1,3) = '260') then
            begin
             text := UTF8StringToWideString(copy(s1,base+ind+3,fl-3));
             if text <> '' then
             begin
              dgplace := extract_field(text,'a',0,false);
              dgpublisher := extract_field(text,'b',0,false);
              dgyear := extract_field(text,'c',0,false);
             end;
            end
            else
            begin
             if (copy(direntry,1,3) = '250') then
             begin
              text := UTF8StringToWideString(copy(s1,base+ind+3,fl-3));
              if text <> '' then dgedition := extract_field(text,'a',0,false);
             end;
            end;
           end;
          end;
       end;
      end;
      dgmaterial := LowerCase(type_of_material(copy(s1, 1, 24)));
    end;


    if not(gdSelected in State) then
        if (dglang='gre') then Font.Color:=clBlue
                        else Font.Color := clgreen;

    if (Column.Field.FieldName = 'level') then
    begin
      level := GetIniMappings('RecordLevel', Column.Field.DataSet.FieldByName('level').AsString);

      TempRect := Rect;
      TempRect.Left := TempRect.Left + 2;
      DrawTextW(Handle, PWideChar(level), -1, TempRect, DT_LEFT);
      exit;
    end;

    if (Column.Field.FieldName = 'text') then
    begin

     if Column.Title.Caption = 'Author' then
      s:=dgauthor
     else if Column.Title.Caption = 'Title' then
      s:=dgtitle
     else if Column.Title.Caption = 'Edition' then
      s:=dgedition
     else if Column.Title.Caption = 'Year' then
      s:=dgyear
     else if Column.Title.Caption = 'Lang' then
      s:=dglang
     else if Column.Title.Caption = 'Publisher' then
      s:=dgpublisher
     else if Column.Title.Caption = 'Place' then
      s:=dgplace
     else if Column.Title.Caption = 'Material' then
      s:=dgmaterial;

     TempRect := Rect;
     TempRect.Left := TempRect.Left + 2;
     DrawTextW(Handle, PWideChar(s), -1, TempRect, DT_LEFT);
    end
    else
    begin
      if gdSelected in State Then
        begin
          (Sender as TTntDBGrid).Canvas.Brush.Color:=clHighLight;
          (Sender as TTntDBGrid).Canvas.Font.Color:=clWhite;
        end;
      (Sender as TTntDBGrid).DefaultDrawColumnCell(Rect, DataCol, TTntColumn(Column), State);
    end;
  end;
end;
end;
}

procedure TFastRecordCreator.SearchBaseTable(which_table : string);
var
  s, sop, h : string;
  r, b, e , ucode: integer;
  todadat : TDate;
  TempDateFormat : string;
begin
 TempDateFormat := ShortDateFormat;
 ShortDateFormat := 'yyyy-mm-dd';

  with data.query1 do
  begin
    Close;

    SQL.Clear;

    s := '';
    sop := ' WHERE ';

    if gotono.Text <> '' Then
    begin
      r :=strtointdef(gotono.Text,-1);
      if r = -1 then
      begin
       h:=gotono.Text;
       b:=strtointdef(copy(h,1,pos('-',h)-1),0);
       e:=strtointdef(copy(h,pos('-',h)+1,length(h)),0);
       s:= s+ sop + ' recno >= ' + inttostr(b)+' and recno <= '+inttostr(e);
      end
      else
      begin
       s:= s + sop + ' recno = ' + inttostr(r);
      end;
      sop := ' and ';
    end;

    if (gotolevel.ItemIndex <> -1)and(gotolevel.ItemIndex <> 0) Then
    begin
      s:= s+ sop + 'level = ' + IntToStr(gotolevel.ItemIndex-1);
      sop := ' and ';
    end;

    //Mine records


    if UsersCombo.Visible Then
    begin
      // showmessage(inttostr(UsersCombo.ItemIndex));
      // showmessage(UsersCombo.Items[UsersCombo.ItemIndex]);
      if (UsersCombo.ItemIndex > 0) Then
      begin
        if (UsersCombo.ItemIndex = 1) Then ucode :=0
        else ucode:= Usercodes[UsersCombo.ItemIndex-2];
        s:= s+ sop + '(creator='+inttostr(ucode)+' or modifier='+inttostr(ucode)+')';
        sop := ' and ';
      end;
    end
    else
    begin
      if MyRecords.Visible and MyRecords.Checked Then
      begin
        s:= s+ sop + '(creator='+inttostr(usercode)+' or modifier='+inttostr(usercode)+')';
        sop := ' and ';
      end;
    end;

{
    if CheckBox2.Checked Then
    begin
      todadat := Today;
      s:= s + sop + '(created = "'+DateToStr(todadat)+'" or modified = "'+DateToStr(todadat)+'")';
      sop := ' and ';
    end;
}
    if DateTimePicker1.Checked Then
    begin
      todadat := DateTimePicker1.Date;
      s:= s + sop + '(created = "'+DateToStr(todadat)+'" or modified = "'+DateToStr(todadat)+'")';
      sop := ' and ';
    end;


    SQL.Add('SELECT count(distinct recno) FROM '+which_table+' ' + s);
    Execute;
    r := Fields[0].AsInteger;

    if r < 1 then
    begin
      WideShowMessage('No records matched your criteria');
    end
    else
    begin
      SetLength(ZebraRecnos, r);
      Close;
      SQL.Clear;
      SQL.Add('SELECT distinct recno FROM '+which_table+' ' + s+' ORDER BY recno DESC');
      Execute;
      First;
      b:=0;
      while not Eof do
      begin
        ZebraRecnos[b] := Fields[0].AsInteger;
        b:=b+1;
        Next;
      end;
      scrollbar1.Enabled := true;
      scrollbar1.Position:=0;
      scrollbar1.Max := r;
      scrollbar1.LargeChange := searchresults.RowCount-1;
      scrollbar1.SmallChange := searchresults.RowCount-1;
      ScrollBar1Change(FastRecordCreator);
    end;
  end;
  HitsLabel.Caption:='Total hits : '+inttostr(r);

end;

procedure TFastRecordCreator.BitBtn2Click(Sender: TObject);
begin
  clear_criteria;
  activecontrol:=term1;
  SetLength(ZebraRecnos,0);
  scrollbar1.Enabled:=false;
  Clear_String_Grid(searchresults);
  HitsLabel.Caption:='Total hits : ';
end;

procedure TFastRecordCreator.FormResize(Sender: TObject);
begin
  tntgroupbox2.Width := pagecontrol2.Width - 215;
  tntgroupbox3.Width := pagecontrol2.Width - 215;
  if bib_auth_status = 'bib' then
  begin
    searchresults.ColWidths[3] := searchresults.ColWidths[3] + floor((searchresults.Width - WidthStrGrid)/2);
    searchresults.ColWidths[4] := searchresults.ColWidths[4] + floor((searchresults.Width - WidthStrGrid)/2);
  end
  else
  begin
    searchresults.ColWidths[4] := searchresults.ColWidths[4] + floor((searchresults.Width - WidthStrGrid));
  end;
  searchresults.RowCount := floor(searchresults.Height/(searchresults.DefaultRowHeight+1));
  WidthStrGrid := searchresults.Width;

  BibSearchResultColWidths[3] := BibSearchResultColWidths[3] + floor((searchresults.Width - WidthStrGrid)/2);
  BibSearchResultColWidths[4] := BibSearchResultColWidths[4] + floor((searchresults.Width - WidthStrGrid)/2);
  AuthSearchResultColWidths[4] := AuthSearchResultColWidths[4] + floor((searchresults.Width - WidthStrGrid));

end;

procedure TFastRecordCreator.MARCDispClick(Sender: TObject);
begin
   MARCDisplayForm.ShowModal;
end;

procedure TFastRecordCreator.Vocabulary1Click(Sender: TObject);
begin
  VocabForm.ShowModal;
end;

procedure TFastRecordCreator.Settings1Click(Sender: TObject);
begin
  SettingsForm.ShowModal;
end;

procedure TFastRecordCreator.FormActivate(Sender: TObject);
begin
  WindowState := wsMaximized;

  searchresults.Rows[0].Strings[0]:='#';
  searchresults.Rows[0].Strings[1]:='Recno';
  searchresults.Rows[0].Strings[2]:='Level';
  searchresults.Rows[0].Strings[3]:='Author';
  searchresults.Rows[0].Strings[4]:='Title';
  searchresults.Rows[0].Strings[5]:='Edition';
  searchresults.Rows[0].Strings[6]:='Publisher';
  searchresults.Rows[0].Strings[7]:='Place';
  searchresults.Rows[0].Strings[8]:='Year';
  ActiveControl := term1;
end;

procedure TFastRecordCreator.BranchesList1Click(Sender: TObject);
begin
  BranchForm.ShowModal;
end;

procedure TFastRecordCreator.CollectionList1Click(Sender: TObject);
begin
  CollectionForm.ShowModal;
end;

procedure TFastRecordCreator.LoancategoryList1Click(Sender: TObject);
begin
//  LoancatForm.ShowModal;
  LoanCategoryForm.ShowModal;
end;

procedure TFastRecordCreator.ProcessstatusList1Click(Sender: TObject);
begin
  ProcessStatusForm.ShowModal;
end;

procedure TFastRecordCreator.SetDefaultBranch1Click(Sender: TObject);
var e: boolean;
begin
  e:=BranchForm.TntBitBtn1.Enabled;
  BranchForm.TntBitBtn1.Enabled := current_user_access=10;
  BranchForm.ShowModal;
  BranchForm.TntBitBtn1.Enabled:=e;
end;

procedure TFastRecordCreator.DigitalObjects1Click(Sender: TObject);
begin
  DigitalSettingsForm.Showmodal;
end;

procedure TFastRecordCreator.NewBibliographicRecord;
var  temp : UTF8string;
begin
  if bib_auth_status = 'bib' then
  begin
    savedmarc := false;
    NewBibliographicForm.ShowModal;
    if savedmarc then
    begin
      MARCEditorForm.record_index := -1;
      MARCEditorForm.edit_from_result_set := false;
      MARCEditorForm.ShowModal;
    end;
  end
  else
  begin
    NewMARCRecord(base_table);
    gotoauthrecno := data.auth.FieldByName('recno').AsInteger;
    MARCAuthEditorForm.record_index := -1;
    MARCAuthEditorForm.edit_from_result_set := false;
    with data.auth do
    begin
      EditTable(data.auth);
      temp := makenewauthmrc;
      if length(temp) >= 10 then temp[10] := 'a';
      EnhanceMARC(gotoauthrecno, temp);
      GetBlob('text').IsUnicode := True;
      GetBlob('text').AsWideString := StringToWideString(temp, Greek_codepage);
      TBlobField(FieldByName('text')).Modified := True;
      PostTable(data.auth);
      RecordUpdated(myzebraauthhost, 'insert', gotoauthrecno, temp);
    end;
    MARCAuthEditorForm.ShowModal;
  end;
end;

procedure TFastRecordCreator.NewRecord1Click(Sender: TObject);
begin
  NewBibliographicRecord;
end;

procedure TFastRecordCreator.NewClick(Sender: TObject);
begin
  NewBibliographicRecord;
end;

procedure TFastRecordCreator.NewBibliographicRecordFromTemplate;
begin
   FastRecordCreator.OpenDialog1.FileName := '';
   FastRecordCreator.OpenDialog1.Filter := 'TMPL files (*.tmpl)|*.tmpl';
   FastRecordCreator.OpenDialog1.FilterIndex := 1; // start the dialog showing all files
   if fastrecordcreator.opendialog1.Execute = true then
   begin
     NewMARCRecord(base_table);
     MARCEditor.templatename := fastrecordcreator.opendialog1.FileName;
     if bib_auth_status = 'bib' then
     begin
       gotorecno := data.SecureBasket.FieldByName('recno').AsInteger;
       MARCEditorForm.record_index := -1;
       MARCEditorForm.edit_from_result_set := false;
       MARCEditorForm.ShowModal;
     end
     else
     begin
       gotoauthrecno := data.auth.FieldByName('recno').AsInteger;
       MARCAuthEditorForm.record_index := -1;
       MARCAuthEditorForm.edit_from_result_set := false;
       MARCAuthEditorForm.ShowModal;
     end;
   end;
end;

procedure TFastRecordCreator.newtmplClick(Sender: TObject);
begin
  NewBibliographicRecordFromTemplate;
end;

procedure TFastRecordCreator.NewRecordFromTemplate1Click(Sender: TObject);
begin
  NewBibliographicRecordFromTemplate;
end;

procedure TFastRecordCreator.CopyBibliographicRecord;
var
  rec : UTF8String;
  recno, newrecno,index : integer;
begin
  //Get text from current record
  recno := TntStringGrid1GetRecno(index);
  if recno = -1 then
  begin
    WideShowMessage('You have to be viewing a record to use this function.');
    exit;
  end;

  if bib_auth_status = 'bib' then
  begin
    if data.basket.Active Then
    begin
      rec := GetLastDataFromBasket(recno);
      //Create new record
      newrecno := NewMARCRecord(base_table);
      //Insert new record in MARC
      EnhanceMARC(newrecno, rec);
      rec := RemoveHoldings(rec);
      Refresh856(newrecno,DO_BaseURL,rec);
      //Insert new text in basket
      EditTable(data.SecureBasket);
      data.SecureBasket.GetBlob('text').IsUnicode := True;
      data.SecureBasket.GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
      TBlobField(data.SecureBasket.FieldByName('text')).Modified := True;
      PostTable(data.secureBasket);
      //Update zebra
      RecordUpdated(myzebrahost, 'insert', newrecno, rec);
      //Open MARC Editor form
      FastRecordCreator.gotorecno := newrecno;
      MARCEditorForm.record_index := -1;
      MARCEditorForm.edit_from_result_set := false;
      MARCEditorForm.ShowModal;
    end;
  end
  else
  begin
    if data.auth.Active Then
    begin
      rec := GetLastDataFromAuth(recno);
      //Create new record
      newrecno := NewMARCRecord(base_table);
      EnhanceMARC(newrecno, rec);
      //Insert new text in basket
      EditTable(data.auth);
      data.auth.GetBlob('text').IsUnicode := True;
      data.auth.GetBlob('text').AsWideString := StringToWideString(rec, Greek_codepage);
      TBlobField(data.auth.FieldByName('text')).Modified := True;
      PostTable(data.auth);
      //Update zebra
      RecordUpdated(myzebraauthhost, 'insert', newrecno, rec);
      //Open MARC Editor form
      FastRecordCreator.gotoauthrecno := newrecno;
      MARCAuthEditorForm.record_index := -1;
      MARCAuthEditorForm.edit_from_result_set := false;
      MARCAuthEditorForm.ShowModal;
    end;
  end;
end;

procedure TFastRecordCreator.CopyRecBtnClick(Sender: TObject);
begin
  CopyBibliographicRecord;
end;

procedure TFastRecordCreator.CopyRecord1Click(Sender: TObject);
begin
  CopyBibliographicRecord;
end;

procedure TFastRecordCreator.SearchClick(Sender: TObject);
var querystring, q1, q2, s1, t1, error,
    sortprefix, sortsuffix : WideString;
    pp, itidx, sortcnt,rc : integer;
begin
 searchresults.Visible:=false;
 errors.Visible:=true;
 Clear_String_Grid(searchresults);

 hits:=0;
 errors.Clear;
 querystring := '';
 error:='';
 s1:='';
 sortprefix:='';
 sortcnt:=0;
 sortsuffix:='';

 for pp:=1 to MAXSEARCHFIELDS do
 begin
  if (FindComponent('term'+inttostr(pp)) <> nil) then
  begin
   if (TTntEdit(FindComponent('term'+inttostr(pp))).Text <> '') then
   begin
    if (querystring<>'') then querystring:=s1+querystring; // add previous valid boolean operator.
    q1:=squeeze(TTntEdit(FindComponent('term'+inttostr(pp))).Text);
    t1:='';
    if (TCheckBox(FindComponent('truncationcheckbox'+inttostr(pp))).Checked) then
     t1 := ' @attr 5=1';
    if (FindComponent('fieldscombobox'+inttostr(pp)) <> nil) then
    begin
      itidx:=TComboBox(FindComponent('fieldscombobox'+inttostr(pp))).ItemIndex;
      q2:=copy(zcmdkeys[itidx],1,pos('=',zcmdkeys[itidx])-1);
      if cmds.indexofname(q2) <> -1 then
       q2:=cmds.ValueFromIndex[cmds.indexofname(q2)]
      else
      begin
       querystring := '';
       break;
      end;
    end;
    // If no attr for word/phrase etc searching is specified,
    // specify 4=1 if it is a single word or
    // 4=6 if there are more than one words in the search term.
    if (pos('@attr 4=',q2)<=0) then
    begin
      q1:=remove_punctuation(q1);
      if (pos(' ',q1) > 0) then
       q2:=q2+' @attr 4=6'
      else
       q2:=q2+' @attr 4=1';
    end;
    q1:=q2+t1+' "'+q1+'"';
    if (findcomponent('opscombobox'+inttostr(pp)) <> nil) then
    begin
      itidx:=Tcombobox(findcomponent('opscombobox'+inttostr(pp))).ItemIndex;
      if itidx=0 then s1:='@and '
      else if itidx=1 then s1:='@or '
      else if itidx=2 then s1:='@not ';
    end;
    querystring:=querystring+' '+q1;
   end;
  end;  // term exist
 end;  //for

 for pp:=1 to MAXSORTFIELDS do
 begin
  if (FindComponent('sortcombobox'+inttostr(pp)) <> nil) then
  begin
    itidx:=TtntComboBox(FindComponent('sortcombobox'+inttostr(pp))).ItemIndex;
    q2:=copy(zsortcmdkeys[itidx],1,pos('=',zsortcmdkeys[itidx])-1);
    if q2 <> '' then
    begin
      if sortcmds.indexofname(q2) <> -1 then
       q2:=sortcmds.ValueFromIndex[sortcmds.indexofname(q2)]
      else
      begin
       sortprefix := '';
       break;
      end;
      if q2<> '' then
      begin
        if (FindComponent('tntradiogroup'+inttostr(pp)) <> nil) then
        begin
         itidx:=Ttntradiogroup(FindComponent('tntradiogroup'+inttostr(pp))).ItemIndex;
        end
        else itidx:=0;
       sortprefix:='@or '+sortprefix;
       sortsuffix:=sortsuffix+' '+q2+' @attr 7='+inttostr(itidx+1)+' '+inttostr(sortcnt);
       sortcnt:=sortcnt+1;
      end;
    end;
  end;  // term exist
 end;  //for

 if bib_auth_status = 'bib' then
   rc:=GenericLocate(myzebrahost, querystring,sortprefix,sortsuffix)
 else
   rc:=GenericLocate(myzebraauthhost, querystring,sortprefix,sortsuffix);

 if rc = 0 then
 begin
   errors.Clear;
   errors.Visible:=false;
   searchresults.Visible:=true;
   if hits > 0 then
   begin
     scrollbar1.Enabled := true;
     scrollbar1.Position:=0;
     scrollbar1.Max := hits;
     scrollbar1.LargeChange := searchresults.RowCount-1;
     scrollbar1.SmallChange := searchresults.RowCount-1;
     ScrollBar1Change(sender);
   end
   else
     scrollbar1.enabled:=false;
 end
 else
 begin
   scrollbar1.Enabled := false;
 end;
end;

function TFastRecordCreator.GenericLocate(var azoomhost : ZOOM_HOST; querystring, sortprefix, sortsuffix : widestring) : integer;
var error, f001 : WideString;
    i, rc : integer;
    more : boolean;
begin
 hits:=0;
 result:=0;

 azoomhost.active:=true;
 azoomhost.errorcode:=0;
 azoomhost.errorstring:='';
 azoomhost.mark:=0;
 azoomhost.hits:=0;

 errors.Clear;

 error:='';

 if (querystring <> '') then
 begin
  errors.lines.add('Please wait...');

  if sortprefix <> '' then
    querystring := sortprefix+' '+querystring+ ' ' + sortsuffix;

  recordset.Free;
  recordset:=TTntstringlist.Create;
  errors.lines.add(azoomhost.name+' '+azoomhost.scharset+ ' '+querystring);
  screen.Cursor:=crhourglass;
  i:= zsearch(azoomhost,querystring,30);
  if i = -1 then
  begin
   errors.Lines.Add(azoomhost.errorstring);
   azoomhost.errorstring:='';
   azoomhost.errorcode:=0;
   result:=1;
  end
  else
  begin
   errors.Lines.Add(inttostr(i)+' records found');
   if azoomhost.errorstring <> '' then
   begin
    errors.Lines.Add(azoomhost.errorstring);
    azoomhost.errorstring:='';
    result:=2;
   end;
   more := true;
   while more do
   begin
    rc:=zpresent(azoomhost,azoomhost.hits,recordset,'F');
    Application.ProcessMessages;
    if rc > 0 then
     hits:=hits+rc
    else
     more :=false;
   end;
   zclose(azoomhost);
   if hits > 0 then
   begin
    SetLength(ZebraRecnos, hits);

    for i:=0 to ((recordset.Count div 3)-1) do
    begin
     get_controlfieldtext(recordset[(i*3)+2],'001','1-9999',f001);
     ZebraRecnos[i] := StrToIntDef(f001, 0);
    end;
   end;
  end;
 end; // querystring
 HitsLabel.Caption:='Total hits : '+inttostr(hits);
 screen.Cursor:=crdefault;
end;

procedure TFastRecordCreator.ScrollBar1Change(Sender: TObject);
var r, n,
    i, fl, ind, base,nf : integer;
    marcrec : UTF8string;
    dgauthor,dgtitle,dgedition,
    dgyear,dglang,
    dgpublisher,
    //dgmaterial,
    dgplace,
    text, direntry, junk, level : WideString;
begin
//  errors.lines.add(inttostr(scrollbar1.position));
  Clear_String_Grid(searchresults);
  n := Scrollbar1.Position+ Scrollbar1.LargeChange;
  if n > Length(ZebraRecnos) then n := Length(ZebraRecnos);
  for r:= Scrollbar1.Position to n-1 do
  begin
    searchresults.Rows[r-Scrollbar1.Position+1].Strings[0]:=inttostr(r+1);
    searchresults.Rows[r-Scrollbar1.Position+1].Strings[1]:=inttostr(Zebrarecnos[r]);
    if bib_auth_status = 'bib' then
      marcrec := GetLastDataFromBasket(Zebrarecnos[r])
    else
      marcrec := GetLastDataFromAuth(Zebrarecnos[r]);

    dgrecno:=Zebrarecnos[r];

    dgauthor:=''; dgtitle:=''; dgpublisher :='';
    dglang:='';  dgedition:=''; dgyear:=''; dgplace:='';

    junk := copy(marcrec,13,5);
    if TryStrToInt(junk, base) Then
    begin
     nf := (base-1-24)div 12;
     for i:=1 to nf do
     begin
      direntry:=copy(marcrec,25+(i-1)*12,12);
      fl := strtointdef(copy(direntry,4,4), -1);
      ind := strtointdef(copy(direntry,8,5), -1);
      if (fl=-1) or (ind=-1) Then Break;
      if bib_auth_status = 'bib' then
      begin
        if (copy(direntry,1,3) = '008') then
        begin
          text := UTF8StringToWideString(copy(marcrec,base+ind+1,fl-1));
          if text <> '' then dglang := copy(text,36,3);
        end;
        if ((copy(direntry,1,3) = '100') or (copy(direntry,1,3) = '110') or (copy(direntry,1,3) = '111')) then
        begin
          text := UTF8StringToWideString(copy(marcrec,base+ind+3,fl-3));
          if text <> '' then dgauthor := extract_field(text,'abcqd',0,false);
        end;
        if (copy(direntry,1,3) = '245') then
        begin
          text := UTF8StringToWideString(copy(marcrec,base+ind+3,fl-3));
          if text <> '' then dgtitle := extract_field(text,'ab',0,false);
        end;
        if (copy(direntry,1,3) = '260') then
        begin
          text := UTF8StringToWideString(copy(marcrec,base+ind+3,fl-3));
          if text <> '' then
          begin
            dgplace := extract_field(text,'a',0,false);
            dgpublisher := extract_field(text,'b',0,false);
            dgyear := extract_field(text,'c',0,false);
          end;
        end;
        if (copy(direntry,1,3) = '250') then
        begin
          text := UTF8StringToWideString(copy(marcrec,base+ind+3,fl-3));
          if text <> '' then dgedition := extract_field(text,'a',0,false);
        end;
      end
      else
      begin
        if (copy(direntry,1,1) = '1') then
        begin
         text := UTF8StringToWideString(copy(marcrec,base+ind+3,fl-3));
         if text <> '' then dgauthor := extract_field(text,'abcdefghijklmnopqrstuvwxyz0123456789',0,false);
         dgtitle := copy(direntry,1,3);
        end
      end;
     end;
    end;
//    dgmaterial := LowerCase(type_of_material(copy(marcrec, 1, 24)));
    if bib_auth_status = 'bib' then
    begin
      level := GetIniMappings('RecordLevel', data.LastDataFromBasket.FieldByName('level').AsString);
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[3]:=dgauthor;
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[4]:=dgtitle;
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[5]:=dgedition;
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[6]:=dgpublisher;
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[7]:=dgplace;
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[8]:=dgyear;
    end
    else
    begin
      level := GetIniMappings('AuthRecordLevel', data.LastDataFromAuth.FieldByName('level').AsString);
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[3]:=dgtitle;
      searchresults.Rows[r-Scrollbar1.Position+1].Strings[4]:=dgauthor;
    end;
    searchresults.Rows[r-Scrollbar1.Position+1].Strings[2]:=level;
  end;
end;

procedure TFastRecordCreator.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if scrollPos mod (searchresults.RowCount-1) <> 0 then
    scrollpos := scrollpos - (scrollPos mod (searchresults.RowCount-1));
end;

procedure TFastRecordCreator.FormKeyPress(Sender: TObject; var Key: Char);
var p:integer;
    acontrol: string;
begin
 if key =#13 then // enter is pressed
 begin
  acontrol := lowercase(activecontrol.Name);
  if ((acontrol='scanterm') or (acontrol = 'scanfield')) then
  begin
   ScanClick(Sender);
  end
  else
  begin
   for p:=1 to MAXSEARCHFIELDS do
   begin
    if (('term'+inttostr(p) = acontrol) or
        ('fieldscombobox'+inttostr(p) = acontrol) or
        ('opscombobox'+inttostr(p) = acontrol) or
        ('truncationcheckbox'+inttostr(p) = acontrol)) then
    begin
      SearchClick(Sender);
    end;
   end;
  end;
 end;
end;

function TFastRecordCreator.TntStringGrid1GetRecno(var index : integer) : integer;
begin
  result := strtointdef(searchresults.Rows[searchresults.Row].Strings[1],-1);
  index := strtointdef(searchresults.Rows[searchresults.Row].Strings[0],-1)
end;

procedure TFastRecordCreator.searchresultsDblClick(Sender: TObject);
var recno,index : integer;
begin
  recno := TntStringGrid1GetRecno(index);
  if recno = -1 then exit;
  if bib_auth_status = 'bib' then
  begin
    if data.basket.Active Then
    begin
     gotorecno := recno;
     OpenSecureBasketTable(gotorecno);
     MARCEditorForm.edit_from_result_set := true;
     MARCEditorForm.record_index := index;
     if data.SecureBasket.RecordCount > 0
       Then MARCEditorForm.ShowModal
       Else MessOK('This record is probably deleted. Please refresh your dataset!');
   end;
  end
  else
  begin
    if data.auth.Active Then
    begin
     gotoauthrecno := recno;
     OpenAuthTable(gotoauthrecno);
     MARCAuthEditorForm.edit_from_result_set := true;
     MARCAuthEditorForm.record_index := index;
     if data.Auth.RecordCount > 0
       Then MARCAuthEditorForm.ShowModal
       Else MessOK('This record is probably deleted. Please refresh your dataset!');
   end;
  end;
end;

procedure TFastRecordCreator.searchresultsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 Then searchresultsDblClick(Sender);
//else showmessage(inttostr(ord(key)));
//if HiWord(GetKeyState(VK_NEXT)) <> 0 then showmessage('kala');
end;

procedure TFastRecordCreator.ScanClick(Sender: TObject);
var itidx : integer;
    scanquery,q2 : widestring;
begin
 scanquery:='';

 if (TTntEdit(FindComponent('scanterm')).Text <> '') then
 begin
   scanquery := TTntEdit(FindComponent('scanterm')).Text;
   if (FindComponent('scanfield') <> nil) then
   begin
     itidx:=TTntComboBox(FindComponent('scanfield')).ItemIndex;
     q2:=copy(zcmdkeys[itidx],1,pos('=',zcmdkeys[itidx])-1);
     if cmds.indexofname(q2) <> -1 then
      scanquery:=cmds.ValueFromIndex[cmds.indexofname(q2)]+' "'+scanquery+'"';
   end;
   if bib_auth_status = 'bib' then
     Genericscan(myzebrahost, scanquery,1)
   else
     Genericscan(myzebraauthhost, scanquery,1);
 end
 else
 begin
  wideshowmessage('Please specify a starting term');
 end;

end;

procedure TFastRecordCreator.GenericScan(var azoomhost: ZOOM_HOST; scanquery : Widestring; start: integer);
var i, scanrows : integer;
begin
 azoomhost.active:=true;
 azoomhost.errorcode:=0;
 azoomhost.errorstring:='';
 azoomhost.mark:=0;
 azoomhost.hits:=0;

 azoomhost.lastscanquery:=scanquery;
 browseerrors.Lines.Clear;
 screen.Cursor:=crhourglass;
 scanset.Free;
 scanset:=TTntstringlist.Create;
 browseresults.RowCount:=2;
 browseresults.FixedRows:=1;
 browseresults.Cells[0,1]:='';
 browseresults.Cells[1,1]:='';
 browseresults.Cells[2,1]:='';
 browseerrors.lines.add(azoomhost.name+' '+azoomhost.scharset+ ' '+scanquery);

 browseresults.Cells[0,0]:='#';
 browseresults.Cells[1,0]:='Term';
 browseresults.Cells[2,0]:='Hits';
 scanset.Clear;
 scanrows:=zscan(azoomhost,scanquery,start,SCAN_RESULTS_PER_PAGE, scanset);
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
 screen.Cursor:=crdefault;
end;

procedure TFastRecordCreator.prevscanClick(Sender: TObject);
var lastterm, scanquery : widestring;
begin

 if bib_auth_status = 'bib' then
   scanquery:=myzebrahost.lastscanquery
 else
   scanquery:=myzebraauthhost.lastscanquery;

 if scanquery<> '' then
 begin
  lastterm :=browseresults.Cells[1,1];
  if lastterm <> '' then
  begin
   scanquery:=copy(scanquery,1,pos('"',scanquery)-1);
   scanquery := scanquery+'"'+lastterm+'"';
   if bib_auth_status = 'bib' then
     Genericscan(myzebrahost, scanquery,SCAN_RESULTS_PER_PAGE)
   else
     Genericscan(myzebraauthhost, scanquery,SCAN_RESULTS_PER_PAGE);
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

procedure TFastRecordCreator.nextscanClick(Sender: TObject);
var lastrow : integer;
    lastterm, scanquery : widestring;
begin

 if bib_auth_status = 'bib' then
   scanquery:=myzebrahost.lastscanquery
 else
   scanquery:=myzebraauthhost.lastscanquery;

 if scanquery<> '' then
 begin
  lastrow:=browseresults.RowCount-1;
  if lastrow = SCAN_RESULTS_PER_PAGE then
  lastterm :=browseresults.Cells[1,lastrow];
  if lastterm <> '' then
  begin
   scanquery:=copy(scanquery,1,pos('"',scanquery)-1);
   scanquery := scanquery+'"'+lastterm+'"';
   if bib_auth_status = 'bib' then
     Genericscan(myzebrahost, scanquery,1)
   else
     Genericscan(myzebraauthhost, scanquery,1);
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


procedure TFastRecordCreator.browsepageEnter(Sender: TObject);
begin
 Activecontrol:=scanterm;
end;

procedure TFastRecordCreator.advsearchpageEnter(Sender: TObject);
begin
 Activecontrol:=term1;
end;

procedure TFastRecordCreator.browseresultsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 mouseposx := x;
 mouseposy := y;
end;

procedure TFastRecordCreator.browseresultsDblClick(Sender: TObject);
var
  Column, Row: Longint;
  rc : integer;
  querystring,q2 : Widestring;
begin
// showmessage(inttostr(mouseposx)+' '+inttostr(mouseposy));
 browseresults.MouseToCell(mouseposX, mouseposY, Column, Row);
 if Row > 0 then
 begin
  querystring:=browseresults.Cells[1, Row];
  if querystring <> '' then
  begin
   if bib_auth_status = 'bib' then
     q2:=myzebrahost.lastscanquery
   else
     q2:=myzebraauthhost.lastscanquery;

   q2:=copy(q2,1,pos('"',q2)-1);
   querystring:=q2+'"'+querystring+'"';
   //wideshowmessage(querystring);
   if bib_auth_status = 'bib' then
     rc:=GenericLocate(myzebrahost, querystring,'','')
   else
     rc:=GenericLocate(myzebraauthhost, querystring,'','');
   pagecontrol2.ActivePageIndex:=0;
   if rc = 0 then
   begin
     errors.Clear;
     errors.Visible:=false;
     searchresults.Visible:=true;
     if hits > 0 then
     begin
       scrollbar1.Enabled := true;
       scrollbar1.Position:=0;
       scrollbar1.Max := hits;
       scrollbar1.LargeChange := searchresults.RowCount-1;
       scrollbar1.SmallChange := searchresults.RowCount-1;
       ScrollBar1Change(sender);
     end
     else
       scrollbar1.enabled:=false;
   end
   else
   begin
     scrollbar1.Enabled := false;
   end;
  end;
 end;
end;

procedure TFastRecordCreator.BibAuthSwitchClick(Sender: TObject);
var path, myinifname : string;
begin
  path:=extractfilepath(paramstr(0));
  myinifname := path+'zparams.ini';
  if bib_auth_status = 'auth' then
  begin
   LocateBtn.Visible := current_user_access > 0;
   exportform.CheckBox1.visible := true;
   bib_auth_status := 'bib';
   base_table := 'basket';
   BibAuthSwitch.Caption:='Switch to Authorities';
   PopulateSearchComponents(myinifname, 'en', myzprofile);
   PopulateComboFromIni('RecordLevel',gotolevel);
   gotolevel.Items.Insert(0,'All Levels');
   gotolevel.ItemIndex:=0;

   StoreColWidths(AuthSearchResultColWidths, searchresults);
   RestoreColWidths(BibSearchResultColWidths, searchresults);
   searchresults.ColCount:=9;
   searchresults.Rows[0].Strings[0]:='#';
   searchresults.Rows[0].Strings[1]:='Recno';
   searchresults.Rows[0].Strings[2]:='Level';
   searchresults.Rows[0].Strings[3]:='Author';
   searchresults.Rows[0].Strings[4]:='Title';
   searchresults.Rows[0].Strings[5]:='Edition';
   searchresults.Rows[0].Strings[6]:='Publisher';
   searchresults.Rows[0].Strings[7]:='Place';
   searchresults.Rows[0].Strings[8]:='Year';

   tntgroupbox1.Visible := true;
  end
  else
  begin
   LocateBtn.Visible := false;
   exportform.CheckBox1.visible := false;
   bib_auth_status := 'auth';
   base_table := 'auth';
   BibAuthSwitch.Caption:='Switch to Bibliographic';
   PopulateSearchComponents(myinifname, 'en', myzauthprofile);
   PopulateComboFromIni('AuthRecordLevel',gotolevel);
   gotolevel.Items.Insert(0,'All Levels');
   gotolevel.ItemIndex:=0;

   StoreColWidths(BibSearchResultColWidths, searchresults);
   RestoreColWidths(AuthSearchResultColWidths, searchresults);
   searchresults.ColCount:=5;
   searchresults.Rows[0].Strings[0]:='#';
   searchresults.Rows[0].Strings[1]:='Recno';
   searchresults.Rows[0].Strings[2]:='Level';
   searchresults.Rows[0].Strings[3]:='Tag';
   searchresults.Rows[0].Strings[4]:='Main Entry';

   tntgroupbox1.Visible := false;
  end;
  Clear_String_Grid(browseresults);
  Clear_String_Grid(searchresults);
  HitsLabel.Caption := 'Total Hits:';
  clear_criteria;
end;

procedure TFastRecordCreator.ExportToWordBtnClick(Sender: TObject);
begin
  PrintRecords;
end;

procedure TFastRecordCreator.PrintRecords;
begin
  if not data.basket.Active Then Data.basket.Open;

  ChoosePrintGroupForm.ShowModal;
  if ChoosePrintGroupForm.ModalResult = mrOk Then
  begin
    if ChoosePrintGroupForm.TntRadioGroup1.ItemIndex = 0 then ExportBasketToFile
    else if ChoosePrintGroupForm.TntRadioGroup1.ItemIndex = 1 then ExportBasketToWord;
  end;
end;

procedure TFastRecordCreator.ExportBasketToWord;
var
  rec : UTF8String;
  grouptext, book : WideString;
  i, nr : integer;
  R : range;
  t : table;
  Direction, Separator, Format, wbreak ,autofit, autofitdef, linestyle: OleVariant;
begin

with data do
begin

  if length(ZebraRecnos) <> 0 then
  begin
//    OpenPrettyMARCQuery(ChoosePrintGroupForm.ChosedName, lang);
    grouptext:='';
    //Initialize Word Document
    MSWord.Connect;
    try
      MSWord.Documents.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
      Document.ConnectTo(MSWord.ActiveDocument);

      MSWord.Options.CheckSpellingAsYouType := false;
      MSWord.Options.CheckGrammarAsYouType := false;

//    msword.Options.CreateBackup := false;
//    msword.Options.SuggestSpellingCorrections:= false;

      Document.PageSetup.LeftMargin := 40;
      Document.PageSetup.RightMargin := 40;
      Direction :=wdCollapseEnd;
      wbreak :=     wdSectionBreakContinuous;
      linestyle := wdLineStyleNone;
      autofit:= true;
      autofitdef := wdWord8TableBehavior;

    //Populate the Document with Data
      nr := 1;
      SetLength(LabelPos, 0);
      SetLength(ContentPos, 0);
      Separator :='$';
      Format := wdTableFormatGrid1;
      Format := wdTableFormatNone;
      R := MsWord.Selection.Range;

      for i:=0 to Length(ZebraRecnos)-1 do
      begin

        rec:=MakeMRCFromSecureBasket(Zebrarecnos[i]);
        book := ProcessRecnoForPrinting(rec, nr, length(Document.Range.Text), True, grouptext, ChoosePrintGroupForm.ChosedName, lang);

        R.InsertAfter(book);

        t:= R.ConvertToTable(Separator, EmptyParam, EmptyParam,
                         EmptyParam, Format, EmptyParam,
                         EmptyParam, EmptyParam, EmptyParam,
                         EmptyParam, EmptyParam, EmptyParam,
                         EmptyParam, autofit ,autofitdef, autofitdef);

        nr := nr + 1;
        t.Borders.Item(wdBorderHorizontal).LineStyle:=linestyle;
        t.Borders.Item(wdBorderVertical).LineStyle:=linestyle;
        t.Borders.Item(wdBorderTop).LineStyle:=linestyle;
        t.Borders.Item(wdBorderRight).LineStyle:=linestyle;
        t.Borders.Item(wdBorderBottom).LineStyle:=linestyle;
        t.Borders.Item(wdBorderLeft).LineStyle:=linestyle;

        R.InsertParagraphAfter;
        R.Collapse(Direction);
        R.SetRange(R.End_, R.End_);
        R.Collapse(Direction);
        Application.ProcessMessages;
      end;

    //Apply Label font
    for i := 0 to length(LabelPos)-1 do
    begin
      MsWord.Selection.SetRange(LabelPos[i].Start, LabelPos[i].Start + LabelPos[i].Len);
      if LabelPos[i].Font.Name <> '' Then
          MSWord.Selection.Font.Name := LabelPos[i].Font.Name;
      if length(LabelPos[i].Font.Style) = 3 Then
      begin
        MSWord.Selection.Font.Bold := StrToIntDef(LabelPos[i].Font.Style[1], 0);
        MSWord.Selection.Font.Italic := StrToIntDef(LabelPos[i].Font.Style[2], 0);
        MSWord.Selection.Font.Underline := StrToIntDef(LabelPos[i].Font.Style[3], 0);
      end;
      if LabelPos[i].Font.Size > 0 Then
        MSWord.Selection.Font.Size := LabelPos[i].Font.Size;
    end;

    //Apply Content font
    for i := 0 to length(ContentPos)-1 do
    begin
      MsWord.Selection.SetRange(ContentPos[i].Start, ContentPos[i].Start + ContentPos[i].Len);
      if ContentPos[i].Font.Name <> '' Then
          MSWord.Selection.Font.Name := ContentPos[i].Font.Name;
      if length(ContentPos[i].Font.Style) = 3 Then
      begin
        MSWord.Selection.Font.Bold := StrToIntDef(ContentPos[i].Font.Style[1], 0);
        MSWord.Selection.Font.Italic := StrToIntDef(ContentPos[i].Font.Style[2], 0);
        MSWord.Selection.Font.Underline := StrToIntDef(ContentPos[i].Font.Style[3], 0);
      end;
      if ContentPos[i].Font.Size > 0 Then
        MSWord.Selection.Font.Size := ContentPos[i].Font.Size;
    end;

    MSWord.Selection.SetRange(0,0);

    MsWord.Visible := True;
  finally
    MsWord.Disconnect;

  end;

  WideShowMessage('Printout completed successfully to ' + FastRecordCreator.SaveDialog1.FileName);
  end
  else
  begin
   WideShowMessage('Please, select some records to export first.');
  end;

end;

end;

procedure TFastRecordCreator.ExportBasketToFile;
var
  rec : UTF8String;
  grouptext, book : WideString;
  i, nr : integer;
  f : TextFile;
//  TempBlob : TBlob;
begin
  SaveDialog1.DefaultExt := 'txt';

  if not SaveDialog1.Execute Then Exit;

  AssignFile(f, SaveDialog1.FileName);
  Rewrite(f);
  grouptext:='';
  with data do
  begin
   try
//     OpenPrettyMARCQuery(ChoosePrintGroupForm.ChosedName,lang);

     nr := 1;
     SetLength(LabelPos, 0);
     SetLength(ContentPos, 0);

     if length(ZebraRecnos) <> 0 then
     begin
      for i:=0 to Length(ZebraRecnos)-1 do
      begin
        rec:=MakeMRCFromSecureBasket(Zebrarecnos[i]);
        book := ProcessRecnoForPrinting(rec, nr, -1, False, grouptext, ChoosePrintGroupForm.ChosedName,lang);
        Write(f, WideStringToUTF8String(book));
        nr := nr + 1;
        Application.ProcessMessages;
      end;
      WideShowMessage('Printout completed successfully to ' + FastRecordCreator.SaveDialog1.FileName);
     end
     else
     begin
       WideShowMessage('Please, select some records to export first.');
     end;
   finally
     CloseFile(f);
   end;
  end;
end;

procedure TFastRecordCreator.statistics_buttonClick(Sender: TObject);
begin
  statisticsForm.ShowModal;
end;

end.

