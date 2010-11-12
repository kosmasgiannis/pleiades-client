unit seldatabase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, inifiles, Buttons, TntButtons, TntStdCtrls, TntForms;

type
  Tseldatabaseform = class(TTntForm)
    ComboBox1: TTntComboBox;
    Label1: TTntLabel;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  seldatabaseform: Tseldatabaseform;

implementation

uses MainUnit;


{$R *.dfm}

procedure Tseldatabaseform.FormActivate(Sender: TObject);
var db,path, myinifname,otherdatabases : string;
    myIniFile : TIniFile;
    i:integer;
begin
  path:=extractfilepath(paramstr(0));
  myinifname := path+'pleiades.ini';
  MyIniFile := TIniFile.Create(myinifname);
  with MyIniFile do
  begin
   otherdatabases := ReadString('FastRecordCreator','databases', '');
  end;
  MyIniFile.Free;
  if otherdatabases <> '' then
  begin
   otherdatabases:=otherdatabases+',';
   if FastRecordCreator.currentdatabase = '' then
    combobox1.Text:='Default'
   else
    combobox1.Text:=FastRecordCreator.currentdatabase;
   combobox1.Items.Clear;
   i:=pos(',',otherdatabases);
   while i >= 1 do begin
    db:=copy(otherdatabases,1,i-1);
    otherdatabases:=copy(otherdatabases,i+1,length(otherdatabases));
    if db='' then db:='Default';
    combobox1.Items.Add(db);
    i:=pos(',',otherdatabases);
   end;
   for i:=0 to combobox1.Items.Count-1 do
    if combobox1.Items[i] = FastRecordCreator.currentdatabase then
     combobox1.ItemIndex:=i;
  end;
end;

procedure Tseldatabaseform.BitBtn1Click(Sender: TObject);
begin
 if combobox1.Text <> 'Default' then
  FastRecordCreator.currentdatabase:=combobox1.Text
 else
  FastRecordCreator.currentdatabase:='';
end;

end.
