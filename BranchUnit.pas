unit BranchUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, Grids, DBGrids,
  TntDBGrids, TntStdCtrls;

type
  TBranchForm = class(TTntForm)
    TntDBGrid1: TTntDBGrid;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntBitBtn3: TTntBitBtn;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntBitBtn6: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntBitBtn3Click(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
    procedure TntDBGrid1DblClick(Sender: TObject);
    procedure TntBitBtn6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BranchForm: TBranchForm;

implementation

uses DataUnit, DB, GlobalProcedures, NewBranchUnit;

{$R *.DFM}

procedure TBranchForm.TntBitBtn1Click(Sender: TObject);
begin
  data.branch.Append;
  NewbranchForm.ShowModal;
end;

procedure TBranchForm.TntBitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TBranchForm.TntBitBtn3Click(Sender: TObject);
begin
  Save_Content(1003,Data.branch.FieldByName('code').AsVariant);
  branchcode := data.branch.FieldByName('code').AsVariant;
  TntLabel1.Caption := branchcode;
end;

procedure TBranchForm.TntFormActivate(Sender: TObject);
begin
  TntLabel1.Caption := branchcode;
  data.branch.Refresh;
end;

procedure TBranchForm.TntDBGrid1DblClick(Sender: TObject);
begin
    if not Data.branch.IsEmpty Then
    begin
      EditTable(data.branch);
      NewbranchForm.ShowModal;
    end;
end;

procedure TBranchForm.TntBitBtn6Click(Sender: TObject);
begin
 if data.branch.IsEmpty = false then
   if MessYesNo('Are you sure?') then
   begin
     data.branch.Delete;
     data.branch.Refresh;
   end;
end;

end.