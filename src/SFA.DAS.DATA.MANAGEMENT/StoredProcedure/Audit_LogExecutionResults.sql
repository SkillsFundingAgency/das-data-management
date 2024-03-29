﻿CREATE PROCEDURE [dbo].[Audit_LogExecutionResults]
@RunId BIGINT,
@StepNo VARCHAR(100) = NULL,
@StoredProcedureName VARCHAR(100),
@ADFTaskType VARCHAR(256),
@Execution_Status BIT = 0
AS
BEGIN TRY

DECLARE @LogID BIGINT

INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,ADFTaskType
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
       @RunId
	   ,@StepNo 
	   ,@StoredProcedureName
	   ,@ADFTaskType
	   ,getdate()
	   ,@Execution_Status

SELECT MAX(LogId) as LogId FROM [Mgmt].[Log_Execution_Results] 

END TRY

BEGIN CATCH

  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'Audit_LogExecutionResults' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE()
		;


/* Update Log Execution Results as Fail if there is an Error*/

END CATCH
GO


