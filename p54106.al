OBJECT Page 54106 Contract Card
{
  OBJECT-PROPERTIES
  {
    Date=18.11.20;
    Time=12:16:43;
    Modified=Yes;
    Version List=PRO.36,PCTRU.18,pvrb,zzerET,pvrb01,7872,8456.Stefa,Profi Light,NAV-404;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[CSY=Karta smlouvy;
               ENU=Contract Card;
               RUS=Карточка контракта];
    SourceTable=Table54105;
    PageType=Card;
    OnOpenPage=BEGIN
                 // PCT RU 2014-12-05 ->
                 SETRANGE("Date Filter",WORKDATE);
                 // <- PCT RU
               END;

    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Post Contract Penalty","Post Penalty Interest","Post Debt Admission","Int. Rate Contract Penalty",
                                  "Int. Rate Penalty Interest","Int. Rate Debt Admission");
                       FinLoanSetup.GET;
                       CRMURL := FinLoanSetup."CRM URL" + "Contract GUID in CRM" + '%7d';

                       // PCT RU ZZER 2014-08-28 ->
                       IF "Date Filter" = 0D THEN
                         "Date Filter" := WORKDATE;
                       // <- PCT

                       //+2018.08.03
                       ContractCRMNAVG.SETRANGE("Contract No.", "Contract No.");
                       IF NOT ContractCRMNAVG.FINDLAST THEN
                         CLEAR(ContractCRMNAVG);
                       //-2018.08.03
                     END;

    ActionList=ACTIONS
    {
      { 1000000034;  ;ActionContainer;
                      Name=<Action1900000003>;
                      ActionContainerType=RelatedInformation }
      { 1101495008;1 ;Action    ;
                      Name=<Action1101495008>;
                      CaptionML=[ENU=Payment Schedule;
                                 RUS=График платежей];
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PaymentScheduleLoc@1101495000 : Record 50003;
                               BEGIN
                                 // switch to new schedule
                                 PaymentScheduleLoc.SETRANGE("Contract No.","Contract No.");
                                 PAGE.RUN(50010,PaymentScheduleLoc);
                               END;
                                }
      { 1101495009;1 ;Action    ;
                      Name=<Action1101495009>;
                      CaptionML=[ENU=Archive Payment Schedule;
                                 RUS=Архив. график платежей];
                      OnAction=VAR
                                 ArchivePaymentScheduleLoc@1101495000 : Record 50005;
                               BEGIN
                                 // switch to new schedule
                                 ArchivePaymentScheduleLoc.SETRANGE("Contract No.","Contract No.");
                                 PAGE.RUN(50011,ArchivePaymentScheduleLoc);
                               END;
                                }
      { 1000000059;1 ;Action    ;
                      CaptionML=[ENU=Daily Running Payables Schedule;
                                 RUS="Штрафы за просрочку платежей по графику "];
                      Promoted=No;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DailyRunningPayScheduleLoc@1101495000 : Record 54136;
                               BEGIN
                                 DailyRunningPayScheduleLoc.SETRANGE("Contract No.","Contract No.");
                                 PAGE.RUN(54146,DailyRunningPayScheduleLoc);
                               END;
                                }
      { 1101495013;1 ;ActionGroup;
                      Name=<Action1101495013>;
                      CaptionML=[ENU=Entry;
                                 RUS=Операции] }
      { 1101495010;2 ;Action    ;
                      Name=<Action1101495010>;
                      ShortCutKey=Ctrl+F5;
                      CaptionML=[ENU=Entry;
                                 RUS=Книга операций по клиентам];
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CustLedgerEntry@1101495000 : Record 21;
                               BEGIN
                                 CustLedgerEntry.SETRANGE("Contract No.","Contract No.");
                                 PAGE.RUN(25,CustLedgerEntry);
                               END;
                                }
      { 1101495011;2 ;Action    ;
                      CaptionML=[ENU=G/L Entry;
                                 RUS=Фин. операции];
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GLEntry@1101495000 : Record 17;
                               BEGIN
                                 GLEntry.SETRANGE("Contract No.","Contract No.");
                                 PAGE.RUN(20,GLEntry);
                               END;
                                }
      { 1101495012;2 ;Action    ;
                      Name=<Action1101495012>;
                      CaptionML=[ENU=Comission General Ledger Entries;
                                 RUS=Фин. операции комиссий];
                      RunObject=Page 20;
                      RunFormView=SORTING(Contract No.)
                                  WHERE(GLE Comission=CONST(Yes));
                      RunFormLink=Contract No.=FIELD(Contract No.) }
      { 1101495032;2 ;Action    ;
                      CaptionML=[ENU=Detailed Cust. Ledg. Entries;
                                 RUS=Подробные операции клиента];
                      OnAction=VAR
                                 DetailedCustLedgEntryLcl@1101495000 : Record 379;
                               BEGIN
                                 //AKAM 270718
                                 DetailedCustLedgEntryLcl.SETRANGE("Contract No.","Contract No.");
                                 PAGE.RUN(573,DetailedCustLedgEntryLcl);
                               END;
                                }
      { 1000000031;1 ;ActionGroup;
                      Name=<Action1000000028>;
                      CaptionML=[CSY=Zobrazit detaily;
                                 ENU=Show Details;
                                 RUS=Подробно] }
      { 1000000076;2 ;Action    ;
                      Name=<Action1000000076>;
                      CaptionML=[CSY=Obdobб гroЯenб;
                                 ENU=Interest Period;
                                 RUS=Проценты за период];
                      OnAction=VAR
                                 InterestPeriodLcl@1000000000 : Record 54125;
                               BEGIN
                                 InterestPeriodLcl.SETFILTER("Contract No.","Contract No.");
                                 PAGE.RUN(54128,InterestPeriodLcl);
                               END;
                                }
      { 1000000030;2 ;Action    ;
                      Name=<Action1000000029>;
                      CaptionML=[CSY=Zm╪ny na smlouv╪;
                                 ENU=Contract Changes;
                                 RUS=Контракт изменения];
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ContractChangesLcl@1000000001 : Record 54106;
                               BEGIN
                                 ContractChangesLcl.SETFILTER("Contract No.","Contract No.");
                                 PAGE.RUN(54107,ContractChangesLcl);
                               END;
                                }
      { 1101495014;1 ;ActionGroup;
                      CaptionML=[ENU=Integration;
                                 RUS=Интеграция] }
      { 1101495015;2 ;Action    ;
                      CaptionML=[ENU=Transfer Payment Schedule;
                                 RUS=Передача графика];
                      OnAction=VAR
                                 TransferPaySchedNAVCRMLoc@1101495000 : Record 54110;
                               BEGIN
                                 TransferPaySchedNAVCRMLoc.SETFILTER("Contract No.","Contract No.");
                                 PAGE.RUN(54112,TransferPaySchedNAVCRMLoc);
                               END;
                                }
      { 1101495016;2 ;Action    ;
                      CaptionML=[ENU=CRM Instruction;
                                 RUS=Инструкции CRM];
                      OnAction=VAR
                                 AccInstructionsCRMNAVLoc@1101495000 : Record 54104;
                               BEGIN
                                 AccInstructionsCRMNAVLoc.SETFILTER("Contract No.","Contract No.");
                                 PAGE.RUN(54104,AccInstructionsCRMNAVLoc);
                               END;
                                }
      { 1101495017;2 ;Action    ;
                      CaptionML=[ENU=Transfer Contract CRM - NAV;
                                 RUS=Передача контракта CRM - NAV];
                      OnAction=VAR
                                 ContractCRMNAVLoc@1101495000 : Record 54116;
                               BEGIN
                                 ContractCRMNAVLoc.SETFILTER("Contract No.","Contract No.");
                                 PAGE.RUN(54117,ContractCRMNAVLoc);
                               END;
                                }
      { 1101495018;2 ;Action    ;
                      CaptionML=[ENU=Transfer Contract NAV -CRM;
                                 RUS=Передача контракта NAV - CRM];
                      OnAction=VAR
                                 ContractNAVCRMLoc@1101495000 : Record 54117;
                               BEGIN
                                 ContractNAVCRMLoc.SETFILTER("Contract No.","Contract No.");
                                 PAGE.RUN(54118,ContractNAVCRMLoc);
                               END;
                                }
      { 1101495026;2 ;Action    ;
                      CaptionML=[CSY=щЯetnб poloзky - NAV - CRM;
                                 ENU=Accounting Entries - NAV - CRM;
                                 RUS=Фин. операции NAV - CRM];
                      RunObject=Page 54111;
                      RunFormLink=Contract No.=FIELD(Contract No.) }
      { 1000000089;0 ;ActionContainer;
                      Name=<Action1000000088>;
                      CaptionML=[CSY=Reports;
                                 ENU=Reports;
                                 RUS=Отчёты];
                      ActionContainerType=Reports }
      { 1101495053;1 ;Action    ;
                      CaptionML=[ENU=Print;
                                 RUS=Печать];
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 DocumentPrintL@1101495000 : Codeunit 229;
                               BEGIN
                                 DocumentPrintL.PrintContract(Rec);
                               END;
                                }
      { 1000000088;1 ;Action    ;
                      Name=<Action1000000087>;
                      CaptionML=[CSY=Future Payables for Early Term;
                                 ENU=Future Payables for Early Term;
                                 RUS=Расчет суммы к ПДП];
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 lContract@1000000000 : Record 54105;
                                 Rep@1000000002 : Report 50199;
                               BEGIN
                                 // PCTRU ZZER 2014-09-02 ->
                                 lContract := Rec;
                                 lContract.SETRECFILTER;
                                 Rep.SETTABLEVIEW(lContract);
                                 Rep.RUN;
                                 // <- PCT
                               END;
                                }
      { 1101495040;1 ;Action    ;
                      Name=<Action1101495040>;
                      CaptionML=[ENU=Calculate ET Amount;
                                 RUS=Рассчитать сумму к ПДП (Новое)];
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 FinancialLoansManagement@1101495000 : Codeunit 54101;
                               BEGIN
                                 FinancialLoansManagement.CalculateETAmountInputDate("Contract No.");
                               END;
                                }
      { 1101495005;1 ;Action    ;
                      Name=Cust. Not LP;
                      CaptionML=RUS=Cust. Not LP;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 lContract@1101495001 : Record 54105;
                                 Rep@1101495000 : Report 50050;
                               BEGIN
                                 //AKAM 300517 >>
                                 lContract := Rec;
                                 lContract.SETRECFILTER;
                                 Rep.SETTABLEVIEW(lContract);
                                 Rep.RUN;
                                 //AKAM 300517 <<
                               END;
                                }
      { 1101495006;1 ;Action    ;
                      Name=Cust. LP;
                      CaptionML=RUS=Cust. LP;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 lContract@1101495001 : Record 54105;
                                 Rep@1101495000 : Report 50051;
                               BEGIN
                                 //AKAM 300517 >>
                                 lContract := Rec;
                                 lContract.SETRECFILTER;
                                 Rep.SETTABLEVIEW(lContract);
                                 Rep.RUN;
                                 //AKAM 300517 <<
                               END;
                                }
      { 1101495007;1 ;Action    ;
                      Name=Cust. Pay Information;
                      CaptionML=RUS=Cust. Pay Information;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 lContract@1101495001 : Record 54105;
                                 Rep@1101495000 : Report 50052;
                               BEGIN
                                 //AKAM 300517 >>
                                 lContract := Rec;
                                 lContract.SETRECFILTER;
                                 Rep.SETTABLEVIEW(lContract);
                                 Rep.RUN;
                                 //AKAM 300517 <<
                               END;
                                }
      { 1000000029;1 ;Action    ;
                      Name=<Action84>;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[CSY=Dimenze;
                                 ENU=Dimensions;
                                 RUS=Измерения;
                                 SKY="Dimenzie "];
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1000000037;1 ;Action    ;
                      CaptionML=[CSY=Poloзky zаkaznбka za smlouvu;
                                 ENU=Customer Ledger Entry per Contract;
                                 RUS=Книга операций клиентов];
                      RunObject=Page 25;
                      RunFormView=SORTING(Customer No.,Contract No.);
                      RunFormLink=Customer No.=FIELD(Customer No.),
                                  Contract No.=FIELD(Contract No.);
                      Promoted=Yes;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CustLELcl@1000000000 : Record 21;
                               BEGIN
                               END;
                                }
      { 1000000041;1 ;Action    ;
                      CaptionML=[CSY=Karta zаkaznбka;
                                 ENU=Customer Card;
                                 RUS=Карточка клиента];
                      RunObject=Page 21;
                      RunFormLink=No.=FIELD(Customer No.);
                      Promoted=Yes;
                      PromotedCategory=Process }
      { 1000000016;1 ;Action    ;
                      CaptionML=[ENU=Bank Accounts;
                                 RUS=Банковский счет];
                      RunObject=Page 424;
                      RunFormLink=Customer No.=FIELD(Customer No.),
                                  Contract No.=FIELD(Contract No.) }
      { 1101495027;1 ;Action    ;
                      CaptionML=ENU=ECL Report;
                      OnAction=VAR
                                 ReservesCalculationReportL@1101495000 : Report 50005;
                                 ContractL@1101495001 : Record 54105;
                               BEGIN
                                 ContractL.SETRANGE("Contract No.", "Contract No.");
                                 ReservesCalculationReportL.SETTABLEVIEW(ContractL);
                                 ReservesCalculationReportL.RUN;
                               END;
                                }
      { 1000000047;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1000000050;1 ;ActionGroup;
                      Name=<Action1000000044>;
                      CaptionML=[CSY=F&unkce;
                                 ENU=F&unctions;
                                 RUS=Ф&ункции;
                                 SKY=F&unkcie] }
      { 1000000049;2 ;Action    ;
                      Name=<Action1000000045>;
                      CaptionML=[CSY=UkonЯit smlouvu;
                                 ENU=End Contract;
                                 RUS=Завершить контракт];
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CustLELcl@1000000000 : Record 21;
                                 NotEndedContract@1000000002 : TextConst 'CSY=Smlouvu nelze ukonЯit.;ENU=Contract is not allow to end.';
                                 PaymentSchedLcl@1000000003 : Record 50003;
                                 NotPost@1000000004 : Boolean;
                               BEGIN
                                 IF "Ending Status" = "Ending Status"::"Prepare to Ending" THEN BEGIN
                                   CustLELcl.SETRANGE("Contract No.","Contract No.");
                                   CustLELcl.SETRANGE(Open,TRUE);
                                   IF NOT CustLELcl.FINDSET THEN BEGIN
                                     VALIDATE("Ending Status","Ending Status"::Ended);
                                     PaymentSchedLcl.SETRANGE("Contract No.","Contract No.");
                                     IF PaymentSchedLcl.FINDSET THEN BEGIN
                                       REPEAT
                                 // switch to new table
                                         IF NOT ((PaymentSchedLcl."Local Interest Posted") OR
                                                 (PaymentSchedLcl."Local Interest Pstd. Amt." = PaymentSchedLcl."Interest - Client")) THEN
                                 //        IF NOT ((PaymentSchedLcl."Posting in Local") OR
                                 //                (PaymentSchedLcl."Post Interest Saving (Local)" = PaymentSchedLcl."Interest - Client")) THEN

                                           NotPost := TRUE;
                                       UNTIL ((PaymentSchedLcl.NEXT = 0) OR (NotPost));
                                       IF NOT NotPost THEN
                                         "Accounting Ended" := TRUE;
                                     END;
                                     MODIFY;
                                   END ELSE
                                     MESSAGE(NotEndedContract);
                                 END ELSE
                                   MESSAGE(NotEndedContract);
                               END;
                                }
      { 1000000081;2 ;Action    ;
                      CaptionML=[CSY=Pаrovat nep¤i¤azenВ platby;
                                 ENU=Apply Payment;
                                 RUS=Применить платёж];
                      OnAction=VAR
                                 CustLELcl@1000000000 : Record 21;
                               BEGIN
                                 CustLELcl.SETRANGE("Contract No.","Contract No.");
                                 REPORT.RUN(54112,FALSE,FALSE,CustLELcl);
                               END;
                                }
      { 1101495024;2 ;Action    ;
                      CaptionML=[ENU=20 Days Storno;
                                 RUS=Сторно в течение 20 дней];
                      OnAction=VAR
                                 FinancialLoansCheckPostingL@1101495000 : Codeunit 54102;
                               BEGIN
                                 FinancialLoansCheckPostingL.CheckFullTermination(Rec);
                               END;
                                }
      { 1101495047;2 ;ActionGroup;
                      Name=<Action1101495042>;
                      CaptionML=[ENU=Post Additional Services;
                                 RUS=Учет доп. услуг] }
      { 1101495046;3 ;Action    ;
                      Name=<Action1101495043>;
                      CaptionML=[ENU=Payment postponement;
                                 RUS=Отсрочка очередного платежа];
                      OnAction=VAR
                                 FinancialLoansManagementL@1101495002 : Codeunit 54101;
                                 GenJnlManagementL@1101495001 : Codeunit 230;
                                 FinancialLoansSetupL@1101495000 : Record 54100;
                               BEGIN
                                 //2019-02-04 AKAM
                                 FinancialLoansSetupL.GET;
                                 IF FinancialLoansManagementL.CreateAdditionalServices("Contract No.", 1) THEN
                                   IF CONFIRM(Text50000, TRUE) THEN
                                     GenJnlManagementL.OpenGeneralJournal(FinancialLoansSetupL."Loan Jnl. Template Name",
                                                                          FinancialLoansSetupL."Add. Service Jnl. Tmpl. Batch");
                               END;
                                }
      { 1101495048;3 ;Action    ;
                      CaptionML=[ENU=Due date change;
                                 RUS=Перенос даты платежа] }
      { 1101495045;3 ;Action    ;
                      Name=<Action1101495044>;
                      CaptionML=[ENU=Quotes on loan balance/payments etc;
                                 RUS=Предоставление доп. справок о зад-ти / о платежах по договору];
                      OnAction=VAR
                                 FinancialLoansManagementL@1101495002 : Codeunit 54101;
                                 GenJnlManagementL@1101495001 : Codeunit 230;
                                 FinancialLoansSetupL@1101495000 : Record 54100;
                               BEGIN
                                 //2019-02-04 AKAM
                                 FinancialLoansSetupL.GET;
                                 IF FinancialLoansManagementL.CreateAdditionalServices("Contract No.", 2) THEN
                                   IF CONFIRM(Text50000, TRUE) THEN
                                     GenJnlManagementL.OpenGeneralJournal(FinancialLoansSetupL."Loan Jnl. Template Name",
                                                                          FinancialLoansSetupL."Add. Service Jnl. Tmpl. Batch");
                               END;
                                }
      { 1101495044;3 ;Action    ;
                      Name=<Action1101495045>;
                      CaptionML=[ENU=SMS Notification;
                                 RUS=СМС-информирование];
                      Visible=FALSE;
                      OnAction=VAR
                                 FinancialLoansManagementL@1101495002 : Codeunit 54101;
                                 GenJnlManagementL@1101495001 : Codeunit 230;
                                 FinancialLoansSetupL@1101495000 : Record 54100;
                               BEGIN
                                 //2019-02-04 AKAM
                                 FinancialLoansSetupL.GET;
                                 IF FinancialLoansManagementL.CreateAdditionalServices("Contract No.", 3) THEN
                                   IF CONFIRM(Text50000, TRUE) THEN
                                     GenJnlManagementL.OpenGeneralJournal(FinancialLoansSetupL."Loan Jnl. Template Name",
                                                                          FinancialLoansSetupL."Add. Service Jnl. Tmpl. Batch");
                               END;
                                }
      { 1101495043;3 ;Action    ;
                      Name=<Action1101495046>;
                      CaptionML=[ENU=E-copy of the loan agreement to Client's email;
                                 RUS=Отправка электронной версии договора займа по электронной почте];
                      OnAction=VAR
                                 FinancialLoansManagementL@1101495002 : Codeunit 54101;
                                 GenJnlManagementL@1101495001 : Codeunit 230;
                                 FinancialLoansSetupL@1101495000 : Record 54100;
                               BEGIN
                                 //2019-02-04 AKAM
                                 FinancialLoansSetupL.GET;
                                 IF FinancialLoansManagementL.CreateAdditionalServices("Contract No.", 4) THEN
                                   IF CONFIRM(Text50000, TRUE) THEN
                                     GenJnlManagementL.OpenGeneralJournal(FinancialLoansSetupL."Loan Jnl. Template Name",
                                                                          FinancialLoansSetupL."Add. Service Jnl. Tmpl. Batch");
                               END;
                                }
      { 1101495042;3 ;Action    ;
                      Name=<Action1101495047>;
                      CaptionML=[ENU=Express delivery of documents (door to door);
                                 RUS=Срочная доставка документов по микрозайму курьерской службой];
                      OnAction=VAR
                                 FinancialLoansManagementL@1101495002 : Codeunit 54101;
                                 GenJnlManagementL@1101495001 : Codeunit 230;
                                 FinancialLoansSetupL@1101495000 : Record 54100;
                               BEGIN
                                 //2019-02-04 AKAM
                                 FinancialLoansSetupL.GET;
                                 IF FinancialLoansManagementL.CreateAdditionalServices("Contract No.", 5) THEN
                                   IF CONFIRM(Text50000, TRUE) THEN
                                     GenJnlManagementL.OpenGeneralJournal(FinancialLoansSetupL."Loan Jnl. Template Name",
                                                                          FinancialLoansSetupL."Add. Service Jnl. Tmpl. Batch");
                               END;
                                }
      { 1101495041;3 ;Action    ;
                      Name=<Action1101495048>;
                      CaptionML=[ENU=Check of Credit history;
                                 RUS=Предоставление кредитного отчета НБКИ];
                      OnAction=VAR
                                 FinancialLoansManagementL@1101495002 : Codeunit 54101;
                                 GenJnlManagementL@1101495001 : Codeunit 230;
                                 FinancialLoansSetupL@1101495000 : Record 54100;
                               BEGIN
                                 //2019-02-04 AKAM
                                 FinancialLoansSetupL.GET;
                                 IF FinancialLoansManagementL.CreateAdditionalServices("Contract No.", 6) THEN
                                   IF CONFIRM(Text50000, TRUE) THEN
                                     GenJnlManagementL.OpenGeneralJournal(FinancialLoansSetupL."Loan Jnl. Template Name",
                                                                          FinancialLoansSetupL."Add. Service Jnl. Tmpl. Batch");
                               END;
                                }
      { 1101495050;2 ;Action    ;
                      Name=<Action1101495050>;
                      CaptionML=[ENU=Collateral Registration/Deregistration;
                                 RUS=Залог Постановка/Снятие с учета];
                      OnAction=VAR
                                 ContractL@1101495001 : Record 54105;
                                 CollateralRegistrationL@1101495000 : Report 50027;
                               BEGIN
                                 //2019-10-01 LAV >
                                 ContractL.SETRANGE("Contract No.","Contract No.");
                                 CollateralRegistrationL.SETTABLEVIEW(ContractL);
                                 CollateralRegistrationL.RUNMODAL;
                               END;
                                }
      { 1101495056;2 ;Action    ;
                      CaptionML=[ENU=Vehicle Title Pledge Set/Removal;
                                 RUS=ПТС Постановка/Снятие с учета];
                      OnAction=BEGIN
                                 VehicleTitleChangeStatus();
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1000000000;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                Name=General;
                CaptionML=[ENU=General;
                           RUS=Общее];
                GroupType=Group }

    { 1000000002;2;Field  ;
                SourceExpr="Contract No.";
                Editable=false }

    { 1000000003;2;Field  ;
                Name=<Contract No.>;
                SourceExpr="Customer No.";
                Editable=false }

    { 1000000040;2;Field  ;
                SourceExpr="Customer Name";
                Importance=Promoted;
                Editable=false }

    { 1101495030;2;Field  ;
                SourceExpr="Coborrower Name";
                Editable=false;
                Style=Strong;
                StyleExpr=TRUE }

    { 1000000004;2;Field  ;
                SourceExpr="Principal Amount";
                Importance=Promoted;
                Editable=false }

    { 1000000005;2;Field  ;
                CaptionML=[CSY=Nominаlnб hodnota;
                           ENU=Initial NV;
                           RUS=Начальная полная стоимость];
                SourceExpr="Nominal Amount";
                Editable=false }

    { 1101495023;2;Field  ;
                CaptionML=[ENU=Actual NV+SP;
                           RUS=Актуальная полная стоимость];
                SourceExpr=GetActualNormalAmount;
                Editable=false }

    { 1000000098;2;Field  ;
                Name=<Nominal Amount>;
                CaptionML=[ENU=Intial NV + SP;
                           RUS=Номинал + комиссия];
                SourceExpr="Nominal Amount"+"Installment Count"*"Product Comission";
                Editable=FALSE }

    { 1000000006;2;Field  ;
                SourceExpr="Installment Count";
                Importance=Promoted;
                Editable=false }

    { 1000000007;2;Field  ;
                SourceExpr="Installment Period";
                Editable=false }

    { 1000000008;2;Field  ;
                CaptionML=[CSY=Vьчe splаtky;
                           ENU=Installment Amount;
                           RUS=Платеж сумма начальная];
                SourceExpr="Installment Amount";
                Importance=Promoted;
                Editable=false }

    { 1101495020;2;Field  ;
                CaptionML=[ENU=Installment Amount Current;
                           RUS=Платеж сумма текущая];
                SourceExpr=CurrInstallmentAmount;
                OnLookup=VAR
                           PaymentScheduleL@1101495000 : Record 50003;
                         BEGIN
                           //AKAM 220617
                           PaymentScheduleL.SETRANGE("Contract No.", "Contract No.");
                           PaymentScheduleL.SETFILTER("Installment No.", '<>%1', 0);
                           PaymentScheduleL.SETFILTER("Installment Date", '>=%1', WORKDATE);
                           IF PaymentScheduleL.FINDFIRST THEN;
                           PAGE.RUNMODAL(50010, PaymentScheduleL);
                         END;
                          }

    { 1000000099;2;Field  ;
                CaptionML=[ENU=Installment Amount + Comission;
                           RUS=Ежемес. платеж + комиссия];
                SourceExpr="Installment Amount"+"Product Comission";
                Editable=FALSE }

    { 1000000009;2;Field  ;
                SourceExpr="Installment Due Date";
                Importance=Promoted;
                Editable=false }

    { 1101495002;2;Field  ;
                SourceExpr="Initial Installment Due Date" }

    { 1000000035;2;Field  ;
                SourceExpr="Initial Installment Due Date 2";
                Editable=False }

    { 1000000044;2;Field  ;
                SourceExpr="APR Profi Light";
                Editable=False }

    { 1000000010;2;Field  ;
                SourceExpr="Principal Revolving Amount";
                Visible=false;
                Editable=false }

    { 1000000011;2;Field  ;
                SourceExpr="Nominal Revolving Amount";
                Visible=false;
                Editable=false }

    { 1000000012;2;Field  ;
                SourceExpr="Interest Rate";
                Editable=false }

    { 1000000066;2;Field  ;
                DecimalPlaces=3:3;
                SourceExpr=APR }

    { 1101495003;2;Field  ;
                Name=<Initial APR>;
                CaptionML=[ENU=Initial APR;
                           RUS=Начальная ПСК];
                DecimalPlaces=3:3;
                SourceExpr=GetHistoricalAPR;
                Editable=FALSE;
                OnDrillDown=VAR
                              ContractChangesL@1101495000 : Record 54106;
                            BEGIN
                              SetHistoricalAPRFilter(ContractChangesL);
                              PAGE.RUNMODAL(0, ContractChangesL);
                            END;
                             }

    { 1000000100;2;Field  ;
                SourceExpr="Product Activated";
                Editable=false }

    { 1101495019;2;Field  ;
                SourceExpr=Restructuring }

    { 1000000101;2;Field  ;
                SourceExpr="Product Type";
                Editable=false }

    { 1000000102;2;Field  ;
                SourceExpr="Product Comission";
                Editable=false }

    { 1000000014;2;Field  ;
                SourceExpr="Installment Bank Acc. No.";
                Editable=false }

    { 1000000036;2;Field  ;
                SourceExpr="Payment Bank Acc. No.";
                Visible=false;
                Editable=false }

    { 1000000082;2;Field  ;
                SourceExpr="PCT Collection Bank Acount";
                Visible=false }

    { 1000000083;2;Field  ;
                SourceExpr="External Doc. No." }

    { 1000000077;2;Field  ;
                SourceExpr="Specific Symbol";
                Visible=false;
                Editable=false }

    { 1000000015;2;Field  ;
                SourceExpr="Collection Consent";
                Visible=false;
                Editable=false }

    { 1000000017;2;Field  ;
                SourceExpr="Date of Signature";
                Editable=false }

    { 1000000042;2;Field  ;
                SourceExpr="Loan Start Date";
                Editable=false }

    { 1000000038;2;Field  ;
                SourceExpr="Date of First Installment";
                Editable=false }

    { 1000000039;2;Field  ;
                SourceExpr="Date of Last Installment";
                Editable=false }

    { 1000000018;2;Field  ;
                SourceExpr="Comission CC";
                Editable=false }

    { 1101495031;2;Field  ;
                Name=CA Commission Rate;
                CaptionML=[ENU=CA Commission Rate;
                           RUS=Ставка комиссии агента];
                SourceExpr=NewUnifiedMathL.GetTotalAgentCommissionRate(Rec) }

    { 1101495034;2;Field  ;
                Name=Lead Source;
                CaptionML=[ENU=Lead Source;
                           RUS=Источник привлечения];
                OptionCaptionML=[ENU=" ,Sales Network,Marketing";
                                 RUS=" ,Личное привлечение,Маркетинг"];
                SourceExpr=ContractCRMNAVG."Lead Source" }

    { 1101495033;2;Field  ;
                Name=Loyal Client;
                CaptionML=[ENU=Loyal Client;
                           RUS=Повторный клиент];
                SourceExpr=ContractCRMNAVG."Loyal Client" }

    { 1000000026;2;Field  ;
                SourceExpr="Revolving Installment Count";
                Visible=false;
                Editable=false }

    { 1000000020;2;Field  ;
                SourceExpr="Immediate Receivable";
                Editable=false }

    { 1000000021;2;Field  ;
                SourceExpr="Remaining Amount on Contract";
                Editable=false }

    { 1000000022;2;Field  ;
                SourceExpr="Global Dimension 1 Code";
                Editable=false }

    { 1000000023;2;Field  ;
                SourceExpr="Global Dimension 2 Code";
                Editable=false }

    { 1000000024;2;Field  ;
                SourceExpr="Shortcut Dimension 3 Code";
                Editable=false }

    { 1000000025;2;Field  ;
                SourceExpr="Shortcut Dimension 4 Code";
                Editable=false }

    { 1000000027;2;Field  ;
                SourceExpr="Contract GUID in CRM";
                Visible=false;
                Editable=false }

    { 1000000032;2;Field  ;
                SourceExpr="Customer GUID in CRM";
                Visible=false;
                Editable=false }

    { 1000000095;2;Field  ;
                SourceExpr="Contract Status";
                Editable=false }

    { 1101495021;2;Field  ;
                CaptionML=[ENU=CRM Contract Status;
                           RUS=CRM Статус Контракта];
                SourceExpr=CRMStatus;
                Editable=FALSE;
                OnAssistEdit=BEGIN
                               CRMStatus := GetCRMStatus;
                             END;
                              }

    { 1000000033;2;Field  ;
                SourceExpr="Ending Status";
                Editable=false }

    { 1000000096;2;Field  ;
                SourceExpr="Termination Date";
                Editable=false }

    { 1000000097;2;Field  ;
                SourceExpr="Legal Proceeding Date";
                Editable=false }

    { 1000000045;2;Field  ;
                SourceExpr="Accounting Ended";
                Visible=false;
                Editable=false }

    { 1000000043;2;Field  ;
                SourceExpr=Depreciated;
                Visible=false;
                Editable=false }

    { 1000000078;2;Field  ;
                SourceExpr="Depreciation Type";
                Visible=false }

    { 1000000079;2;Field  ;
                SourceExpr="Debt Admission Agreement";
                Visible=false }

    { 1000000080;2;Field  ;
                ExtendedDatatype=URL;
                CaptionML=[CSY=CRM Link;
                           ENU=CRM Link;
                           RUS=CRM ссылка];
                SourceExpr=CRMURL;
                Editable=false }

    { 1000000094;2;Field  ;
                SourceExpr="Skip MFO" }

    { 1101495000;2;Field  ;
                SourceExpr=Pledged }

    { 1101495001;2;Field  ;
                SourceExpr="Pledge Date" }

    { 1101495004;2;Field  ;
                SourceExpr="Consent (Claim Assign. Agr.)";
                Visible=FALSE;
                Editable=FALSE }

    { 1101495025;2;Field  ;
                CaptionML=[ENU=Initial Length of Loan in Days;
                           RUS=Исходная длительность контракта в днях];
                DecimalPlaces=0:0;
                SourceExpr=GetInitialLengthOfLoan }

    { 1101495022;2;Field  ;
                CaptionML=[ENU=Client is Dead;
                           RUS=Клиент умер];
                SourceExpr="Client is Dead";
                Editable=false }

    { 1101495028;2;Field  ;
                SourceExpr=Default;
                Editable=FALSE }

    { 1101495029;2;Field  ;
                SourceExpr="Default Date";
                Editable=FALSE }

    { 1101495052;2;Field  ;
                SourceExpr="PTI Amount";
                Editable=False }

    { 1000000013;2;Field  ;
                SourceExpr="Type of Insurance";
                Editable=FALSE }

    { 1000000046;2;Field  ;
                SourceExpr="Cansel Insuranse Date" }

    { 1000000028;2;Field  ;
                SourceExpr=Insurance;
                Editable=FALSE }

    { 1000000054;1;Group  ;
                CaptionML=[CSY=PrЕb╪зnВ гroЯenб;
                           ENU=Continues Interest];
                Editable=false;
                GroupType=Group }

    { 1000000055;2;Field  ;
                SourceExpr="Post Contract Penalty" }

    { 1000000058;2;Field  ;
                SourceExpr="Int. Rate Contract Penalty" }

    { 1000000061;2;Field  ;
                SourceExpr="Starting Date Contract Penalty" }

    { 1000000062;2;Field  ;
                SourceExpr="Update Date Contract Penalty" }

    { 1000000064;2;Field  ;
                SourceExpr="Daily IncrementContractPenalty" }

    { 1000000065;2;Field  ;
                SourceExpr="Posted Amount Contract Penalty" }

    { 1000000057;2;Field  ;
                SourceExpr="Post Running Interest" }

    { 1000000060;2;Field  ;
                SourceExpr="Int. Rate Running Interest" }

    { 1000000019;2;Field  ;
                SourceExpr="Starting Date Running Interest" }

    { 1000000056;2;Field  ;
                SourceExpr="Update Date Running Interest" }

    { 1000000073;2;Field  ;
                SourceExpr="Amount to PostRunningInterest" }

    { 1000000074;2;Field  ;
                SourceExpr=DailyIncrementRunningInterers }

    { 1000000075;2;Field  ;
                SourceExpr="Posted Amount Running Interest" }

    { 1000000067;1;Group  ;
                CaptionML=[CSY=Souhrn;
                           ENU=Summary;
                           RUS=Сводка];
                GroupType=Group }

    { 1000000068;2;Field  ;
                SourceExpr="Principal Amount";
                Importance=Promoted;
                Editable=false }

    { 1000000086;2;Field  ;
                SourceExpr="Paid to Date";
                Editable=FALSE }

    { 1000000085;2;Field  ;
                CaptionML=[CSY=щrok z prodlenб - uhrazeno k datu;
                           ENU=Running Interest - Paid To Date];
                SourceExpr=PaidToDate(0,FALSE,FALSE);
                OnDrillDown=BEGIN
                              PaidToDate(0,TRUE,FALSE);
                            END;
                             }

    { 1000000084;2;Field  ;
                CaptionML=[CSY=щrok z prodlenб poslednб spl. - uhrazeno k datu;
                           ENU=Running Interest (Last Installment) - Paid To Date];
                SourceExpr=PaidToDate(0,FALSE,TRUE);
                OnDrillDown=BEGIN
                              PaidToDate(0,TRUE,TRUE);
                            END;
                             }

    { 1000000072;2;Field  ;
                CaptionML=[CSY=Pokuta - uhrazeno k datu;
                           ENU=Penalty - Paid to Date];
                SourceExpr=PaidToDate(1,FALSE,FALSE);
                OnDrillDown=BEGIN
                              PaidToDate(1,TRUE,FALSE);
                            END;
                             }

    { 1000000071;2;Field  ;
                CaptionML=[CSY=Pokuta poslednб spl. - uhrazeno k datu;
                           ENU=Penalty (Last Installment) - Paid to Date];
                SourceExpr=PaidToDate(1,FALSE,TRUE);
                OnDrillDown=BEGIN
                              PaidToDate(1,TRUE,TRUE);
                            END;
                             }

    { 1000000070;2;Field  ;
                CaptionML=[CSY=PoЯet dnб po splatnosti;
                           ENU=Overdue Days to Date];
                SourceExpr=OverdueDaysToDate(FALSE);
                OnDrillDown=BEGIN
                              OverdueDaysToDate(TRUE);
                            END;
                             }

    { 1000000069;2;Field  ;
                SourceExpr=APR;
                Importance=Promoted }

    { 1101495036;1;Group  ;
                CaptionML=[ENU=Control;
                           RUS=Контроль];
                GroupType=Group }

    { 1101495035;2;Field  ;
                SourceExpr="Manual Control" }

    { 1101495037;2;Field  ;
                SourceExpr="Not Calc. DRPS" }

    { 1101495038;2;Field  ;
                SourceExpr="Manual Control Reason";
                MultiLine=Yes }

    { 1101495039;2;Field  ;
                SourceExpr="Manual Application" }

    { 1101495051;1;Group  ;
                CaptionML=[ENU=Collateral info;
                           RUS=Залоговая инф.];
                GroupType=Group }

    { 1101495049;2;Field  ;
                SourceExpr="Collateral Value Amount";
                Editable=FALSE }

    { 1101495054;2;Field  ;
                SourceExpr="Vehicle Title is Pledged" }

    { 1101495055;2;Field  ;
                SourceExpr="Vehicle Title Change Date" }

    { 1101495057;2;Field  ;
                SourceExpr="After Restart" }

  }
  CODE
  {
    VAR
      FinLoanMGTSetup@1000000000 : Record 54100;
      FinLoanSetup@1000000006 : Record 54100;
      ContractCRMNAVG@1101495002 : Record 54116;
      NewUnifiedMathL@1101495001 : Codeunit 50009;
      CommuOKTxt@1000000003 : TextConst 'CSY=Komunikace se CRM prob╪hla bez problВmЕ.;ENU=CRM communication processed.';
      CommuErrTxt@1000000004 : TextConst 'CSY=Komunikace se CRM skonЯila s chybou %1.;ENU=CRM communication ended with mistake %1.';
      CRMURL@1000000005 : Text[1024];
      CRMStatus@1101495000 : Text[30];
      Text50000@1101495003 : TextConst 'ENU=Recorded in General Journal! Open the Journal?;RUS=Записано в фин. журнал! Открыть журнал?';

    PROCEDURE CreateCustLENAVCRM@1000000001(ContractNoPrm@1000000000 : Code[20]);
    VAR
      ContractLcl@1000000001 : Record 54105;
      CustomerLELcl@1000000002 : Record 21;
      AccountingEntryLcl@1000000003 : Record 54109;
      DetCustLELcl@1000000004 : Record 379;
      PaymentChanelSetup@1000000008 : Record 54114;
      OnHoldLcl@1000000007 : Record 54113;
      SourceCodeSetup@1000000006 : Record 242;
      ReasonFind@1000000005 : Boolean;
      i@1000000009 : Integer;
    BEGIN
      CustomerLELcl.SETRANGE("Contract No.",ContractNoPrm);
      i := 0;
      IF CustomerLELcl.FINDSET THEN
        REPEAT
          i += 1;
          CustomerLELcl.CALCFIELDS("Remaining Amt. (LCY)","Amount (LCY)");
          AccountingEntryLcl.INIT;
          AccountingEntryLcl."Entry No." := GetNextAccEntryNo;
          AccountingEntryLcl."Customer Entry No." := CustomerLELcl."Entry No.";
          AccountingEntryLcl."Customer No." := CustomerLELcl."Customer No.";
          AccountingEntryLcl."Posting Date" := CustomerLELcl."Posting Date";
          IF CustomerLELcl."Document Type" = CustomerLELcl."Document Type"::" " THEN
            AccountingEntryLcl."Ledger Entry Category" := AccountingEntryLcl."Ledger Entry Category"::Instruction;
          IF CustomerLELcl."Document Type" IN [CustomerLELcl."Document Type"::Payment,CustomerLELcl."Document Type"::Refund] THEN
            AccountingEntryLcl."Ledger Entry Category" := AccountingEntryLcl."Ledger Entry Category"::Payment;
          IF ((CustomerLELcl."Document Type"=CustomerLELcl."Document Type"::" ") AND
              (CustomerLELcl.Subtype=CustomerLELcl.Subtype::Payable))
              OR (CustomerLELcl."Document Type"=CustomerLELcl."Document Type"::Refund) THEN
            AccountingEntryLcl.Direction := AccountingEntryLcl.Direction::Out;
          IF ((CustomerLELcl."Document Type"=CustomerLELcl."Document Type"::" ") AND
              (CustomerLELcl.Subtype=CustomerLELcl.Subtype::Receivable))
              OR (CustomerLELcl."Document Type"=CustomerLELcl."Document Type"::Payment) THEN
            AccountingEntryLcl.Direction := AccountingEntryLcl.Direction::"In";

          IF ((CustomerLELcl."Instruction Type" IN [CustomerLELcl."Instruction Type"::"Instruction to Transfer",
               CustomerLELcl."Instruction Type"::"Overpayment Return Fee",CustomerLELcl."Instruction Type"::"Early Termination Fee",
               CustomerLELcl."Instruction Type"::"Early Termination"])
               AND (CustomerLELcl."Operation Type" <> CustomerLELcl."Operation Type"::Creation)) THEN BEGIN
            AccountingEntryLcl."Ledger Entry Category" := AccountingEntryLcl."Ledger Entry Category"::Payment;
            IF AccountingEntryLcl.Direction = AccountingEntryLcl.Direction::"In" THEN
              AccountingEntryLcl.Direction := AccountingEntryLcl.Direction::Out
            ELSE
              AccountingEntryLcl.Direction := AccountingEntryLcl.Direction::"In";
            END;

          AccountingEntryLcl.Description := CustomerLELcl.Description;
          CLEAR(DetCustLELcl);
          DetCustLELcl.SETCURRENTKEY("Posting Date");
          DetCustLELcl.SETRANGE("Cust. Ledger Entry No.",CustomerLELcl."Entry No.");
          IF DetCustLELcl.FINDLAST THEN
            AccountingEntryLcl."Last Posting Date" := DetCustLELcl."Posting Date";
          AccountingEntryLcl."Remaining Amt. (LCY)" := CustomerLELcl."Remaining Amt. (LCY)";
          AccountingEntryLcl."Amount (LCY)" := CustomerLELcl."Amount (LCY)";
      //IF CustomerLELcl."Document Type" IN [CustomerLELcl."Document Type"::Payment,CustomerLELcl."Document Type"::Refund] THEN BEGIN
          IF AccountingEntryLcl."Ledger Entry Category" = AccountingEntryLcl."Ledger Entry Category"::Payment THEN BEGIN
            ReasonFind := FALSE;
            PaymentChanelSetup.SETRANGE("Source Code",CustomerLELcl."Source Code");
            IF PaymentChanelSetup.FINDSET THEN BEGIN
              IF PaymentChanelSetup.COUNT = 1 THEN
                AccountingEntryLcl."Payment Chanel" := PaymentChanelSetup."Payment Chanel"
              ELSE BEGIN
                REPEAT
                  IF CustomerLELcl."Reason Code" = PaymentChanelSetup."Reason Code" THEN BEGIN
                    AccountingEntryLcl."Payment Chanel" := PaymentChanelSetup."Payment Chanel";
                    ReasonFind := TRUE;
                  END;
                UNTIL ((PaymentChanelSetup.NEXT = 0) OR (ReasonFind));
                IF NOT ReasonFind THEN BEGIN
                  PaymentChanelSetup.SETRANGE("Reason Code",'');
                  IF PaymentChanelSetup.FINDFIRST THEN
                    AccountingEntryLcl."Payment Chanel" := PaymentChanelSetup."Payment Chanel";
                END;
              END;
            END;
          END;
          IF CustomerLELcl."On Hold" <> '' THEN BEGIN
            OnHoldLcl.GET(CustomerLELcl."On Hold");
            AccountingEntryLcl."On Hold" := CustomerLELcl."On Hold";
            AccountingEntryLcl."On Hold Description" := OnHoldLcl.Destcription;
          END ELSE BEGIN
            AccountingEntryLcl."On Hold" := '';
            AccountingEntryLcl."On Hold Description" := '';
          END;
          AccountingEntryLcl."Contract No." := CustomerLELcl."Contract No.";
          AccountingEntryLcl."Operation Type" := CustomerLELcl."Operation Type";
          AccountingEntryLcl."Instruction Type" := CustomerLELcl."Instruction Type";
          IF CustomerLELcl."Operation No." <> 0 THEN
            AccountingEntryLcl."Operation No." := CustomerLELcl."Operation No.";
          AccountingEntryLcl.Reversed := CustomerLELcl.Reversed;

          IF CustomerLELcl."Bank Account No. for Payout" <> '' THEN
            AccountingEntryLcl."Bank Account No." := CustomerLELcl."Bank Account No. for Payout"
          ELSE
            AccountingEntryLcl."Bank Account No." := CustomerLELcl."Bank Account No.";
          AccountingEntryLcl.Status := AccountingEntryLcl.Status::New;
          AccountingEntryLcl."Payment Schedule Entry" := CustomerLELcl."Payment Schedule Entry";
          AccountingEntryLcl."Related Contract" := CustomerLELcl."Related Contract";
          AccountingEntryLcl.INSERT(TRUE);

          //AccountingEntryLcl.DotNetCommunication(AccountingEntryLcl,i);

        UNTIL CustomerLELcl.NEXT = 0;
    END;

    PROCEDURE GetNextAccEntryNo@1000000007() : Integer;
    VAR
      AccEntryLcl@1000000000 : Record 54109;
    BEGIN
      CLEAR(AccEntryLcl);
      IF AccEntryLcl.FINDLAST THEN
        EXIT(AccEntryLcl."Entry No." + 1)
      ELSE
        EXIT(1);
    END;

    BEGIN
    {
      PCTRU.11 ZZER 2014-09-02
        - +group: Summary
        - +fnc: Future Payables for Early Term
      PCTRU PVRB 2015-04-15
        + fld: DueAmountToFutureDateExclPay, Date filter is an info fld, some flds promoted
      PCTRU PVRB 2015-07-28
        +fld: Skip MFO, ML
      NC 7872
        + fld "Termination Date", "Legal Proceeding Date", "Contract Status" TN 270416
      NC 8456 TN 2016-05-30
        +fld "Product Activated", "Product Type", "Product Comission"
      2017.04.07 KDV
        Changed CreatePayschedNAVCRM() (changed last posting date assign). Function is not used.
      2017.04.12 KDV
        Новые поля Pledged, Pledge Date
      2017.04.19 KDV
        Поля APR, "Начальная ПСК" нa вклaдку Общее
      2017.05.02
        Новое поле "Consent (Claim Assign. Agr.)" нa вклaдку General
      2017-06-01 SAI
        В CreatePaySchedNAVCRM добавлено заполнение поля Created by Object в таблице 54110.
      AKAM 220617
        Добавлено новое поле CRM Статус Контракта
      AKAM 030717
        Поле Полная стоимость переименовно в Начальная полная стоимость
        Добавлено новое поле Актуальная полная стоимость
      2017.10.27 KDV Restructuring
      2018.01.08 KDV поля Default, Default Date
      AKAM 270718
        Кнопка Контракт/Операции/ добавлен новый пункт меню "Подробные операции клиента"
      PC AKAM 20180813
        Добавлено поле Manual Control (Ручной контроль)
      PC AKAM 160818
        Добавлена вкладка Контроль. На вкладку добавлены поля Не расчитывать DRPS, Ручной контроль.
      2019-04-03 SAI
        Изменен вызов функции NewUnifiedMathL.GetTotalAgentCommissionRate(Rec) - приведен в соответствие с оптимизированным КЮ
      2019-06-10 SAI
        Исправлен неверный вызов функции создания доп. услуг
      2019-10-01 LAV >
        Premium
      2019.12.11 Новое поле "PTI Amount"
      2020.03.12 Новая группа "Залоговая инф."
      2020.03.17  SAA New action - "Print"
      2020.03.18 Пункт в меню Ф-ции "ПТС Постановка/Снятие с учета"
      2020.06.05 SAA Contract "After Restart"

      03.08.20 Stefa Страховка
        CurrPage."Type of Insurance"
        CurrPage.Insurance
          were added (Общее) (Editable = FALSE)

      25.08.20 Stefa New Product Type "Profi Light"
        CurrPage."Initial Installment Due Date 2" was added (Общее) (Editable = FALSE)

      19.10.20 Stefa New Product Type "Profi Light"
        CurrPage."APR Profi Light" was added (Общее) (Editable = FALSE)

      22.10.20 Stefa NAV-404
        CurrPage."Comission CC" was added (Общее) (Editable = FALSE) - вместо FlowField "Commission CC"
    }
    END.
  }
}

