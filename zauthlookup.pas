unit zauthlookup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, IniFiles, ExtCtrls, common, zoomit, DataUnit, ComCtrls,
  mycharconversion, TntStdCtrls, TntGrids, DateUtils, TntDialogs, TntClasses,
  utility, TntComCtrls, ImgList, Buttons, TntButtons, TntExtCtrls, TntForms, DB, cUnicodeCodecs;

type
  Tzauthlookupform = class(TTntForm)
    term1: TTntEdit;
    ListBox1: TTntListBox;
    errors: TTntMemo;
    truncationcheckbox1: TTntCheckBox;
    Label8: TTntLabel;
    newresults: TTntStringGrid;
    Label12: TTntLabel;
    fieldscombobox1: TTntComboBox;
    full: TTntMemo;
    ImageList1: TImageList;
    clearbutton: TTntBitBtn;
    lookupbutton: TTntBitBtn;
    nextrecs: TTntBitBtn;
    prevrecs: TTntBitBtn;
    useheadingbutton: TTntBitBtn;
    cancelbutton: TTntBitBtn;
    New: TTntBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure newresultsClick(Sender: TObject);
    procedure lookupbuttonClick(Sender: TObject);
    procedure clearbuttonClick(Sender: TObject);
    procedure TntFormPaint(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure nextrecsClick(Sender: TObject);
    procedure prevrecsClick(Sender: TObject);
    procedure useheadingbuttonClick(Sender: TObject);
    procedure cancelbuttonClick(Sender: TObject);
    procedure getrecords;
    procedure NewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //globalproxy,
    tag, heading,
    result_heading,
    result_ind      : WideString;

    totalrecords:integer;
    tagmappings,
    cmdnames, // Commands as displayed in comboboxes.
    cmds,     // RPN commands attributes.
    ops,      // boolean operands names.
    zcmdkeys, // internal presentation of search commands.
    keys : TStrings;
    recordset : TTntStrings;
  end;

var
  zauthlookupform: Tzauthlookupform;

const MAXSEARCHFIELDS = 1;
      RECORDS_PER_PAGE = 15;
implementation

uses MainUnit, GlobalProcedures,
  MARCAuthEditor;

{$R *.dfm}

procedure FillCell(SG : TStringGrid; Col, Row : Integer; BkCol, TextCol : TColor); forward;

procedure Tzauthlookupform.FormCreate(Sender: TObject);
begin
  KeyPreview := True;
  recordset := TTntstringlist.Create;
end;

procedure Tzauthlookupform.FormActivate(Sender: TObject);
var
  p, i : integer;
  langcode, path, myinifname2, hlp : string;
  myIniFile2 : TIniFile;
begin
 label12.Caption := '';
 result_ind := '';
 result_heading := '';
 heading := extract_fields(heading, 'abcdefghijklmnopqrstuvwxyz0123456789', '$');
 heading := remove_punctuation(heading);

 zoom_authhosts[1].name:='MyZebraAuthDatabase';
 zoom_authhosts[1].host:=FastRecordCreator.myzebraauthhostname;
 zoom_authhosts[1].port:=FastRecordCreator.myzebraauthport;
 zoom_authhosts[1].database:=FastRecordCreator.myzebraauthdatabase;
 zoom_authhosts[1].proxy:=FastRecordCreator.myzproxy;
 zoom_authhosts[1].active:=false;
 zoom_authhosts[1].errorcode:=0;
 zoom_authhosts[1].errorstring:='';
 zoom_authhosts[1].format:='Usmarc';
 zoom_authhosts[1].scharset:=UpperCase(FastRecordCreator.myzcharset);
 zoom_authhosts[1].dcharset:=UpperCase(FastRecordCreator.myzcharset);
 zoom_authhosts[1].profile:=FastRecordCreator.myzauthprofile+'commands';
 zoom_authhosts[1].mark:=0;
 zoom_authhosts[1].hits:=0;
 label8.Caption:='';
 newresults.RowCount:=2;
 newresults.Cells[0,1]:='';
 newresults.Cells[1,1]:='';
 newresults.Cells[2,1]:='';

 keys:=Tstringlist.Create;
 keys.Clear;

 path:=extractfilepath(paramstr(0));
 myinifname2 := path+'zparams.ini';

 zcmdkeys:=Tstringlist.Create;
 zcmdkeys.Clear;
 cmdnames:=Tstringlist.Create;
 cmdnames.Clear;
 ops:=Tstringlist.Create;
 ops.Clear;
 tagmappings:=Tstringlist.Create;
 tagmappings.Clear;

 langcode:='en';
 MyIniFile2 := TIniFile.Create(myinifname2);

 with MyIniFile2 do
 begin
  ReadSectionValues('myzebauthcommands_descr.'+langcode,zcmdkeys);
  for p:=0 to zcmdkeys.Count -1 do
   cmdnames.Add(zcmdkeys.ValueFromIndex[p]);
  // Add operators
  hlp:=ReadString('Zops.'+langcode,'@and','And');
  ops.Add(hlp);
  hlp:=ReadString('Zops.'+langcode,'@or','Or');
  ops.Add(hlp);
  hlp:=ReadString('Zops.'+langcode,'@not','And Not');
  ops.Add(hlp);

  ReadSectionValues('tag2myzebauthcommand',tagmappings);
  i:=tagmappings.IndexOfName(tag);
  if (i <> -1) then
  begin
    i:= zcmdkeys.IndexOfName(tagmappings.ValueFromIndex[i]);
  end;

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
    if i <> -1 then itemindex:=i;
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

 keys.Clear;
 keys.Free;
 tagmappings.Clear;
 tagmappings.Free;

 MyIniFile2.Free;
 errors.Lines.Clear;
 full.Lines.Clear;
 FillCell(newresults, 0, 1, clWhite, clRed);
 newresults.Cells[0,0]:='#';
 newresults.Cells[1,0]:='Tag';
 newresults.Cells[2,0]:='Heading';

 term1.Text := heading;
 ActiveControl := term1;
end;

procedure Tzauthlookupform.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
 zclose(zoom_authhosts[1]);
 zcmdkeys.Free;
end;

procedure show_records;
var i : integer;
begin
 with zauthlookupform do
 begin
  newresults.RowCount:=(recordset.Count div 3)+1;
  for i:=0 to ((recordset.Count div 3)-1) do
  begin
   newresults.Cells[0,i+1] := inttostr(zoom_authhosts[1].mark-(recordset.Count div 3)+i+1);

//   errors.Lines.Add(utf8decode(recordset[(i*3)+2]));
   get_main_heading(recordset[(i*3)+2],tag,heading);
   newresults.Cells[1,i+1]:=tag;
   newresults.Cells[2,i+1]:=heading;
   application.ProcessMessages;
  end;
 end;
end;

procedure Tzauthlookupform.getrecords;
var
  rc : integer;
begin
  label12.Caption:='';
  full.Clear;
  if zoom_authhosts[1].errorcode = 0 then
  begin
   if zoom_authhosts[1].hits <> 0 then
   begin
    rc := 0;
    if (zoom_authhosts[1].mark < zoom_authhosts[1].hits) then
    begin
     label12.Caption:='Please wait...';
     application.processmessages;
     rc := zpresent(zoom_authhosts[1], RECORDS_PER_PAGE, recordset,'F');
     if rc < 0 then
     begin
       if rc = -1 then
        errors.Lines.Add('Out of memory')
       else if rc = -2 then
       begin
        errors.Lines.Add('Connection to host '+zoom_authhosts[1].name+' lost. Resuming...');
        if zresume_search(zoom_authhosts[1]) <> -1 then
        begin
          rc := zpresent(zoom_authhosts[1], RECORDS_PER_PAGE, recordset,'F');
        end
        else
          errors.Lines.Add('Error connecting to '+zoom_authhosts[1].name+'.');
       end;
     end;
    end;
    if rc >= 0 then
    begin
      show_records;
      if (zoom_authhosts[1].current_row = -1) then
        zoom_authhosts[1].current_row:=1;
      newresults.Row:=zoom_authhosts[1].current_row;
      full.lines.Clear;
      marcrecord2memo(recordset[((newresults.Row-1)*3)+2], full);
      full.SelStart:=0;
      full.SelLength:=0;
      label12.Caption := 'Showing '+inttostr(zoom_authhosts[1].mark-(recordset.Count div 3)+1)+'-'+inttostr(zoom_authhosts[1].mark);
      label12.Caption := label12.Caption+' of '+inttostr(zoom_authhosts[1].hits);
    end
    else
      errors.Lines.Add('Error retrieving records from '+zoom_authhosts[1].name+'.');
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
     label12.Caption:=zoom_authhosts[1].errorstring;
   end;
end;

procedure Tzauthlookupform.FormKeyPress(Sender: TObject; var Key: Char);
var p:integer;
    acontrol: string;
begin
 if key = #27 then zauthlookupform.Close
 else if key =#13 then // enter is pressed
 begin
   acontrol := lowercase(activecontrol.Name);
   for p:=1 to MAXSEARCHFIELDS do
   begin
    if (('term'+inttostr(p) = acontrol) or ('fieldscombobox'+inttostr(p) = acontrol) or
        ('opscombobox'+inttostr(p) = acontrol) or ('truncationcheckbox'+inttostr(p) = acontrol)
    ) then
    begin
     LookupbuttonClick(Sender);
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

procedure Tzauthlookupform.newresultsClick(Sender: TObject);
begin
 if zoom_authhosts[1].hits > 0 then
 begin
  zoom_authhosts[1].current_row:=newresults.Row;
  full.lines.Clear;
  if recordset[((newresults.Row-1)*3)+2] <> '' then
  begin
    marcrecord2memo(recordset[((newresults.Row-1)*3)+2], full);
    full.SelStart:=0;
    full.SelLength:=0;
  end;
 end;
end;

function CompareNames(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(Ttreenode(Item1).Text, Ttreenode(Item2).Text);
end;

procedure Tzauthlookupform.lookupbuttonClick(Sender: TObject);
var
  querystring, q1, q2, s1, t1 : WideString;
  error : WideString;
  i, pp, itidx : integer;
  name, junk : string;
  myinifname2, path : string;
  myinifile2 : TIniFile;
begin
 label12.Caption:='';
 full.Clear;

 path := ExtractFilePath(paramstr(0));

 if zoom_authhosts[1].active then zclose(zoom_authhosts[1]);

 zoom_authhosts[1].id:=junk;
 zoom_authhosts[1].name:=name;
 zoom_authhosts[1].userid:='';
 zoom_authhosts[1].password:='';
 zoom_authhosts[1].groupid:='';
 zoom_authhosts[1].active:=true;
 zoom_authhosts[1].errorcode:=0;
 zoom_authhosts[1].errorstring:='';
 zoom_authhosts[1].format:='USMARC';
 zoom_authhosts[1].mark:=0;
 zoom_authhosts[1].hits:=0;
 zoom_authhosts[1].current_row:=-1;
 recordset.Clear;

 errors.Clear;

 label8.Caption:='Please wait...';
 totalrecords:=0;
 zauthlookupform.Invalidate;
 zauthlookupform.Repaint;
 newresults.RowCount:=2;
 newresults.Cells[0,1]:='';
 newresults.Cells[1,1]:='';
 newresults.Cells[2,1]:='';

// HERE Build the query for each target

   cmds:=Tstringlist.Create;
   cmds.Clear;
   myinifname2 := path+'zparams.ini';
   MyIniFile2 := TIniFile.Create(myinifname2);
   with MyIniFile2 do
   begin
    ReadSectionValues(zoom_authhosts[1].profile,cmds);
   end;
   myinifile2.free;
   querystring := '';
   error:='';
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
    errors.lines.add('h='+zoom_authhosts[1].name+' z='+zoom_authhosts[1].host+':'+zoom_authhosts[1].port+'/'+zoom_authhosts[1].database+' p='+zoom_authhosts[1].proxy+' sch='+zoom_authhosts[1].scharset+ ' q='+querystring);
    i:= zsearch(zoom_authhosts[1],querystring,30);
    Application.ProcessMessages;

    if i = -1 then
    begin
     errors.Lines.Add(zoom_authhosts[1].errorstring);
    end
    else
    begin
     totalrecords:=totalrecords+i;
     errors.Lines.Add(inttostr(i)+' records found in '+zoom_authhosts[1].name);
     label8.Caption:='Total '+inttostr(totalrecords)+' records found. Please wait...';
     zauthlookupform.Invalidate;
     zauthlookupform.Repaint;
     if zoom_authhosts[1].errorstring <> '' then
     begin
      errors.Lines.Add(zoom_authhosts[1].errorstring);
     end;
     getrecords;
    end;
   end;

 label8.Caption:='';
 newresults.SetFocus;
end;

procedure Tzauthlookupform.clearbuttonClick(Sender: TObject);
var pp : integer;
begin
  for pp:=1 to MAXSEARCHFIELDS do
   if (FindComponent('term'+IntToStr(pp)) <> nil) then
    TTntEdit(FindComponent('term'+IntToStr(pp))).Text:= '';
end;

procedure Tzauthlookupform.TntFormPaint(Sender: TObject);
begin
  newresults.Invalidate;
  newresults.Repaint;
end;

procedure Tzauthlookupform.TntFormResize(Sender: TObject);
var vwidth : integer;
begin
  vwidth := newresults.Width-27;
  newresults.ColWidths[0] := round(vwidth * 0.05);
  newresults.ColWidths[1] := round(vwidth * 0.15);
  newresults.ColWidths[2] := round(vwidth * 0.8);
end;

procedure Tzauthlookupform.nextrecsClick(Sender: TObject);
begin
  if (zoom_authhosts[1].mark < zoom_authhosts[1].hits) then
  begin
    recordset.Clear;
    getrecords;
  end;
end;

procedure Tzauthlookupform.prevrecsClick(Sender: TObject);
var rem : integer;
begin
  rem := zoom_authhosts[1].mark mod RECORDS_PER_PAGE;
  if rem = 0 then rem := RECORDS_PER_PAGE;
  zoom_authhosts[1].mark := zoom_authhosts[1].mark - RECORDS_PER_PAGE - rem;
  if (zoom_authhosts[1].mark < 0) then zoom_authhosts[1].mark := 0;
  recordset.Clear;
  getrecords;
end;

procedure Tzauthlookupform.useheadingbuttonClick(Sender: TObject);
var authtag, authind, authheading : WideString;
begin
  if (full.Lines.Count > 0) then
  begin
    get_main_heading_from_memo(full, authtag, authind, authheading);
    result_ind := authind;
    result_heading := authheading;
  end;
end;

procedure Tzauthlookupform.cancelbuttonClick(Sender: TObject);
begin
// zcmdkeys.Free;
 close;
end;

procedure Tzauthlookupform.NewClick(Sender: TObject);
var temp : UTF8string;
begin
  NewMARCRecord('auth');
  FastRecordCreator.gotoauthrecno := data.auth.FieldByName('recno').AsInteger;
  MARCAuthEditorForm.record_index := -1;
  MARCAuthEditorForm.edit_from_result_set := false;
  with data.auth do
  begin
    EditTable(data.auth);
    temp := makenewauthmrc;
    if length(temp) >= 10 then temp[10] := 'a';
    EnhanceMARC(FastRecordCreator.gotoauthrecno, temp);
    GetBlob('text').IsUnicode := True;
    GetBlob('text').AsWideString := StringToWideString(temp, Greek_codepage);
    TBlobField(FieldByName('text')).Modified := True;
    PostTable(data.auth);
    RecordUpdated(myzebraauthhost, 'insert', FastRecordCreator.gotoauthrecno, temp);
  end;
  MARCAuthEditorForm.ShowModal;
end;

end.
