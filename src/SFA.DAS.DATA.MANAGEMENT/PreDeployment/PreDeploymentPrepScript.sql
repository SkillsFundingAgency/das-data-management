﻿
/* Drop previously created tables as part of POC - Tidy Up */



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'DataLoad_Log'
		      AND TABLE_SCHEMA=N'Mgmt'
	      )
DROP TABLE [Mgmt].[DataLoad_Log]




IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Deployment_Audit'
		      AND TABLE_SCHEMA=N'Mgmt'
	      )
DROP TABLE [Mgmt].[Deployment_Audit]


IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('dbo.Ext_Options') )
   DROP EXTERNAL TABLE dbo.Ext_Options
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Stg_FIU_GA_Feedback'
		      AND TABLE_SCHEMA=N'fdb'
	      )
DROP TABLE [fdb].[Stg_FIU_GA_Feedback]


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'JobProgress'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE Comt.JobProgress


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Message'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[Message]


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'PriceHistory'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[PriceHistory]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'TransferRequest'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[TransferRequest]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'IntegrationTestIds'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[IntegrationTestIds]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'History'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[History]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'DataLockStatus'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[DataLockStatus]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'CustomProviderPaymentPriority'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[CustomProviderPaymentPriority]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'BulkUpload'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[BulkUpload]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AssessmentOrganisation'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[AssessmentOrganisation]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Apprenticeship'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[Apprenticeship]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'ApprenticeshipUpdate'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[ApprenticeshipUpdate]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Commitment'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE [Comt].[Commitment]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Commitments_Metadata'
		      AND TABLE_SCHEMA=N'Mtd'
	      )
DROP TABLE [Mtd].Commitments_Metadata

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Metadata_GA_Hierarchy'
		      AND TABLE_SCHEMA=N'Mtd'
	      )
DROP TABLE [Mtd].Metadata_GA_Hierarchy


IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='usp_Manage_Commitments_Lookup'
              and ROUTINE_SCHEMA='Mtd'
		  )
DROP PROCEDURE Mtd.uSP_Manage_Commitments_Lookup

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='usp_Manage_GA_Hierarchy_Metadata'
              and ROUTINE_SCHEMA='Mtd'
		  )
DROP PROCEDURE Mtd.usp_Manage_GA_Hierarchy_Metadata


IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_UnitTest1_CheckCounts'
              and ROUTINE_SCHEMA='Mgmt'
		  )
DROP PROCEDURE mgmt.uSP_UnitTest1_CheckCounts

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Build_AS_DataMart'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Build_AS_DataMart]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Create_External_Tables'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Create_External_Tables]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Create_System_External_Tables'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Create_System_External_Tables]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Generate_RunId'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Generate_RunId]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_Apprentice'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_Apprentice]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_Apprenticeship'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_Apprenticeship]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_AssessmentOrganisation'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_AssessmentOrganisation]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_Commitments'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_Commitments]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_Commitments_Db'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_Commitments_Db]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_DataLockStatus'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_DataLockStatus]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_Employer'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_Employer]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_Provider'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_Provider]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_TrainingCourse'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_TrainingCourse]

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='uSP_Import_Transfers'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[uSP_Import_Transfers]

DROP VIEW IF EXISTS dbo.vw_CommitmentSummary ; 

DROP VIEW IF EXISTS vw_Commitments_Apprenticeship_Details;

DROP VIEW IF EXISTS dbo.vw_FIU_GA_Data ; 

DROP VIEW IF EXISTS dbo.vw_FIU_GA_Segmented_View;

/* Clear Previous Runs to allow Changing Run_Id to RunID */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Log_Record_Counts'
		      AND TABLE_SCHEMA=N'Mgmt'
	      )
DELETE LRC  FROM 
  Mgmt.Log_Record_Counts LRC
  WHERE RunId IN (SELECT RunId 
                    FROM Mgmt.Log_RunId
				   where StartDateTime<'2019-08-15')


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Log_Execution_Results'
		      AND TABLE_SCHEMA=N'Mgmt'
	      )
DELETE LER  FROM 
  Mgmt.Log_Execution_Results LER
  WHERE RunId IN (SELECT RunId 
                    FROM Mgmt.Log_RunId
				   where StartDateTime<'2019-08-15')

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Log_Error_Details'
		      AND TABLE_SCHEMA=N'Mgmt'
	      )
DELETE LED  FROM 
  Mgmt.Log_Error_Details LED
  WHERE RunId IN (SELECT RunId 
                    FROM Mgmt.Log_RunId
				   where StartDateTime<'2019-08-15')

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Log_RunId'
		      AND TABLE_SCHEMA=N'Mgmt'
	      )
DELETE LR  FROM 
  Mgmt.Log_RunId LR
  WHERE StartDateTime<'2019-08-15'


  /* Drop v1 Views before Decomissiong External Tables */

  
Declare @ViewName VARCHAR(256)
Declare @SchemaName varchar(25)
DECLARE @VSQL NVARCHAR(MAX)

Declare RemoveExtViews Cursor for
(
 
select sao.name, ss.name SchemaName
  from sys.sql_modules ssm
  join sys.all_objects sao
    on ssm.object_id=sao.object_id
  join sys.schemas ss
    on ss.schema_id=sao.schema_id
 where sao.name not like '%v2%'
   and SSM.definition like '%EXT_TBL%'
   and sao.type_desc='VIEW'
)
OPEN RemoveExtViews

FETCH NEXT FROM RemoveExtViews into @ViewName,@SchemaName

WHILE(@@FETCH_STATUS=0)
BEGIN

