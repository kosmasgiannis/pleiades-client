object statisticsForm: TstatisticsForm
  Left = 213
  Top = 149
  Width = 1043
  Height = 640
  Caption = 'Statistics'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 28
    Height = 13
    Caption = 'From'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 16
    Height = 13
    Caption = 'To'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object stat_results: TTntStringGrid
    Left = 0
    Top = 120
    Width = 1033
    Height = 481
    TabStop = False
    ColCount = 8
    DefaultRowHeight = 16
    FixedColor = clMedGray
    RowCount = 28
    Font.Charset = GREEK_CHARSET
    Font.Color = clActiveCaption
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = stat_resultsDrawCell
    OnMouseDown = stat_resultsMouseDown
    ColWidths = (
      31
      243
      118
      120
      118
      125
      131
      134)
  end
  object DateTimePicker2: TDateTimePicker
    Left = 55
    Top = 40
    Width = 136
    Height = 21
    Date = 0.499304641220078300
    Format = 'dd-MM-yyyy'
    Time = 0.499304641220078300
    ShowCheckbox = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object DateTimePicker1: TDateTimePicker
    Left = 55
    Top = 8
    Width = 136
    Height = 21
    Date = 0.499304641220078300
    Format = 'dd-MM-yyyy'
    Time = 0.499304641220078300
    ShowCheckbox = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 224
    Top = 8
    Width = 145
    Height = 73
    Caption = 'Go'
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 384
    Top = 8
    Width = 145
    Height = 73
    Caption = 'Save'
    TabOrder = 4
    Visible = False
    OnClick = BitBtn2Click
  end
end
