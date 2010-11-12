unit mycharconversion;

interface

uses Sysutils, dialogs, StdCtrls, Windows;

function elot928toadvance(s : string) : string;
function advancetoelot928(s : string) : string;
function advancetoutf8(s : string) : string;
function elot928toutf8(s : string) : string;
function elot928toutf8esc(s : string) : string;
function iso5428Toelot928(str:string) : string;
function elot928Toiso5428(s : string) : string;
function elot928ToUpperiso5428(s : string) : string;
function utf8to928esc(buf : string):string;
function utf8to928(buf : string):string;
procedure load_utf8fixcodes(fn:string);
function fix_utf_marc1(marcrec: string) : string;

function marc928utf8conv1(marcrec: PWideChar; fromcharset : string; esc:boolean) : WideString;
function WideStringToString(const ws: WideString; codePage: Word): AnsiString;

function Unicode2Elot928(s: WideString): string;
function Elot928ToUnicode (s: string) : WideString;

implementation

var codesfrom,codesto : array [1..512] of string;
    codesdim : integer;

function utf82unicode(utf_char:longword):longword;
var
uni: longword;
u1, u2, u3, u4 : byte;
begin
 uni := 0;
 u1 := utf_char and $ff;
 u2 := (utf_char shr 8) and $ff;
 u3 := (utf_char shr 16) and $ff;
 u4 := (utf_char shr 24) and $ff;
 if (((u4 shr 3) and $1e) <> $00) then
 begin
  uni := ((u4 and $7) shl 2) or ((u3 shr 4) and $3);
  uni := (uni shl 8) or ((u3 and $f) shl 4 or ((u2 shr 2) and $f));
  uni := (uni shl 8) or ((u2 and $3) shl 6 or (u1 and $3f));
 end
 else if (((u3 shr 4) and $e) <> $00) then
 begin
  uni := (u3 and $f);
  uni := (uni shl 4) or ((u2 shr 2) and $f);
  uni := (uni shl 8) or ((u2 and $3) shl 6 or (u1 and $3f));
 end
 else if (((u3 shr 5) and $6) <> $00) then
 begin
  {* Ok, First six bit of the 1st byte goes to the first six bits in the
   * first byte. Then bits # 0, 1 in the 2nd byte goes to bits # 6, 7 in
   * the first byte. So we're done with the first byte.
   * Then bits # 2-4 from the 2nd byte goes to the bits # 0-2 in the 2nd
   * byte. So we're done!
   *}
  uni := (u2 shr 2) and $7;
  uni := (uni shl 8) or ((u2 and $3) shl 6 or (u1 and $3f));
 end else if (u1 <=$7f ) then
  uni := utf_char;
 result:=uni;
end;

function unicodeto928(i : longword) : longword;
begin
 case (i) of
  $20ac: result:=$80;
  $201a: result:=$82;
  $2018: result:=$91;
  $2019: result:=$92;
  $0385: result:=$a1;
  $0386: result:=$a2;
  $0388: result:=$b8;
  $0389: result:=$b9;
  $038a: result:=$ba;
  $038c: result:=$bc;
  $038e: result:=$be;
  $038f: result:=$bf;

  $0390: result:=$c0;
  $0391: result:=$c1;
  $0392: result:=$c2;
  $0393: result:=$c3;
  $0394: result:=$c4;
  $0395: result:=$c5;
  $0396: result:=$c6;
  $0397: result:=$c7;
  $0398: result:=$c8;
  $0399: result:=$c9;
  $039a: result:=$ca;
  $039b: result:=$cb;
  $039c: result:=$cc;
  $039d: result:=$cd;
  $039e: result:=$ce;
  $039f: result:=$cf;
  $03a0: result:=$d0;
  $03a1: result:=$d1;

  $03a3: result:=$d3;
  $03a4: result:=$d4;
  $03a5: result:=$d5;
  $03a6: result:=$d6;
  $03a7: result:=$d7;
  $03a8: result:=$d8;
  $03a9: result:=$d9;
  $03aa: result:=$da;
  $03ab: result:=$db;
  $03ac: result:=$dc;
  $03ad: result:=$dd;
  $03ae: result:=$de;
  $03af: result:=$df;

  $03b0: result:=$e0;
  $03b1: result:=$e1;
  $03b2: result:=$e2;
  $03b3: result:=$e3;
  $03b4: result:=$e4;
  $03b5: result:=$e5;
  $03b6: result:=$e6;
  $03b7: result:=$e7;
  $03b8: result:=$e8;
  $03b9: result:=$e9;
  $03ba: result:=$ea;
  $03bb: result:=$eb;
  $03bc: result:=$ec;
  $03bd: result:=$ed;
  $03be: result:=$ee;
  $03bf: result:=$ef;
  $03c0: result:=$f0;
  $03c1: result:=$f1;
  $03c2: result:=$f2;
  $03c3: result:=$f3;
  $03c4: result:=$f4;
  $03c5: result:=$f5;
  $03c6: result:=$f6;
  $03c7: result:=$f7;
  $03c8: result:=$f8;
  $03c9: result:=$f9;
  $03ca: result:=$fa;
  $03cb: result:=$fb;
  $03cc: result:=$fc;
  $03cd: result:=$fd;
  $03ce: result:=$fe;

  else result:= i;
 end;
