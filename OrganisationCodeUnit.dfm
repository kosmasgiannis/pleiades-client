object OrganisationCodeForm: TOrganisationCodeForm
  Left = 541
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Configuration - Organization Code'
  ClientHeight = 166
  ClientWidth = 398
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
    Left = 26
    Top = 26
    Width = 346
    Height = 70
    Caption = 'Organisation Code'
    TabOrder = 0
    object Edit1: TTntEdit
      Left = 17
      Top = 26
      Width = 303
      Height = 22
      TabOrder = 0
    end
  end
  object BitBtn1: TTntBitBtn
    Left = 293
    Top = 121
    Width = 81
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object BitBtn2: TTntBitBtn
    Left = 190
    Top = 121
    Width = 80
    Height = 27
    Caption = 'Apply'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
