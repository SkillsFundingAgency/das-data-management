CREATE PROCEDURE [dbo].[ImportCommitmentsDb]
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import Data from Commitments Database
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
	   ,'Step-2'
	   ,'ImportCommitmentsDb'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportCommitmentsDb'
     AND RunId=@RunID
  


/* Clear Existing Tables for Full Refresh */


DELETE FROM dbo.DataLockStatus
DELETE FROM dbo.Apprenticeship
DELETE FROM dbo.Commitment
DELETE FROM dbo.Provider
DELETE FROM dbo.Apprentice
DELETE FROM dbo.AssessmentOrganisation
DELETE FROM dbo.EmployerAccountLegalEntity
DELETE FROM dbo.EmployerAccount
DELETE FROM DBO.TrainingCourse
DELETE FROM dbo.Transfers

/* Load with Latest Data */

EXEC dbo.ImportProvider @RunId

EXEC dbo.ImportEmployer @RunId

EXEC ImportCommitments @RunId

EXEC ImportTransfers @RunId

EXEC ImportApprentice @RunId

EXEC ImportTrainingCourse @RunId

EXEC ImportAssessmentOrganisation @RunId

EXEC ImportApprenticeship @RunId

EXEC ImportDataLockStatus @RunId




  
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH

 IF @@TRANCOUNT > 0
  ROLLBACK TRAN

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
	    'ImportCommitmentsDb',
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
