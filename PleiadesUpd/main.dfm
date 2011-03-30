object Form1: TForm1
  Left = 192
  Top = 107
  Width = 482
  Height = 137
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'PleiadesUpd'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 56
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 32
    Top = 8
    Width = 69
    Height = 13
    Caption = 'Please Wait'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 144
    Top = 16
    Width = 169
    Height = 57
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    Visible = False
    WordWrap = False
  end
  object Button1: TButton
    Left = 352
    Top = 80
    Width = 99
    Height = 25
    Caption = 'Next  >'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 32
    Top = 32
    Width = 417
    Height = 16
    TabOrder = 2
  end
end
