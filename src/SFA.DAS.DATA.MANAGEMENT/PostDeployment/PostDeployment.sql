/* Execute Stored Procedure */

EXEC [dbo].[Build_AS_DataMart]


/* Grant Permissions to Roles */

/* Developer Role Access */


IF DATABASE_PRINCIPAL_ID('Developer') IS NULL
BEGIN
	CREATE ROLE [Developer]
END

GRANT SELECT ON SCHEMA :: Comt TO Developer

GRANT SELECT ON SCHEMA :: Acct To Developer

GRANT SELECT ON SCHEMA :: EAUser To Developer

GRANT SELECT ON SCHEMA :: Fin To Developer

GRANT SELECT ON SCHEMA :: Mgmt To Developer

GRANT SELECT ON SCHEMA :: Resv To Developer

GRANT SELECT ON SCHEMA :: Pmts TO Developer

GRANT SELECT ON SCHEMA :: StgPmts TO Developer

GRANT SELECT ON SCHEMA :: Stg TO Developer

GRANT SELECT ON SCHEMA :: AsData_PL TO Developer

GRANT SELECT ON SCHEMA :: Data_Pub TO Developer

GRANT SELECT ON SCHEMA :: Mtd TO Developer

GRANT SELECT ON dbo.[ReferenceData] To Developer

GRANT SELECT ON [dbo].[DASCalendarMonth] To Developer

GRANT SELECT ON dbo.Payments_SS TO Developer

GRANT SELECT ON dbo.SourceDbChanges TO Developer

GRANT UNMASK TO Developer

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DataDictionary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	GRANT SELECT ON dbo.DataDictionary To Developer
End




/*

IF EXISTS(select 1 from sys.views where name='Das_Commitments' and type='v')
GRANT SELECT ON Data_Pub.Das_Commitments TO Developer



IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Commitments_LevyInd' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.Das_Commitments_LevyInd TO Developer
END

IF EXISTS(select 1 from sys.views where name='Das_NonLevy' and type='v')
GRANT SELECT ON Data_Pub.Das_NonLevy TO Developer

IF EXISTS(select 1 from sys.views where name='Das_Payments' and type='v')
GRANT SELECT ON Data_Pub.Das_Payments TO Developer


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Payments_LevyInd' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_Payments_LevyInd TO Developer
END



IF EXISTS(select 1 from sys.views where name='Das_LevyDeclarations' and type='v')
GRANT SELECT ON Data_Pub.Das_LevyDeclarations TO Developer

IF EXISTS(select 1 from sys.views where name='Das_LevyDeclarations_LevyInd' and type='v')
BEGIN
     GRANT SELECT ON Data_Pub.Das_LevyDeclarations_LevyInd TO Developer
END

IF EXISTS(select 1 from sys.views where name='DAS_Employer_AccountTransactions' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_AccountTransactions TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_CalendarMonth' and type='v')
GRANT SELECT ON Data_Pub.DAS_CalendarMonth TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Account_Transfers' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Account_Transfers_LevyInd' and type='v')
BEGIN
  GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers_LevyInd TO Developer
END

IF EXISTS(select 1 from sys.views where name='DAS_Employer_PayeSchemes' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_PayeSchemes TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_LegalEntities' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_LegalEntities TO Developer


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Employer_LegalEntities_LevyInd' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_Employer_LegalEntities_LevyInd TO Developer
END


IF EXISTS(select 1 from sys.views where name='DAS_Employer_Accounts' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Accounts TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Transfer_Relationship' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Transfer_Relationship TO Developer

IF EXISTS(select 1 from sys.views where name='Das_TransactionLine' and type='v')
GRANT SELECT ON ASData_PL.Das_TransactionLine TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Agreements' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Agreements TO Developer

if exists(select 1 from sys.views where name='DAS_SpendControl' and type='v')
GRANT SELECT ON ASData_PL.DAS_SpendControl TO Developer

*/


/* Analyst Role Access */

IF DATABASE_PRINCIPAL_ID('DataAnalyst') IS NULL
BEGIN
	CREATE ROLE [DataAnalyst]
END

if exists(select 1 from sys.views where name='Das_Commitments' and type='v')
BEGIN
   GRANT SELECT ON Data_Pub.Das_Commitments TO DataAnalyst
END


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Commitments_LevyInd' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.Das_Commitments_LevyInd TO DataAnalyst
END

if exists(select 1 from sys.views where name='Das_NonLevy' and type='v')
GRANT SELECT ON Data_Pub.Das_NonLevy TO DataAnalyst

