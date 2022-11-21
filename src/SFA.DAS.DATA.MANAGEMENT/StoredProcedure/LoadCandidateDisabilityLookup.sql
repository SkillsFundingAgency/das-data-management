﻿CREATE PROCEDURE [dbo].[LoadCandidateDisabilityLookUp]
(
   @RunId int
)
AS

-- =======================================================
-- Author:      Manju Nagarajan
-- Create Date: 21/11/2022
-- Description: Load Candidate Disability Reference Data
-- =======================================================

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
	   ,'Step-3'
	   ,'LoadCandidateDisabilityLookUp'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='LoadCandidateDisabilityLookUp'
     AND RunId=@RunID


IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION
DELETE FROM Stg.CandidateDisabilityConfig


/* RAAv2 */

INSERT INTO Stg.CandidateDisabilityConfig
(SourceDb,Category,ShortCode)
VALUES
('RAAv2','Unknown',0),
('RAAv2','Yes',1),
('RAAv2','No',2),
('RAAv2','PreferNotToSay',3)

COMMIT TRANSACTION
END

/* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
	    'LoadCandidateDisabilityLookUp',
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
