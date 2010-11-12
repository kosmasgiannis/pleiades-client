object ImportForm: TImportForm
  Left = 193
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Import'
  ClientHeight = 309
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TTntLabel
    Left = 40
    Top = 176
    Width = 33
    Height = 14
    Caption = 'Format'
  end
  object Label2: TTntLabel
    Left = 40
    Top = 208
    Width = 26
    Height = 14
    Caption = 'Level'
  end
  object CheckBox1: TTntCheckBox
    Left = 40
    Top = 24
    Width = 153
    Height = 17
    Caption = 'Preserve record numbers'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object GroupBox1: TTntGroupBox
    Left = 32
    Top = 48
    Width = 209
    Height = 97
    TabOrder = 1
    object RadioButton1: TTntRadioButton
      Left = 16
      Top = 24
      Width = 169
      Height = 17
      Caption = 'Overwrite existing records'
      Checked = True
      Enabled = False
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TTntRadioButton
      Left = 16
      Top = 56
      Width = 161
      Height = 17
      Caption = 'Ignore existing records'
      Enabled = False
      TabOrder = 1
      TabStop = True
    end
  end
  object BitBtn1: TTntBitBtn
    Left = 32
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Import'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object BitBtn2: TTntBitBtn
    Left = 168
    Top = 272
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    ModalResult = 2
    TabOrder = 5
  end
  object ComboBox1: TTntComboBox
    Left = 96
    Top = 176
    Width = 145
    Height = 22
    ItemHeight = 14
    TabOrder = 2
    Text = 'USMARC'
    Items.Strings = (
      'USMARC'
      'MARCXML (MARC21)'
      'INTERNAL')
  end
  object ComboBox2: TTntComboBox
    Left = 96
    Top = 208
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 3
  end
  object XMLDocument1: TXMLDocument
    Top = 8
    DOMVendorDesc = 'MSXML'
  end
end
