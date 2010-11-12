unit ImportUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DateUtils, Grids, DBGrids, TntDialogs, tntclasses,
  TntStdCtrls, xmldom, XMLIntf, msxmldom, XMLDoc, oxmldom, TntButtons, TntForms,
  cUnicodeCodecs, DB, common;
type
  TImportForm = class(TTntForm)
    CheckBox1: TTntCheckBox;
    GroupBox1: TTntGroupBox;
    RadioButton1: TTntRadioButton;
    RadioButton2: TTntRadioButton;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    Label1: TTntLabel;
    ComboBox1: TTntComboBox;
    Label2: TTntLabel;
    ComboBox2: TTntComboBox;
    XMLDocument1: TXMLDocument;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function Import : boolean;
    procedure Import_a_record(rec : UTF8String; format: string; level : integer; var recno, ovr, ign, cnt : integer);
  public
    { Public declarations }
  end;

var
  ImportForm: TImportForm;

implementation

uses DataUnit, MainUnit, zoomit, WideIniClass, ProgresBarUnit, utility, GlobalProcedures;

{$R *.dfm}

procedure TImportForm.Import_a_record(rec : UTF8String; format : string; level : integer; var recno, ovr, ign, cnt : integer);
var
  reclen : integer;
  junk : WideString;
// base, nf : integer;
//  direntry : Widestring;
//  place, lang, material, notes : WideString;
//  suppl, index, branch, item, collection, cln : WideString;
//  format: string;
  temp : UTF8String;
begin
      reclen := strtointdef(copy(rec,1,5),-1);
      recno:=-1;
      if reclen <> -1 then
      begin
       junk := copy(rec,13,5);
//       base := strtoint(junk);
//       nf := (base-1-24)div 12;

       if CheckBox1.Checked Then                    //Preserve recno
        begin
          recno := GetRecno(rec);

          if Data.basket.Locate('recno', recno, []) Then
          begin
            if RadioButton1.Checked Then          //Overwrite existing records
              begin
               Data.hold.Close;
               Data.hold.Open;

               //Delete holdings first
//Kosmas: Don''t remove holdings anyway... just replace the MARC record.
//               while not data.hold.Eof do data.hold.Delete;
               temp := RemoveHoldings(rec);
               Refresh084(recno, temp);
//FIXME :               Refresh856(recno,temp);
               if length(temp) >= 10 then temp[10] := 'a';
               if length(temp) >= 11 then temp[11] := '2';
               if length(temp) >= 12 then temp[12] := '2';

               EditTable(Data.basket);
               Data.basket['level'] := level;
               Data.basket['format'] := format;
               Data.basket['Creator'] := UserCode;
               Data.basket['Created'] := today;
               Data.basket['Modifier'] := NULL;
               Data.basket['Modified'] := NULL;
               data.basket.GetBlob('text').AsWideString := StringToWideString(temp, Greek_codepage);
               TBlobField(data.basket.FieldByName('text')).Modified := True;

               PostTable(Data.basket);

               ovr := ovr + 1;
              end
              Else
              begin
                ign := ign + 1;
//                nf := 0;
              end;
          end
          Else
          begin
           PostTable(Data.basket);

           temp := RemoveHoldings(rec);
           if length(temp) >= 10 then temp[10] := 'a';
           if length(temp) >= 11 then temp[11] := '2';
           if length(temp) >= 12 then temp[12] := '2';

           Data.basket.Append;
           Data.basket['recno'] := recno;
           Data.basket['level'] := level;
           Data.basket['format'] := format;
           Data.basket['Creator'] := UserCode;
           Data.basket['Created'] := today;
           data.basket.GetBlob('text').AsWideString := StringToWideString(temp, Greek_codepage);
           TBlobField(data.basket.FieldByName('text')).Modified := True;

           PostTable(Data.basket);
           recno := Data.basket['recno'];

           cnt := cnt +1;
          end;
        end
        Else                        //Not preserving record numbers
        begin
         //Add imported recodrs to the basket
         PostTable(Data.basket);
         Data.basket.Append;
         PostTable(Data.basket);        //This is done because we need Recno which is autoincrement

         recno := Data.basket.FieldByName('recno').AsInteger;
         ReplaceRecno(recno, rec);
         temp := RemoveHoldings(rec);
         if length(temp) >= 10 then temp[10] := 'a';
         if length(temp) >= 11 then temp[11] := '2';
         if length(temp) >= 12 then temp[12] := '2';

         EditTable(Data.basket);
         Data.basket['level'] := level;
         Data.basket['format'] := format;
         Data.basket['Creator'] := UserCode;
         Data.basket['Created'] := today;
         data.basket.GetBlob('text').AsWideString := StringToWideString(temp, Greek_codepage);
         TBlobField(data.basket.FieldByName('text')).Modified := True;

         PostTable(Data.basket);

         cnt := cnt +1;
        end;

