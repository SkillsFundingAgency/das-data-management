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


EXEC dbo.uSP_Create_External_Tables 'Ext_Tbl_InfSch_Commitments','comtDBConnection',@RunId