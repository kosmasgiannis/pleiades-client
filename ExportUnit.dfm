object ExportForm: TExportForm
  Left = 234
  Top = 106
  BorderStyle = bsDialog
  Caption = 'Export'
  ClientHeight = 353
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TTntLabel
    Left = 32
    Top = 216
    Width = 65
    Height = 14
    Caption = 'Export format'
  end
  object GroupBox1: TTntGroupBox
    Left = 24
    Top = 24
    Width = 321
    Height = 161
    Caption = 'Export range'
    TabOrder = 0
    object Label2: TTntLabel
      Left = 200
      Top = 64
      Width = 12
      Height = 14
      Caption = 'to:'
    end
    object RadioButton1: TTntRadioButton
      Left = 32
      Top = 32
      Width = 257
      Height = 17
      Caption = 'All'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TTntRadioButton
      Left = 32
      Top = 64
      Width = 89
      Height = 17
      Caption = 'Recno from:'
      TabOrder = 1
      OnClick = RadioButton2Click
    end
    object Edit1: TTntEdit
      Left = 128
      Top = 56
      Width = 57
      Height = 22
      TabOrder = 2
      OnChange = Edit1Change
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TTntEdit
      Left = 224
      Top = 56
      Width = 57
      Height = 22
      TabOrder = 3
      OnChange = Edit2Change
      OnKeyPress = Edit1KeyPress
    end
    object RadioButton3: TTntRadioButton
      Left = 32
      Top = 96
      Width = 233
      Height = 17
      Caption = 'List:'
      TabOrder = 4
      OnClick = RadioButton3Click
    end
    object Edit3: TTntEdit
      Left = 32
      Top = 120
      Width = 241
      Height = 22
      TabOrder = 5
      OnChange = Edit3Change
    end
    object BitBtn1: TTntBitBtn
      Left = 280
      Top = 116
      Width = 27
      Height = 25
      Caption = '...'
      TabOrder = 6
      OnClick = BitBtn1Click
    end
  end
  object ComboBox1: TTntComboBox
    Left = 112
    Top = 208
    Width = 177
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 1
    Text = 'ISO2709'
    Items.Strings = (
      'ISO2709'
      'MARCXML'
      'INTERNAL')
  end
  object CheckBox1: TTntCheckBox
    Left = 32
    Top = 248
    Width = 257
    Height = 17
    Caption = 'Export holdings'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object BitBtn2: TTntBitBtn
    Left = 152
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Export'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object BitBtn3: TTntBitBtn
    Left = 264
    Top = 312
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    ModalResult = 2
    TabOrder = 4
  end
end
