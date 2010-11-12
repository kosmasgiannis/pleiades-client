object ProgresBarForm: TProgresBarForm
  Left = 297
  Top = 127
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 93
  ClientWidth = 352
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TTntPanel
    Left = 3
    Top = 3
    Width = 346
    Height = 86
    TabOrder = 0
    object Label1: TTntLabel
      Left = 17
      Top = 9
      Width = 75
      Height = 15
      Caption = 'Please wait...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TTntLabel
      Left = 17
      Top = 34
      Width = 32
      Height = 14
      Caption = 'Label2'
    end
    object ProgressBar1: TProgressBar
      Left = 9
      Top = 60
      Width = 328
      Height = 18
      TabOrder = 0
    end
  end
end