--IF EXISTS(select 1 from sys.views where name='Das_Payments' and type='v')
--GRANT SELECT ON Data_Pub.Das_Payments TO DataAnalyst

IF EXISTS(select 1 from sys.views where name='Das_LevyDeclarations' and type='v')
GRANT SELECT ON Data_Pub.Das_LevyDeclarations TO DataAnalyst


IF EXISTS(select 1 from sys.views where name='Das_LevyDeclarations_LevyInd' and type='v')
BEGIN
     GRANT SELECT ON Data_Pub.Das_LevyDeclarations_LevyInd TO DataAnalyst
END


IF EXISTS(select 1 from sys.views where name='DAS_Employer_AccountTransactions' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_AccountTransactions TO DataAnalyst

IF EXISTS(select 1 from sys.views where name='DAS_CalendarMonth' and type='v')
GRANT SELECT ON Data_Pub.DAS_CalendarMonth TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Account_Transfers' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers TO DataAnalyst


if exists(select 1 from sys.views where name='DAS_Employer_Account_Transfers_LevyInd' and type='v')
BEGIN
   GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers_LevyInd TO DataAnalyst
END



if exists(select 1 from sys.views where name='DAS_Employer_PayeSchemes' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_PayeSchemes TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_LegalEntities' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_LegalEntities TO DataAnalyst



IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Employer_LegalEntities_LevyInd' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_Employer_LegalEntities_LevyInd TO DataAnalyst
END



if exists(select 1 from sys.views where name='DAS_Employer_Accounts' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Accounts TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Transfer_Relationship' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Transfer_Relationship TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Agreements' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Agreements TO DataAnalyst

IF EXISTS(select 1 from sys.views where name='Das_Payments' and type='v')
GRANT SELECT ON Data_Pub.Das_Payments TO DataAnalyst


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Payments_LevyInd' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_Payments_LevyInd TO DataAnalyst
END

GRANT SELECT ON dbo.Payments_SS TO DataAnalyst


IF EXISTS(select 1 from sys.views where name='DAS_TransactionLine' and type='v')
GRANT SELECT ON ASData_PL.DAS_TransactionLine TO DataAnalyst

/* Finance Role Access */


IF DATABASE_PRINCIPAL_ID('Finance') IS NULL
BEGIN
	CREATE ROLE [Finance]
END


IF EXISTS(select 1 from sys.views where name='DAS_SpendControl' and type='v')
GRANT SELECT ON ASData_PL.DAS_SpendControl TO Finance

IF EXISTS(select 1 from sys.views where name='DAS_SpendControlNonLevy' and type='v')
GRANT SELECT ON ASData_PL.DAS_SpendControlNonLevy TO Finance


/* Service Ops Access */

IF DATABASE_PRINCIPAL_ID('ServiceOps') IS NULL
BEGIN
	CREATE ROLE [ServiceOps]
END


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='RAA_Vacancies' AND TABLE_SCHEMA = 'Stg')
BEGIN
     GRANT SELECT ON Stg.RAA_Vacancies TO ServiceOps
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='RAA_ReferenceDataApprenticeshipProgrammes' AND TABLE_SCHEMA = 'Stg')
BEGIN
     GRANT SELECT ON Stg.RAA_ReferenceDataApprenticeshipProgrammes TO ServiceOps
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='RAA_ApplicationReviews' AND TABLE_SCHEMA = 'Stg')
BEGIN
     GRANT SELECT ON Stg.RAA_ApplicationReviews TO ServiceOps
END

/* Service Ops Access */

IF DATABASE_PRINCIPAL_ID('BetaUser') IS NULL
BEGIN
	CREATE ROLE [BetaUser]
END


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EI_Accounts' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN
     GRANT SELECT ON AsData_PL.EI_Accounts TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EI_IncentiveApplication' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN
     GRANT SELECT ON AsData_PL.EI_IncentiveApplication TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EI_IncentiveApplicationApprenticeship' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN
     GRANT SELECT ON AsData_PL.EI_IncentiveApplicationApprenticeship TO BetaUser
END


/* Assign select permissions on Vacanacy tables to BetaUser */
IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_Application' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_Application To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_ApprenticeshipFrameWorkAndOccupation' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_ApprenticeshipFrameWorkAndOccupation To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_ApprenticeshipStandard' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_ApprenticeshipStandard To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_Candidate' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_Candidate To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_CandidateDetails' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_CandidateDetails To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_EducationLevel' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_EducationLevel To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_Employer' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_Employer To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_LegalEntity' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_LegalEntity To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_Provider' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_Provider To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Va_Vacancy' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Va_Vacancy To BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Acc_Accounts' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Acc_Accounts To BetaUser
END;


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Acc_AccountLegalEntity' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Acc_AccountLegalEntity To BetaUser
END;


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Acc_LegalEntity' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Acc_LegalEntity To BetaUser
END;


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Comt_Apprenticeship' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Comt_Apprenticeship To BetaUser
END;

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Comt_Commitment' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.Comt_Commitment To BetaUser
END;

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='AR_Apprentice' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN     
	 GRANT SELECT ON ASData_PL.AR_Apprentice To BetaUser
END;

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='AR_Employer' AND TABLE_SCHEMA = 'AsData_PL')
BEGIN
     GRANT SELECT ON AsData_PL.AR_Employer TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DataDictionary' AND TABLE_SCHEMA = 'dbo')
BEGIN
	GRANT SELECT ON dbo.DataDictionary To BetaUser
End

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Users' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_Users TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_UserAccountLegalEntity' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_UserAccountLegalEntity TO BetaUser
END

/* Marketo Access */

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MarketoLeads' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.MarketoLeads TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MarketoLeadPrograms' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.MarketoLeadPrograms TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MarketoLeadActivities' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.MarketoLeadActivities TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MarketoCampaigns' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.MarketoCampaigns TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MarketoActivityTypes' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.MarketoActivityTypes TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='MarketoPrograms' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.MarketoPrograms TO BetaUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg')
BEGIN
     GRANT SELECT ON Stg.GA_SessionData TO BetaUser
END



/* Grant UNMASK to BetaUser */
--GRANT UNMASK TO [BetaUser]


/* Provide Users and UserAccountLegalEntity views access to Marketo Team that were designed for them */

IF DATABASE_PRINCIPAL_ID('MarketoUser') IS NULL
BEGIN
	CREATE ROLE [MarketoUser]
END


IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_Users' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_Users TO MarketoUser
END

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_UserAccountLegalEntity' AND TABLE_SCHEMA = 'ASData_PL')
BEGIN
     GRANT SELECT ON ASData_PL.DAS_UserAccountLegalEntity TO MarketoUser
END

/*stg.GA_SessionData changes */

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.Columns where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg' AND  COLUMN_NAME = 'EFSAToken')
BEGIN
	EXEC sp_rename 'Stg.GA_SessionData.EFSAToken', 'ESFAToken', 'COLUMN';  
End

IF NOT EXISTS(SELECT 1 from INFORMATION_SCHEMA.Columns where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg' AND  COLUMN_NAME = 'ID3')
BEGIN	
	    ALTER TABLE Stg.GA_SessionData ADD ID3  NVarchar(512)  NULL
End

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.Columns where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg' AND  COLUMN_NAME = 'Hits_Page_PagePath')
BEGIN
	ALTER TABLE [stg].[GA_SessionData] ALTER COLUMN [Hits_Page_PagePath] nvarchar(Max) NULL
End

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.Columns where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg' AND  COLUMN_NAME = 'Hits_Page_PagePathLevel1')
BEGIN
	ALTER TABLE [stg].[GA_SessionData] ALTER COLUMN [Hits_Page_PagePathLevel1] nvarchar(Max) NULL
End

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.Columns where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg' AND  COLUMN_NAME = 'Hits_Page_PagePathLevel2')
BEGIN
	ALTER TABLE [stg].[GA_SessionData] ALTER COLUMN [Hits_Page_PagePathLevel2] nvarchar(Max) NULL
End

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.Columns where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg' AND  COLUMN_NAME = 'Hits_Page_PagePathLevel3')
BEGIN
	ALTER TABLE [stg].[GA_SessionData] ALTER COLUMN [Hits_Page_PagePathLevel3] nvarchar(Max) NULL
End

IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.Columns where TABLE_NAME='GA_SessionData' AND TABLE_SCHEMA = 'Stg' AND  COLUMN_NAME = 'Hits_Page_PagePathLevel4')
BEGIN
	ALTER TABLE [stg].[GA_SessionData] ALTER COLUMN [Hits_Page_PagePathLevel4] nvarchar(Max) NULL
End

declare @VSQL1  NVarchar(4000) = 'update [Stg].[GA_SessionData] set ID3 = MarketoGUID'
EXEC SP_EXECUTESQL @VSQL1

set @VSQL1  = 'update [Stg].[GA_SessionData] set MarketoGUID = ESFAToken'
EXEC SP_EXECUTESQL @VSQL1

