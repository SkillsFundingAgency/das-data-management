CREATE PROCEDURE [dbo].[ImportVaAddInfoVacancyReviewsToPL]
(
   @RunId int
)
AS

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

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
	   ,'Step-6'
	   ,'ImportVaAddInfoVacancyReviewsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoVacancyReviewsToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.va_VacancyReviews

/* Insert all the unsuccessful outcomes first with a reason */

INSERT INTO ASData_PL.va_VacancyReviews
(EmployerAccountId 
  ,CandidateId 
  ,CreatedDateTime 
  ,SubmittedDateTime 
  ,VacancyReference 
  ,VacancyId 
  ,ManualOutcome   
  ,ManualQaFieldIndicator 
  ,ManualQaFieldChangeRequested 
  ,ManualQaComment 
  ,SubmissionCount
  ,ReviewedDate
  ,ClosedDate  
  ,ReviewedByUser
  ,SlaDeadline
  ,Status
  ,SourceVacancyReviewId 
  ,SourceDb 
  )
SELECT 
	RVR.AccountId
	  ,NULL as CandidateId
	  ,RVR.CreatedDate
	  ,NULL as SubmittedDateTime
	  ,RVR.VacancyReference
	  ,vv.VacancyId
	  ,RVR.ManualOutcome
	  ,RVR.ManualQaFieldIndicators
	  ,CASE WHEN RVR.ManualQaFieldIndicators IS NOT NULL THEN 'true' ELSE 'false' END
	  ,RVR.ManualQaComment	
	  ,RVR.SubmissionCount
    ,RVR.ReviewedDate
	  ,RVR.ClosedDate	 
	  ,RVR.ReviewedByUserEmail
    ,RVR.SlaDeadline   
    ,RVR.Status
	  ,RVR.Id as SourceVacancyReviewId
	  ,'RCRT'
  FROM Stg.RCRT_VacancyReview RVR
  LEFT
  JOIN ASData_PL.Va_Vacancy vv
    on vv.VacancyReferenceNumber=RVR.VacancyReference

COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

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
	    'ImportVaAddInfoVacancyReviewsToPL',
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
