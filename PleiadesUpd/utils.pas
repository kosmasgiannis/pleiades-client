unit utils;

interface

uses Classes, Windows, URLMon, ShellApi, wininet, Forms, SysUtils, Dialogs;

function GetFileFromInternet(const AUrl:string; AStream:TStream): boolean;
function DownloadFile(SourceFile, DestFile: string): Boolean;
function DownloadFile2(const url: string; const destinationFileName: string): boolean;
function GetLastErrorText(): string;
function RunFile(homedir, filename,params : string; Showmode:integer) : integer;
function RunFile_nowait(homedir, filename,params : string; Showmode:integer) : integer;
function MyCopyFile(sourcefile, destfile: string) : boolean;

implementation

function MyCopyFile(sourcefile, destfile: string) : boolean;
var rc1 : longbool;
begin
  if lowercase(copy(sourcefile,1,5)) <> 'http:' then
  begin
    rc1:=CopyFile(Pchar(sourcefile),Pchar(destfile),false);
    if (rc1=false) then begin showmessage(GetLastErrorText); end;
    result:=rc1;
  end
  else
    result:=downloadfile(sourcefile, destfile);
end;

function GetFileFromInternet(const AUrl:string; AStream:TStream): boolean;
var
  hSession, hConnect: hInternet;
  Buf: array[0..1023] of Char;
  ReadCount: Cardinal;
begin
  Result := False;
  hSession := InternetOpen(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    hConnect := InternetOpenUrl(hSession, PChar(AUrl), nil, 0, 0, 0);
    try
      repeat
        if not InternetReadFile(hConnect, @Buf, SizeOf(Buf), ReadCount) then readcount := 0;
        if readcount <> 0 then
        begin
          AStream.Write(Buf, ReadCount);
          Result := True;
        end;
      until readcount = 0;
    finally
      InternetCloseHandle(hConnect);
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;

function DownloadFile(SourceFile, DestFile: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(SourceFile), PChar(DestFile), 0, nil) = 0;
  except
    Result := False;
  end;
end;

function DownloadFile2(const url: string; const destinationFileName: string): boolean;
var
  hInet: HINTERNET;
  hFile: HINTERNET;
  localFile: File;
  buffer: array[1..1024] of byte;
  bytesRead: DWORD;
begin
  result := False;
  hInet := InternetOpen(PChar(application.title),
    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  hFile := InternetOpenURL(hInet,PChar(url),nil,0,INTERNET_FLAG_RELOAD,0);
  if Assigned(hFile) then
  begin
    AssignFile(localFile,destinationFileName);
    Rewrite(localFile,1);
    repeat
      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
      BlockWrite(localFile,buffer,bytesRead);
    until bytesRead = 0;
    CloseFile(localFile);
    result := true;
    InternetCloseHandle(hFile);
  end;
  InternetCloseHandle(hInet);
end;

function GetLastErrorText(): string;
var
  dwSize: DWORD;
  lpszTemp: PAnsiChar;
begin
  dwSize := 512;
  lpszTemp := nil;
  try
    GetMem(lpszTemp, dwSize);
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ARGUMENT_ARRAY,
      nil,
      GetLastError(),
      LANG_NEUTRAL,
      lpszTemp,
      dwSize,
      nil)
  finally
    Result := lpszTemp;
    FreeMem(lpszTemp)
  end
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

function RunFile_nowait(homedir, filename,params : string; Showmode:integer) : integer;
var
  SEInfo: TShellExecuteInfo;
//  ExitCode: DWORD;
  ExecuteFile, p, StartInString: string;
begin
  result:=0;
  p:=params;
  ExecuteFile:=filename;
//  Exitcode:=0;
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
  ShellExecuteEx(@SEInfo);
end;

end.
