unit UpdateSettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, Buttons, TntButtons, dataunit, TntForms;

type
  TUpdateSettingsForm = class(TTntForm)
    TntBitBtn1: TTntBitBtn;
    TntMemo1: TTntMemo;
    StaticText1: TTntStaticText;
    StaticText2: TTntStaticText;
    TntBitBtn2: TTntBitBtn;
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateSettingsForm: TUpdateSettingsForm;

implementation

Uses GlobalProcedures;

{$R *.dfm}

procedure analyze(d:WideString);
var
  s1,s2:string;
  sp,u:integer;
begin

  s1:=copy(d,2,10);
  s2:=copy(d,13,length(d) - 12);
  UpdateSettingsform.StaticText1.Caption:='Updating: '+s1+'-'+s2;

  val(s1,sp,u);

  if sp>0 then
  begin
    if Data.Tools.Locate('Spcode;usercode',vararrayof([sp,0]),[]) then
    begin
      data.Tools.Edit;
      data.Tools['name']:=s2;
      data.tools.Post;
    end
    else
    begin
      data.Tools.append;
      data.Tools['usercode']:=0;
      data.Tools['spcode']:=sp;
      data.Tools['name']:=s2;
      data.tools.Post;
    end;
  end;
end;

procedure TUpdateSettingsForm.TntBitBtn1Click(Sender: TObject);
var
   i :integer;
   st : TStrings;
begin
 st := TStringList.Create;
 try
   st.Clear;
   st.Text := DownloadFile('http://83.171.241.180/public/downloads/'+AppName+'tools.def');
   if st.Text <> '' then
   begin
     for i := 0 to  st.Count-1 do
       analyze(st.Strings[i]);

   {    sr := '';  k1:=0;  k2:=0;
   for i := 0 to ength(s)-1 do
   begin     sr := sr + s[i];
    if (s[i+1] = '[') and (i>5) then
    begin         k2:=i;          sr:=copy(s,k1,k2-k1);
      analyze(sr);       k1:=k2+1;
    end;     end;
      k2:=i;         sr:=copy(s,k1,k2-k1);
      analyze(sr);  }

    setusersetings(usercode);
    UpdateSettingsForm.StaticText1.caption:= ' Tools Updating is finished Succesfully';
    Data.Tools.Refresh;
 end
 else
   UpdateSettingsForm.StaticText1.caption:= ' Tools Updating has suffered an error!';
 finally
  st.Free;
 end;
end;

procedure analyze_voc(s1,s2,s3,s4,s5,s6:string);
begin

if data.vocabulary.Locate('component',s1,[]) then
  begin
    data.vocabulary.Edit;
    data.vocabulary.FieldByName('form').AsString:=s2;
    data.vocabulary.FieldByName('description').AsString:=s3;
    data.vocabulary.FieldByName('comptype').AsString:=s4;
    data.vocabulary.FieldByName('defaults').AsString:=s5;
    data.vocabulary.FieldByName('compactive').AsString:=s6;
    data.vocabulary.post;
  end
  else
  begin
    data.vocabulary.append;
    data.vocabulary.FieldByName('component').AsString:=s1;
    data.vocabulary.FieldByName('form').AsString:=s2;
    data.vocabulary.FieldByName('description').AsString:=s3;
    data.vocabulary.FieldByName('comptype').AsString:=s4;
    data.vocabulary.FieldByName('defaults').AsString:=s5;
    data.vocabulary.FieldByName('compactive').AsString:=s6;
    data.vocabulary.post;
  end;



end;
procedure TUpdateSettingsForm.TntBitBtn2Click(Sender: TObject);
var
   s,sr:String;
   i :integer;
   k1,k2:integer;
   scont : array [1..6] of string;
   c:integer;
begin

  s := '';
  s := DownloadFile('http://83.171.241.180/public/downloads/'+AppName+'voc.def');
  if s <>'' then
  begin
    sr := '';
    k1:=-1;
    i:=0;
    c:=0;
    while i<length(s)-1 do
    begin
      repeat
       i:=i+1;
      until (s[i]='*') or (s[i]='@') or (i>=length(s));
      c:=c+1;
      k2:=i;
      k1:=k1+2;
      scont[c]:=copy(s,k1,k2-k1);
      k1:=k2+1;
      if c=6 then
      begin
        analyze_voc(scont[1],scont[2],scont[3],scont[4],scont[5],scont[6]);
        c:=0;
      end;
    end;
    UpdateSettingsForm.StaticText2.caption:= ' Vocabulary Updating is finished Succesfully';
  end
  else
    UpdateSettingsForm.StaticText2.caption:= ' Vocabulary Updating has suffered an error!';

end;

procedure TUpdateSettingsForm.TntFormShow(Sender: TObject);
begin
  StaticText1.Caption := '--';
  StaticText2.Caption := '--';
end;

end.
