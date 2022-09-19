
CREATE PROCEDURE dbo.UpdateRAAVacancyReviews
    @RunId int
AS 
BEGIN TRY

SET NOCOUNT ON

 DECLARE @LogID int

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
	   ,'UpdateRAAVacancyReviews'
	   ,getdate()
	   ,0


  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='UpdateRAAVacancyReviews'
     AND RunId=@RunID

BEGIN TRANSACTION

UPDATE Stg.RAA_VacancyReviews
SET ReviewedByUserEmail = LEFT(ReviewedByUserEmail, CHARINDEX('@', ReviewedByUserEmail)-1)
Where ReviewedByUserEmail is not null

COMMIT TRANSACTION
 
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

			-- this is to make sure staging doesnt have any PII data if the Update statement fails
			TRUNCATE TABLE Stg.RAA_VacancyReviews

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
				'UpdateRAAVacancyReviews',
				ERROR_MESSAGE(),
				GETDATE(),
				@RunId as RunId,
				'UpdateRAAVacancyReviews'; 

		  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

		/* Update Log Execution Results as Fail if there is an Error*/

		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=0
			  ,EndDateTime=getdate()
			  ,ErrorId=@ErrorId
		 WHERE LogId=@LogID
		   AND RunID=@RunId

  END CATCH
