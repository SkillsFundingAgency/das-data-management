CREATE PROCEDURE [dbo].[uSP_Build_AS_DataMart]
AS
-- ==========================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Master Stored Proc that builds AS DataMart
-- ==========================================================

/* Generate Run Id for Logging Execution */

DECLARE @RunId int

EXEC @RunId= dbo.uSP_Generate_RunId

EXEC uSP_Create_System_External_Tables 'comtDBConnection','Commitments',@RunId

EXEC uSP_Create_System_External_Tables 'easAccDBConnection','Accounts',@RunId

EXEC dbo.uSP_Create_External_Tables 'comtDBConnection','Ext_Tbl_InfSch_Commitments',@RunId

EXEC dbo.uSP_Create_External_Tables 'easAccDBConnection','Ext_Tbl_InfSch_Accounts',@RunId

EXEC dbo.uSP_Import_Provider @RunId

