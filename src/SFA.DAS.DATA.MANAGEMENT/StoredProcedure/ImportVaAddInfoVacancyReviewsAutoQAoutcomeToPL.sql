CREATE PROCEDURE [dbo].[ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL]
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
	   ,'ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.va_VacancyReviews_AutoQAoutcome

/* Insert all the unsuccessful outcomes first with a reason */

INSERT INTO ASData_PL.va_VacancyReviews_AutoQAoutcome
(EmployerAccountId 
  ,CandidateId 
  ,VacancyReference 
  ,VacancyId
  ,RuleoutcomeID 
  ,Rule_RuleId 
  ,Rule_Score 
  ,Rule_Narrative 
  ,Rule_Target 
  ,Details_BinaryID 
  ,Details_RuleID 
  ,Details_score 
  ,Details_narrative 
  ,Details_data 
  ,Details_target 
  ,SourceVacancyReviewId 
  ,SourceDb 
  )
SELECT 
	  RVRA.EmployerAccountId
      ,vc.CandidateId
	  ,RVRA.VacancyReference
	  ,vv.VacancyId
	  ,RVRA.RuleoutcomeID 
      ,RVRA.Rule_RuleId 
      ,RVRA.Rule_Score 
      ,RVRA.Rule_Narrative 
      ,RVRA.Rule_Target 
      ,RVRAD.Details_BinaryID 
      ,RVRAD.Details_RuleID 
      ,RVRAD.Details_score 
      ,RVRAD.Details_narrative 
      ,RVRAD.Details_data 
      ,RVRAD.Details_target 
	  ,RVR.BinaryId
	  ,'RAAv2'
  FROM Stg.RAA_VacancyReviews_AutoQAoutcome RVRA
  LEFT
  JOIN Stg.RAA_VacancyReviews_AutoQAoutcomedetails RVRAD
    on RVRA.VacancyReference = RVRAD.VacancyReference
  LEFT 
  JOIN ASData_PL.Va_Vacancy vv
    on vv.VacancyReferenceNumber=RVRA.VacancyReference
  LEFT
  JOIN ASData_PL.Va_Candidate vc
    on vc.CandidateGuid=RVRA.UserId

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
