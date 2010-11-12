unit CollectionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, Grids, DBGrids, TntDBGrids, StdCtrls, Buttons,
  TntButtons, TntStdCtrls;

type
  TCollectionForm = class(TTntForm)
    TntDBGrid1: TTntDBGrid;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntBitBtn6: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntDBGrid1DblClick(Sender: TObject);
    procedure TntBitBtn6Click(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CollectionForm: TCollectionForm;

implementation

uses common, DataUnit, DB, GlobalProcedures, NewCollectionUnit;

{$R *.DFM}

procedure TCollectionForm.TntBitBtn1Click(Sender: TObject);
begin
  data.collection.Append;
  NewCollectionForm.ShowModal;
end;

procedure TCollectionForm.TntDBGrid1DblClick(Sender: TObject);
begin
  if not Data.collection.IsEmpty Then
  begin
    EditTable(data.collection);
    NewCollectionForm.ShowModal;
  end;
end;

procedure TCollectionForm.TntBitBtn6Click(Sender: TObject);
begin
 if data.collection.IsEmpty = false then
   if MessYesNo('Are you sure?') then
   begin
     data.collection.Delete;
     data.collection.Refresh;
   end;
end;

procedure TCollectionForm.TntFormActivate(Sender: TObject);
begin
     data.collection.Refresh;
     data.branch.Refresh;
end;

end.
