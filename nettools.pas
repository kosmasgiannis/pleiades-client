unit GeneralApplicationToolkitUnit;

interface

uses
  Windows, SysUtils, Classes, Forms, IdHTTP, IdComponent, ShellAPI,
  ComObj, ActiveX, NB30, ComCtrls, Gauges, DateUtils, terautils;

var
  product_name, product_code, product_version, product_current_version, product_current_version_url,
    computer_mac, product_infofile, product_contactfile, product_updater_url: AnsiString;
  FProductRegistered, FProductActivated: boolean;


//Downloads and runs the updated application (this is called from the updater)
procedure DownloadUpdate(AURL: string);

//Downloads and runs the updater (example: Agenda_update.exe)
procedure UpdaterDownload(AURL: string);

function DownloadFileIntoStr(const AURL: string; const AUserName: string = ''; const APassword: string = ''): string;

//Finalize the URL as adding timestamp to it etc
function FinalizeURL(URL: string): string;

function IsInternet(): boolean;

//______________________________________________________________________________

type
  TUpdate = class
  private
//FProgressBar: TProgressBar;
    FProgressBar: TGauge;
    FHTTP: TIdHTTP;
    FMaxProgress: int64;
    FAbort: boolean;
  protected
    procedure OnProgressBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: int64);
    procedure OnProgress(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: int64);
    procedure OnProgressEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure InitUpdate();
  public
    constructor Create(AProgressBar: TGauge { TProgressBar } = nil);
    destructor Destroy; override;
    procedure UpdaterDownload(AURL: string);
    procedure DownloadUpdate(AURL: string);
    function DownloadUpdateChanged(AURL: string): string;
    procedure DownloadFileToFile(const AURL, AFileName: string);
    procedure Cancel;
    procedure UPdateAsk;
  end;

  TSunB = packed record
    s_b1, s_b2, s_b3, s_b4: byte;
  end;

  TSunW = packed record
    s_w1, s_w2: word;
  end;

  PIPAddr = ^TIPAddr;

  TIPAddr = record
    case integer of
      0:
      (S_un_b: TSunB);
      1:
      (S_un_w: TSunW);
      2:
      (S_addr: longword);
  end;

  IPAddr = TIPAddr;
function IcmpCreateFile: THandle; stdcall; external 'icmp.dll';
function IcmpCloseHandle(icmpHandle: THandle): boolean; stdcall; external 'icmp.dll';
function IcmpSendEcho(icmpHandle: THandle; DestinationAddress: IPAddr; RequestData: Pointer; RequestSize: Smallint; RequestOptions: Pointer;
  ReplyBuffer: Pointer; ReplySize: DWORD; Timeout: DWORD): DWORD; stdcall; external 'icmp.dll';
function Ping(InetAddress: AnsiString): boolean;

procedure UPdateAsk;
//______________________________________________________________________________

implementation

uses
  Dialogs, HTTPApp, WinSock, controls, Variants;
//______________________________________________________________________________

