﻿
CREATE PROCEDURE uSP_Create_External_Tables
(
   @ExternalDataSource Varchar(255),
   @SysTableName varchar(255),
   @SchemaName Char(4),
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Dynamically Creates External Tables
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

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
	   ,'uSP_Create_External_Tables'+'-'+@ExternalDataSource
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

 DECLARE @PrepareSQL nvarchar(max)
 DECLARE @ExecuteSQL nvarchar(max)
 SET @EXECUTESQL=''

 SET @PrepareSQL ='
 SELECT @Result= (
 SELECT DISTINCT '' ''+  ''IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID('''''+@SchemaName+'.Ext_Tbl_''+so.table_name+'''''') ) DROP EXTERNAL TABLE '+@SchemaName+'.Ext_Tbl_''+so.table_name+'' CREATE EXTERNAL TABLE '+@SchemaName+'.Ext_Tbl_'' + so.TABLE_NAME + '' ('' + o.list + '')'' 
				 +'' WITH (Data_Source=['+@ExternalDataSource+'],Schema_Name=''''''+so.Table_Schema+'''''',Object_Name=''''''+so.table_name+'''''')''
  FROM '+@SchemaName+'.'+@SysTableName+' so
 CROSS APPLY
   (SELECT STUFF ((SELECT '',''+
           ''  [''+column_name+''] '' + 
           data_type + case data_type
           when ''sql_variant'' then ''''
           when ''text'' then ''''
           when ''ntext'' then ''''
           when ''xml'' then ''''
           when ''decimal'' then ''('' + cast(numeric_precision as varchar) + '', '' + cast(numeric_scale as varchar) + '')''
           else coalesce(''(''+case when character_maximum_length = -1 then ''MAX'' else cast(character_maximum_length as varchar) end +'')'','''') end + '' '' +
           + '' '' +
           (case when IS_NULLABLE = ''No'' then ''NOT '' else '''' end ) + ''NULL '' 
     FROM  '+@SchemaName+'.'+@SysTableName+'
    WHERE  table_name = so.table_name
    ORDER  BY ordinal_position
      FOR  XML PATH('''')),1,1,'''')) o (list)
 WHERE so.table_schema<>''sys''
  FOR XML PATH(''''))
  '
 
 
 EXEC SP_EXECUTESQL @PrepareSQL,N'@Result varchar(max) out',@ExecuteSQL OUT

 EXEC SP_EXECUTESQL @ExecuteSQL

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
	    'uSP_Create_External_Tables'+'-'+@ExternalDataSource AS ErrorProcedure,
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
