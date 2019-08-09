CREATE PROCEDURE uSP_Create_System_External_Tables
(
   @ExternalDataSource Varchar(255),
   @DatabaseName varchar(255),
   @SchemaName varchar(255),
   @RunId int
)
AS

-- ============================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Dynamically Creates System External Tables which will then be used for Dynamically Creating
--              Actual External Tables.
-- ============================================================================================================

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

 SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

 /* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-1'
	   ,'uSP_Create_System_External_Tables'+'-'+@DatabaseName
	   ,getdate()
	   ,0



 DECLARE @ExecuteSQL nvarchar(max)
 SET @EXECUTESQL=''

 SET @ExecuteSQL ='
 IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('''+@SchemaName+'.Ext_Tbl_InfSch_'+@DatabaseName+''') )
DROP EXTERNAL TABLE '+@SchemaName+'.Ext_Tbl_InfSch_'+@DatabaseName+'

CREATE EXTERNAL TABLE '+@SchemaName+'.Ext_Tbl_InfSch_'+@DatabaseName+' (  
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
WITH (Data_Source=['+@ExternalDataSource+'],Schema_Name=''Information_Schema'',Object_Name=''Columns'')
  '
 
 EXEC SP_EXECUTESQL @ExecuteSQL
 --PRINT @PrepareSQL

 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,Run_Id
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'uSP_Create_System_External_Tables'+'-'+@DatabaseName AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH

GO
