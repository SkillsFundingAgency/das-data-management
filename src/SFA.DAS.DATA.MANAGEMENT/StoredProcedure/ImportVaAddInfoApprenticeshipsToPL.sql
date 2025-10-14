CREATE PROCEDURE [dbo].[ImportVaAddInfoApprenticeshipsToPL]
(
   @RunId varchar(100)
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

DELETE FROM ASData_PL.Va_Apprenticeships where SourceDb = 'FAAV2'

-- ####################################################################
-- # Basic UPDATE statement
-- # See https://www.ibm.com/docs/en/db2-for-zos/13?topic=statements-update for complete syntax.
-- ####################################################################
UPDATE stg.RAA_ApplicationReviews
SET CandidateId_UI=CONVERT(UNIQUEIDENTIFIER, 
            CONVERT(VARCHAR(36), 
            CAST(CAST(N'' AS XML).value('xs:base64Binary(sql:column("CandidateId"))', 'VARBINARY(16)') as uniqueidentifier)
        )
    )

INSERT INTO [ASData_PL].[Va_Apprenticeships]
           (CandidateId 
           ,VacancyId 
		       ,ApplicationId  
		       ,ApplicationGUID  
           ,VacancyReference 
           ,CreatedDateTime 
           ,UpdatedDateTime 
           ,AppliedDateTime 
           ,IsRecruitVacancy
           ,ApplyViaEmployerWebsite 
           ,SuccessfulDateTime 
           ,UnsuccessfulDateTime 
           ,WithdrawalDateTime
           ,WithDrawnOrDeclinedReason 
           ,UnsuccessfulReason 
           ,SourceApprenticeshipId
           ,DateProviderSharedApplicationWithEmployer 
           ,ApplicationStatusRecruitmentView
           ,[Status]
           ,SourceDb
           ,MigrationDate
           ,CandidateId_UI
           ,MigratedCandidateId_UI

		   )
-- SELECT vc.CandidateId                                                  as CandidateId
--       ,vv.VacancyId                                                    as VacancyId
-- 	  ,coalesce(va.ApplicationId,vav2.ApplicationId,FA.LEGACYAPPLICATIONID) as ApplicationID
--     ,NULL                                                            as ApplicationGUID
-- 	  ,cast(vv.VacancyReferenceNumber  as varchar)                   as VacancyReferenceNumber
-- 	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.DateCreatedTimeStamp)      as DateCreatedTimeStamp
-- 	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.DateUpdatedTimeStamp)      as DateUpdatedTimeStamp
-- 	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.DateAppliedTimeStamp)      as DateAppliedTimeStamp
-- 	  ,IsRecruitVacancy                                                as IsRecruitVacancy
-- 	  ,ApplyViaEmployerWebsite                                         as ApplyViaEmployerWebsite
-- 	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.SuccessfulTimeStamp)       as SuccessfulTimeStamp
-- 	  ,dbo.Fn_ConvertTimeStampToDateTime(fa.UnsuccessfulTimeStamp)     as UnsuccessfulTimeStamp
--     ,NULL                                                            as WithdrawalDateTime
-- 	  ,WithdrawnOrDeclinedReason                                       as WithdrawnOrDeclinedReason
-- 	  ,UnsuccessfulReason                                              as UnsuccessfulReason
-- 	  ,FA.BinaryId                                                     as SourceApprenticeshipId
--     ,dbo.Fn_ConvertTimeStampToDateTime(RAR.DateSharedWithEmployer)   as dateSharedWithEmployer
--     ,RAR.Applicationstatus                                           as ApplicationStatusRecruitmentView
--     ,CASE 
--         WHEN FA.Status = 0 THEN 'Unknown'
--         WHEN FA.Status = 5 THEN 'Saved'
--         WHEN FA.Status = 10 THEN 'Draft'
--         WHEN FA.Status = 15 THEN 'ExpiredOrWithdrawn'
--         WHEN FA.Status = 20 THEN 'Submitting'
--         WHEN FA.Status = 30 THEN 'Submitted'
--         WHEN FA.Status = 40 THEN 'InProgress'
--         WHEN FA.Status = 80 THEN 'Successful'
--         WHEN FA.Status = 90 THEN 'Unsuccessful'
--         WHEN FA.Status = 100 THEN 'CandidateWithdrew'
--         ELSE 'Invalid Status Code'
--     END AS [Status]
-- 	  ,'RAAv2'                                                         as SourceDb
--     ,NULL
--     ,NULL
--     ,NULL
--   FROM Stg.FAA_Apprenticeships FA
--   LEFT
--   JOIN ASData_PL.Va_Candidate VC
--     ON FA.CandidateId=vc.CandidateGuid 
--   left
--   join ASData_PL.Va_Application VA
--     ON VA.SourceApplicationId=FA.LegacyApplicationId
--    AND VA.SourceDb='RAAv1'
--    AND FA.LegacyApplicationId<>0
--   left
--   Join ASData_PL.Va_Vacancy vv
--     on vv.VacancyReferenceNumber= cast(replace(fa.vacancyreference,'vac','') AS INT)
--   left
--   join STG.RAA_ApplicationReviews RAR
--     ON RAR.CandidateId=FA.CandidateId
--    AND RAR.VacancyReference=cast(replace(fa.vacancyreference,'vac','') AS INT)
--   LEFT
--   JOIN ASData_PL.Va_Application vav2
--     on vav2.SourceApplicationId=rar.SourseSK
--    and vav2.SourceDb='RAAv2'
--UNION
SELECT vc.CandidateId                                                   as CandidateId
      ,vv.VacancyId                                                    as VacancyId
	    ,NULL                                                            as ApplicationID
      ,A.ID                                                            as ApplicationGUID
	    ,A.VacancyReference                                              as VacancyReferenceNumber
	    ,A.CreatedDate                                                   as DateCreatedTimeStamp
	    ,A.UpdatedDate                                                   as DateUpdatedTimeStamp
	    ,A.SubmittedDate                                                 as DateAppliedTimeStamp
	    ,'True'                                                          as IsRecruitVacancy
	    ,'True'                                                          as ApplyViaEmployerWebsite
	    ,CASE WHEN A.Status = 3 THEN A.UpdatedDate  
            ELSE NULL 
       END                                                             as SuccessfulTimeStamp
	    ,CASE WHEN A.Status = 4 THEN A.UpdatedDate  
            ELSE NULL 
       END                                                             as UnsuccessfulTimeStamp
      ,CASE WHEN A.Status = 2 THEN A.UpdatedDate  
            ELSE NULL 
       END                                                             as WithdrawalDateTime
	    ,'N/A'                                                           as WithdrawnOrDeclinedReason
	    ,A.ResponseNotes                                                 as UnsuccessfulReason
	    ,'N/A'                                                           as SourceApprenticeshipId
      ,dbo.Fn_ConvertTimeStampToDateTime(RAR.DateSharedWithEmployer)   as dateSharedWithEmployer
      ,RAR.Applicationstatus                                           as ApplicationStatusRecruitmentView
      ,CASE  
        WHEN A.Status = 0 THEN 'Draft'
        WHEN A.Status = 1 THEN 'Submitted'
        WHEN A.Status = 2 THEN 'Withdrawn'
        WHEN A.Status = 3 THEN 'Successful'
        WHEN A.Status = 4 THEN 'Unsuccessful'
        WHEN A.Status = 5 THEN 'Expired'
      ELSE 'Invalid Status Code'
      END AS [Status]
	    ,'FAAV2'                                                         as SourceDb
      ,MigrationDate                                                   as MigrationDate
      ,RAR.CandidateId_UI
      ,FC.MigratedCandidateId
  FROM Stg.FAAV2_Application A
  LEFT JOIN ( SELECT *, ROW_NUMBER() OVER (PARTITION BY RAR.CandidateId_UI, RAR.VacancyReference ORDER BY CAST(RAR.CreatedDateTimeStamp AS BIGINT) DESC) AS rn
        FROM Stg.RAA_ApplicationReviews RAR) RAR 
	ON A.CandidateId = RAR.CandidateId_UI AND A.VacancyReference = RAR.VacancyReference AND RAR.rn = 1
  LEFT JOIN ASData_PL.Va_Vacancy vv
    on TRY_CAST(vv.VacancyReferenceNumber as varchar)= A.vacancyreference
  LEFT JOIN ASData_PL.Va_Candidate VC
    ON cast(A.CandidateId AS VARCHAR(36)) = VC.SourceCandidateId_v3
  LEFT JOIN Stg.FAAV2_Candidate FC
    ON FC.Id = A.CandidateId


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
