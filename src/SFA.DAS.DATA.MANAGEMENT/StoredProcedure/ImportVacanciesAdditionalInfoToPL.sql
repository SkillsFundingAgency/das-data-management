CREATE PROCEDURE [dbo].[ImportVacanciesAdditionalInfoToPL]
(
   @RunId int
)
AS
-- ==============================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 01/03/2021
-- Description: Import Vacancies Apprenticeships, Traineeships, Saved Searches, ContactMessages
--              Vacancy Reviews etc to PL
-- ==============================================================================================

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
	   ,'ImportVacanciesAdditionalInfoToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesAdditionalInfoToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_Apprenticeships

INSERT INTO [ASData_PL].[Va_Apprenticeships]
           (CandidateId 
           ,VacancyId 
		   ,ApplicationId
           ,VacancyReference 
           ,CreatedDateTime 
           ,UpdatedDateTime 
           ,AppliedDateTime 
           ,IsRecruitVacancy
           ,ApplyViaEmployerWebsite 
           ,SuccessfulDateTime 
           ,UnsuccessfulDateTime 
           ,WithDrawnOrDeclinedReason 
           ,UnsuccessfulReason 
           ,SourceApprenticeshipId
           ,SourceDb 
		   )
SELECT vc.CandidateId                                                  as CandidateId
      ,vv.VacancyId                                                    as VacancyId
	  ,coalesce(va.ApplicationId,vav2.ApplicationId,FA.LEGACYAPPLICATIONID) as ApplicationID
	  ,vv.VacancyReferenceNumber                                       as VacancyReferenceNumber
	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.DateCreatedTimeStamp)      as DateCreatedTimeStamp
	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.DateUpdatedTimeStamp)      as DateUpdatedTimeStamp
	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.DateAppliedTimeStamp)      as DateAppliedTimeStamp
	  ,IsRecruitVacancy                                                as IsRecruitVacancy
	  ,ApplyViaEmployerWebsite                                         as ApplyViaEmployerWebsite
	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.SuccessfulTimeStamp)       as SuccessfulTimeStamp
	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.UnsuccessfulTimeStamp)     as UnsuccessfulTimeStamp
	  ,WithdrawnOrDeclinedReason                                       as WithdrawnOrDeclinedReason
	  ,UnsuccessfulReason                                              as UnsuccessfulReason
	  ,FA.BinaryId                                                     as SourceApprenticeshipId
	  ,'RAAv2'                                                         as SourceDb
  FROM Stg.FAA_Apprenticeships FA
  LEFT
  JOIN ASData_PL.Va_Candidate VC
    ON FA.CandidateId=vc.CandidateGuid 
  left
  join ASData_PL.Va_Application VA
    ON VA.SourceApplicationId=FA.LegacyApplicationId
   AND VA.SourceDb='RAAv1'
   AND FA.LegacyApplicationId<>0
  left
  Join ASData_PL.Va_Vacancy vv
    on vv.VacancyReferenceNumber= cast(replace(fa.vacancyreference,'vac','') AS INT)
  left
  join STG.RAA_ApplicationReviews RAR
    ON RAR.CandidateId=FA.CandidateId
   AND RAR.VacancyReference=cast(replace(fa.vacancyreference,'vac','') AS INT)
  LEFT
  JOIN ASData_PL.Va_Application vav2
    on vav2.SourceApplicationId=rar.SourseSK
   and vav2.SourceDb='RAAv2'


   
COMMIT TRANSACTION

BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_SavedSearches

INSERT INTO ASData_PL.Va_SavedSearches
(      CandidateId 
      ,CreatedDateTime 
      ,UpdatedDateTime 
	  ,SearchLocation 
	  ,KeyWords 
	  ,WithInDistance 
	  ,ApprenticeshipLevel 
      ,SourceSavedSearchesId 
	  ,SourceDb
)


