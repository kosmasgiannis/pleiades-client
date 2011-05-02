unit utility;

interface

uses   db, Windows, ShellApi, Winsock, controls, MyAccess, Forms,
       StdCtrls, dialogs, TntDialogs, TntGrids, Grids;

type integerArray = array of integer;

 //Refering to user procedure
procedure PostTable(Table: TDataSet);
procedure CancelTable(Table: TDataSet);
procedure EditTable(Table: TDataSet);
function IsInEdit(Table: TDataSet): boolean;
procedure MessOK(msg1 : string);
procedure ShowSaveDialog(Table : TDataSet);
procedure Terminate_Program;
procedure ApplyUserAccess;

procedure PopulateListBoxFromTable(ListBox : TCustomListBox; table, field : string);
procedure OpenSecureBasketTable(recnr : integer);
procedure OpenAuthTable(recnr : integer);

function enterbox(title,prompt,def:string) : string;

function URLEncode(const S: string; const InQueryString: Boolean): string;
function URLDecode(const S: string): string;
function GetIPFromHost(var HostName, IPaddr, WSAErr: string): Boolean;
function RunFile(homedir, filename,params : string; Showmode:integer) : integer;

procedure Clear_String_Grid(name : TtntStringGrid);
procedure StoreColWidths(var arr : integerArray; name : TtntStringGrid);
procedure RestoreColWidths(arr : integerArray; name : TtntStringGrid);

implementation

uses DataUnit, SysUtils, DateUtils, MainUnit, GlobalProcedures,
  ItemsUnit, HoldingsUnit, MARCEditor;

function enterbox(title,prompt,def:string) : string;
begin
 result:=inputbox(title,prompt,'<cancel>');
end;

procedure PostTable(Table: TDataSet);
begin
  if (Table.State=dsEdit)or(Table.State=dsInsert)
    Then Table.Post;
end;

procedure EditTable(Table: TDataSet);
begin
  if (Table.State<>dsEdit)and(Table.State<>dsInsert)
    Then Table.Edit;
end;

procedure CancelTable(Table: TDataSet);
begin
  if (Table.State=dsEdit)or(Table.State=dsInsert)
    Then Table.Cancel;
end;

function IsInEdit(Table: TDataSet): boolean;
begin
  Result := (Table.State=dsEdit)or(Table.State=dsInsert);
end;

procedure MessOK(msg1 : string);
begin
  MessageBox(0,PAnsiChar(msg1),PAnsiChar(Application.Title), MB_OK + MB_ICONEXCLAMATION + MB_TASKMODAL);
end;

procedure ShowSaveDialog(Table : TDataSet);
begin
  case
       MessageBox(0,'Do you want to save the changes?', PChar(Application.Title), MB_YESNO + MB_ICONQUESTION + MB_TASKMODAL) of
    mrYes :
           PostTable(Table);
    mrNo :
         CancelTable(Table);
   end;
end;

procedure ApplyUserAccess;
begin

  MARCEditorForm.TntbitBtn1.Visible := current_user_access > 0;
  MARCEditorForm.TntbitBtn3.Visible := current_user_access > 0;
  MARCEditorForm.New.Visible := current_user_access > 0;
  MARCEditorForm.TntbitBtn5.Visible := current_user_access > 0;
  MARCEditorForm.TntbitBtn6.Visible := current_user_access > 0;
  MARCEditorForm.ToolsBtn.Visible := current_user_access > 0;
  Holdings.TntbitBtn1.Visible := current_user_access > 0;
  Holdings.TntbitBtn2.Visible := current_user_access > 0;
  Holdings.OK.Visible := current_user_access > 0;
  ItemsForm.TntbitBtn1.Visible := current_user_access > 0;
  ItemsForm.OK.Visible := current_user_access > 0;
  Holdings.DeleteBtn.Visible := current_user_access > 0;
  ItemsForm.DeleteBtn.Visible := current_user_access > 0;

  Holdings.DeleteBtn.Enabled := current_user_access >= 6;
  ItemsForm.DeleteBtn.Enabled := current_user_access >= 6;

  with FastRecordCreator do
  begin
    BibAuthSwitch.Enabled :=  current_user_access > 0;
    //CheckBox2.Enabled := current_user_access > 0;
    //DateTimePicker1.Enabled := current_user_access > 0;
    New.Enabled := current_user_access > 0;
    Newtmpl.Enabled := current_user_access > 0;
    CopyRecBtn.Enabled := current_user_access > 0;
    BibAuthSwitch.Visible :=  current_user_access > 0;
    //CheckBox2.Visible := current_user_access > 0;
    //DateTimePicker1.Visible := current_user_access > 0;
    New.Visible := current_user_access > 0;
    Newtmpl.Visible := current_user_access > 0;
    CopyRecBtn.Visible := current_user_access > 0;

    NewRecord1.Visible := current_user_access > 0;
    NewRecordFromTemplate1.Visible := current_user_access > 0;
    CopyRecord1.Visible := current_user_access > 0;
    LocateBtn.Visible := current_user_access > 0;
    mainmenu1.Items[1].Visible := current_user_access>0;
    mainmenu1.Items[2].Visible := current_user_access>0;
    Settings1.Visible := current_user_access>0;
    N2.Visible := current_user_access>0;
    SetDefaultBranch1.Visible :=  current_user_access>0;

    Configure.Visible := current_user_access = 10;
    N1.Visible := current_user_access = 10;
    //ChangeDatabase1.Visible := current_user_access = 10;
    import1.Visible:= current_user_access = 10;
    replaceMARCrecords1.Visible:= current_user_access = 10;
    finalexport1.Visible := current_user_access = 10;
    finalexport2.Visible := current_user_access = 10;
    Utitlities1.Visible  := current_user_access = 10;
    MyRecords.Visible  := (current_user_access > 0) and (current_user_access <= 8);
    TntLabel2.Visible  := current_user_access = 10;
    UsersCombo.Visible  := current_user_access = 10;
    ExporttoWordBtn.Visible := current_user_access = 10;
    About.Enabled := true;
    statistics_button.Visible := current_user_access = 10;

  end;

