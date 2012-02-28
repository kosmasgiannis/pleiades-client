program pleiades;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {FastRecordCreator},
  DataUnit in 'DataUnit.pas' {Data: TDataModule},
  mycharconversion in 'mycharconversion.pas',
  common in 'common.pas',
  SplashScrUnit in 'SplashScrUnit.pas' {SplashScrForm},
  NewBibliographicUnit in 'NewBibliographicUnit.pas' {NewBibliographicForm},
  MARCEditor in 'MARCEditor.pas' {MARCEditorform},
  form008 in 'form008.pas' {eight},
  form008auth in 'form008auth.pas' {eightauth},
  ldr in 'ldr.pas' {LeaderForm},
  HoldingsUnit in 'HoldingsUnit.pas' {Holdings},
  ImportUnit in 'ImportUnit.pas' {ImportForm},
  ExportUnit in 'ExportUnit.pas' {ExportForm},
  seldatabase in 'seldatabase.pas' {seldatabaseform},
  NewRecnoUnit in 'NewRecnoUnit.pas' {NewRecnoForm},
  transferholdings in 'transferholdings.pas' {xferholdings},
  CreateListUnit in 'CreateListUnit.pas' {CreateListForm},
  WideIniClass in 'WideIniClass.pas',
  ReportsUnit in 'ReportsUnit.pas' {ReportsForm},
  ClassCodeFormUnit in 'ClassCodeFormUnit.pas' {ClassCodeForm},
  zlookup in 'zlookup.pas' {zlookupform},
  zlocate in 'zlocate.pas' {zlocateform},
  zauthlocate in 'zauthlocate.pas' {zauthlocateform},
  zauthlookup in 'zauthlookup.pas' {zauthlookupform},
  zoomit in 'zoomit.pas',
  zoom in 'zoom.pas',
  EditMarcUnit in 'EditMarcUnit.pas' {EditMarcForm},
  DefClnSettingsUnit in 'DefClnSettingsUnit.pas' {DefClnSettingsForm},
  ZTargetsSettingsUnit in 'ZTargetsSettingsUnit.pas' {ZTargetsSettingsForm},
  ProgresBarUnit in 'ProgresBarUnit.pas' {ProgresBarForm},
  SettingsZebraUnit in 'SettingsZebraUnit.pas' {SettingsZebraForm},
  OrganisationCodeUnit in 'OrganisationCodeUnit.pas' {OrganisationCodeForm},
  PrettyMARCUnit in 'PrettyMARCUnit.pas' {PrettyMARCForm},
  utility in 'utility.pas',
  NewGroupUnit in 'NewGroupUnit.pas' {NewGroupForm},
  NewMarcUnit in 'NewMarcUnit.pas' {NewMarcForm},
  ChoosePrintGroupUnit in 'ChoosePrintGroupUnit.pas' {ChoosePrintGroupForm},
  MARCDisplayUnit in 'MARCDisplayUnit.pas' {MARCDisplayForm},
  GlobalProcedures in 'GlobalProcedures.pas',
  ItemsUnit in 'ItemsUnit.pas' {ItemsForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  SetlangUnit in 'SetlangUnit.pas' {SetlangForm},
  ToolsUnit in 'ToolsUnit.pas' {ToolsForm},
  VocabUnit in 'VocabUnit.pas' {VocabForm},
  MovesUnit in 'MovesUnit.pas' {MovesForm},
  UserUnit in 'UserUnit.pas' {UserForm},
  NewUserUnit in 'NewUserUnit.pas' {NewUserForm},
  SetPasswordUnit in 'SetPasswordUnit.pas' {SetPasswordForm},
  UserSettingsUnit in 'UserSettingsUnit.pas' {UserSettingsForm},
  UpdateSettingsUnit in 'UpdateSettingsUnit.pas' {UpdateSettingsForm: TTntForm},
  ShowHoldMemoUnit in 'ShowHoldMemoUnit.pas' {ShowHoldMemoForm},
  LoginUnit in 'LoginUnit.pas' {LoginForm: TTntForm},
  ShowTextHoldingUnit in 'ShowTextHoldingUnit.pas' {ShowTextHoldingForm},
  BranchUnit in 'BranchUnit.pas' {BranchForm: TTntForm},
  NewBranchUnit in 'NewBranchUnit.pas' {NewBranchForm: TTntForm},
  ChangePasUnit in 'ChangePasUnit.pas' {ChangePasForm: TTntForm},
  CollectionUnit in 'CollectionUnit.pas' {CollectionForm: TTntForm},
  NewCollectionUnit in 'NewCollectionUnit.pas' {NewCollectionForm: TTntForm},
  TransferOneHoldUnit in 'TransferOneHoldUnit.pas' {TransferOneHoldForm},
  TransferItemUnit in 'TransferItemUnit.pas' {TransferItemForm},
  DigitalUnit in 'DigitalUnit.pas' {DigitalForm: TTntForm},
  LoancatUnit in 'LoancatUnit.pas' {LoancatForm},
  ProcessStatusUnit in 'ProcessStatusUnit.pas' {ProcessStatusForm: TTntForm},
  NewProcessStatusUnit in 'NewProcessStatusUnit.pas' {NewProcessStatusForm: TTntForm},
  NewLoanCategoryUnit in 'NewLoanCategoryUnit.pas' {NewLoanCategoryForm: TTntForm},
  LoanCategoryUnit in 'LoanCategoryUnit.pas' {LoanCategoryForm: TTntForm},
  ConfigurationUnit in 'ConfigurationUnit.pas' {ConfigurationForm: TTntForm},
  DigitalSettings in 'DigitalSettings.pas' {DigitalSettingsForm: TTntForm},
  EditDigitalObject in 'EditDigitalObject.pas' {EditDigital: TTntForm},
  cUnicodeCodecs in 'cUnicodeCodecs.pas',
  MARCAuthEditor in 'MARCAuthEditor.pas' {MARCAuthEditorform: TTntForm},
  md5 in 'MD5.pas',
  statistics in 'statistics.pas' {statisticsForm},
  HoldingsRangeUnit in 'HoldingsRangeUnit.pas' {HoldingsRange: TTntForm},
  ReplaceMARCrecs in 'ReplaceMARCrecs.pas' {ReplaceMARCrecords};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Pleiades';
  Application.CreateForm(TFastRecordCreator, FastRecordCreator);
  Application.CreateForm(TSplashScrForm, SplashScrForm);
  Application.CreateForm(TData, Data);
  Application.CreateForm(TNewBibliographicForm, NewBibliographicForm);
  Application.CreateForm(TMARCEditorform, MARCEditorform);
  Application.CreateForm(Teight, eight);
  Application.CreateForm(Teightauth, eightauth);
  Application.CreateForm(TLeaderForm, LeaderForm);
  Application.CreateForm(THoldings, Holdings);
  Application.CreateForm(TImportForm, ImportForm);
  Application.CreateForm(TExportForm, ExportForm);
  Application.CreateForm(Tseldatabaseform, seldatabaseform);
  Application.CreateForm(TNewRecnoForm, NewRecnoForm);
  Application.CreateForm(Txferholdings, xferholdings);
  Application.CreateForm(TEditMarcForm, EditMarcForm);
  Application.CreateForm(TCreateListForm, CreateListForm);
  Application.CreateForm(TReportsForm, ReportsForm);
  Application.CreateForm(TClassCodeForm, ClassCodeForm);
  Application.CreateForm(Tzlookupform, zlookupform);
  Application.CreateForm(Tzlocateform, zlocateform);
  Application.CreateForm(Tzauthlocateform, zauthlocateform);
  Application.CreateForm(Tzauthlookupform, zauthlookupform);
  Application.CreateForm(TEditMarcForm, EditMarcForm);
  Application.CreateForm(TDefClnSettingsForm, DefClnSettingsForm);
  Application.CreateForm(TZTargetsSettingsForm, ZTargetsSettingsForm);
  Application.CreateForm(TProgresBarForm, ProgresBarForm);
  Application.CreateForm(TSettingsZebraForm, SettingsZebraForm);
  Application.CreateForm(TOrganisationCodeForm, OrganisationCodeForm);
  Application.CreateForm(TPrettyMARCForm, PrettyMARCForm);
  Application.CreateForm(TNewGroupForm, NewGroupForm);
  Application.CreateForm(TNewMarcForm, NewMarcForm);
  Application.CreateForm(TChoosePrintGroupForm, ChoosePrintGroupForm);
  Application.CreateForm(TMARCDisplayForm, MARCDisplayForm);
  Application.CreateForm(TItemsForm, ItemsForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TSetlangForm, SetlangForm);
  Application.CreateForm(TToolsForm, ToolsForm);
  Application.CreateForm(TVocabForm, VocabForm);
  Application.CreateForm(TMovesForm, MovesForm);
  Application.CreateForm(TUserForm, UserForm);
  Application.CreateForm(TNewUserForm, NewUserForm);
  Application.CreateForm(TSetPasswordForm, SetPasswordForm);
  Application.CreateForm(TUserSettingsForm, UserSettingsForm);
  Application.CreateForm(TUpdateSettingsForm, UpdateSettingsForm);
  Application.CreateForm(TShowHoldMemoForm, ShowHoldMemoForm);
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TShowTextHoldingForm, ShowTextHoldingForm);
  Application.CreateForm(TBranchForm, BranchForm);
  Application.CreateForm(TNewBranchForm, NewBranchForm);
  Application.CreateForm(TChangePasForm, ChangePasForm);
  Application.CreateForm(TCollectionForm, CollectionForm);
  Application.CreateForm(TNewCollectionForm, NewCollectionForm);
  Application.CreateForm(TTransferOneHoldForm, TransferOneHoldForm);
  Application.CreateForm(TTransferItemForm, TransferItemForm);
  Application.CreateForm(TDigitalForm, DigitalForm);
  Application.CreateForm(TLoancatForm, LoancatForm);
  Application.CreateForm(TProcessStatusForm, ProcessStatusForm);
  Application.CreateForm(TNewProcessStatusForm, NewProcessStatusForm);
  Application.CreateForm(TNewLoanCategoryForm, NewLoanCategoryForm);
  Application.CreateForm(TLoanCategoryForm, LoanCategoryForm);
  Application.CreateForm(TConfigurationForm, ConfigurationForm);
  Application.CreateForm(TDigitalSettingsForm, DigitalSettingsForm);
  Application.CreateForm(TEditDigital, EditDigital);
  Application.CreateForm(TMARCAuthEditorform, MARCAuthEditorform);
  Application.CreateForm(TstatisticsForm, statisticsForm);
  Application.CreateForm(THoldingsRange, HoldingsRange);
  Application.CreateForm(TReplaceMARCrecords, ReplaceMARCrecords);
  Application.Run;
end.
