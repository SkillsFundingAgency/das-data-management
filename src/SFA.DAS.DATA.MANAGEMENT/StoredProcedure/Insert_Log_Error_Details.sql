CREATE PROCEDURE [dbo].[InsertLogErrorDetails]
(
   @RunId int
  ,@TaskType varchar(256)
  ,@ErrorMessage varchar(256)
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 01/04/2020
-- Description: Stored Procedure to Log Error
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

 DECLARE @ErrorId int

 SELECT @LogID = MAX(LogID)
   FROM Mgmt.Log_Execution_Results
  WHERE StoredProcedureName='DataFactory'
    AND ADFTaskType=@TaskType

  INSERT INTO Mgmt.Log_Error_Details
	  (
	   ErrorProcedure
	  ,ErrorADFTaskType
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        
	    'DataFactory',
		@TaskType,
	    @ErrorMessage,
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

   END TRY
BEGIN CATCH

SELECT  SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    ERROR_MESSAGE()
END CATCH