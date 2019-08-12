CREATE PROCEDURE [dbo].[uSP_Import_Commitments_Db]
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
	   ,'uSP_Import_Commitments_Db'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

BEGIN TRANSACTION

/* Clear Existing Tables for Full Refresh */


TRUNCATE TABLE dbo.DataLockStatus
TRUNCATE TABLE dbo.Apprenticeship
TRUNCATE TABLE dbo.Commitment
TRUNCATE TABLE dbo.Provider
TRUNCATE TABLE dbo.Apprentice
TRUNCATE TABLE dbo.AssessmentOrganisation
TRUNCATE TABLE dbo.EmployerAccountLegalEntity
TRUNCATE TABLE dbo.EmployerAccount
TRUNCATE TABLE DBO.TrainingCourse
TRUNCATE TABLE dbo.Transfers

/* Load with Latest Data */

EXEC dbo.uSP_Import_Provider @RunId

EXEC dbo.uSP_Import_Employer @RunId

EXEC uSP_Import_Commitments @RunId

EXEC uSP_Import_Transfers @RunId

EXEC [dbo].[uSP_Import_Apprentice] @RunId

EXEC [dbo].[uSP_Import_TrainingCourse] @RunId

EXEC [dbo].[uSP_Import_AssessmentOrganisation] @RunId

EXEC [dbo].[uSP_Import_Apprenticeship] @RunId

EXEC [dbo].[uSP_Import_DataLockStatus] @RunId



COMMIT TRANSACTION

  
 
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
	    'uSP_Import_Commitments_Db',
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
