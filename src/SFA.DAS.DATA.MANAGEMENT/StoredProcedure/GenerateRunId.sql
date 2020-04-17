CREATE PROCEDURE [dbo].[GenerateRunId]
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Generates RunId which will be used for logging Execution
-- =========================================================================
BEGIN TRY

/* Generate Run Id by inserting startdatetime into Log_RunId */

DECLARE @RunId bigint
DECLARE @DateStamp VARCHAR(10)
DECLARE @LogID int

INSERT INTO [Mgmt].[Log_RunId]
(StartDateTime)
Values(GETDATE())

SELECT @RunId=MAX(RunId) FROM [Mgmt].[Log_RunId]

select @DateStamp =  CAST(CAST(YEAR(GETDATE()) AS VARCHAR)+RIGHT('0' + RTRIM(cast(MONTH(getdate()) as varchar)), 2) +RIGHT('0' +RTRIM(CAST(DAY(GETDATE()) AS VARCHAR)),2) as int)

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,EndDateTime
	   ,Execution_Status
	   ,FullJobStatus
	  )
  SELECT 
        @RunId
	   ,'Step-1'
	   ,'GenerateRunId'
	   ,getdate()
	   ,getdate()
	   ,1
	   ,'Pending'


RETURN (@RunId)

END TRY

BEGIN CATCH

  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'GenerateRunId' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE()
		;


/* Update Log Execution Results as Fail if there is an Error*/

END CATCH
GO


