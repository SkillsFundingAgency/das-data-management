CREATE PROCEDURE [dbo].[ImportEmployerFeedbackStgToLive]
(
   @RunId int
)
AS

-- ============================================================================================
-- Author:      Sarma Evani
-- Create Date: 31/03/2021
-- Description: Import Employer Feedback Staging to LIVE 
-- ============================================================================================

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
	   ,'Step-5'
	   ,'ImportProvideEmployerFeedbackStgToLive'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportProvideEmployerFeedbackStgToLive'
     AND RunId=@RunID

  /* Get Employer Feedback From Staging to Live Tables, Apply Transformation Rules */

   
BEGIN TRANSACTION

				DELETE FROM [ASData_PL].[PFBE_EmployerFeedback]

				--INSERT INTO [ASData_PL].[PFBE_EmployerFeedback]
				--		   ([EmployerFeedbackBinaryId]
				--		   ,[Ukprn]
				--		   ,[AccountId]
				--		   ,[DatetimeCompleted]
				--		   ,[FeedbackName]
				--		   ,[FeedbackValue]
				--		   ,[ProviderRating]
				--		   ,[RunId])	
				--	SELECT [id]
				--		  ,[Ukprn]
				--		  ,[AccountId]
				--		  ,[DatetimeCompleted]
				--		  ,[FeedbackName]
				--		  ,[FeedbackValue]
				--		  ,[ProviderRating]
				--		  ,@RunId					
				--	  FROM [Stg].[PFBE_EmployerFeedback]

COMMIT TRANSACTION

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
	  ,ErrorADFTaskType
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'ImportProvideEmployerFeedbackStgToLive',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId,
		'ImportProvideEmployerFeedbackToLive'; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH