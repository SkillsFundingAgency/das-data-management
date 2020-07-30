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

GRANT SELECT ON dbo.Apprentice To Developer

GRANT SELECT ON dbo.Apprenticeship To Developer

GRANT SELECT ON dbo.AssessmentOrganisation To Developer

GRANT SELECT ON dbo.Commitment To Developer

GRANT SELECT ON dbo.DataLockStatus To Developer

GRANT SELECT ON dbo.EmployerAccount To Developer

GRANT SELECT ON dbo.EmployerAccountLegalEntity To Developer

GRANT SELECT ON dbo.Provider To Developer

GRANT SELECT ON dbo.TrainingCourse To Developer

GRANT SELECT ON dbo.Transfers To Developer

GRANT SELECT ON dbo.[ReferenceData] To Developer

GRANT SELECT ON [dbo].[DASCalendarMonth] To Developer

GRANT SELECT ON dbo.Payments_SS TO Developer

GRANT SELECT ON dbo.SourceDbChanges TO Developer

GRANT UNMASK TO Developer




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
