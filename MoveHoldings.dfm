object MoveHoldingsForm: TMoveHoldingsForm
  Left = 516
  Top = 406
  Width = 539
  Height = 86
  Caption = 'Move Holding'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 76
    Height = 13
    Caption = 'Move Holding #'
  end
  object Label2: TLabel
    Left = 248
    Top = 16
    Width = 7
    Height = 13
    Caption = '#'
  end
  object srchold: TEdit
    Left = 96
    Top = 16
    Width = 65
    Height = 21
    TabOrder = 0
  end
  object dsthold: TEdit
    Left = 264
    Top = 16
    Width = 65
    Height = 21
    TabOrder = 1
  end
  object TntButton1: TTntButton
    Left = 344
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Move'
    TabOrder = 2
    OnClick = TntButton1Click
  end
  object movedirection: TTntComboBox
    Left = 168
    Top = 16
    Width = 73
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    ItemIndex = 0
    ParentFont = False
    TabOrder = 3
    Text = 'Before'
    Items.Strings = (
      'Before'
      'After')
  end
  object Cancel: TButton
    Left = 432
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
