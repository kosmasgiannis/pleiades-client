object CreateListForm: TCreateListForm
  Left = 193
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Create list'
  ClientHeight = 357
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TTntGroupBox
    Left = 8
    Top = 24
    Width = 681
    Height = 289
    Caption = 'Create list'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TTntLabel
      Left = 208
      Top = 96
      Width = 12
      Height = 14
      Caption = 'to:'
    end
    object RadioButton2: TTntRadioButton
      Left = 32
      Top = 27
      Width = 105
      Height = 17
      Caption = 'By classification'
      TabOrder = 0
      OnClick = RadioButton2Click
    end
    object Edit2: TTntEdit
      Left = 144
      Top = 24
      Width = 185
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = Edit2Change
    end
    object RadioButton4: TTntRadioButton
      Left = 32
      Top = 94
      Width = 81
      Height = 17
      Caption = 'Recno from:'
      TabOrder = 4
      OnClick = RadioButton4Click
    end
    object Edit4: TTntEdit
      Left = 144
      Top = 92
      Width = 57
      Height = 22
      TabOrder = 5
      OnChange = Edit4Change
      OnKeyPress = Edit4KeyPress
    end
    object Edit5: TTntEdit
      Left = 224
      Top = 92
      Width = 57
      Height = 22
      TabOrder = 6
      OnChange = Edit4Change
      OnKeyPress = Edit5KeyPress
    end
    object RadioButton5: TTntRadioButton
      Left = 32
      Top = 199
      Width = 161
      Height = 17
      Caption = 'Records with syntax errors'
      TabOrder = 7
      OnClick = RadioButton5Click
    end
    object RadioButton6: TTntRadioButton
      Left = 32
      Top = 232
      Width = 153
      Height = 17
      Caption = 'Records without subject'
      TabOrder = 8
      OnClick = RadioButton6Click
    end
    object RadioButton7: TTntRadioButton
      Left = 32
      Top = 61
      Width = 97
      Height = 17
      Caption = 'By record level'
      TabOrder = 2
      OnClick = RadioButton7Click
    end
    object ComboBox1: TTntComboBox
      Left = 144
      Top = 58
      Width = 121
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 3
      OnChange = ComboBox1Change
    end
    object RadioButton8: TTntRadioButton
      Left = 32
      Top = 128
      Width = 129
      Height = 17
      Caption = 'Modified date between'
      TabOrder = 9
      OnClick = RadioButton8Click
    end
    object DateTimePicker1: TTntDateTimePicker
      Left = 168
      Top = 126
      Width = 122
      Height = 21
      Date = 39022.652558229160000000
      Format = 'dd/MM/yyyy'
      Time = 39022.652558229160000000
      TabOrder = 10
      OnChange = DateTimePicker1Change
    end
    object DateTimePicker2: TTntDateTimePicker
      Left = 312
      Top = 128
      Width = 121
      Height = 21
      Date = 39022.652941261570000000
      Format = 'dd/MM/yyyy'
      Time = 39022.652941261570000000
      TabOrder = 11
      OnChange = DateTimePicker1Change
    end
  end
  object Button1: TTntButton
    Left = 424
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TTntButton
    Left = 544
    Top = 328
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
