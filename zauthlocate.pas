unit zauthlocate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, IniFiles, ExtCtrls, common, zoomit, DataUnit, ComCtrls,
  mycharconversion, TntStdCtrls, TntGrids, DateUtils, TntDialogs, TntClasses,
  utility, TntComCtrls, ImgList, Buttons, TntButtons, TntExtCtrls, TntForms, DB, cUnicodeCodecs;

type
  Tzauthlocateform = class(TTntForm)
    term1: TTntEdit;
    ListBox1: TTntListBox;
    errors: TTntMemo;
    truncationcheckbox1: TTntCheckBox;
    Label3: TTntLabel;
    Label7: TTntLabel;
    Label8: TTntLabel;
    PageControl1: TTntPageControl;
    Retrievedsheet: TTabSheet;
    mergedsheet: TTntTabSheet;
    PageControl2: TTntPageControl;
    errorspage: TTntTabSheet;
    merged: TTntMemo;
    Label6: TTntLabel;
    Savebutton: TTntButton;
    Button1: TTntButton;
    Button2: TTntButton;
    TabSheet1: TTntTabSheet;
    ListBox3: TTntListBox;
    timeoutedit: TTntEdit;
    Label10: TTntLabel;
    TabSheet2: TTntTabSheet;
    TreeView1: TTntTreeView;
    newresults: TTntStringGrid;
    Label11: TTntLabel;
    Label12: TTntLabel;
    Button5: TTntButton;
    Button6: TTntButton;
    fieldscombobox1: TTntComboBox;
    Panel1: TTntPanel;
    sourcerec: TTntMemo;
    Label5: TTntLabel;
    Splitter1: TTntSplitter;
    Panel2: TTntPanel;
    full: TTntMemo;
    Label4: TTntLabel;
    Mergebutton: TTntButton;
    TntTreeView1: TTntTreeView;
    ImageList1: TImageList;
    Label1: TTntLabel;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MergebuttonClick(Sender: TObject);
    procedure SavebuttonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure newresultsClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure TntTreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TntFormPaint(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //globalproxy,
    current_format, tag, heading: WideString;
    source_record, merged_record, located_record : UTF8String;
    myrecno : integer;
    calledfrom : string;
    totalrecords, displayedrecords:integer;
    cmdnames, // Commands as displayed in comboboxes.
    cmds,     // RPN commands attributes.
    ops,      // boolean operands names.
    zcmdkeys, // internal presentation of search commands.
    keys , tcodes, tnames: TStrings;
    selected_targets : TtntStrings;
  end;

var
  zauthlocateform: Tzauthlocateform;

const MAXSEARCHFIELDS = 1;

implementation

uses form008auth, ldr, MainUnit, GlobalProcedures;

{$R *.dfm}

procedure FillCell(SG : TStringGrid; Col, Row : Integer; BkCol, TextCol : TColor); forward;

procedure Tzauthlocateform.FormCreate(Sender: TObject);
var i : integer;
begin
 selected_targets:=TtntStringlist.Create;
 selected_targets.Clear;

  KeyPreview := True;
  for i:=1 to MAXHOSTS do
   zoom_authhosts[i].Records := TTntstringlist.Create;
end;

procedure Tzauthlocateform.FormActivate(Sender: TObject);
var
  //i,
  p,x : integer;
  ptr : Pointer;
  tno, langcode, path, myinifname, myinifname2, hlp : string;
  myIniFile, myIniFile2 : TIniFile;
begin
 WindowState := wsMaximized;
 label11.Caption:='';
 label12.Caption:='';
 treeview1.Items.Clear;

 get_main_heading(source_record,tag,heading);
 heading := remove_punctuation(heading);
 for p:=1 to MAXHOSTS do
  Zoom_authhosts[1].active:=false;

 current_format:='USmarc';
 pagecontrol1.ActivePageIndex:=0;
 pagecontrol2.ActivePageIndex:=0;
 label8.Caption:='';
 newresults.RowCount:=2;
 newresults.Cells[0,1]:='';
 newresults.Cells[1,1]:='';
 newresults.Cells[2,1]:='';

 keys:=Tstringlist.Create;
 keys.Clear;
 tnames:=Tstringlist.Create;
 tnames.Clear;
 tcodes:=Tstringlist.Create;
 tcodes.Clear;

 path:=extractfilepath(paramstr(0));
 myinifname := path+'zauthtargets.ini';
 myinifname2 := path+'zparams.ini';

 zcmdkeys:=Tstringlist.Create;
 zcmdkeys.Clear;
 cmdnames:=Tstringlist.Create;
 cmdnames.Clear;
 ops:=Tstringlist.Create;
 ops.Clear;

 langcode:='en';
 MyIniFile := TIniFile.Create(myinifname);
 MyIniFile2 := TIniFile.Create(myinifname2);
 with MyIniFile do
 begin
  ReadSections(tcodes);
  for p:=tcodes.Count -1 downto 0 do
  begin
   if lowercase(tcodes[p]) = 'zgroups' then
    tcodes.Delete(p);
  end;
  for p:=0 to tcodes.Count -1 do
  begin
    hlp:=ReadString(tcodes[p],'name','Unknown');
    tnames.Add(hlp);
  end;
 end;

 with MyIniFile2 do
 begin
  ReadSectionValues('Zauthcommands_descr.'+langcode,zcmdkeys);
  for p:=0 to zcmdkeys.Count -1 do
   cmdnames.Add(zcmdkeys.ValueFromIndex[p]);
  // Add operators
  hlp:=ReadString('Zops.'+langcode,'@and','And');
  ops.Add(hlp);
  hlp:=ReadString('Zops.'+langcode,'@or','Or');
  ops.Add(hlp);
  hlp:=ReadString('Zops.'+langcode,'@not','And Not');
  ops.Add(hlp);
 end;


 for p:=1 to MAXSEARCHFIELDS do
 begin
  if FindComponent('fieldscombobox'+IntToStr(p)) <> nil then
  begin
   with TComboBox(FindComponent('fieldscombobox'+IntToStr(p))) do
   begin
    items.Clear;
    items.Assign(cmdnames);
    if cmdnames.Count > p-1 then itemindex:=p-1
    else itemindex:=0;
   end;
  end;
  if FindComponent('opscombobox'+IntToStr(p)) <> nil then
  begin
   with TComboBox(FindComponent('opscombobox'+IntToStr(p))) do
   begin
    items.Clear;
    items.Assign(ops);
    itemindex:=0;
   end;
  end;
  if FindComponent('term'+IntToStr(p)) <> nil then
  begin
   with TTntEdit(FindComponent('term'+IntToStr(p))) do
   begin
{
    if pos('AUTHOR',uppercase(zcmdkeys.Names[x])) > 0 then
      text:=tag
    else if pos('TITLE',uppercase(zcmdkeys.Names[x])) > 0 then
      text:=heading
    else
}
      text:='';
   end;
  end;
  if FindComponent('truncationcheckbox'+IntToStr(p)) <> nil then
  begin
   with TCheckBox(FindComponent('truncationcheckbox'+IntToStr(p))) do
   begin
    Checked:=false;
   end;
  end;
 end;
 cmdnames.Free;
 ops.Free;

 with listbox1 do
 begin
  Items.Clear;
  Items.Assign(tnames);
  Itemindex:=0;
 end;

 keys.Clear;
 tnames.Clear;
 with MyIniFile do
 begin
  ReadSection('Zgroups',keys);
  for p:=0 to keys.Count -1 do
  begin
   tnames.Add(ReadString('Zgroups',keys[p],''));
  end;
 end;

 with listbox3 do
 begin
  Items.Clear;
  Items.Assign(keys);
  Itemindex:=0;
 end;
// i:=0;

 tnttreeview1.items.clear;
 for p:=0 to keys.Count-1 do
 begin
  ptr:=tnttreeview1.Items.Add(nil,keys[p]);
//  i:=tnttreeview1.Items.Count-1;
  hlp:=tnames[p];
  hlp:=hlp+',';
  repeat
   x:=pos(',',hlp);
   tno:=copy(hlp,1,x-1);
   hlp:=copy(hlp,x+1,length(hlp));
   for x:=0 to tcodes.Count-1 do
   begin
    if tcodes[x]=tno then
    begin
      //ptr := getzoomhostbyid(tno);
//      tnttreeview1.Items.Addchildobject(tnttreeview1.Items[i],listbox1.Items[x],nil);
//      showmessage('Adding '+listbox1.Items[x]+' to '+keys[p]+' code='+tno);
      tnttreeview1.Items.Addchildobject(ptr,listbox1.Items[x],nil);
    end;
   end;
  until hlp='';
 end;

 tnttreeview1.Items.AddFirst(nil,'All');
 for p := 0 to listbox1.Count-1 do
 begin
  tnttreeview1.Items.Addchildobject(tnttreeview1.Items[0],listbox1.Items[p],nil);
 end;

 for p := 0 to tnttreeview1.Items[0].Count-1 do
 begin
  for x := 0 to selected_targets.Count-1 do
  if (tnttreeview1.Items[0].Item[p].Text = selected_targets.Strings[x]) then
  begin
    tnttreeview1.Select(tnttreeview1.Items[0].Item[p],[ssCtrl]);
    break;
  end;
 end;
 keys.Free;

 MyIniFile.Free;
 MyIniFile2.Free;
 errors.Lines.Clear;
 full.Lines.Clear;
 sourcerec.Lines.Clear;
 marcrecord2memo(source_record, sourcerec);
 sourcerec.SelStart:=0;
 sourcerec.SelLength:=0;
 FillCell(newresults, 0, 1, clWhite, clRed);
 newresults.Cells[0,0]:='#';
 newresults.Cells[1,0]:='Tag';
 newresults.Cells[2,0]:='Heading';
 merged.Clear;
 merged_record:='';

 ActiveControl := term1;
end;

procedure Tzauthlocateform.FormClose(Sender: TObject;  var Action: TCloseAction);
var p:integer;
begin
 for p:=1 to MAXHOSTS do
  zclose(zoom_authhosts[p]);

 zcmdkeys.Free;
 tnames.Free;
 tcodes.Free;
end;

procedure show_records;
var  node : PZOOM_HOST;
     i : integer;
begin
 with zauthlocateform do
 begin
  node:=PZOOM_HOST(TreeView1.Selected.Data);
  newresults.RowCount:=(node^.Records.Count div 3)+1;
  for i:=0 to ((node^.Records.Count div 3)-1) do
  begin
   newresults.Cells[0,i+1]:=inttostr(i+1);
//   errors.Lines.Add(utf8decode(node^.Records[(i*3)+2]));
   get_main_heading(node^.Records[(i*3)+2],tag,heading);
   newresults.Cells[1,i+1]:=tag;
   newresults.Cells[2,i+1]:=heading;
   application.ProcessMessages;
  end;
 end;
end;

procedure Tzauthlocateform.TreeView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HT : THitTests;
  node : PZOOM_HOST;
  rc : integer;
begin
if (Sender is TTntTreeView) then
  begin
  with Sender as TTntTreeView do
    begin
     HT := GetHitTestInfoAt(X,Y);
     if (htOnItem in HT) then
     begin
      node := PZOOM_HOST(GetNodeAt(X,Y).Data);
      label11.Caption:=node^.name+' ('+node^.format+') ';
      label12.Caption:='';
      full.Clear;
      if node^.errorcode = 0 then
      begin
       if node^.hits <> 0 then
       begin
        rc := 0;
        if (node^.mark<node^.hits) then
        begin
         label12.Caption:='Please wait...';
         application.processmessages;
         rc := zpresent(node^,15,node^.Records,'F');
         if rc < 0 then
         begin
           pagecontrol2.ActivePageIndex:=1;
           if rc = -1 then
            errors.Lines.Add('Out of memory')
           else if rc = -2 then
           begin
            errors.Lines.Add('Connection to host '+node^.name+' lost. Resuming...');
            if zresume_search(node^) <> -1 then
            begin
              pagecontrol2.ActivePageIndex:=2;
              rc := zpresent(node^,15,node^.Records,'F');
            end
            else
              errors.Lines.Add('Error connecting to '+node^.name+'.');
           end;
         end;
        end;
        if rc >= 0 then 
        begin
          show_records;
          if (node^.current_row = -1) then
            node^.current_row:=1;
          newresults.Row:=node^.current_row;
          full.lines.Clear;
          marcrecord2memo(node^.Records[((newresults.Row-1)*3)+2], full);
          current_format:= node^.Records[((newresults.Row-1)*3)+1];
          full.SelStart:=0;
          full.SelLength:=0;

          label12.Caption:='Showing 1-'+inttostr(node^.mark)+' of '+inttostr(node^.hits);
         end
         else 
           errors.Lines.Add('Error retrieving records from '+node^.name+'.');
       end
       else
       begin
        newresults.RowCount := 2;
        newresults.Cells[0,1]:='';
        newresults.Cells[1,1]:='';
        newresults.Cells[2,1]:='';
        label12.Caption:='No results.';
       end;
      end
      else
      begin
       newresults.RowCount := 2;
       newresults.Cells[0,1]:='';
       newresults.Cells[1,1]:='';
       newresults.Cells[2,1]:='';
       label12.Caption:=node^.errorstring;
      end;
     end;
    end;
  end;

end;

procedure Tzauthlocateform.FormKeyPress(Sender: TObject; var Key: Char);
var p:integer;
    acontrol: string;
begin
 if key = #27 then zauthlocateform.Close
 else if key =#13 then // enter is pressed
 begin
   acontrol := lowercase(activecontrol.Name);
   for p:=1 to MAXSEARCHFIELDS do
   begin
    if (('term'+inttostr(p) = acontrol) or ('fieldscombobox'+inttostr(p) = acontrol) or
        ('opscombobox'+inttostr(p) = acontrol) or ('truncationcheckbox'+inttostr(p) = acontrol)
    ) then
    begin
     BitBtn3Click(Sender);
     exit;
    end;
   end;
 end;
end;

procedure FillCell(SG : TStringGrid; Col, Row : Integer; BkCol, TextCol : TColor);
var
Rect : TRect;
begin
 Rect := SG.CellRect(Col, Row);
 with SG.Canvas do begin
   Brush.Color := BkCol;
   FillRect(Rect);
   Font.Color := TextCol;
   TextOut(Rect.Left + 2, Rect.Top + 2, SG.Cells[Col, Row]);
 end;
end;


procedure Tzauthlocateform.MergebuttonClick(Sender: TObject);
//var  node : PZOOM_HOST;
begin
 merged.Clear;
 if (full.Lines.Text <> '') then
 begin
  disp2mrc(full.Lines, located_record);
  merged_record:=merge_mrcs(source_record,located_record);
  marcrecord2memo(merged_record, merged);
 end
 else
 begin
  marcrecord2memo(source_record, merged);
 end;
 merged.SelStart:=0;
 merged.SelLength:=0;
 pagecontrol1.ActivePageIndex:=1;
end;

procedure Tzauthlocateform.SavebuttonClick(Sender: TObject);
var
  text : UTF8String;
begin

 if (merged.Lines.Text <> '') then
 begin

  FixMemo(merged);

  if disp2mrc(merged.Lines, merged_record) = 0 then
  begin
   if not SyntaxCheck(merged.Lines,'auth') Then
   begin
     WideShowMessage('You have a syntax error in this record. Please check.');
     Exit;
   end;

   EnhanceMARC(myrecno, merged_record);

   if lowercase(calledfrom) = 'main' then
   begin
    OpenAuthTable(myrecno);
    if data.auth.Locate('recno', myrecno, []) Then
    begin
     EditTable(Data.auth);

     Data.auth['Modifier'] := UserCode;
     Data.auth['Modified'] := today;
     Data.auth.GetBlob('text').AsWideString := StringToWideString(merged_record, Greek_codepage);
     TBlobField(data.auth.FieldByName('text')).Modified := True;

     text := WideStringToString(data.auth.GetBlob('text').AsWideString, Greek_codepage);
     PostTable(data.auth);

     merged.Clear;
     marcrecord2memo(text, merged);
     RecordUpdated(myzebraauthhost, 'update', myrecno, MakeMRCFromAuth(myrecno));
   end;
   end
   else if lowercase(calledfrom) = 'editor' then // called from MARCEditor
   begin
     zauthlocateform.Close;
   end;
  end
  else
   WideShowMessage('You have a syntax error in this record. Please check.');
 end
 else
  WideShowMessage('No record to save');
end;

procedure Tzauthlocateform.Button1Click(Sender: TObject);
begin
 filter_marc_memo(merged);
end;

procedure Tzauthlocateform.Button2Click(Sender: TObject);
var cl,i : integer;
    mater:string;
begin
 cl := -1;
 for i:=0 to merged.Lines.Count-1 do
  if copy(merged.Lines[i],1,5) = '[008]' then begin cl := i; break; end;
 for i:=0 to full.Lines.Count-1 do
  if copy(full.Lines[i],1,5) = '[LDR]' then begin mater:=type_of_material(copy(full.Lines[i],7,100)); break; end;
 if ((mater <>'MP') and (mater <>'VM') and (mater <> 'SE') and (mater <> 'AM') and (mater <> 'MU') and (mater <> 'MA')) then mater :='BK';
 if cl <> -1 then
 begin
  eightauth.Edit1.text:=copy(merged.Lines[cl],7,length(merged.Lines[cl]));
  eightauth.showmodal;
  merged.Lines[cl] :='[008] '+eightauth.Edit1.text;
 end;
end;

procedure Tzauthlocateform.ListBox3Click(Sender: TObject);
var i,p:integer;
    hlp,tno:string;
begin
 for p:=0 to listbox1.Items.Count-1 do
  listbox1.Selected[p]:=false;
 for i := 0 to listbox3.Items.Count-1 do
 begin
  if listbox3.Selected[i] then
  begin
   hlp:=tnames[i];
   hlp:=hlp+',';
   repeat
    p:=pos(',',hlp);
    tno:=copy(hlp,1,p-1);
    hlp:=copy(hlp,p+1,length(hlp));
    for p:=0 to tcodes.Count-1 do
    begin
     if tcodes[p]=tno then listbox1.Selected[p]:=true;
    end;
   until hlp='';
  end;
 end;
 listbox1.itemindex:=0;
end;

procedure Tzauthlocateform.newresultsClick(Sender: TObject);
var  node : PZOOM_HOST;
begin
 node:=PZOOM_HOST(TreeView1.Selected.Data);
 if node^.hits > 0 then
 begin
  node^.current_row:=newresults.Row;
  full.lines.Clear;
  if node^.Records[((newresults.Row-1)*3)+2] <> '' then
  begin
    marcrecord2memo(node^.Records[((newresults.Row-1)*3)+2], full);
    current_format:= node^.Records[((newresults.Row-1)*3)+1];
    if uppercase(current_format) = 'UNIMARC' then
    begin
     if fileexists(extractfilepath(paramstr(0))+'\uni2us\uni2us.ini') then
    end
    else

    full.SelStart:=0;
    full.SelLength:=0;
  end;
 end;
end;

procedure Tzauthlocateform.Button5Click(Sender: TObject);
begin
load_and_merge_record(fastrecordcreator.OpenDialog1, merged);
end;

procedure Tzauthlocateform.Button6Click(Sender: TObject);
var cl,i : integer;
begin
 cl := -1;
 for i:=0 to merged.Lines.Count-1 do
  if copy(merged.Lines[i],1,5) = '[LDR]' then begin cl := i; break; end;
 if cl <> -1 then
 begin
  leaderform.record_type := 'auth';
  leaderform.Edit1.text:=copy(merged.Lines[cl],7,length(merged.Lines[cl]));
  leaderform.showmodal;
  merged.Lines[cl] :='[LDR] '+leaderform.Edit1.text;
 end;
end;

function CompareNames(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(Ttreenode(Item1).Text, Ttreenode(Item2).Text);
end;

procedure Tzauthlocateform.BitBtn3Click(Sender: TObject);
var al : Tlist;
    alx: integer;
    pname : string;
  querystring, q1, q2, s1, t1 : WideString;
  error : WideString;
  cnt, i, p, pp, itidx : integer;
  h, m, willsearch : boolean;
  userid,password,groupid,proxy, name, junk, host, port, database, target, dcharset,
  scharset, format, profile : string;
  ch : char;
  pzh : PZOOM_HOST;
  myinifname, myinifname2, path : string;
  myinifile, myinifile2 : TIniFile;
begin
 label11.Caption:='';
 label12.Caption:='';
 full.Clear;

 path := ExtractFilePath(paramstr(0));
 myinifname := path+'zauthtargets.ini';
 MyIniFile := TIniFile.Create(myinifname);

 cnt:=0;
 for p:=1 to MAXHOSTS do
 begin
  if zoom_authhosts[p].active then zclose(zoom_authhosts[p]);
  zoom_authhosts[p].active:=false;
 end;

 willsearch:=false;

 al:=Tlist.Create;
 al.Clear;
 pname:='';
 if tnttreeview1.GetSelections(al) <> nil then
 begin
  al.Sort(comparenames);
  for alx:=0 to al.Count-1 do
  begin
   if Ttreenode(al[alx]).HasChildren = false then
   begin
    if pname <> Ttreenode(al[alx]).Text then
    begin
   //    showmessage(Ttreenode(al[alx]).Text+' '+tcodes[listbox1.items.IndexOf(Ttreenode(al[alx]).Text)+1]);

       willsearch:=true;
       name:=Ttreenode(al[alx]).Text;
       junk:=tcodes[listbox1.items.IndexOf(Ttreenode(al[alx]).Text)];
       target:='';
       format:='';
       scharset:='';
       dcharset:='';
       proxy:='';
       userid:='';
       password:='';
       groupid:='';
       profile:='';

       with myinifile do
       begin
        target:=readstring(junk,'zurl','');
        format:=readstring(junk,'format','USMARC');
        proxy:=readstring(junk,'proxy','');
        userid:=readstring(junk,'userid','');
        password:=readstring(junk,'password','');
        groupid:=readstring(junk,'groupid','');
        scharset:=UpperCase(readstring(junk,'scharset','UTF8'));
        dcharset:=UpperCase(readstring(junk,'dcharset','UTF8'));
        if dcharset='ADVANCE' then dcharset:='ADVANCEGREEK';
        if dcharset='ISO5428' then dcharset:='ISO5428:1984';
        profile:=readstring(junk,'profile','Zauthcommands');
       end;

       h:=true;
       m:=true;
       host:='';
       port:='';
       database:='';

       for i:=1 to length(target) do
       begin
        ch:=target[i];
        if (ch = ':') then
        begin
         h:=false;
        end;
        if (ch='/') then
        begin
         m:=false;
        end;
        if h then host:=host+ch;
        if ((not h) and m) then port:=port+ch;
        if ((not h) and (not m)) then database:=database+ch;
       end;

       port:=copy(port,2,length(port));
       database:=copy(database,2,length(database));
       if port= '' then port:='210';
       if database='' then database:='Default';
       if profile='' then profile:='Zauthcommands';
       cnt:=cnt+1;
       zoom_authhosts[cnt].id:=junk;
       zoom_authhosts[cnt].name:=name;
       zoom_authhosts[cnt].host:=host;
       zoom_authhosts[cnt].port:=port;
       zoom_authhosts[cnt].database:=database;
       zoom_authhosts[cnt].proxy:=proxy;
       zoom_authhosts[cnt].userid:=userid;
       zoom_authhosts[cnt].password:=password;
       zoom_authhosts[cnt].groupid:=groupid;
       zoom_authhosts[cnt].active:=true;
       zoom_authhosts[cnt].errorcode:=0;
       zoom_authhosts[cnt].errorstring:='';
       zoom_authhosts[cnt].format:=format;
       zoom_authhosts[cnt].scharset:=scharset;
       zoom_authhosts[cnt].dcharset:=dcharset;
       zoom_authhosts[cnt].mark:=0;
       zoom_authhosts[cnt].hits:=0;
       zoom_authhosts[cnt].current_row:=-1;
       zoom_authhosts[cnt].Records.Clear;
       zoom_authhosts[cnt].profile:=profile;

       pname := Ttreenode(al[alx]).Text;
    end;
   end;
  end;
 end;
 al.Free;


 if willsearch = false then
 begin
  exit;
 end;
 pagecontrol2.ActivePageIndex:=1;
 errors.Clear;

 label8.Caption:='Please wait...';
 totalrecords:=0;
 zauthlocateform.Invalidate;
 zauthlocateform.Repaint;
 newresults.RowCount:=2;
 newresults.Cells[0,1]:='';
 newresults.Cells[1,1]:='';
 newresults.Cells[2,1]:='';
 treeview1.Items.Clear;

 for p:=MAXHOSTS downto 1 do
 begin
  if zoom_authhosts[p].active = true then
  begin
{}
// HERE Build the query for each target

   cmds:=Tstringlist.Create;
   cmds.Clear;
   myinifname2 := path+'zparams.ini';
   MyIniFile2 := TIniFile.Create(myinifname2);
   with MyIniFile2 do
   begin
    ReadSectionValues(zoom_authhosts[cnt].profile,cmds);
   end;
   myinifile2.free;

   querystring := ''; error:='';
   s1:='';
   for pp:=1 to MAXSEARCHFIELDS do
   begin
    if (FindComponent('term'+IntToStr(pp)) <> nil) then
    begin
     if (TTntEdit(FindComponent('term'+IntToStr(pp))).Text <> '') then
     begin
      if (querystring<>'') then querystring:=s1+querystring; // add previous valid boolean operator.

      q1:=squeeze(TTntEdit(FindComponent('term'+IntToStr(pp))).Text);
      t1:='';
      if (TCheckBox(FindComponent('truncationcheckbox'+IntToStr(pp))).Checked) then
       t1 := ' @attr 5=1';
      if (FindComponent('fieldscombobox'+IntToStr(pp)) <> nil) then
      begin
        itidx:=TComboBox(FindComponent('fieldscombobox'+IntToStr(pp))).ItemIndex;
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
      if (FindComponent('opscombobox'+IntToStr(pp)) <> nil) then
      begin
        itidx:=TComboBox(FindComponent('opscombobox'+IntToStr(pp))).ItemIndex;
        if itidx=0 then s1:='@and '
        else if itidx=1 then s1:='@or '
        else if itidx=2 then s1:='@not ';
      end;
      querystring:=querystring+' '+q1;
     end;
    end;  // term exist
   end;  //for
   cmds.Free;

// Query is ready
{}
   if (querystring <> '' ) then
   begin
    pzh := @zoom_authhosts[p];
    errors.lines.add('h='+zoom_authhosts[p].name+' z='+zoom_authhosts[p].host+':'+zoom_authhosts[p].port+'/'+zoom_authhosts[p].database+' p='+zoom_authhosts[p].proxy+' sch='+zoom_authhosts[p].scharset+ ' q='+querystring);
    i:= zsearch(zoom_authhosts[p],querystring,strtointdef(timeoutedit.Text,30));
    Application.ProcessMessages;

    if i = -1 then
    begin
     errors.Lines.Add(zoom_authhosts[p].errorstring);
     treeview1.Items.AddobjectFirst(nil,inttostr(p)+' '+zoom_authhosts[p].name+' (Error)',pzh);
    end
    else
    begin
     totalrecords:=totalrecords+i;
     errors.Lines.Add(inttostr(i)+' records found in '+zoom_authhosts[p].name);
     label8.Caption:='Total '+inttostr(totalrecords)+' records found. Please wait...';
     zauthlocateform.Invalidate;
     zauthlocateform.Repaint;
     treeview1.Items.AddobjectFirst(nil,inttostr(p)+' '+zoom_authhosts[p].name+' ('+inttostr(i)+')',pzh);
     if zoom_authhosts[p].errorstring <> '' then
     begin
      errors.Lines.Add(zoom_authhosts[p].errorstring);
     end;
    end;
   end;
  end;
 end;

 pagecontrol2.ActivePageIndex:=2;
 label8.Caption:='';
 newresults.SetFocus;
end;

procedure Tzauthlocateform.BitBtn2Click(Sender: TObject);
var pp : integer;
begin
  for pp:=1 to MAXSEARCHFIELDS do
   if (FindComponent('term'+IntToStr(pp)) <> nil) then
    TTntEdit(FindComponent('term'+IntToStr(pp))).Text:= '';
end;

procedure Tzauthlocateform.TntTreeView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var t,tn:TTntTreeNode;
  HT: THitTests;
begin
  HT := tntTreeView1.GetHitTestInfoAt(X, Y);
  tn := tnttreeview1.GetNodeAt(X,Y);
  if (htOnItem in HT) then
  begin
    if tn.HasChildren then
    begin
     if (ssAlt in Shift) then
     begin
      t:=tn.getFirstChild;
      while t <> nil do
      begin
       tnttreeview1.Select(t,[ssCtrl]);
       t:=tn.getNextChild(t);
      end;
     end;
    end;
  end;
end;

procedure Tzauthlocateform.TntFormPaint(Sender: TObject);
begin
  newresults.Invalidate;
  newresults.Repaint;
end;

procedure Tzauthlocateform.TntFormResize(Sender: TObject);
var vwidth : integer;
begin
  vwidth := newresults.Width-27;
  newresults.ColWidths[0] := round(vwidth * 0.05);
  newresults.ColWidths[1] := round(vwidth * 0.15);
  newresults.ColWidths[2] := round(vwidth * 0.8);
end;

procedure Tzauthlocateform.TntFormDestroy(Sender: TObject);
begin
  selected_targets.Free;
end;

end.
