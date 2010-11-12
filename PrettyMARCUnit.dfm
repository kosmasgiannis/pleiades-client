object PrettyMARCForm: TPrettyMARCForm
  Left = 182
  Top = 171
  BorderStyle = bsDialog
  Caption = 'Pretty MARC Form'
  ClientHeight = 448
  ClientWidth = 1016
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object go: TTntButton
    Left = 592
    Top = 408
    Width = 187
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = goClick
  end
  object BitBtn1: TTntBitBtn
    Left = 816
    Top = 408
    Width = 187
    Height = 25
    Cancel = True
    Caption = 'Exit'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TTntGroupBox
    Left = 8
    Top = 8
    Width = 1001
    Height = 377
    Caption = 'Configuration '
    TabOrder = 2
    object Label5: TTntLabel
      Left = 8
      Top = 348
      Width = 94
      Height = 14
      Caption = 'Max Length per line'
    end
    object Label6: TTntLabel
      Left = 8
      Top = 320
      Width = 48
      Height = 14
      Caption = 'Separator'
    end
    object Label1: TTntLabel
      Left = 8
      Top = 288
      Width = 53
      Height = 14
      Caption = 'Label'#39's File'
    end
    object maxlen: TTntEdit
      Left = 112
      Top = 344
      Width = 33
      Height = 22
      TabOrder = 0
      Text = '75'
      OnKeyPress = maxlenKeyPress
    end
    object separator: TTntEdit
      Left = 64
      Top = 316
      Width = 369
      Height = 22
      TabOrder = 1
    end
    object StringGrid1: TTntStringGrid
      Left = 8
      Top = 16
      Width = 425
      Height = 225
      ColCount = 8
      DefaultColWidth = 50
      DefaultRowHeight = 17
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 2
      OnDrawCell = StringGrid1DrawCell
    end
    object Edit3: TTntEdit
      Left = 64
      Top = 284
      Width = 369
      Height = 22
      TabOrder = 3
    end
    object BitBtn2: TTntBitBtn
      Left = 184
      Top = 248
      Width = 73
      Height = 25
      Caption = 'Load'
      TabOrder = 4
      OnClick = BitBtn2Click
    end
    object BitBtn3: TTntBitBtn
      Left = 272
      Top = 248
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 5
      OnClick = BitBtn3Click
    end
    object TntMemo1: TTntMemo
      Left = 448
      Top = 16
      Width = 545
      Height = 353
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 6
    end
    object BitBtn4: TTntBitBtn
      Left = 360
      Top = 248
      Width = 75
      Height = 25
      Caption = 'Preview'
      TabOrder = 7
      OnClick = BitBtn4Click
    end
    object CheckBox1: TTntCheckBox
      Left = 208
      Top = 346
      Width = 97
      Height = 17
      Caption = 'Record Counter'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object CheckBox2: TTntCheckBox
      Left = 383
      Top = 18
      Width = 17
      Height = 17
      TabOrder = 9
    end
  end
end
