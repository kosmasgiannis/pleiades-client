object SettingsZebraForm: TSettingsZebraForm
  Left = 530
  Top = 246
  BorderStyle = bsDialog
  Caption = 'Configuration - Local Zebra Server'
  ClientHeight = 403
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TTntGroupBox
    Left = 12
    Top = 21
    Width = 327
    Height = 340
    Caption = 'Configuration Zebra Server'
    TabOrder = 0
    object Label1: TTntLabel
      Left = 10
      Top = 47
      Width = 86
      Height = 14
      Caption = 'Bibliographic Host'
    end
    object Label2: TTntLabel
      Left = 10
      Top = 83
      Width = 83
      Height = 14
      Caption = 'Bibliographic Port'
    end
    object Label3: TTntLabel
      Left = 10
      Top = 119
      Width = 110
      Height = 14
      Caption = 'Bibliographic Database'
    end
    object TntLabel3: TTntLabel
      Left = 10
      Top = 271
      Width = 93
      Height = 14
      Caption = 'Authority Database'
    end
    object TntLabel2: TTntLabel
      Left = 10
      Top = 235
      Width = 66
      Height = 14
      Caption = 'Authority Port'
    end
    object TntLabel1: TTntLabel
      Left = 10
      Top = 199
      Width = 69
      Height = 14
      Caption = 'Authority Host'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TTntEdit
      Left = 128
      Top = 43
      Width = 191
      Height = 22
      TabOrder = 0
    end
    object Edit2: TTntEdit
      Left = 128
      Top = 79
      Width = 191
      Height = 22
      TabOrder = 1
    end
    object Edit3: TTntEdit
      Left = 128
      Top = 114
      Width = 191
      Height = 22
      TabOrder = 2
    end
    object Edit4: TTntEdit
      Left = 128
      Top = 195
      Width = 191
      Height = 22
      TabOrder = 3
    end
    object Edit6: TTntEdit
      Left = 128
      Top = 266
      Width = 191
      Height = 22
      TabOrder = 4
    end
    object Edit5: TTntEdit
      Left = 128
      Top = 231
      Width = 191
      Height = 22
      TabOrder = 5
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 144
      Width = 133
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Dom Mode'
      TabOrder = 6
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 304
      Width = 133
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Authority Dom Mode'
      TabOrder = 7
    end
  end
  object BitBtn1: TTntBitBtn
    Left = 249
    Top = 368
    Width = 80
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object BitBtn2: TTntBitBtn
    Left = 162
    Top = 368
    Width = 81
    Height = 27
    Caption = 'Apply'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
