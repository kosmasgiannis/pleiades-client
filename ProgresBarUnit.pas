unit ProgresBarUnit;

interface

uses          
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, TntStdCtrls, TntExtCtrls, TntForms;

type
  TProgresBarForm = class(TTntForm)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Label2: TTntLabel;
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProgresBarForm: TProgresBarForm;

implementation

{$R *.dfm}

end.