end;

procedure Terminate_Program;
begin
 append_move(UserCode, 2,Today, CurrentUserName + ' logged out');
 if data.basket.Active then data.basket.Close;
 if data.securebasket.Active then data.securebasket.Close;
 if data.hold.Active then data.hold.Close;
 if data.auth.Active then data.auth.Close;
 if data.items.Active then data.items.Close;
 if data.users.Active then data.users.Close;
 if data.moves.Active then data.moves.Close;
 if data.MyConnection1.Connected then Data.MyConnection1.Disconnect;
 Application.Terminate;
end;

procedure PopulateListBoxFromTable(ListBox : TCustomListBox; table, field : string);
begin

  with data.Query1 do
  begin
    SQL.Clear;
    SQL.Add('select distinct ' + field + ' from ' + table);
    Execute;

    ListBox.Items.Clear;

    while not Eof do
    begin
      if Not FieldByName(field).isNull then
        ListBox.Items.Add(FieldByName(field).Value);
      Next;
    end;
    if ListBox.Items.Count > 0 then
       ListBox.ItemIndex := 0;
  end;

end;

procedure OpenSecureBasketTable(recnr : integer);
begin
   with data.SecureBasket do
   begin
     Close;
     ParamByName('recno').AsInteger := recnr;
     Execute;
   end;
end;

procedure OpenAuthTable(recnr : integer);
begin
   with data.auth do
   begin
     Close;
     ParamByName('recno').AsInteger := recnr;
     Execute;
   end;
end;

function URLEncode(const S: string; const InQueryString: Boolean): string;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
      else
        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

function URLDecode(const S: string): string;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer;  // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;

function GetIPFromHost(var HostName, IPaddr, WSAErr: string): Boolean;
type
  Name = array[0..100] of Char;
  PName = ^Name;
var
  HEnt: pHostEnt;
  HName: PName;
  WSAData: TWSAData;
  i: Integer;
begin
  Result := False;
  if WSAStartup($0101, WSAData) <> 0 then begin
    WSAErr := 'Winsock is not responding."';
    Exit;
  end;
  IPaddr := '';
  New(HName);
  if GetHostName(HName^, SizeOf(Name)) = 0 then
  begin
    HostName := StrPas(HName^);
    HEnt := GetHostByName(HName^);
    for i := 0 to HEnt^.h_length - 1 do
     IPaddr :=
      Concat(IPaddr,
      IntToStr(Ord(HEnt^.h_addr_list^[i])) + '.');
    SetLength(IPaddr, Length(IPaddr) - 1);
    Result := True;
  end
  else begin
   case WSAGetLastError of
    WSANOTINITIALISED:WSAErr:='WSANotInitialised';
    WSAENETDOWN      :WSAErr:='WSAENetDown';
    WSAEINPROGRESS   :WSAErr:='WSAEInProgress';
   end;
  end;
  Dispose(HName);
  WSACleanup;
end;

function RunFile(homedir, filename,params : string; Showmode:integer) : integer;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  ExecuteFile, p, StartInString: string;
begin
  p:=params;
  ExecuteFile:=filename;
  Exitcode:=0;
  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExecuteFile);
// ParamString can contain the application parameters.
  lpParameters := PChar(p);
// StartInString specifies the name of the working directory.
// If ommited, the current directory is used.
    startinstring:=homedir;
    lpDirectory := PChar(Startinstring);
    nShow := Showmode;
//    nShow := SW_SHOWNORMAL;
//    nShow := SW_HIDE;
  end;
  if ShellExecuteEx(@SEInfo) then
  begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess, ExitCode);
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
    result:=ExitCode;
//showmessage( SysErrorMessage(GetLastError));
//    showmessage(SEInfo.lpFile+' '+Seinfo.lpDirectory+' '+SEInfo.lpParameters);
  end
  else result:=0;
end;

procedure Clear_String_Grid(name : TtntStringGrid);
var n,m, r , c : integer;
    myRect: TGridRect;
begin
// Select first grid row
  m:=name.ColCount-1;
  n:=name.RowCount-1;
  myRect.Left := 0;
  myRect.Top := 1;
  myRect.Right := m;
  myRect.Bottom := 1;

  name.Selection := myRect;
  for r:=1 to n do
  begin
    for c :=0 to m do name.Rows[r].Strings[c] := '';
  end;
end;

procedure StoreColWidths(var arr : integerArray; name : TtntStringGrid);
var  m,i:integer;
begin
  m:=name.ColCount-1;
  SetLength(arr, m+1);
  for i:=0 to m do
   arr[i] := name.ColWidths[i];
end;

procedure RestoreColWidths(arr : integerArray; name : TtntStringGrid);
var  m,i:integer;
begin
  name.ColCount := Length(arr);
  m :=   name.ColCount - 1;
  for i:=0 to m do
   name.ColWidths[i] := arr[i];
end;

end.
