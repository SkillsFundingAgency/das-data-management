
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



/* Clear IF Exists External Tables created as part of POC */

Declare @ExtTable VARCHAR(256)
Declare RemoveExt Cursor
for
(SELECT name
from sys.external_tables
where name like 'Ext_Tbl_%'
)

OPEN RemoveExt

FETCH NEXT FROM RemoveExt into @ExtTable

WHILE(@@FETCH_STATUS=0)
BEGIN
DECLARE @VSQL NVARCHAR(MAX)
SET @VSQL='
IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('''+@ExtTable+''') ) 
DROP EXTERNAL TABLE ['+@ExtTable+']
'
EXEC (@VSQL)
FETCH NEXT FROM RemoveExt into @ExtTable
END

CLOSE RemoveExt
DEALLOCATE RemoveExt

-- Remove old schema version of DAS_TransactionLine as it's moved to ASData_PL.

if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='DAS_TransactionLine' and TABLE_SCHEMA = 'Data_Pub')
Drop View Data_Pub.DAS_TransactionLine




