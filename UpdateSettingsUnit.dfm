object UpdateSettingsForm: TUpdateSettingsForm
  Left = 261
  Top = 210
  BorderStyle = bsDialog
  Caption = 'Update settings'
  ClientHeight = 124
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 14
  object TntBitBtn1: TTntBitBtn
    Left = 16
    Top = 16
    Width = 145
    Height = 25
    Caption = 'Update Tools'
    TabOrder = 0
    OnClick = TntBitBtn1Click
  end
  object TntMemo1: TTntMemo
    Left = 184
    Top = 72
    Width = 209
    Height = 49
    Lines.Strings = (
      'TntMemo1')
    ScrollBars = ssBoth
    TabOrder = 1
    Visible = False
    WordWrap = False
  end
  object StaticText1: TTntStaticText
    Left = 176
    Top = 21
    Width = 12
    Height = 18
    Caption = '--'
    TabOrder = 2
  end
  object StaticText2: TTntStaticText
    Left = 176
    Top = 51
    Width = 12
    Height = 18
    Caption = '--'
    TabOrder = 3
  end
  object TntBitBtn2: TTntBitBtn
    Left = 16
    Top = 56
    Width = 145
    Height = 25
    Caption = 'Update Vocabulary'
    TabOrder = 4
    OnClick = TntBitBtn2Click
  end
end
