object ReportsForm: TReportsForm
  Left = 601
  Top = 133
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Reports Form'
  ClientHeight = 394
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TTntGroupBox
    Left = 15
    Top = 14
    Width = 320
    Height = 323
    Caption = 'Reports'
    TabOrder = 0
    object RadioButton1: TTntRadioButton
      Left = 17
      Top = 26
      Width = 217
      Height = 18
      Caption = 'Print by Author, Title'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TTntRadioButton
      Left = 17
      Top = 60
      Width = 251
      Height = 19
      Caption = 'Create book indexes list by collection'
      TabOrder = 1
      OnClick = RadioButton2Click
    end
    object RadioButton3: TTntRadioButton
      Left = 17
      Top = 95
      Width = 268
      Height = 18
      Caption = 'Create book indexes file by classification'
      TabOrder = 2
      OnClick = RadioButton3Click
    end
    object RadioButton4: TTntRadioButton
      Left = 17
      Top = 129
      Width = 122
      Height = 19
      Caption = 'Print headings'
      TabOrder = 3
      OnClick = RadioButton4Click
    end
    object RadioButton5: TTntRadioButton
      Left = 17
      Top = 190
      Width = 208
      Height = 18
      Caption = 'Print Heading'#39's index'
      TabOrder = 4
      OnClick = RadioButton5Click
    end
    object BitBtn3: TTntBitBtn
      Left = 284
      Top = 146
      Width = 27
      Height = 23
      Caption = '...'
      TabOrder = 5
      OnClick = BitBtn3Click
    end
    object BitBtn4: TTntBitBtn
      Left = 284
      Top = 207
      Width = 27
      Height = 22
      Caption = '...'
      TabOrder = 6
      OnClick = BitBtn4Click
    end
    object Edit1: TTntEdit
      Left = 17
      Top = 146
      Width = 260
      Height = 22
      TabOrder = 7
      OnChange = Edit1Change
    end
    object Edit2: TTntEdit
      Left = 17
      Top = 207
      Width = 260
      Height = 22
      TabOrder = 8
      OnChange = Edit2Change
    end
    object RadioButton6: TTntRadioButton
      Left = 17
      Top = 248
      Width = 122
      Height = 18
      Caption = 'Pretty MARC'
      TabOrder = 9
      OnClick = RadioButton6Click
    end
  end
  object BitBtn1: TTntBitBtn
    Left = 144
    Top = 352
    Width = 81
    Height = 27
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TTntBitBtn
    Left = 256
    Top = 352
    Width = 81
    Height = 27
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 3
  end
  object CheckBox1: TTntCheckBox
    Left = 32
    Top = 308
    Width = 105
    Height = 19
    Caption = 'From Active List'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object SaveDialog1: TTntSaveDialog
    DefaultExt = '.txt'
    Left = 29
    Top = 349
  end
  object OpenDialog1: TTntOpenDialog
    DefaultExt = 'txt'
    Filter = 'TXT Files (*.txt)|*.txt|All Files (*.*)|*.*'
    InitialDir = 'c:\'
    Left = 69
    Top = 349
  end
end
