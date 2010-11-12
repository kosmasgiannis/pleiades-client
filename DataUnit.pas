unit DataUnit;

interface

uses
  SysUtils, Classes, MyAccess, DB, MemDS, DBAccess, Dialogs, WordXP,
  OleServer, TntDialogs, MyDump, forms, MyScript, MyDacVcl, DAScript,
  DADump, memdata;

type
  Plibparams = ^libparams;
  libparams = record
     code : string;
     branchcode : string;
     name : widestring;
  end;

  TData = class(TDataModule)
    HoldSource: TDataSource;
    BasketSource: TDataSource;
    hold: TMyTable;
    Query1: TMyQuery;
    moves: TMyTable;
    users: TMyTable;
    UsersSource: TDataSource;
    MyConnection1: TMyConnection;
    basket: TMyQuery;
    MovesSource: TDataSource;
    marcdisplay: TMyTable;
    marcdisplaySource: TDataSource;
    vocabulary: TMyTable;
    vocabularySource: TDataSource;
    MSWord: TWordApplication;
    Document: TWordDocument;
    OpenDialog1: TTntOpenDialog;
    SaveDialog1: TTntSaveDialog;
    MyDump1: TMyDump;
    MyScript1: TMyScript;
    Languages: TMyTable;
    LanguagesSource: TDataSource;
    Tools: TMyTable;
    ToolsSource: TDataSource;
    ItemsSource: TDataSource;
    Items: TMyTable;
    HoldQuery: TMyQuery;
    ItemsQuery: TMyQuery;
    SecureBasket: TMyQuery;
    SecureBasketSource: TDataSource;
    MyCommand1: TMyCommand;
    MyConnectDialog1: TMyConnectDialog;
    InsertSecureBasket: TMyCommand;
    loancatSource: TDataSource;
    branch: TMyTable;
    branchsource: TDataSource;
    collection: TMyTable;
    collectionsource: TDataSource;
    PrintDialog1: TPrintDialog;
    Query2: TMyQuery;
    DataSource1: TDataSource;
    LastDataFromBasket: TMyQuery;
    CollectionQuery: TMyQuery;
    digital: TMyTable;
    digitalSource: TDataSource;
    patroncat: TMyTable;
    patroncatSource: TDataSource;
    processstatus: TMyTable;
    processstatusSource: TDataSource;
    loancat: TMyTable;
    loancategory: TMyTable;
    loancategorysource: TDataSource;
    AuthSource: TDataSource;
    Auth: TMyQuery;
    LastDataFromAuth: TMyQuery;
    procedure basketBeforeScroll(DataSet: TDataSet);
    procedure marcdisplayAfterScroll(DataSet: TDataSet);
    function loadparams(t: TMyTable; var p : TList) : integer;
    procedure freeparams(p : Tlist);
    procedure showparams(p : Tlist);
    function lookupparam(p : Tlist; code, bcode : string) : Widestring;
    procedure MyConnection1ConnectionLost(Sender: TObject;
      Component: TComponent; ConnLostCause: TConnLostCause;
      var RetryMode: TRetryMode);

  private
    { Private declarations }
  public
    { Public declarations }
    loancategories, processstatuses, brancheslist, collectionlist : TList;
  end;

var
  Data: TData;

implementation

uses MARCEditor, MainUnit, BackupUnit, MARCDisplayUnit, GlobalProcedures;

{$R *.dfm}

//----------------------------------------------------------------------------//
function Compareparams(Item1, Item2: Pointer): Integer;
var a,b : Plibparams;
begin
  a := Plibparams(item1);
  b := Plibparams(item2);
  Result := CompareText(a^.code+a^.branchcode, b^.Code+b^.branchcode);
end;

//----------------------------------------------------------------------------//
function TData.loadparams(t: TMyTable; var p : TList) : integer;
var a : Plibparams;
begin
 result:=0;
 p := Tlist.Create;
 if t.Active then
 begin
  if Not t.IsEmpty then
  begin
   t.First;
   while not t.eof do
   begin
    New(a);
    a^.code := t.fieldbyname('code').AsString;
    if t.FieldDefs.IndexOf('branchcode') <> -1 then
      a^.branchcode:=t.fieldbyname('branchcode').AsString
    else
      a^.branchcode := '';
    a^.name:=t.fieldbyname('name').Value;
    p.add(a);
    result:=result+1;
    t.Next;
   end;
  end;
 end;
 if result <> 0 then {p.Free
 else }p.Sort(@Compareparams);
