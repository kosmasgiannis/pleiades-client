unit ConfigurationUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, inifiles, ComCtrls, TntStdCtrls, TntForms;//unit1,

type
  TConfigurationForm = class(TTntForm)
    Edit1: TTntEdit;
    Button1: TTntButton;
    Button2: TTntButton;
    Button3: TTntButton;
    ComboBox1: TTntComboBox;
    ListBox1: TTntListBox;
    Label1: TTntLabel;
    Button4: TTntButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigurationForm: TConfigurationForm;
  Langs, Materials : WideString;
  collec : array of WideString;
//  li : integer;
implementation

uses common, MainUnit, WideIniClass;

{$R *.dfm}

procedure TConfigurationForm.FormActivate(Sender: TObject);
var s,hlp:WideString;
    p:integer;
    path, myinifname : string;
    myIniFile : TWideIniFile;
    first: string;
begin
 if fastrecordcreator.setbranches =2 then  // languages
   begin
    ComboBox1.Visible := false;
    Label1.Visible := false;
   end
 else  //Matterials
   begin
    ComboBox1.Visible := false;
    Label1.Visible := false;
   end;

 edit1.Text := '';
 path:=extractfilepath(paramstr(0));
 myinifname := path+'pleiades.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 with MyIniFile do
 begin          //////////////////
  Langs := ReadWideString('FastRecordCreator','Languages', 'gre,eng');
  Materials := ReadString('FastRecordCreator','Materials', '');
 end;

 if fastrecordcreator.setbranches = 2 then
 begin
  s := Langs+',';
  first:='';
  listbox1.Items.Clear;
  while (s <> '') do
  begin
   p := pos(',',s);
   if (p <> 0) then
   begin
    hlp := copy(s,1,p-1);
    s:= copy(s,p+1,length(s));
//    if (first = '') then first := hlp;
    if hlp <> '' then listbox1.Items.Add(hlp);
   end
  end;
 end;

 if fastrecordcreator.setbranches = 3 then
 begin
  s := Materials+',';
  first:='';
  listbox1.Items.Clear;
  while (s <> '') do
  begin
   p := pos(',',s);
   if (p <> 0) then
   begin
    hlp := copy(s,1,p-1);
    s:= copy(s,p+1,length(s));
//    if (first = '') then first := hlp;
    if hlp <> '' then listbox1.Items.Add(hlp);
   end
  end;
 end;

 MyIniFile.Free;
end;

procedure TConfigurationForm.Button1Click(Sender: TObject);
var f : boolean;
    i : integer;
begin
 if Edit1.Text <> '' then
 begin
  f := false;
  for i:=0 to listbox1.Items.Count-1 do
   if Edit1.Text = listbox1.Items.Strings[i] then f := true;
  if f = false then
   listbox1.Items.Add(Edit1.Text);
 end;
 Edit1.Clear;
end;

procedure TConfigurationForm.Button2Click(Sender: TObject);
var
  path, myinifname : string;
  myIniFile : TWideIniFile;
begin
  path:=extractfilepath(paramstr(0));
  myinifname := path+'pleiades.ini';
  MyIniFile := TWideIniFile.Create(myinifname);
  with MyIniFile do
  begin
    ListBox1.DeleteSelected;
    Free;
  end;
end;

procedure TConfigurationForm.ComboBox1Change(Sender: TObject);
var
  s,hlp:WideString;
  p:integer;
  first : string;
begin
{ path:=extractfilepath(paramstr(0));
 myinifname := path+'pleiades.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 Cols := '';}

{ with MyIniFile do
 begin
  SetLength(collec, ComboBox1.Items.Count-1);
  for p := 0 to ComboBox1.Items.Count-1 do
    collec[p] := ReadWideString(FastRecordCreator.currentdatabase,FastRecordCreator.currentdatabase+'.'+ComboBox1.Items[p], '');
//  Cols := ReadWideString(FastRecordCreator.currentdatabase,FastRecordCreator.currentdatabase+'.'+ComboBox1.Text, '');
 end;}

// s := Cols+',';
 s := collec[ComboBox1.itemindex]+',';
 first:='';
 ListBox1.Items.Clear;
 while (s <> '') do
 begin
  p := pos(',',s);
  if (p <> 0) then
  begin
   hlp := copy(s,1,p-1);
   s:= copy(s,p+1,length(s));
   if (first = '') then first := hlp;
   if hlp <> '' then Listbox1.Items.Add(hlp);
  end
 end;
// MyIniFile.Free;

end;

procedure TConfigurationForm.Button3Click(Sender: TObject);
var
    s:WideString;
    p:integer;
    path, myinifname : string;
    myIniFile : TWideIniFile;
begin
 for p:=0 to listbox1.Items.Count-1 do
  s:=s+listbox1.Items.Strings[p]+',';
 s:=copy(s,1,length(s)-1);

 path:=extractfilepath(paramstr(0));
 myinifname := path+'pleiades.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 with MyIniFile do
 begin
  if fastrecordcreator.setbranches = 2 then
   begin
   FastRecordCreator.Languages := s;
    MyIniFile.WriteString('FastRecordCreator','Languages',s);
   end;
  if fastrecordcreator.setbranches = 3 then
   begin
    FastRecordCreator.Materials := s;
    MyIniFile.WriteWideString('FastRecordCreator','Materials',s);
   end;
 end;
 MyIniFile.UpdateFile;
 MyIniFile.Free;
end;

end.
