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

IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('dbo.Ext_Tbl_InfSch_Accounts') )
DROP EXTERNAL TABLE dbo.Ext_Tbl_InfSch_Accounts

CREATE EXTERNAL TABLE [dbo].Ext_Tbl_InfSch_Accounts (  
   Table_Catalog nvarchar(128),
   Table_Schema nvarchar(128),
   Table_Name nvarchar(128) not null,
   Column_Name nvarchar(128) null,
   Ordinal_Position int null,
   Column_Default nvarchar(4000) null,
   Is_Nullable varchar(3) NULL,
   Data_Type nvarchar(128) NULL,
   Character_Maximum_Length int null,
   Character_Octet_Length int null,
   Numeric_Precision tinyint null,
   Numeric_Precision_Radix smallint null,
   Numeric_Scale int null,
   Datetime_Precision smallint null,
   Character_Set_Catalog nvarchar(128) null,
   Character_Set_Schema nvarchar(128) null,
   Character_Set_Name nvarchar(128) null,
   Collation_Catalog nvarchar(128) null,
   Collation_Schema nvarchar(128) null,
   Collation_Name nvarchar(128) null,
   Domain_Catalog nvarchar(128) null,
   Domain_Schema nvarchar(128) null,
   Domain_Name nvarchar(128) null
)  
WITH (Data_Source=['EasAccDBConnection'],Schema_Name='Information_Schema',Object_Name='Columns')

EXEC dbo.uSP_Create_External_Tables 'comtDBConnection','Ext_Tbl_InfSch_Commitments',@RunId

EXEC dbo.uSP_Create_External_Tables 'EasAccDBConnection','Ext_Tbl_InfSch_Accounts',@RunId

EXEC dbo.uSP_Import_Provider @RunId