end;

//----------------------------------------------------------------------------//
procedure Tdata.freeparams(p : Tlist);
var i : integer;
    a : Plibparams;
begin
 try
 for i:=0 to p.Count-1 do
 begin
  a:=p.items[i];
  dispose(a);
 end;

  p.Free;
 finally
 end;
end;

//----------------------------------------------------------------------------//
procedure Tdata.showparams(p : Tlist);
var i : integer;
    a : Plibparams;
begin
 for i:=0 to p.Count-1 do
 begin
  a := p.Items[i];
  wideshowmessage(a^.code+','+a^.branchcode+'='+a^.name);
 end;
end;

function Tdata.lookupparam(p : Tlist; code, bcode: string) : Widestring;
var i : integer;
    a : Plibparams;
begin
 result:='';
 for i:=0 to p.Count-1 do
 begin
  a := p.Items[i];
  if ( (a^.code = code) and (a^.branchcode = bcode) ) then
  begin
   result:=a^.name;
   exit;
  end;
 end;
end;

//----------------------------------------------------------------------------//
procedure TData.basketBeforeScroll(DataSet: TDataSet);
begin
  if not MyConnection1.Connected Then DataSet.Open;
  if not DataSet.Active Then DataSet.Open;
end;

procedure TData.marcdisplayAfterScroll(DataSet: TDataSet);
var
  style : string[3];
  AllUp : boolean;
begin
  if (MarcDisplayForm <> nil) and (MarcDisplayForm.Active)
    Then
    begin
      AllUp := False;

      //Label Font Style
      if not data.marcdisplay.FieldByName('label').IsNull Then
        MarcDisplayForm.TntGroupBox2.Caption := data.marcdisplay.FieldByName('label').Value +
                                              ' Label font';

      if not IsEmptyField(data.marcdisplay, 'l_style') Then
      begin
        style := data.marcdisplay.FieldByName('l_style').AsString;
        if length(style)<>3 Then AllUp := True
        Else
        begin
          MarcDisplayForm.SpeedButton1.Down := style[1] = '1';
          MarcDisplayForm.SpeedButton2.Down := style[2] = '1';
          MarcDisplayForm.SpeedButton3.Down := style[3] = '1';
        end;
       end
      Else AllUp := True;

      if AllUp Then
      begin
        MarcDisplayForm.SpeedButton1.Down := False;
        MarcDisplayForm.SpeedButton2.Down := False;
        MarcDisplayForm.SpeedButton3.Down := False;
      end;

      //Content Font Style
      AllUp := False;
      if not data.marcdisplay.FieldByName('label').IsNull Then
        MarcDisplayForm.TntGroupBox3.Caption := data.marcdisplay.FieldByName('label').Value +
                                              ' Content font';

      if not IsEmptyField(data.marcdisplay, 'c_style') Then
      begin
        style := data.marcdisplay.FieldByName('c_style').AsString;
        if length(style)<>3 Then AllUp := True
        Else
        begin
          MarcDisplayForm.SpeedButton4.Down := style[1] = '1';
          MarcDisplayForm.SpeedButton5.Down := style[2] = '1';
          MarcDisplayForm.SpeedButton6.Down := style[3] = '1';
        end;
       end
      Else AllUp := True;

      if AllUp Then
      begin
        MarcDisplayForm.SpeedButton4.Down := False;
        MarcDisplayForm.SpeedButton5.Down := False;
        MarcDisplayForm.SpeedButton6.Down := False;
      end;
    end


end;

procedure TData.MyConnection1ConnectionLost(Sender: TObject;
  Component: TComponent; ConnLostCause: TConnLostCause;
  var RetryMode: TRetryMode);
begin
  RetryMode := rmReconnectExecute;
end;

end.
