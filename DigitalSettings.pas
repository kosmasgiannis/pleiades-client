unit DigitalSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, Buttons, TntButtons;

type
  TDigitalSettingsForm = class(TTntForm)
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntLabel2: TTntLabel;
    TntEdit1: TTntEdit;
    TntLabel3: TTntLabel;
    TntEdit2: TTntEdit;
    procedure TntFormActivate(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DigitalSettingsForm: TDigitalSettingsForm;

implementation

{$R *.DFM}

uses GlobalProcedures, common;

procedure TDigitalSettingsForm.TntFormActivate(Sender: TObject);
begin
 DO_Windows_storage_location := GetContent(1,UserCode);
 DO_BaseURL := GetContent(2,UserCode);
 tntedit1.Text := DO_Windows_storage_location;
 tntedit2.Text := DO_BaseURL;
 tntedit1.SetFocus;
end;

procedure TDigitalSettingsForm.TntBitBtn1Click(Sender: TObject);
begin
 DO_Windows_storage_location := tntedit1.Text;
 DO_BaseURL := tntedit2.Text;

 Save_Content(1, DO_Windows_storage_location);
 Save_Content(2, DO_BaseURL);

end;

end.
