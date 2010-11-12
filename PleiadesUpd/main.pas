unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MMSystem, IniFiles, utils, ComCtrls, md5;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure doit;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  smdarr : array [1..1000] of string;
  smdarrdim : integer;
  batchmode : boolean;
  templocation : string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 doit;
end;

function chkmdsum(fname:string) : string;
begin
  result := '';
  if fileexists(fname) then result:=lowercase(MD5DigestToStr(MD5file(fname)));
end;

procedure TForm1.doit;
var sourcepathdelim, sourcefile, destfile, sourcemdsum, destmdsum, fname,
    md5fname, sourcedir, destpath, destdir : string;
    myinifile, mymd5inifile : TiniFile;
    files : Tstrings;
    i : integer;
    f : Textfile;
    flag : boolean;
begin

 if button1.Caption='Finish' then Application.Terminate
 else
 begin

 Files:=Tstringlist.Create;
 MyIniFile := TIniFile.Create(extractfilepath(paramstr(0))+'PleiadesUpd.ini');
 with MyIniFile do
 begin
  sourcedir:=ReadString('Updater','sourcedir','');
  destdir:=ReadString('Updater','destdir','');
  md5fname:=ReadString('Updater','filelist','');
  ReadSectionValues('files',Files);
 end;

 sourcepathdelim := '\';

 if lowercase(copy(sourcedir,1,5)) = 'http:' then
   sourcepathdelim := '/';

 if ((sourcedir <>'') and (destdir <> '')) then
 begin
  if (sourcedir[length(sourcedir)] <> sourcepathdelim) then
    sourcedir:=sourcedir+sourcepathdelim;
  if (destdir[length(destdir)] <> '\') then destdir:=destdir+'\';

  if (md5fname <> '') then
  begin
    flag := mycopyfile(sourcedir+md5fname,extractfilepath(paramstr(0))+'PleiadesUpd.md5');
    if flag = false then
    begin
      showmessage('Can not get MD5 file list.');
      button1.Caption:='Finish';
      if batchmode then Application.Terminate
      else Exit;
    end;
    mymd5IniFile := TIniFile.Create(extractfilepath(paramstr(0))+'PleiadesUpd.md5');
    with mymd5IniFile do
    begin
      Files.Clear;
      ReadSectionValues('files',Files);
    end;
  end;


// Update the updater
  mycopyfile(sourcedir+'PleiadesUpd.exe', templocation+'PleiadesUpd.tmp');
  sourcemdsum := lowercase(MD5DigestToStr(MD5file(templocation+'PleiadesUpd.tmp')));
  destmdsum := lowercase(MD5DigestToStr(MD5file(paramstr(0))));

  if sourcemdsum <> destmdsum then
  begin
    memo1.lines.Add('Updating updater...');
    Assignfile(f,extractfilepath(paramstr(0))+'PleiadesUpdex.bat');
    Rewrite(f);
    writeln(f,'sleep 3');

    writeln(f,'copy ',templocation,'PleiadesUpd.tmp ',paramstr(0));
    writeln(f,'sleep 3');
    writeln(f,'delete ',templocation,'PleiadesUpd.tmp ');
    for i:=0 to paramcount do
     write(f,paramstr(i),' ');
    writeln(f);
    Closefile(f);
    RunFile_nowait(extractfilepath(paramstr(0)), 'PleiadesUpdex.bat','',SW_HIDE);
    Application.Terminate;
    exit;
  end
  else
  begin
    deletefile(templocation+'PleiadesUpd.tmp');
    memo1.lines.Add('Updater looks OK ...');
  end;

  if fileexists(extractfilepath(paramstr(0))+'PleiadesUpdex.bat') then
    DeleteFile(extractfilepath(paramstr(0))+'PleiadesUpdex.bat');

  memo1.lines.Add('Files: '+inttostr(files.Count));
  progressbar1.Min:=0;
  progressbar1.Max:=files.Count;
  progressbar1.Step:=1;
  // Do the actual file update
  for i:= 0 to files.Count-1 do
  begin
    fname:=copy(files[i],pos('=',files[i])+1,length(files[i]));
    sourcemdsum:=lowercase(copy(files[i],1,pos('=',files[i])-1));

    if lowercase(copy(sourcedir,1,5)) = 'http:' then
      sourcefile:=sourcedir+stringreplace(fname,'\','/',[rfReplaceAll])
    else
      sourcefile:=sourcedir+fname;

    destfile:=destdir+fname;
    destmdsum:=chkmdsum(destdir+fname);

    memo1.lines.Add('File: '+fname);
    memo1.lines.Add('Source MD5sum: '+sourcemdsum);
    memo1.lines.Add('Dest   MD5sum: '+destmdsum);
    label1.Caption := 'Checking '+fname+'...';
    if ((fileexists(destfile) = false) or (destmdsum <> sourcemdsum)) then
    begin
      destpath:=extractfilepath(destfile);
      if (directoryexists(destpath) = false) then forcedirectories(destpath);

      memo1.lines.Add('Copying '+sourcefile+' to '+destfile+' ...');
      label1.Caption := 'Updating '+fname+'...';

      MyCopyFile(sourcefile, destfile);
    end;

    progressbar1.StepIt;
    Application.ProcessMessages;

  end;
 MyInifile.Free;
 end
 else
  memo1.lines.Add('Please specify a valid source and destination directory.');

 label1.Caption:='';
 button1.Caption:='Finish';
 end;
end;

procedure TForm1.FormActivate(Sender: TObject);
var i : integer;
begin
 label1.Caption := '';
 batchmode :=false;
 for i:=1 to paramcount do
 begin
  if paramstr(i) = '-a' then
  begin
   Application.Minimize;
   doit;
   batchmode:=true;
  end;
 end;
 templocation:=GetEnvironmentVariable('TEMP');
 memo1.Lines.Add(templocation);
 if batchmode then Application.Terminate;
end;

end.
