object NewRecnoForm: TNewRecnoForm
  Left = 548
  Top = 148
  BorderStyle = bsDialog
  Caption = 'Enter new starting recno'
  ClientHeight = 162
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TTntLabel
    Left = 17
    Top = 17
    Width = 32
    Height = 14
    Caption = 'Label1'
  end
  object Edit1: TTntEdit
    Left = 17
    Top = 60
    Width = 260
    Height = 22
    TabOrder = 0
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object BitBtn1: TTntBitBtn
    Left = 95
    Top = 121
    Width = 81
    Height = 27
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object BitBtn2: TTntBitBtn
    Left = 198
    Top = 121
    Width = 81
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
