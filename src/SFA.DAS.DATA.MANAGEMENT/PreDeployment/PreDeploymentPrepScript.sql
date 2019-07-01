
/* Drop previously created tables - Tidy Up */

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
            WHERE TABLE_NAME = N'Commitment'
		      AND TABLE_SCHEMA=N'Comt'
	      )
DROP TABLE  [Comt].[Commitment]




--IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
--            WHERE TABLE_NAME = N'Apprenticeship'
--		      AND TABLE_SCHEMA=N'Comt'
--	      )
--DROP TABLE [Comt].[Apprenticeship]

	
--DROP SCHEMA IF EXISTS fdb;

--Drop Table dbo.[Deployment_Audit]

--Drop Procedure dbo.uSP_UnitTest1_CheckCounts