end;

function elottounicode(i : longword) : longword;
begin
 case i  of
  $80: result:=$20ac;
  $82: result:=$201a;
  $91: result:=$2018;
  $92: result:=$2019;
  $a1: result:=$0385;
  $a2: result:=$0386;
  $b8: result:=$0388;
  $b9: result:=$0389;
  $ba: result:=$038a;
  $bc: result:=$038c;
  $be: result:=$038e;
  $bf: result:=$038f;

  $c0: result:=$0390;
  $c1: result:=$0391;
  $c2: result:=$0392;
  $c3: result:=$0393;
  $c4: result:=$0394;
  $c5: result:=$0395;
  $c6: result:=$0396;
  $c7: result:=$0397;
  $c8: result:=$0398;
  $c9: result:=$0399;
  $ca: result:=$039a;
  $cb: result:=$039b;
  $cc: result:=$039c;
  $cd: result:=$039d;
  $ce: result:=$039e;
  $cf: result:=$039f;
  $d0: result:=$03a0;
  $d1: result:=$03a1;

  $d3: result:=$03a3;
  $d4: result:=$03a4;
  $d5: result:=$03a5;
  $d6: result:=$03a6;
  $d7: result:=$03a7;
  $d8: result:=$03a8;
  $d9: result:=$03a9;
  $da: result:=$03aa;
  $db: result:=$03ab;
  $dc: result:=$03ac;
  $dd: result:=$03ad;
  $de: result:=$03ae;
  $df: result:=$03af;

  $e0: result:=$03b0;
  $e1: result:=$03b1;
  $e2: result:=$03b2;
  $e3: result:=$03b3;
  $e4: result:=$03b4;
  $e5: result:=$03b5;
  $e6: result:=$03b6;
  $e7: result:=$03b7;
  $e8: result:=$03b8;
  $e9: result:=$03b9;
  $ea: result:=$03ba;
  $eb: result:=$03bb;
  $ec: result:=$03bc;
  $ed: result:=$03bd;
  $ee: result:=$03be;
  $ef: result:=$03bf;
  $f0: result:=$03c0;
  $f1: result:=$03c1;
  $f2: result:=$03c2;
  $f3: result:=$03c3;
  $f4: result:=$03c4;
  $f5: result:=$03c5;
  $f6: result:=$03c6;
  $f7: result:=$03c7;
  $f8: result:=$03c8;
  $f9: result:=$03c9;
  $fa: result:=$03ca;
  $fb: result:=$03cb;
  $fc: result:=$03cc;
  $fd: result:=$03cd;
  $fe: result:=$03ce;
 else
       result:=i;
 end;
end;

function unicode2utf8(uc : longword) : longword;
var u1, u2, u3, u4 : byte;
ret : longword;
begin
 if (uc < $80) then
  result:=uc
 else if (uc < $800) then
 begin
  u2 := $C0 or uc shr 6;
  u1 := $80 or uc and $3F;
  ret := (u2 shl 8) or u1;
  result := ret;
 end
 else if (uc < $10000) then
 begin
  u3 := $E0 or uc shr 12;
  u2 := $80 or uc shr 6 and $3F;
  u1 := $80 or uc and $3F;
  ret := (u2 shl 8) or u1;
  ret := (u3 shl 16) or ret;
  result := ret;
 end
 else if (uc < $200000) then
 begin
  u4 := $F0 or uc shr 18;
  u3 := $80 or uc shr 12 and $3F;
  u2 := $80 or uc shr 6 and $3F;
  u1 := $80 or uc and $3F;
  ret := (u2 shl 8) or u1;
  ret := (u3 shl 16) or ret;
  ret := (u4 shl 24) or ret;
  result:= ret;
 end
 else
 result := 0;
end;

procedure utf8tochar(i : longword; var s : string);
var sc : byte;
 j,l:integer;
 ch:char;
begin
 s:='';
 while (i<>0) do
 begin
  sc:=i and $ff;
  s:=s+chr(sc);
  i:=i shr 8;
 end;
 l:=length(s);
 for j:=1 to (l div 2) do
 begin
  ch:=s[j];
  s[j]:=s[l-j+1];
  s[l-j+1]:=ch;
 end;
end;

