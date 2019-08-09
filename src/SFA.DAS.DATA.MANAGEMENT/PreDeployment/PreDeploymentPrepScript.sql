
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
              and ROUTINE_SCHEMA='Mtd'
		  )
DROP PROCEDURE mgmt.uSP_UnitTest1_CheckCounts


DROP VIEW IF EXISTS dbo.vw_CommitmentSummary ; 

DROP VIEW IF EXISTS vw_Commitments_Apprenticeship_Details;

DROP VIEW IF EXISTS dbo.vw_FIU_GA_Data ; 

DROP VIEW IF EXISTS dbo.vw_FIU_GA_Segmented_View;


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
DROP EXTERNAL TABLE '''+@ExtTable+'''
'
PRINT @VSQL
FETCH NEXT FROM RemoveExt into @ExtTable
END

CLOSE RemoveExt
DEALLOCATE RemoveExt

--IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
--            WHERE TABLE_NAME = N'Commitment'
--		      AND TABLE_SCHEMA=N'Comt'
--	      )
--DROP TABLE  [Comt].[Commitment]




--IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
--            WHERE TABLE_NAME = N'Apprenticeship'
--		      AND TABLE_SCHEMA=N'Comt'
--	      )
--DROP TABLE [Comt].[Apprenticeship]

	
--DROP SCHEMA IF EXISTS fdb;

--Drop Table dbo.[Deployment_Audit]

--Drop Procedure dbo.uSP_UnitTest1_CheckCounts