SET @VSQL='
IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='''+@ViewName+''' AND TABLE_SCHEMA = '''+@SchemaName+''')
DROP VIEW ['+@SchemaName+'].['+@ViewName+']
'
EXEC (@VSQL)
FETCH NEXT FROM RemoveExtViews into @ViewName,@SchemaName
END

CLOSE RemoveExtViews
DEALLOCATE RemoveExtViews


/* Drop Procedures that create v1 Views */

Declare @ProcName VARCHAR(256)

Declare RemoveExtProcs Cursor for
(
 
select sao.name, ss.name SchemaName
  from sys.sql_modules ssm
  join sys.all_objects sao
    on ssm.object_id=sao.object_id
  join sys.schemas ss
    on ss.schema_id=sao.schema_id
 where sao.name not like '%v2%'
   and SSM.definition like '%EXT_TBL%'
   and sao.type_desc='SQL_STORED_PROCEDURE'
   and sao.name <> 'Build_AS_DataMart'
)
OPEN RemoveExtProcs

FETCH NEXT FROM RemoveExtProcs into @ProcName,@SchemaName

WHILE(@@FETCH_STATUS=0)
BEGIN
SET @VSQL='
IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='''+@ProcName+'''
              and ROUTINE_SCHEMA='''+@SchemaName+'''
		  )
DROP PROCEDURE ['+@SchemaName+'].['+@ProcName+']
'
EXEC (@VSQL)
FETCH NEXT FROM RemoveExtProcs into @ProcName,@SchemaName
END

CLOSE RemoveExtProcs
DEALLOCATE RemoveExtProcs

/* Remove v1 External Tables */



Declare @ExtTable VARCHAR(256)
Declare @SchemaId varchar(25)
Declare RemoveExt Cursor
for
(SELECT et.name, et.Schema_Id, s.name as SchemaName
from sys.external_tables et
join sys.schemas s
  on et.schema_id=s.schema_id
where et.name like 'Ext_Tbl_%'
)

OPEN RemoveExt

FETCH NEXT FROM RemoveExt into @ExtTable,@SchemaId,@SchemaName

WHILE(@@FETCH_STATUS=0)
BEGIN
SET @VSQL='
IF EXISTS ( SELECT * FROM sys.external_tables WHERE name = '''+@ExtTable+''' and schema_id='+@SchemaId+') 
DROP EXTERNAL TABLE ['+@SchemaName+'].['+@ExtTable+']
'
EXEC (@VSQL)
FETCH NEXT FROM RemoveExt into @ExtTable,@SchemaId,@SchemaName
END

CLOSE RemoveExt
DEALLOCATE RemoveExt

-- Remove old schema version of DAS_TransactionLine as it's moved to ASData_PL.

if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_TransactionLine' and TABLE_SCHEMA = 'Data_Pub')
Drop View Data_Pub.DAS_TransactionLine


/* Clean AT */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'EAU_UserAccountSettings'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE [ASData_PL].EAU_UserAccountSettings



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'EAUser_User'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.EAUser_User


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Account'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.Account


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AccountLegalEntity'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.AccountLegalEntity


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AccountUserRole'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.AccountUserRole


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'EmployerAgreement'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.EmployerAgreement


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'LegalEntity'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.LegalEntity

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'UserAccountSettings'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.UserAccountSettings


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AsDataPL_AccountUserRole'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.AsDataPL_AccountUserRole


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AsDataPL_EmployerAgreementStatus'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.AsDataPL_EmployerAgreementStatus

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AsDataPL_Va_LegalEntity'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.AsDataPL_Va_LegalEntity


/* Drop Tables that are no longer used */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'DataLockStatus'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.DataLockStatus

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Apprenticeship'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.Apprenticeship


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Commitment'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.Commitment


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Provider'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.Provider


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Apprentice'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.Apprentice

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AssessmentOrganisation'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.AssessmentOrganisation


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'EmployerAccountLegalEntity'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.EmployerAccountLegalEntity


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'EmployerAccount'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.EmployerAccount

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'TrainingCourse'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.TrainingCourse


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Transfers'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.Transfers


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'Stg_FIC_Feedback'
		      AND TABLE_SCHEMA=N'dbo'
	      )
DROP TABLE dbo.Stg_FIC_Feedback

/* Drop EI_Accounts Table as the same data exists in Acc_Accounts Table */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'EI_Accounts'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE ASData_PL.EI_Accounts


/* Drop GA_SessionData Table as the same new versioned table deployed GA_SessionDataDetail */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'GA_SessionData'
		      AND TABLE_SCHEMA=N'Stg'
	      )
DROP TABLE [Stg].[GA_SessionData]

/* Drop Salt Key Log and move to a different schema */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'SaltKeyLog'
		      AND TABLE_SCHEMA=N'AsData_PL'
	      )
DROP TABLE [ASData_PL].[SaltKeyLog]

/* Drop App Redundancy Stored Proc */


IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='ImportAppRedundancyToPL'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[ImportAppRedundancyToPL]

/* Drop Spend Control Temp Proc */

IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES
            where ROUTINE_NAME='ImportSpendControlToStgTemp'
              and ROUTINE_SCHEMA='dbo'
		  )
DROP PROCEDURE [dbo].[ImportSpendControlToStgTemp]

/* Drop Temporary Staging Tables */


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'SpendControl_v2'
		      AND TABLE_SCHEMA=N'Stg'
	      )
DROP TABLE [Stg].[SpendControl_v2]


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'SpendControlNonLevy_v2'
		      AND TABLE_SCHEMA=N'Stg'
	      )
DROP TABLE [Stg].[SpendControlNonLevy_v2]

