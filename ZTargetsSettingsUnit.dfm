object ZTargetsSettingsForm: TZTargetsSettingsForm
  Left = 251
  Top = 122
  BorderStyle = bsDialog
  Caption = 'Configuration - Ztargets'
  ClientHeight = 457
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TTntLabel
    Left = 8
    Top = 4
    Width = 27
    Height = 14
    Caption = 'Name'
  end
  object Label2: TTntLabel
    Left = 8
    Top = 52
    Width = 137
    Height = 14
    Caption = 'Ztarget (host:port/database)'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 160
    Width = 30
    Height = 14
    Caption = 'MARC'
  end
  object Label4: TTntLabel
    Left = 8
    Top = 192
    Width = 50
    Height = 14
    Caption = 'In CharSet'
  end
  object Label5: TTntLabel
    Left = 160
    Top = 192
    Width = 59
    Height = 14
    Caption = 'Out CharSet'
  end
  object Label6: TTntLabel
    Left = 8
    Top = 104
    Width = 28
    Height = 14
    Caption = 'Proxy'
  end
  object Edit1: TTntEdit
    Left = 8
    Top = 24
    Width = 305
    Height = 22
    Font.Charset = GREEK_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Edit2: TTntEdit
    Left = 8
    Top = 72
    Width = 305
    Height = 22
    Font.Charset = GREEK_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object ComboBox1: TTntComboBox
    Left = 64
    Top = 156
    Width = 89
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 3
    Items.Strings = (
      'MARC21'
      'UNIMARC')
  end
  object ComboBox2: TTntComboBox
    Left = 64
    Top = 188
    Width = 89
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
    Items.Strings = (
      'Win-1253'
      'advance'
      'iso5428'
      'UTF8'
      'LATIN1')
  end
  object ComboBox3: TTntComboBox
    Left = 224
    Top = 188
    Width = 89
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 5
    Items.Strings = (
      'Win-1253'
      'advance'
      'iso5428'
      'UTF8'
      'LATIN1')
  end
  object GroupBox1: TTntGroupBox
    Left = 8
    Top = 224
    Width = 313
    Height = 193
    Caption = 'Servers'
    TabOrder = 6
    object ListBox1: TTntListBox
      Left = 8
      Top = 24
      Width = 193
      Height = 153
      Font.Charset = GREEK_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
      OnClick = ListBox1Click
    end
    object Button1: TTntButton
      Left = 216
      Top = 24
      Width = 83
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TTntButton
      Left = 216
      Top = 56
      Width = 83
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button5: TTntButton
      Left = 216
      Top = 120
      Width = 83
      Height = 25
      Caption = 'Clear'
      TabOrder = 4
      OnClick = Button5Click
    end
    object BitBtn1: TTntBitBtn
      Left = 216
      Top = 88
      Width = 83
      Height = 25
      Caption = 'Change'
      TabOrder = 3
      OnClick = BitBtn1Click
    end
  end
  object Edit3: TTntEdit
    Left = 8
    Top = 120
    Width = 305
    Height = 22
    TabOrder = 2
  end
  object Button3: TTntButton
    Left = 120
    Top = 424
    Width = 99
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TTntButton
    Left = 224
    Top = 424
    Width = 99
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
end
