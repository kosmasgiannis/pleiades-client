unit MoveHoldings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, common;

type
  TMoveHoldingsForm = class(TForm)
    Label1: TLabel;
    srchold: TEdit;
    Label2: TLabel;
    dsthold: TEdit;
    TntButton1: TTntButton;
    movedirection: TTntComboBox;
    Cancel: TButton;
    procedure TntButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
     maxhold, recno : integer;
    { Public declarations }
  end;

var
  MoveHoldingsForm: TMoveHoldingsForm;

implementation

{$R *.dfm}

procedure TMoveHoldingsForm.TntButton1Click(Sender: TObject);
var s,d : integer;
var op : integer;
var direction : string;
var h, i, cnt:integer;
begin
  op := 0;
  s := strtointdef(srchold.Text, -1);
  d := strtointdef(dsthold.Text, -1);
  if (s < 1) or (s > maxhold) then
  begin
    ShowMessage('Source holding number is invalid');
  end
  else
  begin
    if (d < 1) or (d > maxhold) then
    begin
      ShowMessage('Destination holding number is invalid');
    end
    else
    begin
      if (movedirection.ItemIndex = -1) then
      begin
        ShowMessage('Select move direction');
      end
      else if (movedirection.Items[movedirection.ItemIndex] = 'After') then
      begin
        if ((s <> d) and (s <> d+1)) then
        begin
          //ShowMessage('Move holding '+srchold.Text+' '+ movedirection.Items[movedirection.ItemIndex]+ ' '+dsthold.Text);
          if (s < d) then
          begin
            direction:='down';
            h:=1;
            cnt := d-s;
          end
          else
          begin
            direction:='up';
            h:=-1;
            cnt := -d+s-1;
          end;
          //ShowMessage(direction+' '+inttostr(cnt)+' '+inttostr(s));
          for i:=0 to cnt-1 do
          begin
            MoveHoldingUpDown2(direction, recno, s+(h*i));
          end;
          op:=1;
        end
        else
        begin
          ShowMessage('Holding number combination is invalid');
        end;
      end
      else if (movedirection.Items[movedirection.ItemIndex] = 'Before') then
      begin
        if ((s <> d) and (s <> d-1)) then
        begin
          //ShowMessage('Move holding '+srchold.Text+' '+ movedirection.Items[movedirection.ItemIndex]+ ' '+dsthold.Text);
          if (s < d) then
          begin
            direction:='down';
            h:=1;
            cnt := d-s-1;
          end
          else
          begin
            direction:='up';
            h:=-1;
            cnt := -d+s;
          end;
          //ShowMessage(direction+' '+inttostr(cnt)+' '+inttostr(s));
          for i:=0 to cnt-1 do
          begin
            MoveHoldingUpDown2(direction, recno, s+(h*i));
          end;
          op:=1;
        end
        else
        begin
          ShowMessage('Holding number combination is invalid');
        end;
      end
      else
      begin
        ShowMessage('Invalid move direction');
      end;
    end;
  end;
  if (op = 1) then
    ModalResult := mrOk
  else
    ModalResult := mrNone;
end;

procedure TMoveHoldingsForm.FormActivate(Sender: TObject);
begin
  movedirection.ItemIndex := 0;
  srchold.Text:='';
  dsthold.Text:='';
end;

end.