{
       //Add holdings
       for i:=1 to nf do
       begin
        direntry:=copy(rec,25+(i-1)*12,12);
        fl := strtoint(copy(direntry,4,4));
        ind := strtoint(copy(direntry,8,5));
        if (copy(direntry,1,3) = '936') then
        begin
         branch := ''; collection :=''; item:=''; cln :='';
         suppl:=''; index:='';
         junk := copy(rec,base+ind+2,fl-2);
         ppy:=0;
         for l:=1 to length(junk) do
         begin
          if ppy = 0 then
          begin
           if junk[l] = 'a' then ppy := 1
           else if junk[l] = 'b' then ppy := 2
           else if junk[l] = 'c' then ppy := 3
           else if junk[l] = 'd' then ppy := 4
           else if junk[l] = 'v' then ppy := 5
           else if junk[l] = 's' then ppy := 6
           else if junk[l] = 'i' then ppy := 7
           else ppy:=8;
          end
          else
           if junk[l] = #31 then ppy := 0
           else
           begin
            if ppy =1 then branch := branch+junk[l];
            if ppy =2 then collection := collection+junk[l];
            if ppy =3 then cln := cln+junk[l];
            if ppy =4 then item := item+junk[l];
            if ppy =6 then suppl := suppl+junk[l];
            if ppy =7 then index := index+junk[l];
           end;
         end;
         if ((recno <> -1) and ((branch<>'') or (collection <> '') or (item <> '') or (cln <> '') or (suppl<>'') or (index<>''))) then
         begin
          data.hold.Append;
//          data.hold.FieldByName('recno').Value := recno;
//          data.hold.FieldByName('branch').Value := UTF8Decode(branch);
//          data.hold.FieldByName('collection').Value := UTF8Decode(collection);
//          data.hold.FieldByName('cln').Value := UTF8Decode(cln);
//          data.hold.FieldByName('item').Value := UTF8Decode(item);
//          data.hold.FieldByName('f867').Value := UTF8Decode(suppl);
//          data.hold.FieldByName('f868').Value := UTF8Decode(index);

          data.hold.FieldByName('recno').Value := recno;
          data.hold.FieldByName('branch').Value := branch;
          data.hold.FieldByName('collection').Value := collection;
          data.hold.FieldByName('cln').Value := cln;
          data.hold.FieldByName('item').Value := item;
          data.hold.FieldByName('f867').Value := suppl;
          data.hold.FieldByName('f868').Value := index;

          data.hold.Post;

         end;
        end;
       end;
}
       RecordUpdated(myzebrahost,
       'update', recno, MakeMRCFromBasket, false);
      end;
end;

function TImportForm.Import : boolean;
var
  F : Textfile;
  rec : UTF8String;
  level, recno : integer;
  ch : char;
  flag : boolean;
  nr, i, nri, j, nrj, k, nrk, l, ign, cnt, ovr : integer;
  format: string;
  FSize, BytesRead: integer;
  nd,ndb,ndh,ndhr: IXMLNode;
  holdrec, basketrec: ttntstrings;
