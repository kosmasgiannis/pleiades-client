unit WideIniClass;

interface

uses Classes, TntClasses, IniFiles, cUnicodeCodecs;

type
  TWideIniFile = class(TIniFile)
    public
      function ReadWideString(const Section, Ident: WideString; Default: WideString): WideString;
      procedure WriteWideString(const Section, Ident: WideString; Value: WideString);
      procedure ReadWideSection(const Section: WideString; Strings: TtntStringList);
      procedure ReadWideSectionValues(const Section: WideString; Strings: TtntStringList);
    end;

implementation

{ TWideIniFile }

function TWideIniFile.ReadWideString(const Section, Ident: WideString;
  Default: WideString): WideString;
var
  Temp: string;
begin
  Temp := ReadString(WideStringToUTF8String(Section), WideStringToUTF8String(Ident), '<default>');
  if Temp = '<default>' Then Result := Default
                        Else Result := UTF8StringToWideString(Temp);
end;

procedure TWideIniFile.WriteWideString(const Section, Ident: WideString;
  Value: WideString);
begin
  WriteString(WideStringToUTF8String(Section), WideStringToUTF8String(Ident), WideStringToUTF8String(Value));
end;

procedure TWideIniFile.ReadWideSection(const Section: WideString;
  Strings: TtntStringList);
var
  Temp: Tstrings;
  i : integer;
begin
  Temp:=Tstringlist.Create;
  Temp.Clear;
  ReadSection(WideStringToUTF8String(Section), Temp);
  for i:=0 to Temp.Count-1 do
   Strings.Add(UTF8StringToWideString(Temp[i]));
  Temp.Free;
end;

procedure TWideIniFile.ReadWideSectionValues(const Section: WideString;
  Strings: TtntStringList);
var
  Temp: Tstrings;
  i : integer;
begin
  Temp:=Tstringlist.Create;
  Temp.Clear;
  ReadSectionValues(WideStringToUTF8String(Section), Temp);
  for i:=0 to Temp.Count-1 do
   Strings.Add(UTF8StringToWideString(Temp[i]));
  Temp.Free;
end;


end.
