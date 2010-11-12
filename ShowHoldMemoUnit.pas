unit ShowHoldMemoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TntButtons, TntStdCtrls, ComCtrls,
  TntComCtrls;

type
  TShowHoldMemoForm = class(TForm)
    TntRichEdit: TTntRichEdit;
    TntBitBtn1: TTntBitBtn;
    procedure TntRichEditKeyPress(Sender: TObject; var Key: Char);
    procedure TntRichEditMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TntRichEditMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowHoldMemoForm: TShowHoldMemoForm;

implementation

uses HoldingsUnit, MARCEditor, DataUnit, common;

{$R *.dfm}

procedure TShowHoldMemoForm.TntRichEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #27 then ModalResult := mrCancel;
end;

procedure TShowHoldMemoForm.TntRichEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Pt : TPoint;
  ICharIndex, i,
  line: integer;
begin
    with TTntRichEdit(Sender) do
  begin
    Pt := Point(X, Y);
    Cursor := crDefault;

    // Get Character Index from word under the cursor
    iCharIndex := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt));
    if iCharIndex < 0 then Exit;
    for i := 0 to length(links) - 1 do
      if (iCharIndex >= links[i].start)and
         (iCharIndex <= links[i].start + links[i].len)
          then
            begin
              if (links[i].name = 'open') then
              begin
               line := SendMessage(TntRichEdit.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
               if Data.hold.Locate('holdon',links[i].holdon ,[]) then
               begin
                 Holdings.ShowModal;
                 marceditorform.Refresh_Holdings(TntRichEdit);
                 SendMessage(TntRichEdit.Handle, EM_LINESCROLL, 0, line);
               end;
              end
              else if (links[i].name = 'up') then
              begin
                line := SendMessage(TntRichEdit.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
                if Data.hold.Locate('holdon',links[i].holdon ,[]) then
                begin
                   MoveHoldingUpDown('up', links[i].recno, links[i].holdon, links[i].aa );
                   marceditorform.holdings_moved := true;
                end;
                SendMessage(TntRichEdit.Handle, EM_LINESCROLL, 0, line);
                marceditorform.Refresh_Holdings(TntRichEdit);
              end
              else if (links[i].name = 'down') then
              begin
                line := SendMessage(TntRichEdit.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
                if Data.hold.Locate('holdon',links[i].holdon ,[]) then
                begin
                   MoveHoldingUpDown('down', links[i].recno, links[i].holdon, links[i].aa );
                   marceditorform.holdings_moved := true;
                end;
                SendMessage(TntRichEdit.Handle, EM_LINESCROLL, 0, line);
                marceditorform.Refresh_Holdings(TntRichEdit);
              end;
              Break;
            end
       Else Cursor := crDefault;
   end;

end;

procedure TShowHoldMemoForm.TntRichEditMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Pt : TPoint;
  ICharIndex, i : integer;
begin

  with TTntRichEdit(Sender) do
  begin
    Pt := Point(X, Y);
    Cursor := crDefault;

    // Get Character Index from word under the cursor
    iCharIndex := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt));
    if iCharIndex < 0 then Exit;
    for i := 0 to length(links) - 1 do
      if (iCharIndex >= links[i].start)and
         (iCharIndex <= links[i].start + links[i].len)
          then
            begin
              Cursor := crHandPoint;
              Break;
            end
       Else Cursor := crDefault;
   end;

end;

end.
