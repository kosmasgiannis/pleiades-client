object FinalExportForm: TFinalExportForm
  Left = 397
  Top = 299
  Width = 495
  Height = 139
  Caption = 'Final_Export_Form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 97
    Height = 13
    Caption = 'Start numbering from'
  end
  object Label2: TLabel
    Left = 280
    Top = 16
    Width = 188
    Height = 13
    Caption = 'Use '#39'0'#39' (zero) to keep original numbering'
  end
  object BitBtn1: TBitBtn
    Left = 296
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Export'
    ModalResult = 1
    TabOrder = 0
  end
  object BitBtn2: TBitBtn
    Left = 392
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 136
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 40
    Width = 145
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Append to existing files?'
    TabOrder = 3
  end
end
