/****** Object:  StoredProcedure [dbo].[ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL]    Script Date: 22/02/2024 12:24:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL]
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
	   ,'ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.va_VacancyReviewsAutoQAOutcomeID
/* Insert all the unsuccessful outcomes first with a reason */

INSERT INTO ASData_PL.va_VacancyReviewsAutoQAOutcomeID
(  EmployerAccountId 
  ,CandidateId 
  ,VacancyReference 
  ,VacancyId 
  ,Ruleoutcome_BinaryID 
  ,AutoQAfieldisReferred 
  ,SourceVacancyReviewId 
  ,SourceDb 
  )
SELECT 
	RVR.EmployerAccountId
      ,vc.CandidateId
	  ,rvr.VacancyReference
	  ,vv.VacancyId
	  ,Ruleoutcome_BinaryID
      ,AutoQAfieldisReferred
	  ,RVR.BinaryId
	  ,'RAAv2'
  FROM Stg.RAA_VacancyReviews RVR
  LEFT
  JOIN ASData_PL.Va_Vacancy vv
    on vv.VacancyReferenceNumber=RVR.VacancyReference
  LEFT
  JOIN ASData_PL.Va_Candidate vc
    on vc.CandidateGuid=RVR.UserId

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
	    'ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL',
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