procedure TranslateStringToTInAddr(AIP: AnsiString; var AInAddr);
var
  phe: PHostEnt;
  pac: PAnsiChar;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  try
    phe := GetHostByName(PAnsiChar(AIP));
    if Assigned(phe) then
    begin
      pac := phe^.h_addr_list^;
      if Assigned(pac) then
      begin
        with TIPAddr(AInAddr).S_un_b do
        begin
          s_b1 := byte(pac[0]);
          s_b2 := byte(pac[1]);
          s_b3 := byte(pac[2]);
          s_b4 := byte(pac[3]);
        end;
      end
      else
        raise Exception.Create('Error getting IP from HostName');
    end
    else
      raise Exception.Create('Error getting HostName');
  except
    FillChar(AInAddr, SizeOf(AInAddr), #0);
  end;
  WSACleanup;
end;
//______________________________________________________________________________

function Ping(InetAddress: AnsiString): boolean;
var
  Handle: THandle;
  InAddr: IPAddr;
  DW: DWORD;
  rep: array[1..128] of byte;
begin
  Result := false;
  Handle := IcmpCreateFile;
  if Handle = INVALID_HANDLE_VALUE then
    Exit;
  TranslateStringToTInAddr(InetAddress, InAddr);
  DW := IcmpSendEcho(Handle, InAddr, nil, 0, nil, @rep, 128, 1000);
  Result := (DW <> 0);
  IcmpCloseHandle(Handle);
end;
//______________________________________________________________________________

function IsInternet(): boolean;
  function FuncAvail(_dllname, _funcname: string; var _p: Pointer): boolean;
  { return True if _funcname exists in _dllname }
  var
    _lib: THandle;
  begin
    Result := false;
    if LoadLibrary(PChar(_dllname)) = 0 then
      Exit;
    _lib := GetModuleHandle(PChar(_dllname));
    if _lib <> 0 then
    begin
      _p := GetProcAddress(_lib, PChar(_funcname));
      if _p <> nil then
        Result := True;
    end;
  end;

const
  IPs: array[1..3] of AnsiString = ('google.com', 'yahoo.com', 'microsoft.com');
var
  InetIsOffline: function(dwFlags: DWORD): BOOL;
  stdcall;
  I:
    integer;
begin
  Result := false;
  if FuncAvail('URL.DLL', 'InetIsOffline', @InetIsOffline) and (not InetIsOffline(0)) then
  begin
    try
      for I := 1 to length(IPs) do
      begin
        if Ping(IPs[I]) then
        begin
          Result := True;
          break;
        end;
      end;
    except
    end;
  end;
end;
//______________________________________________________________________________

function DownloadFileIntoStr(const AURL: string; const AUserName: string = ''; const APassword: string = ''): string;
begin
  with TIdHTTP.Create(nil) do
  begin
    try
      Request.BasicAuthentication := True;
      Request.Username := AUserName;
      Request.Password := APassword;
      Result := Get(AURL);
    finally
      Free;
    end;
  end
end;
//______________________________________________________________________________

procedure DownloadUpdate(AURL: string);
var
  IdHTTP: TIdHTTP;
  f: TMemoryStream;
  PATH, app, exe, bak: string;
  p: integer;
begin
  PATH := ExtractFilePath(ParamStr(0));
  app := ExtractFileName(StringReplace(AURL, '/', '\', [rfReplaceAll]));
  exe := PATH + app;
  p := pos('?', exe);
  if p > 0 then
  begin
    Delete(exe, p, length(exe));
  end;

  bak := ChangeFileExt(exe, '.BAK');

  if FileExists(bak) then
    DeleteFile(bak);
  sleep(50);
  RenameFile(exe, bak);
  sleep(50);
  f := TMemoryStream.Create;
  IdHTTP := TIdHTTP.Create(nil);
  try
    try
      IdHTTP.HandleRedirects := True;
      IdHTTP.Get(FinalizeURL(AURL), f);
      f.SaveToFile(exe);
      sleep(50);
      DeleteFile(bak);

      MessageDlg(Format('Congratulations. Now you have the latest version of %s. Thank you.', [UpperCase(ChangeFileExt(app, ''))]), mtInformation, [mbOK], 0);
//WinExec(PChar(EXE), SW_SHOWNORMAL);

      ShellExecute(0, 'Open', PChar(exe), nil, nil, SW_SHOWNORMAL);

      Application.Terminate;
    except
      on E: EIdHTTPProtocolException do
        if E.ErrorCode = 404 then
          ShowMessage('Error :' +  AURL +  ' File missing');
    end;
  finally
    f.Free;
    IdHTTP.Free;
  end;
end;
//______________________________________________________________________________

procedure UpdaterDownload(AURL: string);
var
  IdHTTP: TIdHTTP;
  f: TMemoryStream;
  PATH, exe, bak: string;
  p: integer;
begin
  PATH := ExtractFilePath(ParamStr(0));
  exe := PATH + ExtractFileName(StringReplace(AURL, '/', '\', [rfReplaceAll]));
  p := pos('?', exe);
  if p > 0 then
  begin
    Delete(exe, p, length(exe));
  end;

  bak := ChangeFileExt(exe, '.BAK');

  //If the file to be downloaded exists rename it to .bak
  if FileExists(bak) then
    DeleteFile(bak);
  sleep(50);
  RenameFile(exe, bak);
  sleep(50);

  //Download the file
  f := TMemoryStream.Create;
  IdHTTP := TIdHTTP.Create(nil);
  try
    try
      IdHTTP.HandleRedirects := True;
      IdHTTP.Get(FinalizeURL(AURL), f);

      f.SaveToFile(exe);
      sleep(50);
      //Execute newly generated file
      DeleteFile(bak);

    //WinExec(PChar(EXE), SW_SHOWNORMAL);
      ShellExecute(0, 'Open', PChar(exe), nil, nil, SW_SHOWNORMAL);

      Application.Terminate;
    except
      on E: EIdHTTPProtocolException do
        if E.ErrorCode = 404 then
          ShowMessage('Error' + AURL + ' Updater missing');
    end;
  finally
    f.Free;
    IdHTTP.Free;
  end;
end;
//______________________________________________________________________________

procedure UPdateAsk;
var
  buttonselected: integer;
  PostponedFile: TextFile;
  PostponedFileName, PostPonedDateF: string;
  ask: boolean;
  MySettings: TFormatSettings;

begin
  GetLocaleFormatSettings(GetUserDefaultLCID, MySettings);
  MySettings.DateSeparator := '-';
  MySettings.TimeSeparator := ':';
  MySettings.ShortDateFormat := 'mm-dd-yyyy';
  MySettings.ShortTimeFormat := 'hh:nn:ss';
  PostponedFileName := 'postponed.txt';
  AssignFile(PostponedFile, PostponedFileName);
  if FileExists(PostponedFileName) then
  begin
    Reset(PostponedFile);
    Readln(PostponedFile, PostPonedDateF);
    CloseFile(PostponedFile);

    if (StrToDateTime(PostPonedDateF, MySettings) <= StrToDateTime(DateTimeToStr(Now, MySettings), MySettings)) then
      ask := True
    else
      ask := false;
  end
  else
    ask := True;

  if ask then
  begin
    if IsInternet then
    begin
      product_current_version := AnsiString(DownloadFileIntoStr(string(product_current_version_url)));

      if product_version <> product_current_version then
      begin
        buttonselected := MessageDlg('There is a new version of ' + string(product_name) + #13#10 + '              Update Now ?', mtInformation, [mbYes, mbNo], 0);
        if buttonselected = mrYes then
        begin
          if IsInternet then
          begin
            UpdaterDownload(string(product_updater_url));
          end
          else
            MessageDlg('Internet connection failed!'#13#10'Please check your internet connection!', mtError, [mbOK], 0);
        end
        else
        begin
          if not FileExists(PostponedFileName) then
          begin
            Rewrite(PostponedFile);
            Writeln(PostponedFile, DateTimeToStr(IncDay(Now, 7), MySettings));
            CloseFile(PostponedFile);

          end;
        end;
      end;
    end
  end;
end;

//------------------------------------------------------------------------------
  { TUpdate }
//------------------------------------------------------------------------------

constructor TUpdate.Create(AProgressBar: TGauge { TProgressBar } = nil);
begin
  inherited Create;
  FAbort := false;
  if AProgressBar <> nil then
    FProgressBar := AProgressBar;
end;
//______________________________________________________________________________

destructor TUpdate.Destroy;
begin
  FreeAndNil(FHTTP);
  inherited;
end;
//______________________________________________________________________________

procedure TUpdate.InitUpdate;
begin
  FAbort := false;
  FreeAndNil(FHTTP);
  FHTTP := TIdHTTP.Create(nil);
  FHTTP.HandleRedirects := True;
  FHTTP.OnWork := OnProgress;
  FHTTP.OnWorkBegin := OnProgressBegin;
  FHTTP.OnWorkEnd := OnProgressEnd;

  if FProgressBar <> nil then
    FProgressBar.Visible := True;
end;
//______________________________________________________________________________

procedure TUpdate.Cancel;
begin
  FAbort := True;
  if FAbort and (FProgressBar <> nil) then
  begin
//FProgressBar.Position := 0;
    FProgressBar.Progress := 0;
  end;
end;
//______________________________________________________________________________

procedure TUpdate.OnProgressBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: int64);
begin
  FMaxProgress := AWorkCountMax;
end;
//______________________________________________________________________________

procedure TUpdate.OnProgress(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: int64);
begin
  if FAbort then
    Abort;
  if FProgressBar <> nil then
  begin
//FProgressBar.Position := AWorkCount * 100 div FMaxProgress;
    FProgressBar.Progress := AWorkCount * 100 div FMaxProgress;
    if FProgressBar.Progress < 1000000 then
      sleep(30); //To show progress for files < 1MB
  end;
end;
//______________________________________________________________________________

procedure TUpdate.OnProgressEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if (not FAbort) and (FProgressBar <> nil) then
  begin
//FProgressBar.Position := 100;
    FProgressBar.Progress := 100;
  end;
end;
//______________________________________________________________________________

procedure TUpdate.UpdaterDownload(AURL: string);
var
  f: TMemoryStream;
  PATH, exe, bak: string;
  p: integer;
begin
  InitUpdate;
  PATH := ExtractFilePath(ParamStr(0));
  exe := PATH + ExtractFileName(StringReplace(AURL, '/', '\', [rfReplaceAll]));
  p := pos('?', exe);
  if p > 0 then
  begin
    Delete(exe, p, length(exe));
  end;

  bak := ChangeFileExt(exe, '.BAK');

  //If the file to be downloaded exists rename it to .bak
  if FileExists(bak) then
    DeleteFile(bak);
  sleep(50);
  RenameFile(exe, bak);
  sleep(50);

  //Download the file
  f := TMemoryStream.Create;
  try
    try
      FHTTP.Get(AURL, f);
      f.SaveToFile(exe);
      sleep(50);
      //Execute newly generated file
      DeleteFile(bak);

//WinExec(PChar(EXE), SW_SHOWNORMAL);
      ShellExecute(0, 'Open', PChar(exe), nil, nil, SW_SHOWNORMAL);

      Application.Terminate;
    except
      on E: EIdHTTPProtocolException do
        if E.ErrorCode = 404 then
          ShowMessage('Error ' + AURL + ' Updater missing');
    end;
  finally
    f.Free;
    FreeAndNil(FHTTP);
  end;
end;
//______________________________________________________________________________

procedure TUpdate.DownloadFileToFile(const AURL, AFileName: string);
var
  f: TMemoryStream;
begin
  InitUpdate;
  f := TMemoryStream.Create;
  try
    try
      FHTTP.Get(AURL, f);
      f.SaveToFile(AFileName);
    except
      on E: EIdHTTPProtocolException do
        if E.ErrorCode = 404 then
          ShowMessage('Error ' + AURL + 'File missing');
    end;
  finally
    f.Free;
  end;
end;

procedure TUpdate.DownloadUpdate(AURL: string);
var
  f: TMemoryStream;
  PATH, app, exe, bak: string;
  p: integer;
begin
  InitUpdate;
  PATH := ExtractFilePath(ParamStr(0));
  app := ExtractFileName(StringReplace(AURL, '/', '\', [rfReplaceAll]));
  exe := PATH + app;

  p := pos('?', exe);
  if p > 0 then
  begin
    Delete(exe, p, length(exe));
  end;

  bak := ChangeFileExt(exe, '.BAK');

  if FileExists(bak) then
    DeleteFile(bak);
  sleep(50);
  RenameFile(exe, bak);
  sleep(50);
  f := TMemoryStream.Create;
  try
    try
      FHTTP.Get(AURL, f);
      f.SaveToFile(exe);
      sleep(50);
      DeleteFile(bak);

      MessageDlg(Format('Congratulations. Now you have the latest version of %s. Thank you.', [UpperCase(ChangeFileExt(app, ''))]), mtInformation, [mbOK], 0);

//WinExec(PChar(EXE), SW_SHOWNORMAL);
      ShellExecute(0, 'Open', PChar(exe), nil, nil, SW_SHOWNORMAL);

      Application.Terminate;
    except
      on E: EIdHTTPProtocolException do
        if E.ErrorCode = 404 then
          ShowMessage('Error ' + AURL + 'File missing');
    end;
  finally
    f.Free;
    FreeAndNil(FHTTP);
  end;
end;
//______________________________________________________________________________

function TUpdate.DownloadUpdateChanged(AURL: string): string;
var
  f: TMemoryStream;
  PATH, app, exe, bak: string;
  p: integer;
begin
  Result := '';
  InitUpdate;
  PATH := ExtractFilePath(ParamStr(0));
  app := ExtractFileName(StringReplace(AURL, '/', '\', [rfReplaceAll]));
  exe := PATH + app;

  p := pos('?', exe);
  if p > 0 then
  begin
    Delete(exe, p, length(exe));
  end;

  bak := ChangeFileExt(exe, '.BAK');

  if FileExists(bak) then
    DeleteFile(bak);
  sleep(50);
  RenameFile(exe, bak);
  sleep(50);
  f := TMemoryStream.Create;
  try
    try
      FHTTP.Get(AURL, f);
      f.SaveToFile(exe);
      sleep(50);
      DeleteFile(bak);

      Result := exe;
  //ShellExecute(0, 'Open', PChar(EXE), NiL, NiL, SW_SHOWNORMAL);
  //Application.Terminate;
    except
      on E: EIdHTTPProtocolException do
        if E.ErrorCode = 404 then
          ShowMessage('Error ' + AURL + 'File missing');
    end;
  finally
    f.Free;
    FreeAndNil(FHTTP);
  end;
end;
//______________________________________________________________________________

procedure TUpdate.UPdateAsk;
begin
  UPdateAsk;
end;

end.

