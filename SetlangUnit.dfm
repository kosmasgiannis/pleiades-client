object SetlangForm: TSetlangForm
  Left = 396
  Top = 320
  Width = 195
  Height = 112
  Caption = 'Set Languages'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object TntComboBox1: TTntComboBox
    Left = 96
    Top = 24
    Width = 73
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    Items.Strings = (
      'EL'
      'EN'
      'RO'
      'RU')
  end
  object TntBitBtn1: TTntBitBtn
    Left = 16
    Top = 24
    Width = 73
    Height = 25
    Caption = 'Change to '
    TabOrder = 1
    OnClick = TntBitBtn1Click
  end
end