SELECT vc.CandidateId                                                  as CandidateId
	  ,dbo.Fn_ConvertTimeStampToDateTime(fSS.DateCreatedTimeStamp)      as DateCreatedTimeStamp
	  ,dbo.Fn_ConvertTimeStampToDateTime(fss.DateUpdatedTimeStamp)      as DateUpdatedTimeStamp
	  ,fss.[Location]
	  ,LEFT(fss.Keywords,256) as Keywords
	  ,fss.WithInDistance
	  ,fss.ApprenticeshipLevel
	  ,Fss.BinaryId                                                     as SourceApprenticeshipId
	  ,'RAAv2'                                                         as SourceDb
  FROM Stg.FAA_SavedSearches FSS
  LEFT
  JOIN ASData_PL.Va_Candidate VC
    ON FSS.CandidateId=vc.CandidateGuid
    
COMMIT TRANSACTION


BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_ContactMessages

INSERT INTO ASData_PL.Va_ContactMessages
(      CreatedDateTime 
      ,UpdatedDateTime 
      ,UserId  
      ,Enquiry 
	  ,SourceContactMessagesId 
      ,SourceDb 
)
SELECT dbo.Fn_ConvertTimeStampToDateTime(CM.DateCreatedTimeStamp)      as DateCreatedTimeStamp
	  ,dbo.Fn_ConvertTimeStampToDateTime(CM.DateUpdatedTimeStamp)      as DateUpdatedTimeStamp
	  ,CM.UserId                                                       as UserId
	  ,CM.Enquiry                                                      as Enquiry
	  ,CM.BinaryId                                                     as SourceContactMessageId
	  ,'RAAv2'                                                         as SourceDb
  FROM Stg.FAA_ContactMessages CM

  

COMMIT TRANSACTION


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
SELECT RVR.EmployerAccountId
      ,vc.CandidateId
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.CreatedTimeStamp)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.SubmittedTimeStamp)
	  ,rvr.VacancyReference
	  ,vv.VacancyId
	  ,rvr.ManualOutcome
	  ,rvr.ManualQaFieldIndicator
	  ,rvr.ManualQaFieldChangeRequested
	  ,rvr.ManualQaComment
	  ,rvr.SubmissionCount
      ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ReviewedDate)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ClosedDate)	 
	  ,LEFT(rvr.ReviewedByUserEmail, CHARINDEX('@', rvr.ReviewedByUserEmail)-1)
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
 Where ManualQaFieldChangeRequested='true'


 /* Insert all successful outcomes , It doesn't require ManualOutcome and QAComment so ignore these columns to reduce volumes of data */


 INSERT INTO ASData_PL.va_VacancyReviews
(EmployerAccountId 
  ,CandidateId 
  ,CreatedDateTime 
  ,SubmittedDateTime 
  ,VacancyReference 
  ,VacancyId 
  ,ManualOutcome   
  ,SubmissionCount
  ,ReviewedDate
  ,ClosedDate  
  ,ReviewedByUser
  ,SlaDeadline
  ,Status
  ,SourceVacancyReviewId 
  ,SourceDb 
  ,closedDate
  ,ReviewedByUserEmail
  )
SELECT DISTINCT
       RVR.EmployerAccountId
      ,vc.CandidateId
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.CreatedTimeStamp)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.SubmittedTimeStamp)
	  ,rvr.VacancyReference
	  ,vv.VacancyId
	  ,rvr.ManualOutcome
	  ,rvr.SubmissionCount
      ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ReviewedDate)
	  ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ClosedDate)	 
	  ,LEFT(rvr.ReviewedByUserEmail, CHARINDEX('@', rvr.ReviewedByUserEmail)-1)
      ,dbo.Fn_ConvertTimeStampToDateTime(rvr.SlaDeadline)
      ,rvr.Status
	  ,RVR.BinaryId
	  ,'RAAv2'
    ,dbo.Fn_ConvertTimeStampToDateTime(rvr.ReviewedDate)
    ,ReviewedByUserEmail
  FROM Stg.RAA_VacancyReviews RVR
  LEFT
  JOIN ASData_PL.Va_Vacancy vv
    on vv.VacancyReferenceNumber=RVR.VacancyReference
  LEFT
  JOIN ASData_PL.Va_Candidate vc
    on vc.CandidateGuid=RVR.UserId
 Where not exists (select 1 from ASData_PL.Va_VacancyReviews VR where vr.SourceVacancyReviewId=rvr.BinaryId)


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
	    'ImportVacanciesAdditionalInfoToPL',
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
