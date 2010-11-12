unit SetlangUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, Buttons, TntButtons, globalprocedures,
  TntForms;

type
  TSetlangForm = class(TTntForm)
    TntComboBox1: TTntComboBox;
    TntBitBtn1: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetlangForm: TSetlangForm;

implementation

{$R *.dfm}

procedure TSetlangForm.TntBitBtn1Click(Sender: TObject);
begin
 lang:=setlangform.tntcombobox1.text;
 Save_Content(1000,lang);
 set_vocabulary;
end;

end.
