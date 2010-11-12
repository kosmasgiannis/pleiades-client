object ClassCodeForm: TClassCodeForm
  Left = 470
  Top = 207
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Enter Classification Code'
  ClientHeight = 137
  ClientWidth = 294
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
  object Label1: TTntLabel
    Left = 8
    Top = 16
    Width = 280
    Height = 14
    Caption = 'Enter classification Code, it will be matched as a substring'
  end
  object Label2: TTntLabel
    Left = 8
    Top = 32
    Width = 148
    Height = 14
    Caption = 'in the classification data fields.'
  end
  object TntEdit1: TTntEdit
    Left = 24
    Top = 56
    Width = 233
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object BitBtn1: TTntBitBtn
    Left = 184
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object BitBtn2: TTntBitBtn
    Left = 88
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object SaveDialog1: TTntSaveDialog
    Left = 16
    Top = 96
  end
end
