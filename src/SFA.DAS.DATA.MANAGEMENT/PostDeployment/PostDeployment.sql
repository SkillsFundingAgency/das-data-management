/* Execute Stored Procedure */

EXEC [dbo].[Build_AS_DataMart]


/* Grant Permissions to Roles */


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

IF EXISTS(select 1 from sys.views where name='Das_Commitments' and type='v')
GRANT SELECT ON Data_Pub.Das_Commitments TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Account_Transfers' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_PayeSchemes' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_PayeSchemes TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_LegalEntities' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_LegalEntities TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Accounts' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Accounts TO Developer

IF EXISTS(select 1 from sys.views where name='DAS_Employer_Transfer_Relationship' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Transfer_Relationship TO Developer

IF DATABASE_PRINCIPAL_ID('DataAnalyst') IS NULL
BEGIN
	CREATE ROLE [DataAnalyst]
END

if exists(select 1 from sys.views where name='Das_Commitments' and type='v')
GRANT SELECT ON Data_Pub.Das_Commitments TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Account_Transfers' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Account_Transfers TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_PayeSchemes' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_PayeSchemes TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_LegalEntities' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_LegalEntities TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Accounts' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Accounts TO DataAnalyst

if exists(select 1 from sys.views where name='DAS_Employer_Transfer_Relationship' and type='v')
GRANT SELECT ON Data_Pub.DAS_Employer_Transfer_Relationship TO DataAnalyst
