CREATE PROCEDURE [dbo].[LoadCandidateGendrLookUp]
(
   @RunId int
)
AS

-- =======================================================
-- Author:      Manju Nagarajan
-- Create Date: 21/11/2022
-- Description: Load Candidate Gender Reference Data
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
	   ,'LoadCandidateGendrLookUp'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='LoadCandidateGendrLookUp'
     AND RunId=@RunID


IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION
TRUNCATE TABLE Stg.CandidateGenderConfig


/* RAAv2 */

INSERT INTO Stg.CandidateGenderConfig
(SourceDb,Category,ShortCode)
VALUES
('RAAv2','Unknown',0),
('RAAv2','Male',1),
('RAAv2','Female',2),
('RAAv2','Other',3),
('RAAv2','PreferNotToSay',4),
('FAAV2','Male',1),
('FAAv2','Female',2),
('FAAv2','PreferNotToSay',3)

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
	    'LoadCandidateGendrLookUp',
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
