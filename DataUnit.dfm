object Data: TData
  OldCreateOrder = False
  Left = 463
  Top = 172
  Height = 634
  Width = 771
  object HoldSource: TDataSource
    DataSet = hold
    Left = 128
    Top = 168
  end
  object BasketSource: TDataSource
    DataSet = basket
    Left = 128
    Top = 16
  end
  object hold: TMyTable
    TableName = 'hold'
    OrderFields = 'aa'
    MasterFields = 'recno'
    DetailFields = 'recno'
    MasterSource = SecureBasketSource
    Connection = MyConnection1
    FetchAll = True
    Left = 40
    Top = 168
  end
  object Query1: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      '')
    FilterOptions = [foCaseInsensitive]
    Left = 40
    Top = 456
  end
  object moves: TMyTable
    TableName = 'moves'
    Connection = MyConnection1
    Filtered = True
    FilterOptions = [foCaseInsensitive]
    FetchAll = True
    Left = 224
    Top = 72
  end
  object users: TMyTable
    TableName = 'users'
    Connection = MyConnection1
    FetchAll = True
    Left = 224
    Top = 16
  end
  object UsersSource: TDataSource
    DataSet = users
    Left = 304
    Top = 16
  end
  object MyConnection1: TMyConnection
    Database = 'pleiades'
    Options.UseUnicode = True
    Options.LocalFailover = True
    Username = 'pleiades'
    Password = 'pleiades'
    Server = '192.168.1.68'
    OnConnectionLost = MyConnection1ConnectionLost
    ConnectDialog = MyConnectDialog1
    LoginPrompt = False
    Left = 40
    Top = 400
  end
  object basket: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'SELECT * FROM basket'
      'ORDER BY recno DESC'
      'LIMIT 0,50')
    FetchRows = 500
    BeforeScroll = basketBeforeScroll
    FetchAll = False
    Left = 40
    Top = 16
  end
  object MovesSource: TDataSource
    DataSet = moves
    Left = 304
    Top = 72
  end
  object marcdisplay: TMyTable
    TableName = 'marcdisplay'
    OrderFields = 'Name,Lang'
    Connection = MyConnection1
    FilterOptions = [foCaseInsensitive]
    AfterScroll = marcdisplayAfterScroll
    FetchAll = True
    IndexFieldNames = 'Name'
    Left = 224
    Top = 120
  end
  object marcdisplaySource: TDataSource
    DataSet = marcdisplay
    Left = 304
    Top = 120
  end
  object vocabulary: TMyTable
    TableName = 'vocabulary'
    Connection = MyConnection1
    FilterOptions = [foCaseInsensitive]
    FetchAll = True
    Left = 224
    Top = 168
  end
  object vocabularySource: TDataSource
    DataSet = vocabulary
    Left = 304
    Top = 168
  end
  object MSWord: TWordApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 424
    Top = 408
  end
  object Document: TWordDocument
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 488
    Top = 408
  end
  object OpenDialog1: TTntOpenDialog
    Left = 368
    Top = 408
  end
  object SaveDialog1: TTntSaveDialog
    Left = 296
    Top = 408
  end
  object MyDump1: TMyDump
    Connection = MyConnection1
    Left = 224
    Top = 456
  end
  object MyScript1: TMyScript
    Connection = MyConnection1
    Left = 304
    Top = 456
  end
  object Languages: TMyTable
    TableName = 'languages'
    MasterFields = 'Spcode'
    DetailFields = 'VocSpcode'
    MasterSource = vocabularySource
    Connection = MyConnection1
    FilterOptions = [foCaseInsensitive]
    FetchAll = True
    Left = 224
    Top = 224
  end
  object LanguagesSource: TDataSource
    DataSet = Languages
    Left = 304
    Top = 224
  end
  object Tools: TMyTable
    TableName = 'tools'
    Connection = MyConnection1
    FilterOptions = [foCaseInsensitive]
    FetchAll = True
    Left = 400
    Top = 16
  end
  object ToolsSource: TDataSource
    DataSet = Tools
    Left = 480
    Top = 16
  end
  object ItemsSource: TDataSource
    DataSet = Items
    Left = 128
    Top = 224
  end
  object Items: TMyTable
    TableName = 'items'
    MasterFields = 'holdon'
    DetailFields = 'holdon'
    MasterSource = HoldSource
    Connection = MyConnection1
    FetchAll = True
    Left = 40
    Top = 224
  end
  object HoldQuery: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'select * from hold'
      'where recno = :recno'
      'ORDER BY aa;')
    Left = 40
    Top = 288
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'recno'
      end>
  end
  object ItemsQuery: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'select * from items'
      'where holdon = :holdon')
    Left = 128
    Top = 288
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'holdon'
      end>
  end
  object SecureBasket: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'select * from basket'
      'where recno = :recno')
    FetchRows = 1
    Left = 40
    Top = 72
    ParamData = <
      item
        DataType = ftString
        Name = 'recno'
        Value = ''
      end>
  end
  object SecureBasketSource: TDataSource
    DataSet = SecureBasket
    Left = 128
    Top = 72
  end
  object MyCommand1: TMyCommand
    Connection = MyConnection1
    Left = 128
    Top = 456
  end
  object MyConnectDialog1: TMyConnectDialog
    ShowPort = False
    DatabaseLabel = 'Database'
    PortLabel = 'Port'
    Caption = 'Connect'
    UsernameLabel = 'User Name'
    PasswordLabel = 'Password'
    ServerLabel = 'Server'
    ConnectButton = 'Connect'
    CancelButton = 'Cancel'
    Left = 128
    Top = 400
  end
  object InsertSecureBasket: TMyCommand
    Connection = MyConnection1
    SQL.Strings = (
      'INSERT INTO basket'
      '  (format, level, creator, created )'
      'VALUES'
      '  (:format, :level, :creator, :created)')
    Left = 40
    Top = 120
    ParamData = <
      item
        DataType = ftString
        Name = 'format'
        Value = ''
      end
      item
        DataType = ftString
        Name = 'level'
        Value = ''
      end
      item
        DataType = ftString
        Name = 'creator'
        Value = ''
      end
      item
        DataType = ftString
        Name = 'created'
        Value = ''
      end>
  end
  object loancatSource: TDataSource
    DataSet = loancat
    Left = 480
    Top = 72
  end
  object branch: TMyTable
    TableName = 'branch'
    OrderFields = 'code'
    Connection = MyConnection1
    FetchAll = True
    Left = 400
    Top = 120
  end
  object branchsource: TDataSource
    DataSet = branch
    Left = 480
    Top = 120
  end
  object collection: TMyTable
    TableName = 'collection'
    OrderFields = 'branchcode,code'
    Connection = MyConnection1
    FetchAll = True
    Left = 400
    Top = 168
  end
  object collectionsource: TDataSource
    DataSet = collection
    Left = 480
    Top = 168
  end
  object PrintDialog1: TPrintDialog
    Left = 224
    Top = 408
  end
  object Query2: TMyQuery
    Connection = MyConnection1
    Left = 400
    Top = 456
  end
  object DataSource1: TDataSource
    DataSet = Query2
    Left = 488
    Top = 456
  end
  object LastDataFromBasket: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'SELECT * FROM basket'
      'WHERE recno = :recno')
    Left = 128
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'recno'
      end>
  end
  object CollectionQuery: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'SELECT * FROM collection'
      'WHERE branchcode = :branchcode')
    Left = 400
    Top = 224
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'branchcode'
      end>
  end
  object digital: TMyTable
    TableName = 'digital'
    MasterFields = 'recno'
    DetailFields = 'recno'
    MasterSource = SecureBasketSource
    Connection = MyConnection1
    FetchAll = True
    Left = 400
    Top = 288
  end
  object digitalSource: TDataSource
    DataSet = digital
    Left = 480
    Top = 288
  end
  object patroncat: TMyTable
    TableName = 'patroncat'
    Connection = MyConnection1
    FetchAll = True
    Left = 224
    Top = 288
  end
  object patroncatSource: TDataSource
    DataSet = patroncat
    Left = 304
    Top = 288
  end
  object processstatus: TMyTable
    TableName = 'processstatus'
    OrderFields = 'code'
    Connection = MyConnection1
    FetchAll = True
    Left = 224
    Top = 344
  end
  object processstatusSource: TDataSource
    DataSet = processstatus
    Left = 304
    Top = 344
  end
  object loancat: TMyTable
    TableName = 'loancat'
    OrderFields = 'description'
    Connection = MyConnection1
    Filtered = True
    Filter = 'patroncatid=0'
    FetchAll = True
    Left = 400
    Top = 72
  end
  object loancategory: TMyTable
    TableName = 'loancategory'
    OrderFields = 'code'
    Connection = MyConnection1
    FetchAll = True
    IndexFieldNames = 'code'
    Left = 40
    Top = 344
  end
  object loancategorysource: TDataSource
    DataSet = loancategory
    Left = 128
    Top = 344
  end
  object AuthSource: TDataSource
    DataSet = Auth
    Left = 128
    Top = 536
  end
  object Auth: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'select * from auth'
      'where recno = :recno')
    FetchRows = 1
    Left = 40
    Top = 536
    ParamData = <
      item
        DataType = ftString
        Name = 'recno'
        Value = ''
      end>
  end
  object LastDataFromAuth: TMyQuery
    Connection = MyConnection1
    SQL.Strings = (
      'SELECT * FROM auth'
      'WHERE recno = :recno')
    Left = 216
    Top = 544
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'recno'
      end>
  end
end
