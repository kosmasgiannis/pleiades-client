unit ZTargetsSettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,IniFiles, Buttons, TntButtons, TntStdCtrls, TntForms;

type
  TZTargetsSettingsForm = class(TTntForm)
    Edit1: TTntEdit;
    Edit2: TTntEdit;
    Label1: TTntLabel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Label4: TTntLabel;
    ComboBox1: TTntComboBox;
    ComboBox2: TTntComboBox;
    ComboBox3: TTntComboBox;
    Label5: TTntLabel;
    GroupBox1: TTntGroupBox;
    ListBox1: TTntListBox;
    Button1: TTntButton;
    Button2: TTntButton;
    Button5: TTntButton;
    Edit3: TTntEdit;
    Label6: TTntLabel;
    Button3: TTntButton;
    Button4: TTntButton;
    BitBtn1: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TServers = record
                name : string;
                zurl : string;
                proxy : string;
                format : string;
                scharset : string;
                dcharset : string;
               end;

var
  ZTargetsSettingsForm: TZTargetsSettingsForm;
//  name, host, marc, CharSetIn, CharSetOut : WideString;
  serv : array of TServers;

implementation

uses common, WideIniClass;

{$R *.dfm}

procedure TZTargetsSettingsForm.FormActivate(Sender: TObject);
var
  p:integer;
  path, myinifname : string;
  myIniFile : TWideIniFile;
  keys : TStrings;

//    targets: TStrings;
begin
 edit1.Text := '';
 edit2.Text := '';
 keys:=Tstringlist.Create;
 keys.Clear;
 path:=extractfilepath(paramstr(0));
 myinifname := path+'ztargets.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 with MyIniFile do
 begin
  ReadSections(keys);
  SetLength(serv, keys.Count-1);
  for p:=1 to keys.Count - 1 do
  begin
    serv[p-1].name := ReadString(keys[p], 'name', '');
    serv[p-1].zurl := ReadString(keys[p], 'zurl', '');
    serv[p-1].proxy := ReadString(keys[p], 'proxy', '');
    serv[p-1].format := ReadString(keys[p], 'format', '');
    serv[p-1].scharset := ReadString(keys[p], 'scharset', '');
    serv[p-1].dcharset := ReadString(keys[p], 'dcharset', '');
  end;
 end;
 MyIniFile.Free;

 with listbox1 do
 begin
  clear;
  for p := 0 to length(serv)-1 do Items.Add(serv[p].name);
  Itemindex:=0;
  ListBox1Click(sender);
 end;
 keys.Free;
end;

procedure TZTargetsSettingsForm.Button1Click(Sender: TObject);
var
  i : integer;
  f : boolean;
begin
 if ((Edit1.Text <> '') and (Edit2.Text <> '')) then
 begin
  f :=  true;
  for i:=0 to Length(serv)-1 do
   if serv[i].zurl = Edit2.Text then f:=false;

  if f = true then
  begin
   ListBox1.Items.Add(Edit1.Text);
   SetLength(serv, length(serv)+1);
   serv[length(serv)-1].name := Edit1.Text;
   serv[length(serv)-1].zurl := Edit2.Text;
   serv[length(serv)-1].proxy := Edit3.Text;
   if LowerCase(ComboBox1.Text) = LowerCase('marc21')then
     serv[length(serv)-1].format := 'USMARC'
   else
     serv[length(serv)-1].format := ComboBox1.Text;
   serv[length(serv)-1].scharset := ComboBox2.Text;
   serv[length(serv)-1].dcharset := ComboBox3.Text;
  end
  else
   showmessage('Target already in list.');
 end;
 Edit1.Text:='';
 Edit2.Text:='';
 Edit3.Text:='';
 combobox1.ItemIndex:=0;
 combobox2.ItemIndex:=0;
 combobox3.ItemIndex:=0;
end;

procedure TZTargetsSettingsForm.Button2Click(Sender: TObject);
var
  i, index : integer;
begin
  i:=listbox1.ItemIndex;
  if i >= 0 then listbox1.DeleteSelected;
//  DelItemFromArray
  for index := i to length(serv)-2 do serv[index] := serv[index+1];
  SetLength(serv, Length(serv)-1);

end;

procedure TZTargetsSettingsForm.Button3Click(Sender: TObject);
var
  p:integer;
  path, myinifname : string;
  myIniFile : TWideIniFile;
  keys : TStrings;
  s : string;
begin
 keys := TStringList.Create;
 path:=extractfilepath(paramstr(0));
 myinifname := path+'ztargets.ini';
 MyIniFile := TWideIniFile.Create(myinifname);
 with MyIniFile do
 begin
  ReadSections(keys);
  for p := 1 to keys.Count - 1 do EraseSection(keys[p]);
  for p:=0 to length(serv)-1 do
  begin
//   WriteString('@@@Ztargets',listbox1.Items[p],listbox2.Items[p]);****************
    if p <9 then s := '0'+IntToStr(p) else s := IntToStr(p);
    WriteString(s, 'name', serv[p].name);
    WriteString(s, 'zurl', serv[p].zurl);
    WriteString(s, 'proxy', serv[p].proxy);
    WriteString(s, 'format', serv[p].format);
    WriteString(s, 'scharset', serv[p].scharset);
    WriteString(s, 'dcharset', serv[p].dcharset);
  end;
 end;
 keys.Free;
 MyIniFile.Free;
end;

procedure TZTargetsSettingsForm.ListBox1Click(Sender: TObject);
begin
  Edit1.Text := serv[ListBox1.ItemIndex].name;
  Edit2.Text := serv[ListBox1.ItemIndex].zurl;
  Edit3.Text := serv[ListBox1.ItemIndex].proxy;

  if LowerCase(serv[ListBox1.ItemIndex].format)=LowerCase('usmarc') then
    ComboBox1.ItemIndex := ComboBox1.Items.IndexOf('marc21')
  else
    ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(serv[ListBox1.ItemIndex].format);
  ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(serv[ListBox1.ItemIndex].scharset);
  ComboBox3.ItemIndex := ComboBox3.Items.IndexOf(serv[ListBox1.ItemIndex].dcharset);

end;

procedure TZTargetsSettingsForm.Button5Click(Sender: TObject);
begin
  Edit1.Text :='';
  Edit2.Text :='';
  Edit3.Text :='';
end;

procedure TZTargetsSettingsForm.BitBtn1Click(Sender: TObject);
begin
  serv[ListBox1.ItemIndex].name := Edit1.Text;
  serv[ListBox1.ItemIndex].zurl := Edit2.Text;
  serv[ListBox1.ItemIndex].proxy := Edit3.Text;
   if LowerCase(ComboBox1.Text) = LowerCase('marc21')then
     serv[ListBox1.ItemIndex].format := 'USMARC'
   else
     serv[ListBox1.ItemIndex].format := ComboBox1.Text;
  serv[ListBox1.ItemIndex].scharset := ComboBox2.Text;
  serv[ListBox1.ItemIndex].dcharset := ComboBox3.Text;
  ListBox1.Items[ListBox1.ItemIndex] := Edit1.text;
end;

end.