function utf8to928(buf : string):string;
var junk : string;
b1,b2,c,i,len : longword;
lala,v:byte;
begin
 c:=0;

 result:='';
 len := length(buf);

 for i:=1 to len do
 begin
  v := ord(buf[i]);
  lala := (v and $80) shr 7;
  if (lala = 1) then
  begin
   lala := (v and $C0) shr 6;
   if (lala = 3) then
   begin
    if (c <> 0) then begin
     // result:=result+chr(unicodeto928(c));
     if (unicodeto928(c) = c) then utf8tochar(unicode2utf8(c),junk) // change to add a backslash
     else junk := chr(unicodeto928(c));
     result:=result+junk;
    end;
    b1 := v and $1f;
    c := b1;
   end
   else if (lala = 2) then
   begin
    b2 := v and $3f;
    c := (c shl 6) or b2;
   end
  end
  else
  begin
   if (c <> 0) then
   begin
    // result:=result+chr(unicodeto928(c));
    if (unicodeto928(c) = c) then utf8tochar(unicode2utf8(c),junk) // change to add a backslash
    else junk := chr(unicodeto928(c));
    result:=result+junk;
    c := 0;
   end;
   // if buf[i] = '\' then result:=result+'\'; // changed to add a backslash
   result:=result+buf[i];
  end;
 end;
end;

function utf8touni(buf : string):WideString;
var junk : string;
b1,b2,c,i,len : longword;
lala,v:byte;
begin
 c:=0;

 result:='';
 len := length(buf);

 for i:=1 to len do
 begin
  v := ord(buf[i]);
  lala := (v and $80) shr 7;
  if (lala = 1) then
  begin
   lala := (v and $C0) shr 6;
   if (lala = 3) then
   begin
    if (c <> 0) then begin
     // result:=result+chr(unicodeto928(c));
     if (unicodeto928(c) = c) then utf8tochar(unicode2utf8(c),junk) // change to add a backslash
     else junk := chr(unicodeto928(c));
     result:=result+junk;
    end;
    b1 := v and $1f;
    c := b1;
   end
   else if (lala = 2) then
   begin
    b2 := v and $3f;
    c := (c shl 6) or b2;
   end
  end
  else
  begin
   if (c <> 0) then
   begin
    // result:=result+chr(unicodeto928(c));
    if (unicodeto928(c) = c) then utf8tochar(unicode2utf8(c),junk) // change to add a backslash
    else junk := chr(unicodeto928(c));
    result:=result+junk;
    c := 0;
   end;
   result:=result+buf[i];
  end;
 end;
end;

function utf8to928esc(buf : string):string;
var junk : string;
b1,b2,c,i,j,len : longword;
lala,v:byte;
begin
 c:=0;

 result:='';
 len := length(buf);

 for i:=1 to len do
 begin
  v := ord(buf[i]);
  lala := (v and $80) shr 7;
  if (lala = 1) then
  begin
   lala := (v and $C0) shr 6;
   if (lala = 3) then
   begin
    if (c <> 0) then begin
     if (unicodeto928(c) = c) then
     begin
      utf8tochar(unicode2utf8(c),junk); // change to add a backslash
      for j:=1 to length(junk) do
       result:=result+'\'+junk[j];
     end
     else result := result+chr(unicodeto928(c));
    end;
    b1 := v and $1f;
    c := b1;
   end
   else if (lala = 2) then
   begin
    b2 := v and $3f;
    c := (c shl 6) or b2;
   end
  end
  else
  begin
   if (c <> 0) then
   begin
    if (unicodeto928(c) = c) then
    begin
     utf8tochar(unicode2utf8(c),junk); // change to add a backslash
     for j:=1 to length(junk) do
      result:=result+'\'+junk[j];
    end
    else result := result+chr(unicodeto928(c));
    c := 0;
   end;
   if buf[i] = '\' then result:=result+'\'; // changed to add a backslash
   result:=result+buf[i];
  end;
 end;
end;

function elot928toutf8(s : string) : string;
var utftochar,r : string;
i : integer;
begin
 r:='';
 for i:=1 to length(s) do
 begin
  utf8tochar(unicode2utf8(elottounicode(ord(s[i])) ), utftochar);
  r:=r+utftochar;
 end;
 result := r;
end;

