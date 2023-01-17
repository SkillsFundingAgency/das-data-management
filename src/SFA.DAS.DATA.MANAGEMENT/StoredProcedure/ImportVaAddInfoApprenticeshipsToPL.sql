CREATE PROCEDURE [dbo].[ImportVaAddInfoApprenticeshipsToPL]
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
	   ,'ImportVaAddInfoApprenticeshipsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoApprenticeshipsToPL'
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
	    'ImportVaAddInfoApprenticeshipsToPL',
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
