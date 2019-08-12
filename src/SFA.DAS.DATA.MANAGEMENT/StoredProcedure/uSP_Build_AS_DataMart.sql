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

EXEC uSP_Create_System_External_Tables 'comtDBConnection','Commitments','Comt',@RunId

EXEC dbo.uSP_Create_External_Tables 'comtDBConnection','Ext_Tbl_InfSch_Commitments','Comt',@RunId

EXEC uSP_Create_System_External_Tables 'rsrvDBConnection','Reservations','Resv',@RunId

EXEC dbo.uSP_Create_External_Tables 'rsrvDBConnection','Ext_Tbl_InfSch_Reservations','Resv',@RunId

EXEC uSP_Create_System_External_Tables 'easfinDBConnection','Finance','Fin',@RunId

EXEC dbo.uSP_Create_External_Tables 'easfinDBConnection','Ext_Tbl_InfSch_Finance','Fin',@RunId

EXEC uSP_Create_System_External_Tables 'usersDBConnection','Users','EAUser',@RunId

EXEC dbo.uSP_Create_External_Tables 'usersDBConnection','Ext_Tbl_InfSch_Users','EAUser',@RunId

EXEC uSP_Create_System_External_Tables 'easAccDBConnection','Account','Acct',@RunId

EXEC dbo.uSP_Create_External_Tables 'easAccDBConnection','Ext_Tbl_InfSch_Account','Acct',@RunId


/* Load Commitments into Modelled Data Tables */

EXEC uSP_Import_Commitments_Db @RunId




