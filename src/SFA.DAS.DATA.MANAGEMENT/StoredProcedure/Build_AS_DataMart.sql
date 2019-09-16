CREATE PROCEDURE [dbo].[Build_AS_DataMart]
AS
-- ==========================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Master Stored Proc that builds AS DataMart
-- ==========================================================

/* Generate Run Id for Logging Execution */

DECLARE @RunId int

EXEC @RunId= dbo.GenerateRunId

EXEC CreateSystemExternalTables 'comtDBConnection','Commitments','Comt',@RunId

EXEC CreateExternalTables 'comtDBConnection','Ext_Tbl_InfSch_Commitments','Comt',@RunId

EXEC CreateSystemExternalTables 'rsrvDBConnection','Reservations','Resv',@RunId

EXEC CreateExternalTables 'rsrvDBConnection','Ext_Tbl_InfSch_Reservations','Resv',@RunId

EXEC CreateSystemExternalTables 'easfinDBConnection','Finance','Fin',@RunId

EXEC CreateExternalTables 'easfinDBConnection','Ext_Tbl_InfSch_Finance','Fin',@RunId

EXEC CreateSystemExternalTables 'usersDBConnection','Users','EAUser',@RunId

EXEC CreateExternalTables 'usersDBConnection','Ext_Tbl_InfSch_Users','EAUser',@RunId

EXEC CreateSystemExternalTables 'easAccDBConnection','Account','Acct',@RunId

EXEC CreateExternalTables 'easAccDBConnection','Ext_Tbl_InfSch_Account','Acct',@RunId

EXEC CreateCommitmentsView @RunId

EXEC CreateEmployerAccountTransfersView @RunId 

EXEC CreateEmployerPAYESchemesView @RunId 


/* Load Commitments into Modelled Data Tables */

EXEC ImportCommitmentsDb @RunId




