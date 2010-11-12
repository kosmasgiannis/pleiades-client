unit DigitalUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, Grids, DBGrids,
  TntDBGrids, ExtCtrls, DBCtrls, ShellApi, DBAccess;

type
  TDigitalForm = class(TTntForm)
    TntDBGrid1: TTntDBGrid;
    TntBitBtn1: TTntBitBtn;
    New: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure TntDBGrid1DblClick(Sender: TObject);
    procedure TntDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DigitalForm: TDigitalForm;

implementation

uses DataUnit, common, GlobalProcedures,  EditDigitalObject;

{$R *.DFM}

procedure TDigitalForm.TntBitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TDigitalForm.TntFormActivate(Sender: TObject);
begin
  DO_Windows_storage_location := IncludeTrailingPathDelimiter(GetContent(1,UserCode));
end;

procedure TDigitalForm.NewClick(Sender: TObject);
begin
  data.digital.Append;
  EditDigital.ShowModal;
end;

procedure TDigitalForm.TntDBGrid1DblClick(Sender: TObject);
begin
  if not Data.digital.IsEmpty Then
  begin
    EditTable(data.digital);
    EditDigital.ShowModal;
  end;
end;

procedure TDigitalForm.TntDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var s1 : widestring;
  TempRect : TRect;

begin
  with (Sender as TTntDBGrid).Canvas do
  begin

    if gdSelected in State Then
    begin
       (Sender as TTntDBGrid).Canvas.Brush.Color := clHighLight;
       (Sender as TTntDBGrid).Canvas.Font.Color := clWhite;
    end;

    FillRect(Rect);

    if Column.Field.DataSet.IsEmpty then  Exit;

    if (Column.Field.FieldName = 'link_text') then
    begin
      S1 := TCustomDADataSet(Column.Field.DataSet).GetBlob('link_text').AsWideString;
      while Pos(#13, S1) > 0 do //remove carriage returns and
       S1[Pos(#13, S1)] := ' ';
      while Pos(#10, S1) > 0 do //line feeds
       S1[Pos(#10, S1)] := ' ';

      TempRect := Rect;
      TempRect.Left := TempRect.Left + 2;
      DrawTextW(Handle, PWideChar(s1), -1, TempRect, DT_LEFT);
    end
    else
     (Sender as TTntDBGrid).DefaultDrawColumnCell(Rect, DataCol, TTntColumn(Column), State);

  end;
end;

end.