function elot928toutf8esc(s : string) : string;
var utftochar,r : string;
f : boolean;
i : integer;
v:byte;
begin
 r:='';
 f:=false;
 for i:=1 to length(s) do
 begin
  v:=ord(s[i]) and $ff;
  if (s[i] = '\') then
  begin
   if f then
   begin
    r:=r+'\';
    f:=false;
   end
   else f:=true
  end
  else begin
   if f then
   begin
    r:=r+chr(v);
   end
   else
   begin
    utf8tochar(unicode2utf8(elottounicode(ord(s[i])) ), utftochar);
    r:=r+utftochar;
   end;
   f:=false;
  end;
 end;
 result := r;
end;

function iso5428Toelot928(str:string) : string;
var tonos, dialitika, i,k,l: integer;
    r:string;
begin
 l := length(str);
 tonos := 0;
 dialitika := 0;
 r:='';

 for i:=1 to l do
 begin
  k:= ord(str[i]);
  case k of
   $a1: tonos := 1;
   $a2: tonos := 1;
   $a3: dialitika := 1;
   $a4: tonos := 1;
   $a5: begin end;
   $a6: begin end;
   $a7: begin end;
   $b0: r:=r+ '«';
   $b1: r:=r+ '»';
   $b2: r:=r+ '"';
   $b3: r:=r+ '"';
   $b4: begin end;
   $b5: begin end;
   $bb: r:=r+ '·';
   $bf: r:=r+ ';';
   $c1: begin if (tonos = 1) then r:=r+ '¢' else r:=r+ 'Á'; tonos := 0; end;
   $c2: r:=r+ 'Â';
   $c4: r:=r+ 'Ã';
   $c5: r:=r+ 'Ä';
   $c6: begin if (tonos = 1) then r:=r+ '¸' else r:=r+ 'Å'; tonos := 0; end;
   $c7: begin end;
   $c8: begin end;
   $c9: r:=r+ 'Æ';
   $ca: begin if (tonos = 1) then r:=r+ '¹' else r:=r+ 'Ç'; tonos := 0; end;
   $cb: r:=r+ 'È';
   $cc: begin if (tonos = 1) then
               if (dialitika = 1) then begin
                r:=r+ '¡';
                r:=r+ 'É';
               end
               else
                r:=r+ 'º'
              else
               if (dialitika = 1) then
                r:=r+ 'Ú'
               else
                r:=r+ 'É';
              dialitika := 0;
              tonos := 0;
        end;
   $cd: r:=r+ 'Ê';
   $ce: r:=r+ 'Ë';
   $cf: r:=r+ 'Ì';
   $d0: r:=r+ 'Í';
   $d1: r:=r+ 'Î';
   $d2: begin if (tonos = 1) then r:=r+ '¼' else r:=r+ 'Ï'; tonos := 0; end;
   $d3: r:=r+ 'Ð';
   $d4: begin end;
   $d5: r:=r+ 'Ñ';
   $d6: r:=r+ 'Ó';
   $d8: r:=r+ 'Ô';
   $d9: begin
        if (tonos = 1) then
           if (dialitika = 1) then begin
             r:=r+ '¡';
             r:=r+ 'Õ';
           end
           else
             r:=r+ '¾'
        else
           if (dialitika = 1) then
                r:=r+ 'Û'
           else
                r:=r+ 'Õ';
        dialitika := 0;
        tonos := 0;
        end;
   $da: r:=r+ 'Ö';
   $db: r:=r+ '×';
   $dc: r:=r+ 'Ø';
   $dd: begin if (tonos=1) then r:=r+ '¿' else r:=r+ 'Ù'; tonos := 0; end;
   $de: begin end;
   $e1: begin if (tonos=1) then r:=r+ 'Ü' else r:=r+ 'á'; tonos := 0; end;
   $e2: r:=r+ 'â';
   $e3: r:=r+ 'â';
   $e4: r:=r+ 'ã';
   $e5: r:=r+ 'ä';
   $e6: begin if (tonos=1) then r:=r+ 'Ý' else r:=r+ 'å'; tonos := 0; end;
   $e7: begin end;
   $e8: begin end;
   $e9: r:=r+ 'æ';
   $ea: begin if (tonos=1) then r:=r+ 'Þ' else r:=r+ 'ç'; tonos := 0; end;
   $eb: r:=r+ 'è';
   $ec: begin
        if (tonos = 1) then
           if (dialitika = 1) then
                r:=r+ 'À'
           else
                r:=r+ 'ß'
        else
           if (dialitika = 1) then
                r:=r+ 'ú'
           else
                r:=r+ 'é';
         dialitika := 0;
         tonos := 0;
        end;
   $ed: r:=r+ 'ê';
   $ee: r:=r+ 'ë';
   $ef: r:=r+ 'ì';
   $f0: r:=r+ 'í';
   $f1: r:=r+ 'î';
   $f2: begin if (tonos =1) then r:=r+ 'ü' else r:=r+ 'ï'; tonos := 0; end;
   $f3: r:=r+ 'ð';
   $f4: begin end;
   $f5: r:=r+ 'ñ';
   $f6: r:=r+ 'ó';
   $f7: r:=r+ 'ò';
   $f8: r:=r+ 'ô';
   $f9: begin
        if (tonos = 1) then
          if (dialitika = 1) then
            r:=r+ 'à'
          else
            r:=r+ 'ý'
        else
          if (dialitika = 1) then
            r:=r+ 'û'
          else
            r:=r+ 'õ';
        dialitika := 0;
        tonos := 0;
       end;
   $fa: r:=r+ 'ö';
   $fb: r:=r+ '÷';
   $fc: r:=r+ 'ø';
   $fd: begin if (tonos = 1) then r:=r+'þ' else r:=r+'ù'; tonos := 0; end;
   $fe: begin end;
  else
           if ((tonos = 1) and (dialitika = 1)) then
           begin
            r:=r+'¡';
            if (tonos = 1) then r:=r+ '´';
            if (dialitika = 1) then r:=r+ '¨';
           end;
           r:=r+str[i];
  end;
 end;
 result:=r;
end;

function elot928Toiso5428(s : string) : string;
var r : string;
i,l: integer;
begin
 r:='';
 l:=length(s);
 for i:=1 to l do
 begin
  case s[i] of
   'Ü' : r:=r+#162#225;
   'Ý' : r:=r+#162#230;
   'Þ' : r:=r+#162#234;
   'ß' : r:=r+#162#236;
   'ú' : r:=r+#163#236;
   'À' : r:=r+#162#163#236;
   'ü' : r:=r+#162#242;
   'ý' : r:=r+#162#249;
   'à' : r:=r+#162#163#249;
   'û' : r:=r+#163#249;
   'þ' : r:=r+#162#253;
   '¢' : r:=r+#162#193;
   '¸' : r:=r+#162#198;
   '¹' : r:=r+#162#202;
   'º' : r:=r+#162#204;
   'Ú' : r:=r+#163#204;
   '¼' : r:=r+#162#210;
   '¾' : r:=r+#162#217;
   'Û' : r:=r+#163#217;
   '¿' : r:=r+#162#221;
   'Á' : r:=r+#193;
   'Â' : r:=r+#194;
   'Ã' : r:=r+#196;
   'Ä' : r:=r+#197;
   'Å' : r:=r+#198;
   'Æ' : r:=r+#201;
   'Ç' : r:=r+#202;
   'È' : r:=r+#203;
   'É' : r:=r+#204;
   'Ê' : r:=r+#205;
   'Ë' : r:=r+#206;
   'Ì' : r:=r+#207;
   'Í' : r:=r+#208;
   'Î' : r:=r+#209;
   'Ï' : r:=r+#210;
   'Ð' : r:=r+#211;
   'Ñ' : r:=r+#213;
   'Ó' : r:=r+#214;
   'Ô' : r:=r+#216;
   'Õ' : r:=r+#217;
   'Ö' : r:=r+#218;
   '×' : r:=r+#219;
   'Ø' : r:=r+#220;
   'Ù' : r:=r+#221;
   'á' : r:=r+#225;
   'â' : r:=r+#227;
   'ã' : r:=r+#228;
   'ä' : r:=r+#229;
   'å' : r:=r+#230;
   'æ' : r:=r+#233;
   'ç' : r:=r+#234;
   'è' : r:=r+#235;
   'é' : r:=r+#236;
   'ê' : r:=r+#237;
   'ë' : r:=r+#238;
   'ì' : r:=r+#239;
   'í' : r:=r+#240;
   'î' : r:=r+#241;
   'ï' : r:=r+#242;
   'ð' : r:=r+#243;
   'ñ' : r:=r+#245;
   'ó' : r:=r+#246;
   'ò' : r:=r+#247;
   'ô' : r:=r+#248;
   'õ' : r:=r+#249;
   'ö' : r:=r+#250;
   '÷' : r:=r+#251;
   'ø' : r:=r+#252;
   'ù' : r:=r+#253;
   '¡' : r:=r+#162#163;
   '´' : r:=r+#162;
   '¨' : r:=r+#163;
  else
   r:=r+s[i];
  end;
 end;
 result := r;
end;

function elot928ToUpperiso5428(s : string) : string;
var r : string;
i,l: integer;
begin
 r:='';
 l:=length(s);
 for i:=1 to l do
 begin
  case s[i] of
   'Ü' : r:=r+#162#193;
   'Ý' : r:=r+#162#198;
   'Þ' : r:=r+#162#202;
   'ß' : r:=r+#162#204;
   'ú' : r:=r+#163#204;
   'À' : r:=r+#163#204;
   'ü' : r:=r+#162#210;
   'ý' : r:=r+#162#217;
   'û' : r:=r+#163#217;
   'à' : r:=r+#163#217;
   'þ' : r:=r+#162#221;
   '¢' : r:=r+#162#193;
   '¸' : r:=r+#162#198;
   '¹' : r:=r+#162#202;
   'º' : r:=r+#162#204;
   'Ú' : r:=r+#163#204;
   '¼' : r:=r+#162#210;
   '¾' : r:=r+#162#217;
   'Û' : r:=r+#163#217;
   '¿' : r:=r+#162#221;
   'Á' : r:=r+#193;
   'Â' : r:=r+#194;
   'Ã' : r:=r+#196;
   'Ä' : r:=r+#197;
   'Å' : r:=r+#198;
   'Æ' : r:=r+#201;
   'Ç' : r:=r+#202;
   'È' : r:=r+#203;
   'É' : r:=r+#204;
   'Ê' : r:=r+#205;
   'Ë' : r:=r+#206;
   'Ì' : r:=r+#207;
   'Í' : r:=r+#208;
   'Î' : r:=r+#209;
   'Ï' : r:=r+#210;
   'Ð' : r:=r+#211;
   'Ñ' : r:=r+#213;
   'Ó' : r:=r+#214;
   'Ô' : r:=r+#216;
   'Õ' : r:=r+#217;
   'Ö' : r:=r+#218;
   '×' : r:=r+#219;
   'Ø' : r:=r+#220;
   'Ù' : r:=r+#221;
   'á' : r:=r+#193;
   'â' : r:=r+#194;
   'ã' : r:=r+#196;
   'ä' : r:=r+#197;
   'å' : r:=r+#198;
   'æ' : r:=r+#201;
   'ç' : r:=r+#202;
   'è' : r:=r+#203;
   'é' : r:=r+#204;
   'ê' : r:=r+#205;
   'ë' : r:=r+#206;
   'ì' : r:=r+#207;
   'í' : r:=r+#208;
   'î' : r:=r+#209;
   'ï' : r:=r+#210;
   'ð' : r:=r+#211;
   'ñ' : r:=r+#213;
   'ó' : r:=r+#214;
   'ò' : r:=r+#214;
   'ô' : r:=r+#216;
   'õ' : r:=r+#217;
   'ö' : r:=r+#218;
   '÷' : r:=r+#219;
   'ø' : r:=r+#220;
   'ù' : r:=r+#221;
   '¡' : r:=r+#162#163;
   '´' : r:=r+#162;
   '¨' : r:=r+#163;
  else
   r:=r+s[i];
  end;
 end;
 result := r;
end;

function marc928utf8conv1(marcrec: PWideChar; fromcharset : string; esc:boolean) : WideString;
var i,p,base, start, leng : integer;
 text, r, ldr, newdir, hlp : WideString;
 tag : string;
 numoffields,newpos,newlen : integer;
begin
  hlp := copy(marcrec,1,5);
  leng := strtoint(hlp);
  for i:=1 to leng do if (marcrec[i]=#0) then marcrec[i]:='.';
  ldr := copy(marcrec,6,19);
  hlp := copy(marcrec,13,5);
  r:='';
  newdir:='';
  newpos:=0;
  base := strtoint(hlp);
  numoffields := (base - 1 -24) div 12;
  p := 25;
  for i:=1 to numoffields do
  begin
   hlp := copy(marcrec,p,12);
   tag := copy(hlp,1,3);
   leng:=strtoint(copy(hlp,4,4));
   start:=base+strtoint(copy(hlp,8,5));
   text := copy(marcrec,start+1,leng);
   if esc = true then
   begin
    if fromcharset = '928' then
     text:=elot928toutf8esc(text)
    else if fromcharset = 'UTF8' then
     text := utf8to928esc(text);
   end
   else
   begin
    if fromcharset = '928' then
     text:=elot928toutf8(text)
    else if fromcharset = 'UTF8' then
     text := utf8to928(text);
   end;

//   if esc and (fromcharset = 'UTF8') then text := UTF8Decode(text);

   r:=r+text;
   newlen:=length(text);
   newdir:=newdir+tag+WideFormat('%.4d',[newlen])+WideFormat('%.5d',[newpos]);
   newpos:=newpos+newlen;
   p:=p+12;
  end;

  newlen:=5+length(ldr)+length(newdir)+length(r)+2;
  hlp:=WideFormat('%.5d',[newlen]);
  result:=hlp+ldr+newdir+#30+r+#29;
end;



function elot928ToAdvance(s : string) : string;
var r : string;
i,l,k: integer;
begin
 r:='';
 l:=length(s);
 for i:=1 to l do
 begin
  k:= ord(s[i]) and $ff;
  case k of
// 9d tonos ; 9e dialitika ; 9f shift
   $dc : r:=r+chr($9d)+chr($81);
   $dd : r:=r+chr($9d)+chr($85);
   $de : r:=r+chr($9d)+chr($87);
   $df : r:=r+chr($9d)+chr($89);
   $fc : r:=r+chr($9d)+chr($8f);
   $fd : r:=r+chr($9d)+chr($95);
   $fe : r:=r+chr($9d)+chr($99);
   $c0 : r:=r+chr($9d)+chr($9e)+chr($89);
   $e0 : r:=r+chr($9d)+chr($9e)+chr($95);
   $a2 : r:=r+chr($9d)+chr($9f)+chr($81);
   $b8 : r:=r+chr($9d)+chr($9f)+chr($85);
   $b9 : r:=r+chr($9d)+chr($9f)+chr($87);
   $ba : r:=r+chr($9d)+chr($9f)+chr($89);
   $bc : r:=r+chr($9d)+chr($9f)+chr($8f);
   $be : r:=r+chr($9d)+chr($9f)+chr($95);
   $bf : r:=r+chr($9d)+chr($9f)+chr($99);
   $fa : r:=r+chr($9e)+chr($89);
   $fb : r:=r+chr($9e)+chr($95);
   $da : r:=r+chr($9e)+chr($9f)+chr($89);
   $db : r:=r+chr($9e)+chr($9f)+chr($95);
   $c1 : r:=r+chr($9f)+chr($81);
   $c2 : r:=r+chr($9f)+chr($82);
   $c3 : r:=r+chr($9f)+chr($83);
   $c4 : r:=r+chr($9f)+chr($84);
   $c5 : r:=r+chr($9f)+chr($85);
   $c6 : r:=r+chr($9f)+chr($86);
   $c7 : r:=r+chr($9f)+chr($87);
   $c8 : r:=r+chr($9f)+chr($88);
   $c9 : r:=r+chr($9f)+chr($89);
   $ca : r:=r+chr($9f)+chr($8a);
   $cb : r:=r+chr($9f)+chr($8b);
   $cc : r:=r+chr($9f)+chr($8c);
   $cd : r:=r+chr($9f)+chr($8d);
   $ce : r:=r+chr($9f)+chr($8e);
   $cf : r:=r+chr($9f)+chr($8f);
   $d0 : r:=r+chr($9f)+chr($90);
   $d1 : r:=r+chr($9f)+chr($91);
   $d3 : r:=r+chr($9f)+chr($93);
   $d4 : r:=r+chr($9f)+chr($94);
   $d5 : r:=r+chr($9f)+chr($95);
   $d6 : r:=r+chr($9f)+chr($96);
   $d7 : r:=r+chr($9f)+chr($97);
   $d8 : r:=r+chr($9f)+chr($98);
   $d9 : r:=r+chr($9f)+chr($99);
   $e1 : r:=r+chr($81);
   $e2 : r:=r+chr($82);
   $e3 : r:=r+chr($83);
   $e4 : r:=r+chr($84);
   $e5 : r:=r+chr($85);
   $e6 : r:=r+chr($86);
   $e7 : r:=r+chr($87);
   $e8 : r:=r+chr($88);
   $e9 : r:=r+chr($89);
   $ea : r:=r+chr($8a);
   $eb : r:=r+chr($8b);
   $ec : r:=r+chr($8c);
   $ed : r:=r+chr($8d);
   $ee : r:=r+chr($8e);
   $ef : r:=r+chr($8f);
   $f0 : r:=r+chr($90);
   $f1 : r:=r+chr($91);
   $f2 : r:=r+chr($92);
   $f3 : r:=r+chr($93);
   $f4 : r:=r+chr($94);
   $f5 : r:=r+chr($95);
   $f6 : r:=r+chr($96);
   $f7 : r:=r+chr($97);
   $f8 : r:=r+chr($98);
   $f9 : r:=r+chr($99);
  else
   r:=r+s[i];
  end;
 end;
 result := r;
end;

function advancetoelot928(s : string) : string;
var r : string;
i,l,k: integer;
tonos, dial, shift : boolean;
begin
 r:='';
 tonos:=false;
 dial :=false;
 shift:=false;
 l:=length(s);
 for i:=1 to l do
 begin
  k:= ord(s[i]) and $ff;
  if k =$9d then tonos := true
  else if k=$9e then dial :=true
  else if k=$9f then shift := true
  else
  begin
   case k of
    $81 : begin
               if shift then
                 if tonos then r:=r+chr($a2) else r:=r+chr($c1)
               else
                 if tonos then r:=r+chr($dc) else r:=r+chr($e1);
          end;
    $82 : if shift then r:=r+chr($c2) else r:=r+chr($e2);
    $83 : if shift then r:=r+chr($c3) else r:=r+chr($e3);
    $84 : if shift then r:=r+chr($c4) else r:=r+chr($e4);
    $85 : begin
               if shift then
                 if tonos then r:=r+chr($b8) else r:=r+chr($c5)
               else
                 if tonos then r:=r+chr($dd) else r:=r+chr($e5);
          end;
    $86 : if shift then r:=r+chr($c6) else r:=r+chr($e6);
    $87 : begin
               if shift then
                 if tonos then r:=r+chr($b9) else r:=r+chr($c7)
               else
                 if tonos then r:=r+chr($de) else r:=r+chr($e7);
          end;
    $88 : if shift then r:=r+chr($c8) else r:=r+chr($e8);
    $89 : begin
               if shift then
               begin
                 if tonos then r:=r+chr($ba)
                 else if dial then r:=r+chr($9e) else r:=r+chr($c9);
               end
               else
               begin
                 if tonos then
                  if dial then r:=r+chr($c0) else r:=r+chr($df)
                 else
                  if dial then r:=r+chr($fa) else r:=r+chr($e9)
               end;
          end;
    $8a : if shift then r:=r+chr($ca) else r:=r+chr($ea);
    $8b : if shift then r:=r+chr($cb) else r:=r+chr($eb);
    $8c : if shift then r:=r+chr($cc) else r:=r+chr($ec);
    $8d : if shift then r:=r+chr($cd) else r:=r+chr($ed);
    $8e : if shift then r:=r+chr($ce) else r:=r+chr($ee);
    $8f : begin
               if shift then
                 if tonos then r:=r+chr($bc) else r:=r+chr($cf)
               else
                 if tonos then r:=r+chr($fc) else r:=r+chr($ef);
          end;
    $90 : if shift then r:=r+chr($d0) else r:=r+chr($f0);
    $91 : if shift then r:=r+chr($d1) else r:=r+chr($f1);
    $92 : r:=r+chr($f2);
    $93 : if shift then r:=r+chr($d3) else r:=r+chr($f3);
    $94 : if shift then r:=r+chr($d4) else r:=r+chr($f4);
    $95 : begin
               if shift then
               begin
                 if tonos then r:=r+chr($be)
                 else if dial then r:=r+chr($db) else r:=r+chr($d5);
               end
               else
               begin
                 if tonos then
                  if dial then r:=r+chr($e0) else r:=r+chr($fd)
                 else
                  if dial then r:=r+chr($fb) else r:=r+chr($f5)
               end;
          end;
    $96 : if shift then r:=r+chr($d6) else r:=r+chr($f6);
    $97 : if shift then r:=r+chr($d7) else r:=r+chr($f7);
    $98 : if shift then r:=r+chr($d8) else r:=r+chr($f8);
    $99 : begin
               if shift then
                 if tonos then r:=r+chr($bf) else r:=r+chr($d9)
               else
                 if tonos then r:=r+chr($fe) else r:=r+chr($f9);
          end;
   else
    r:=r+s[i];
   end;
   tonos:=false;
   dial :=false;
   shift:=false;
  end;
 end;
 result := r;
end;

function advancetoutf8(s : string) : string;
var r:string;
begin
 r:=advancetoelot928(s);
 result:=elot928toutf8(r);
end;

function replacecodes (s : string) : string;
var i : integer;
begin
 result:=s;
 for i:=1 to codesdim do
  result:=stringreplace(result,codesfrom[i],codesto[i],[rfReplaceAll]);
end;

function fix_utf_marc1(marcrec: string) : string;
var i,p,base, start, leng : integer;
 r,ldr,newdir,hlp,tag,text : string;
 numoffields,newpos,newlen : integer;
begin
  result:='';
  hlp := copy(marcrec,1,5);
  leng := strtoint(hlp);
  for i:=1 to leng do if (marcrec[i]=#0) then marcrec[i]:=' ';
  ldr := copy(marcrec,6,19);
  hlp := copy(marcrec,13,5);
  r:='';
  newdir:='';
  newpos:=0;
  base := strtoint(hlp);
  numoffields := (base - 1 -24) div 12;
  p := 25;
  for i:=1 to numoffields do
  begin
   hlp := copy(marcrec,p,12);
   tag := copy(hlp,1,3);
   leng:=strtoint(copy(hlp,4,4));
   start:=base+strtoint(copy(hlp,8,5));
   text := copy(marcrec,start+1,leng);
//
// add code to replace strings...
//
   text := replacecodes(text);
   r:=r+text;
   newlen:=length(text);
   newdir:=newdir+tag+format('%.4d',[newlen])+format('%.5d',[newpos]);
   newpos:=newpos+newlen;
   p:=p+12;
  end;

  newlen:=5+length(ldr)+length(newdir)+length(r)+2;
  hlp:=format('%.5d',[newlen]);
  result:=hlp+ldr+newdir+#30+r+#29;
end;

procedure load_utf8fixcodes(fn:string);
var fc : textfile;
    line :string;
begin
 codesdim := 0;
 if fileexists(fn) then
 begin
  AssignFile(fc,fn);
  reset(fc);
  while(not eof(fc)) do
  begin
   readln(fc,line);
   if (line[1] <> '#') then
   begin
    codesdim:=codesdim+1;
    codesfrom[codesdim]:=copy(line,1,pos('=',line)-1);
    codesto[codesdim]:=copy(line,pos('=',line)+1,length(line));
   end;
  end;
  CloseFile(fc);
 end;
end;

function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
  else
  begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], - 1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], - 1, @Result[1], l - 1, nil, nil);
  end;
end;

function Unicode2Elot928(s: WideString): string;
var
  i: integer;
  WC : PWord;
  s1 : string;
begin
  WC := PWord(PWideChar(s));

  s1 := '';
  for i := 0 to length(s)-1 do
  begin
    s1 := s1 + Char(unicodeto928(WC^));
    Inc(WC);
  end;

  Result := s1;
end;

function Elot928ToUnicode(s: string): WideString;
var
  C: PByte;
  i: integer;
  s1: WideString;
begin
  c := PByte(PChar(s));

  s1 := '';
  for i := 1 to length(s) do
   begin
     s1 := s1 + WideChar(elottounicode(c^));
     Inc(c);
   end;

  Result := s1;
end;


end.
