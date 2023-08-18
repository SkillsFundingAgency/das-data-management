CREATE PROCEDURE [dbo].[Audit_LogExecutionSuccess]
@RunId BIGINT,
@LogId BIGINT,
@FullJobStatus VARCHAR(256) = 'Pending'
AS
BEGIN TRY

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus=@FullJobStatus
 WHERE LogId=@LogID
   AND RunID=@RunId

END TRY

BEGIN CATCH

  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'Audit_LogExecutionSuccess' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE()
		;
/* Update Log Execution Results as Fail if there is an Error*/

END CATCH
GO
