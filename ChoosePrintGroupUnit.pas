unit ChoosePrintGroupUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntButtons, TntForms, TntStdCtrls,
  TntExtCtrls;

type
  TChoosePrintGroupForm = class(TTntForm)
    TntLabel1: TTntLabel;
    ListBox: TTntListBox;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntLabel2: TTntLabel;
    TntRadioGroup1: TTntRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBoxDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ChosedName : string;
  end;

var
  ChoosePrintGroupForm: TChoosePrintGroupForm;

implementation

uses DataUnit, utility;

{$R *.dfm}

procedure TChoosePrintGroupForm.FormActivate(Sender: TObject);
begin
  PopulateListBoxFromTable(ListBox, 'marcdisplay', 'Name');
end;

procedure TChoosePrintGroupForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  case ModalResult of
    mrOk : if ListBox.ItemIndex > -1
                Then ChosedName := ListBox.Items[ListBox.ItemIndex]
                Else Action := caNone;
  end;

end;

procedure TChoosePrintGroupForm.ListBoxDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
