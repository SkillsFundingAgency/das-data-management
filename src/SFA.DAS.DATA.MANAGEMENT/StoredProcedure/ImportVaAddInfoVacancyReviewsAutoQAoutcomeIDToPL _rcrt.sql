CREATE PROCEDURE [dbo].[ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL_rcrt]
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
	   ,'ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL_rcrt'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL_rcrt'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.va_VacancyReviewsAutoQAOutcomeID_rcrt
/* Insert all the unsuccessful outcomes first with a reason */

INSERT INTO ASData_PL.va_VacancyReviewsAutoQAOutcomeID_rcrt
(  VacancyReference 
  ,VacancyId 
  ,Ruleoutcome_BinaryID 
  ,AutoQAfieldisReferred 
  ,SourceVacancyReviewId 
  ,SourceDb 
  )


SELECT 
         E. VacancyReference
		,vv.VacancyId
        ,dbo.Fn_ConvertGuidToBase64(b.id_1)  AS Ruleoutcome_BinaryID
        ,COALESCE(AutomatedQaOutcomeIndicators,'False') as AutoQAfieldisReferred
        ,dbo.Fn_ConvertGuidToBase64(E.Id)  as BinaryID
        ,'RAAv2'

 FROM stg.RCRT_VacancyReview E
   LEFT
  JOIN ASData_PL.Va_Vacancy_rcrt vv
    on vv.VacancyReferenceNumber=E.VacancyReference
--join ASData_PL.Va_Vacancy_Rcrt v on E.VacancyReference=v.VacancyReference
 CROSS APPLY OPENJSON(E.AutomatedQaOutcome, '$.ruleOutcomes')
    WITH (
        id_1           UNIQUEIDENTIFIER '$.id'

    
            ) B
        where  ISJSON(AutomatedQaOutcome) = 1
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


