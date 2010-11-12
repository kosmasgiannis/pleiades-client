object Form1: TForm1
  Left = 203
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Pretty MARC Form'
  ClientHeight = 121
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 16
    Top = 28
    Width = 48
    Height = 13
    Caption = 'Language'
  end
  object Label5: TLabel
    Left = 136
    Top = 28
    Width = 93
    Height = 13
    Caption = 'Max Length per line'
  end
  object Label6: TLabel
    Left = 16
    Top = 52
    Width = 46
    Height = 13
    Caption = 'Separator'
  end
  object go: TButton
    Left = 312
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = goClick
  end
  object language: TComboBox
    Left = 80
    Top = 24
    Width = 49
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'EN'
    Items.Strings = (
      'EN'
      'GR')
  end
  object rdmarc: TRadioButton
    Left = 344
    Top = 24
    Width = 57
    Height = 17
    Caption = 'MARC'
    TabOrder = 2
  end
  object rdlabels: TRadioButton
    Left = 408
    Top = 24
    Width = 57
    Height = 17
    Caption = 'Labels'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object maxlen: TEdit
    Left = 240
    Top = 24
    Width = 33
    Height = 21
    TabOrder = 4
    Text = '75'
    OnKeyPress = maxlenKeyPress
  end
  object separator: TEdit
    Left = 80
    Top = 48
    Width = 385
    Height = 21
    TabOrder = 5
  end
  object BitBtn1: TBitBtn
    Left = 392
    Top = 88
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    ModalResult = 2
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Title = 'Input File...'
    Left = 240
    Top = 80
  end
  object SaveDialog1: TSaveDialog
    Title = 'Output File...'
    Left = 208
    Top = 80
  end
end
