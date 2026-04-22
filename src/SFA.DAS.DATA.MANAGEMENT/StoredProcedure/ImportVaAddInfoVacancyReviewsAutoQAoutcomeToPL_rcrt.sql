CREATE PROCEDURE [dbo].[ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL_rcrt]
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
	   ,'ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL_rcrt'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL_rcrt'
     AND RunId=@RunID

BEGIN TRANSACTION

DROP TABLE IF EXISTS #RuleOutcomes;
TRUNCATE TABLE ASData_PL.va_VacancyReviewsAutoQAOutcome_rcrt
SELECT
      e.Id AS VacancyReviewId,
      e.VacancyReference,
      v.VacancyId,
      r.id_1,
      r.ruleId,
      r.score,
      r.narrative,
      NULLIF(r.target, '') AS target,
      r.details
INTO #RuleOutcomes
FROM stg.RCRT_VacancyReview e
LEFT JOIN ASData_PL.Va_Vacancy_Rcrt v
       ON v.VacancyReferenceNumber = e.VacancyReference
CROSS APPLY OPENJSON(e.AutomatedQaOutcome, '$.ruleOutcomes')
WITH (
        id_1         UNIQUEIDENTIFIER '$.id',
        ruleId       INT             '$.ruleId',
        score        INT             '$.score',
        narrative    NVARCHAR(MAX)   '$.narrative',
        target       NVARCHAR(256)   '$.target',
        details      NVARCHAR(MAX)   '$.details' AS JSON
     ) r
WHERE ISJSON(e.AutomatedQaOutcome) = 1;

CREATE CLUSTERED INDEX IX_RuleOutcomes_Id ON #RuleOutcomes(VacancyReviewId);
CREATE NONCLUSTERED INDEX IX_RuleOutcomes_RuleId ON #RuleOutcomes(ruleId);

INSERT INTO ASData_PL.va_VacancyReviewsAutoQAOutcome_rcrt
(
    VacancyReference,
    VacancyId,
    RuleoutcomeID,
    Rule_RuleId,
    Rule_Score,
    Rule_Narrative,
    Rule_Target,
    Details_BinaryID,
    Details_RuleID,
    Details_score,
    Details_narrative,
    Details_data,
    Details_target,
    SourceVacancyReviewId,
    SourceDb
)
SELECT
      r.VacancyReference,
      r.VacancyId,
      dbo.Fn_ConvertGuidToBase64(r.id_1),
      r.ruleId,
      r.score,
      r.narrative,
      r.target,

      dbo.Fn_ConvertGuidToBase64(d.details_id),
      d.details_ruleId,
      d.details_score,
      d.details_narrative,
      d.details_data,
      d.details_target,

      dbo.Fn_ConvertGuidToBase64(r.VacancyReviewId),
      'RAAv2'
FROM #RuleOutcomes r
OUTER APPLY OPENJSON(r.details)
WITH (
        details_id         UNIQUEIDENTIFIER '$.id',
        details_ruleId     INT             '$.ruleId',
        details_score      INT             '$.score',
        details_narrative  NVARCHAR(MAX)   '$.narrative',
        details_target     NVARCHAR(256)   '$.target',
        details_data       NVARCHAR(MAX)   '$.data'
     ) d;



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
	    'ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL',
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
