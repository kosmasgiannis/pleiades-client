object eight: Teight
  Left = 198
  Top = 128
  Width = 703
  Height = 296
  Caption = '008 editing...'
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
    Left = 5
    Top = 57
    Width = 93
    Height = 13
    Caption = 'Date entered on file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 111
    Top = 57
    Width = 60
    Height = 13
    Caption = 'Type of date'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 186
    Top = 57
    Width = 32
    Height = 13
    Caption = 'Date 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 245
    Top = 57
    Width = 32
    Height = 13
    Caption = 'Date 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 304
    Top = 57
    Width = 94
    Height = 13
    Caption = 'Place of Publication'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 419
    Top = 57
    Width = 48
    Height = 13
    Caption = 'Language'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 486
    Top = 57
    Width = 78
    Height = 13
    Caption = 'Modified Record'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 577
    Top = 57
    Width = 93
    Height = 13
    Caption = 'Cataloguing Source'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TMaskEdit
    Left = 16
    Top = 16
    Width = 465
    Height = 22
    TabStop = False
    Font.Charset = GREEK_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    MaxLength = 40
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 504
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object MaskEdit1: TMaskEdit
    Left = 5
    Top = 76
    Width = 49
    Height = 21
    EditMask = '999999;1; '
    MaxLength = 6
    TabOrder = 3
    Text = '      '
  end
  object MaskEdit2: TMaskEdit
    Left = 111
    Top = 76
    Width = 45
    Height = 21
    EditMask = '<c;1; '
    MaxLength = 1
    TabOrder = 4
    Text = ' '
  end
  object MaskEdit3: TMaskEdit
    Left = 186
    Top = 76
    Width = 47
    Height = 21
    EditMask = '<cccc;1; '
    MaxLength = 4
    TabOrder = 5
    Text = '    '
  end
  object MaskEdit4: TMaskEdit
    Left = 245
    Top = 76
    Width = 47
    Height = 21
    EditMask = '<cccc;1; '
    MaxLength = 4
    TabOrder = 6
    Text = '    '
  end
  object Button2: TButton
    Left = 592
    Top = 16
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object MaskEdit5: TMaskEdit
    Left = 303
    Top = 76
    Width = 47
    Height = 21
    EditMask = '<ccc;1; '
    MaxLength = 3
    TabOrder = 7
    Text = '   '
  end
  object MaskEdit6: TMaskEdit
    Left = 419
    Top = 76
    Width = 46
    Height = 21
    EditMask = '<ccc;1; '
    MaxLength = 3
    TabOrder = 8
    Text = '   '
  end
  object MaskEdit7: TMaskEdit
    Left = 486
    Top = 76
    Width = 45
    Height = 21
    EditMask = '<c;1; '
    MaxLength = 1
    TabOrder = 9
    Text = ' '
  end
  object MaskEdit8: TMaskEdit
    Left = 577
    Top = 76
    Width = 45
    Height = 21
    EditMask = '<c;1; '
    MaxLength = 1
    TabOrder = 10
    Text = ' '
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 112
    Width = 689
    Height = 145
    ActivePage = TabSheet5
    TabOrder = 11
    object TabSheet1: TTabSheet
      Caption = 'Book'
      object Label10: TLabel
        Left = 98
        Top = 15
        Width = 79
        Height = 13
        Caption = 'Target Audience'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 206
        Top = 15
        Width = 58
        Height = 13
        Caption = 'Form of Item'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 291
        Top = 15
        Width = 89
        Height = 13
        Caption = 'Nature of Contents'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 399
        Top = 15
        Width = 113
        Height = 13
        Caption = 'Government Publication'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 532
        Top = 15
        Width = 110
        Height = 13
        Caption = 'Conference Publication'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 8
        Top = 15
        Width = 52
        Height = 13
        Caption = 'Illustrations'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 8
        Top = 73
        Width = 48
        Height = 13
        Caption = 'Festschrift'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 68
        Top = 73
        Width = 26
        Height = 13
        Caption = 'Index'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 131
        Top = 73
        Width = 49
        Height = 13
        Caption = 'Undefined'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 200
        Top = 73
        Width = 60
        Height = 13
        Caption = 'Literary Form'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 293
        Top = 73
        Width = 47
        Height = 13
        Caption = 'Biography'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object MaskEdit9: TMaskEdit
        Left = 6
        Top = 35
        Width = 45
        Height = 21
        EditMask = '<cccc;1; '
        MaxLength = 4
        TabOrder = 0
        Text = '    '
      end
      object MaskEdit10: TMaskEdit
        Left = 98
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 1
        Text = ' '
      end
      object MaskEdit11: TMaskEdit
        Left = 206
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 2
        Text = ' '
      end
      object MaskEdit12: TMaskEdit
        Left = 290
        Top = 35
        Width = 45
        Height = 21
        EditMask = '<cccc;1; '
        MaxLength = 4
        TabOrder = 3
        Text = '    '
      end
      object MaskEdit13: TMaskEdit
        Left = 398
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 4
        Text = ' '
      end
      object MaskEdit14: TMaskEdit
        Left = 531
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 5
        Text = ' '
      end
      object MaskEdit19: TMaskEdit
        Left = 292
        Top = 92
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 10
        Text = ' '
      end
      object MaskEdit15: TMaskEdit
        Left = 8
        Top = 92
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 6
        Text = ' '
      end
      object MaskEdit16: TMaskEdit
        Left = 71
        Top = 92
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 7
        Text = ' '
      end
      object MaskEdit17: TMaskEdit
        Left = 132
        Top = 92
        Width = 43
        Height = 21
        TabStop = False
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 8
        Text = ' '
      end
      object MaskEdit18: TMaskEdit
        Left = 199
        Top = 92
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 9
        Text = ' '
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Serial'
      ImageIndex = 1
      object Label20: TLabel
        Left = 8
        Top = 15
        Width = 50
        Height = 13
        Caption = 'Frequency'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label21: TLabel
        Left = 583
        Top = 15
        Width = 57
        Height = 13
        Caption = 'Form of item'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 471
        Top = 15
        Width = 93
        Height = 13
        Caption = 'Form of original item'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label23: TLabel
        Left = 311
        Top = 15
        Width = 110
        Height = 13
        Caption = 'Type of Cont Resource'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label24: TLabel
        Left = 220
        Top = 15
        Width = 58
        Height = 13
        Caption = 'ISSN center'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label25: TLabel
        Left = 119
        Top = 15
        Width = 47
        Height = 13
        Caption = 'Regularity'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label26: TLabel
        Left = 8
        Top = 73
        Width = 99
        Height = 13
        Caption = 'Nature of entire work'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label27: TLabel
        Left = 119
        Top = 73
        Width = 83
        Height = 13
        Caption = 'Nature of content'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label28: TLabel
        Left = 220
        Top = 73
        Width = 81
        Height = 13
        Caption = 'Government publ'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label29: TLabel
        Left = 311
        Top = 73
        Width = 78
        Height = 13
        Caption = 'Conference publ'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label30: TLabel
        Left = 405
        Top = 73
        Width = 49
        Height = 13
        Caption = 'Undefined'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label31: TLabel
        Left = 471
        Top = 73
        Width = 79
        Height = 13
        Caption = 'Original alphabet'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label32: TLabel
        Left = 583
        Top = 73
        Width = 80
        Height = 13
        Caption = 'Entry convention'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object MaskEdit20: TMaskEdit
        Left = 8
        Top = 35
        Width = 33
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 0
        Text = ' '
      end
      object MaskEdit21: TMaskEdit
        Left = 119
        Top = 35
        Width = 34
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 1
        Text = ' '
      end
      object MaskEdit22: TMaskEdit
        Left = 220
        Top = 35
        Width = 31
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 2
        Text = ' '
      end
      object MaskEdit23: TMaskEdit
        Left = 311
        Top = 35
        Width = 36
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 3
        Text = ' '
      end
      object MaskEdit24: TMaskEdit
        Left = 471
        Top = 35
        Width = 37
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 4
        Text = ' '
      end
      object MaskEdit25: TMaskEdit
        Left = 583
        Top = 35
        Width = 38
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 5
        Text = ' '
      end
      object MaskEdit26: TMaskEdit
        Left = 8
        Top = 92
        Width = 39
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 6
        Text = ' '
      end
      object MaskEdit27: TMaskEdit
        Left = 119
        Top = 92
        Width = 38
        Height = 21
        EditMask = '<ccc;1; '
        MaxLength = 3
        TabOrder = 7
        Text = '   '
      end
      object MaskEdit28: TMaskEdit
        Left = 220
        Top = 92
        Width = 41
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 8
        Text = ' '
      end
      object MaskEdit29: TMaskEdit
        Left = 311
        Top = 92
        Width = 42
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 9
        Text = ' '
      end
      object MaskEdit30: TMaskEdit
        Left = 404
        Top = 92
        Width = 41
        Height = 21
        TabStop = False
        EditMask = '<ccc;1; '
        MaxLength = 3
        TabOrder = 10
        Text = '   '
      end
      object MaskEdit31: TMaskEdit
        Left = 471
        Top = 92
        Width = 42
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 11
        Text = ' '
      end
      object MaskEdit32: TMaskEdit
        Left = 583
        Top = 92
        Width = 42
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 12
        Text = ' '
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Visual'
      ImageIndex = 2
      object Label33: TLabel
        Left = 8
        Top = 15
        Width = 66
        Height = 13
        Caption = 'Running Time'
      end
      object Label34: TLabel
        Left = 98
        Top = 15
        Width = 79
        Height = 13
        Caption = 'Target Audience'
      end
      object Label35: TLabel
        Left = 199
        Top = 15
        Width = 113
        Height = 13
        Caption = 'Government Publication'
      end
      object Label36: TLabel
        Left = 334
        Top = 15
        Width = 58
        Height = 13
        Caption = 'Form of Item'
      end
      object Label37: TLabel
        Left = 415
        Top = 15
        Width = 107
        Height = 13
        Caption = 'Type of Visual Material'
      end
      object Label38: TLabel
        Left = 535
        Top = 15
        Width = 51
        Height = 13
        Caption = 'Technique'
      end
      object MaskEdit33: TMaskEdit
        Left = 6
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<ccc;1; '
        MaxLength = 3
        TabOrder = 0
        Text = '   '
      end
      object MaskEdit34: TMaskEdit
        Left = 98
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 1
        Text = ' '
      end
      object MaskEdit35: TMaskEdit
        Left = 198
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 2
        Text = ' '
      end
      object MaskEdit36: TMaskEdit
        Left = 334
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 3
        Text = ' '
      end
      object MaskEdit37: TMaskEdit
        Left = 415
        Top = 35
        Width = 36
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 4
        Text = ' '
      end
      object MaskEdit38: TMaskEdit
        Left = 535
        Top = 35
        Width = 36
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 5
        Text = ' '
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Music'
      ImageIndex = 3
      object Label39: TLabel
        Left = 6
        Top = 15
        Width = 95
        Height = 13
        Caption = 'Form of Composition'
      end
      object Label40: TLabel
        Left = 134
        Top = 15
        Width = 75
        Height = 13
        Caption = 'Format of Music'
      end
      object Label41: TLabel
        Left = 230
        Top = 15
        Width = 55
        Height = 13
        Caption = 'Music Parts'
      end
      object Label42: TLabel
        Left = 334
        Top = 15
        Width = 78
        Height = 13
        Caption = 'Target audience'
      end
      object Label43: TLabel
        Left = 462
        Top = 15
        Width = 57
        Height = 13
        Caption = 'Form of item'
      end
      object Label44: TLabel
        Left = 566
        Top = 15
        Width = 102
        Height = 13
        Caption = 'Accompanying matter'
      end
      object Label45: TLabel
        Left = 6
        Top = 63
        Width = 153
        Height = 13
        Caption = 'Literary text for sound recordings'
      end
      object Label46: TLabel
        Left = 230
        Top = 63
        Width = 146
        Height = 13
        Caption = 'Transposition and arrangement'
      end
      object MaskEdit39: TMaskEdit
        Left = 6
        Top = 35
        Width = 39
        Height = 21
        EditMask = '<cc;1; '
        MaxLength = 2
        TabOrder = 0
        Text = '  '
      end
      object MaskEdit40: TMaskEdit
        Left = 134
        Top = 35
        Width = 37
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 1
        Text = ' '
      end
      object MaskEdit41: TMaskEdit
        Left = 230
        Top = 35
        Width = 37
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 2
        Text = ' '
      end
      object MaskEdit42: TMaskEdit
        Left = 334
        Top = 35
        Width = 37
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 3
        Text = ' '
      end
      object MaskEdit43: TMaskEdit
        Left = 462
        Top = 35
        Width = 37
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 4
        Text = ' '
      end
      object MaskEdit44: TMaskEdit
        Left = 566
        Top = 35
        Width = 51
        Height = 21
        EditMask = '<cccccc;1; '
        MaxLength = 6
        TabOrder = 5
        Text = '      '
      end
      object MaskEdit45: TMaskEdit
        Left = 6
        Top = 83
        Width = 49
        Height = 21
        EditMask = '<cc;1; '
        MaxLength = 2
        TabOrder = 6
        Text = '  '
      end
      object MaskEdit46: TMaskEdit
        Left = 230
        Top = 83
        Width = 37
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 7
        Text = ' '
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Map'
      ImageIndex = 4
      object Label47: TLabel
        Left = 598
        Top = 15
        Width = 57
        Height = 13
        Caption = 'Form of item'
      end
      object Label48: TLabel
        Left = 246
        Top = 15
        Width = 137
        Height = 13
        Caption = 'Type of cartographic material'
      end
      object Label49: TLabel
        Left = 6
        Top = 15
        Width = 27
        Height = 13
        Caption = 'Relief'
      end
      object Label50: TLabel
        Left = 86
        Top = 15
        Width = 47
        Height = 13
        Caption = 'Projection'
      end
      object Label51: TLabel
        Left = 166
        Top = 15
        Width = 49
        Height = 13
        Caption = 'Undefined'
      end
      object Label52: TLabel
        Left = 86
        Top = 71
        Width = 26
        Height = 13
        Caption = 'Index'
      end
      object Label54: TLabel
        Left = 246
        Top = 71
        Width = 142
        Height = 13
        Caption = 'Special Format Characteristics'
      end
      object Label55: TLabel
        Left = 398
        Top = 15
        Width = 49
        Height = 13
        Caption = 'Undefined'
      end
      object Label56: TLabel
        Left = 463
        Top = 15
        Width = 113
        Height = 13
        Caption = 'Government Publication'
      end
      object Label53: TLabel
        Left = 6
        Top = 71
        Width = 49
        Height = 13
        Caption = 'Undefined'
      end
      object Label57: TLabel
        Left = 166
        Top = 71
        Width = 49
        Height = 13
        Caption = 'Undefined'
      end
      object MaskEdit47: TMaskEdit
        Left = 598
        Top = 35
        Width = 37
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 0
        Text = ' '
      end
      object MaskEdit48: TMaskEdit
        Left = 246
        Top = 35
        Width = 31
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 1
        Text = ' '
      end
      object MaskEdit49: TMaskEdit
        Left = 166
        Top = 35
        Width = 32
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 2
        Text = ' '
      end
      object MaskEdit50: TMaskEdit
        Left = 86
        Top = 35
        Width = 31
        Height = 21
        EditMask = '<cc;1; '
        MaxLength = 2
        TabOrder = 3
        Text = '  '
      end
      object MaskEdit51: TMaskEdit
        Left = 6
        Top = 35
        Width = 34
        Height = 21
        EditMask = '<cccc;1; '
        MaxLength = 4
        TabOrder = 4
        Text = '    '
      end
      object MaskEdit52: TMaskEdit
        Left = 86
        Top = 91
        Width = 33
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 5
        Text = ' '
      end
      object MaskEdit54: TMaskEdit
        Left = 246
        Top = 91
        Width = 49
        Height = 21
        EditMask = '<ccc;1; '
        MaxLength = 3
        TabOrder = 6
        Text = '   '
      end
      object MaskEdit55: TMaskEdit
        Left = 398
        Top = 35
        Width = 30
        Height = 21
        EditMask = '<cc;1; '
        MaxLength = 2
        TabOrder = 7
        Text = '  '
      end
      object MaskEdit56: TMaskEdit
        Left = 462
        Top = 35
        Width = 43
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 8
        Text = ' '
      end
      object MaskEdit53: TMaskEdit
        Left = 6
        Top = 91
        Width = 32
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 9
        Text = ' '
      end
      object MaskEdit57: TMaskEdit
        Left = 166
        Top = 88
        Width = 32
        Height = 21
        EditMask = '<c;1; '
        MaxLength = 1
        TabOrder = 10
        Text = ' '
      end
    end
  end
  object Edit2: TEdit
    Left = 208
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 12
    Visible = False
  end
end
