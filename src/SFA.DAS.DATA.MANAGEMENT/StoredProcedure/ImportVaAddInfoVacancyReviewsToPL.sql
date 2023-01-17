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

DELETE FROM ASData_PL.va_VacancyReviews

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
	RVR.EmployerAccountId
      ,vc.CandidateId
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.CreatedTimeStamp)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.SubmittedTimeStamp)
	  ,rvr.VacancyReference
	  ,vv.VacancyId
	  ,rvr.ManualOutcome
	  ,CASE WHEN ManualQaFieldChangeRequested='true' THEN rvr.ManualQaFieldIndicator ELSE NULL END
	  ,CASE WHEN ManualQaFieldChangeRequested='true' THEN rvr.ManualQaFieldChangeRequested ELSE NULL END
	  ,CASE WHEN ManualQaFieldChangeRequested='true' THEN rvr.ManualQaComment ELSE NULL END	
	  ,rvr.SubmissionCount
    ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ReviewedDate)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ClosedDate)	 
	  ,rvr.ReviewedByUserEmail
    ,dbo.Fn_ConvertTimeStampToDateTime(rvr.SlaDeadline)   
    ,rvr.Status
	  ,RVR.BinaryId
	  ,'RAAv2'
  FROM Stg.RAA_VacancyReviews RVR
  LEFT
  JOIN ASData_PL.Va_Vacancy vv
    on vv.VacancyReferenceNumber=RVR.VacancyReference
  LEFT
  JOIN ASData_PL.Va_Candidate vc
    on vc.CandidateGuid=RVR.UserId
where ManualQaFieldChangeRequested='true'

  UNION all
  SELECT 
  DISTINCT
	RVR.EmployerAccountId
      ,vc.CandidateId
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.CreatedTimeStamp)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.SubmittedTimeStamp)
	  ,rvr.VacancyReference
	  ,vv.VacancyId
	  ,rvr.ManualOutcome
	  ,NULL 
	  ,NULL 
	  ,NULL 	
	  ,rvr.SubmissionCount
    ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ReviewedDate)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ClosedDate)	 
	  ,rvr.ReviewedByUserEmail
    ,dbo.Fn_ConvertTimeStampToDateTime(rvr.SlaDeadline)   
    ,rvr.Status
	  ,RVR.BinaryId
	  ,'RAAv2'
  FROM Stg.RAA_VacancyReviews RVR
  LEFT
  JOIN ASData_PL.Va_Vacancy vv
    on vv.VacancyReferenceNumber=RVR.VacancyReference
  LEFT
  JOIN ASData_PL.Va_Candidate vc
    on vc.CandidateGuid=RVR.UserId  
Where not exists (select 1 from (select BinaryId from Stg.RAA_VacancyReviews where ManualQaFieldChangeRequested='true') vr where vr.BinaryId=rvr.BinaryId )

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
