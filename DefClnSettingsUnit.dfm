object DefClnSettingsForm: TDefClnSettingsForm
  Left = 409
  Top = 250
  BorderStyle = bsDialog
  Caption = 'Configuration - Def. Classification'
  ClientHeight = 87
  ClientWidth = 255
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TTntLabel
    Left = 8
    Top = 8
    Width = 101
    Height = 14
    Caption = 'Default Classification'
  end
  object Edit1: TTntEdit
    Left = 8
    Top = 24
    Width = 241
    Height = 22
    Font.Charset = GREEK_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TTntButton
    Left = 8
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TTntButton
    Left = 176
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = Button2Click
  end
end