begin
 FastRecordCreator.OpenDialog1.FileName := '';

 format := ComboBox1.Text;
 if ComboBox1.Text = 'MARCXML (MARC21)' then
  format := 'USMARC';

 if copy(ComboBox1.Text,1,7) = 'MARCXML' then
  FastRecordCreator.OpenDialog1.Filter := 'MARCXML files (*.xml)|*.xml|All Files (*.*)|*.*'
 else if copy(ComboBox1.Text,1,8) = 'INTERNAL' then
  FastRecordCreator.OpenDialog1.Filter := 'SRC INTERNAL files (*.xml)|*.xml|All Files (*.*)|*.*'
 else
  FastRecordCreator.OpenDialog1.Filter := 'MRC files (*.mrc)|*.mrc|All Files (*.*)|*.*';

 FastRecordCreator.OpenDialog1.FilterIndex := 1; { start the dialog showing all files }

 if FastRecordCreator.OpenDialog1.Execute = true then
 begin
  Screen.Cursor:=crHourGlass;
  data.basket.DisableControls;
  data.hold.DisableControls;
  ProgresBarForm.Show;
  ProgresBarForm.ProgressBar1.Min := 0;
  ProgresBarForm.ProgressBar1.Max := 100;
  ProgresBarForm.ProgressBar1.Position := 0;
  ProgresBarForm.ProgressBar1.Visible := True;

  level := ComboBox2.ItemIndex;

  cnt := 0; ign := 0; ovr := 0;

  try
   if copy(ComboBox1.Text,1,7) = 'MARCXML' then
   begin
     xmldocument1.FileName:=FastRecordCreator.opendialog1.FileName;
     xmldocument1.Active:=true;
     if xmldocument1.DocumentElement.LocalName = 'record' then nr:=1
     else nr :=xmldocument1.DocumentElement.ChildNodes.Count;

     if (nr = 1 ) then
     begin
        rec:=make_MARC_from_MARCXML(xmldocument1.DocumentElement);
        Import_a_record(rec, format, level, recno, ovr, ign, cnt);

        ProgresBarForm.Label2.Caption := 'Importing RecNo:  '+IntToStr(recno);
        ProgresBarForm.ProgressBar1.Position := 100;
        Application.ProcessMessages;

     end
     else if (nr > 1) then
     begin
       for i:=0 to nr -1 do
       begin
         rec:=make_MARC_from_MARCXML(xmldocument1.DocumentElement.ChildNodes[i]);
         Import_a_record(rec, format, level, recno, ovr, ign, cnt);

         ProgresBarForm.Label2.Caption := 'Importing RecNo:  '+IntToStr(recno);
         ProgresBarForm.ProgressBar1.Position := Round(i*100/nr);
         Application.ProcessMessages;
       end;
     end;
     xmldocument1.Active:=false;
   end
   else if copy(ComboBox1.Text,1,8) = 'INTERNAL' then
   begin
     holdrec:=TtntStringlist.Create;
     basketrec:=TtntStringlist.Create;

   // Import record in INTERNAL FORMAT
     xmldocument1.FileName:=FastRecordCreator.opendialog1.FileName;
     xmldocument1.Active:=true;
     nr :=xmldocument1.DocumentElement.ChildNodes.Count;
     for i:=0 to nr -1 do
     begin
       nd :=xmldocument1.DocumentElement.ChildNodes[i];
       nri:=nd.ChildNodes.Count;
       for j:=0 to nri -1 do
       begin
        if nd.ChildNodes[j].LocalName = 'basket' then
        begin
          basketrec.Clear;
          ndb :=nd.ChildNodes[j];
          nrj := ndb.ChildNodes.Count;
          for k:=0 to nrj -1 do
          begin
           basketrec.Add(ndb.ChildNodes[k].LocalName);
           if ndb.ChildNodes[k].LocalName = 'text' then
           begin
             rec:=make_MARC_from_MARCXML(ndb.ChildNodes[k].ChildNodes[0]);
             basketrec.Add(UTF8StringToWideString(rec));
           end
           else
             basketrec.Add(ndb.ChildNodes[k].Text);
          end;

          nrj := basketrec.Count div 2;

          for k:=0 to nrj-1 do
          begin
          // FIXME: Here add the code to append the record in basket either in insert or in overwrite mode...
           wideshowmessage(basketrec[k*2]+'='+basketrec[(k*2)+1]);
          end;

        end
        else if nd.ChildNodes[j].LocalName = 'hold' then
        begin
          ndh :=nd.ChildNodes[j];
          nrj := ndh.ChildNodes.Count;
          for k:=0 to nrj -1 do
          begin
            ndhr :=ndh.ChildNodes[k];
            nrk := ndhr.ChildNodes.Count;
            holdrec.Clear;
            for l:=0 to nrk -1 do
            begin
             holdrec.Add(ndhr.ChildNodes[l].LocalName);
             holdrec.Add(ndhr.ChildNodes[l].Text);
