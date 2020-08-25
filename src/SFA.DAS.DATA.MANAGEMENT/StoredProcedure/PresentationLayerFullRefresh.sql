CREATE PROCEDURE [dbo].[PresentationLayerFullRefresh]
(
   @RunId int
  ,@PLTableName varchar(255)
  ,@StgTableName varchar(255)
  ,@ColumnList varchar(max)
)
AS
/* ===============================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/08/2020
-- Description: Dynamically Refresh Data Mart Presentation Layer
--              This is built dynamically such that it can be used for any Full Refresh of Presentation Layer.
-- ===============================================================================================================
*/

BEGIN TRY


DECLARE @LogID int
DECLARE @SPName Varchar(255)

select @SPName = 'PresentationLayerFullRefresh'+SUBSTRING(@PLTableName,CHARINDEX('.',@PLTableName)+1,LEN(@PLTableName))

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
	   ,'Step-4'
	   ,@SPName
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName=@SPName
     AND RunId=@RunID

BEGIN TRANSACTION

Declare @VSQL1 NVARCHAR(MAX)

SET @VSQL1=

'
DELETE FROM '+@PLTableName+'

INSERT INTO '+@PLTableName+'
('+@ColumnList+')
SELECT '+@ColumnList+'
  FROM '+@StgTableName+'
'

EXEC SP_EXECUTESQL @VSQL1

COMMIT TRANSACTION

/* Drop Staging Table */

DECLARE @VSQL2 NVARCHAR(MAX)
Declare @TableName Varchar(255)
SELECT @TableName=SUBSTRING(@StgTableName,CHARINDEX('.',@StgTableName)+1,LEN(@StgTableName))

SET @VSQL2=
'
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'''+@TableName+''' AND TABLE_SCHEMA=N''Stg'') 
DROP TABLE [Stg].'+@TableName+'
'
EXEC SP_EXECUTESQL @VSQL2


UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

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
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    @SPName,
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


		  

