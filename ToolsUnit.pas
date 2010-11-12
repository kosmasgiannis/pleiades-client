unit ToolsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DBCtrls, Grids, DBGrids,
  TntDBGrids, TntStdCtrls, TntButtons, TntForms;

type
  TToolsForm = class(TTntForm)
    DBGrid1: TTntDBGrid;
    DBNavigator1: TDBNavigator;
    BitBtn2: TTntBitBtn;
    Label3: TTntLabel;
    TntBitBtn1: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ToolsForm: TToolsForm;

implementation

Uses DataUnit, DB;

{$R *.dfm}

procedure TToolsForm.TntBitBtn1Click(Sender: TObject);
  //Extract all objects from application
var
  i : integer;
  s:string;
  myFile : TextFile;
BEGIN
 AssignFile(myFile, 'Tools.ini');
 ReWrite(myFile);
 with Data.Tools do
 begin
   First;
   while Not eof do
   begin
     i:=fieldbyname('spcode').asinteger;
     str(i:10,s);
     Writeln(myFile, '['+s+']'+ fieldbyname('name').asstring);
     Next;
   end;

 CloseFile(myFile);
END;
end;

end.