//              wideshowmessage(ndhr.ChildNodes[l].LocalName);
            end;
            nrk := holdrec.Count div 2;

            for l:=0 to nrk-1 do
            begin
            // FIXME: Here add the code to append the record in hold either in insert or in overwrite mode...
             wideshowmessage(holdrec[l*2]+'='+holdrec[(l*2)+1]);
            end;
          end;
        end;
       end;
     end;
     holdrec.Free;
     basketrec.Free;
     xmldocument1.Active:=false;
   end
   else
   begin
    AssignFile(F, FastRecordCreator.OpenDialog1.FileName);
    Reset(F);
    BytesRead := 0;
    FSize := FileSize(f);
    flag := false;
    while not eof(f) do
    begin
     read(f,ch);
     BytesRead := BytesRead + 1;
     if ((ch=#13) or (ch=#10)) then ch:=' ';
     if (flag = false) then
     begin
      if ((ord(ch) >= ord('0')) and (ord(ch)<=ord('9'))) then
      begin
       rec:=ch;
       flag:=true;
      end;
     end
     else
     begin
      rec:=rec+ch;
      if (ch=#29) then
      begin
       flag:=false;

       Import_a_record(rec, format, level, recno, ovr, ign, cnt);

       ProgresBarForm.Label2.Caption := 'Importing RecNo:  '+IntToStr(recno);
       ProgresBarForm.ProgressBar1.Position := Round(100*BytesRead/(128*FSize));
       Application.ProcessMessages;

      end;
     end;
    end;

   end;

   finally
     if copy(ComboBox1.Text,1,7) = 'USMARC' then CloseFile(F);
     Screen.Cursor := crDefault;
     data.basket.EnableControls;
     data.hold.EnableControls;
     FastRecordCreator.SetFocus;
     Result := True;

   if CheckBox1.Checked Then
     begin
      if RadioButton1.Checked Then
         WideShowMessage(IntToStr(ovr)+' records overwritten, ' + IntToStr(cnt) + ' appended from file:  '+FastRecordCreator.OpenDialog1.FileName+'.');
      if RadioButton2.Checked Then
         WideShowMessage(IntToStr(cnt)+' records appended, ' + IntToStr(ign) + ' ignored from file:  '+FastRecordCreator.OpenDialog1.FileName+'.')
     end
     Else
     WideShowMessage(IntToStr(cnt)+' records appended from file: '+FastRecordCreator.OpenDialog1.FileName+'.');
     ProgresBarForm.ProgressBar1.Visible := False;
     ProgresBarForm.Close;
   end;
 end
 Else
 Result := False;
end;

procedure TImportForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ImportForm.Enabled := False;
  try
    case ModalResult of
     mrOk: if not Import Then Action := caNone;
    end;
  finally
    ImportForm.Enabled := True;
  end;
end;

procedure TImportForm.CheckBox1Click(Sender: TObject);
begin
  RadioButton1.Enabled := CheckBox1.Checked;
  RadioButton2.Enabled := CheckBox1.Checked;
end;

procedure TImportForm.FormCreate(Sender: TObject);
begin
  if FastRecordCreator.bib_auth_status = 'bib' then
    PopulateComboFromIni('RecordLevel', ComboBox2)
  else
    PopulateComboFromIni('AuthRecordLevel', ComboBox2);
  if ComboBox2.Items.Count > 1 Then ComboBox2.ItemIndex := 1;
end;

end.
