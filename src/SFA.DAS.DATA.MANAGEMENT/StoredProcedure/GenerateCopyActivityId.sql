CREATE PROCEDURE [dbo].[GenerateCopyActivityId] 
(@RunId bigint,@SourceDb Varchar(255),@Category varchar(256))
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 27/07/2020
-- Description: Generates CopyActivity Id 
-- =========================================================================
BEGIN TRY


DECLARE @LogID BIGINT
DECLARE @CAID BIGINT

INSERT INTO Stg.CopyActivity
(RunId,SourceDb,Category)
Values(@RunId,@SourceDb,@Category)

SELECT @CAID=NID FROM Stg.CopyActivity Where ID = (SELECT MAX(ID) FROM Stg.CopyActivity)


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
	   ,'Step-3'
	   ,'GenerateCopyActivityId'
	   ,getdate()
	   ,getdate()
	   ,1
	   ,'Pending'


RETURN (@CAID)

END TRY

BEGIN CATCH

  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'GenerateCopyActivityId' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE()
		;


/* Update Log Execution Results as Fail if there is an Error*/

END CATCH
GO


