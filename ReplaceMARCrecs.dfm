object ReplaceMARCrecords: TReplaceMARCrecords
  Left = 192
  Top = 451
  Width = 347
  Height = 188
  Caption = 'ReplaceMARCrecords'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 321
    Height = 105
    TabStop = False
    Lines.Strings = (
      'Click Go to select input file with MARC records to replace the '
      'records with same record numbers in Database. '
      ''
      'Remember to update Zebra indexes after this operation.')
    ReadOnly = True
    TabOrder = 2
  end
end
