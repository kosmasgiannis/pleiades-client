object NewMarcForm: TNewMarcForm
  Left = 254
  Top = 121
  BorderStyle = bsDialog
  Caption = 'Choose name'
  ClientHeight = 106
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object TntLabel1: TTntLabel
    Left = 26
    Top = 9
    Width = 66
    Height = 14
    Caption = 'Choose name'
  end
  object TntComboBox1: TTntComboBox
    Left = 9
    Top = 26
    Width = 216
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
  end
  object BitBtn1: TTntBitBtn
    Left = 17
    Top = 69
    Width = 81
    Height = 27
    Caption = 'Create'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TTntBitBtn
    Left = 138
    Top = 69
    Width = 81
    Height = 27
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = BitBtn2Click
  end
end
