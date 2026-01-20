CREATE PROCEDURE [dbo].[ImportVaAddInfoApprenticeshipsToPL_Rcrt]
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
	   ,'ImportVaAddInfoApprenticeshipsToPL_Rcrt'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoApprenticeshipsToPL_Rcrt'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_Apprenticeships_Rcrt

-- ####################################################################
-- # Basic UPDATE statement
-- # See https://www.ibm.com/docs/en/db2-for-zos/13?topic=statements-update for complete syntax.
-- ####################################################################

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
      ,RAR.DateSharedWithEmployer   as dateSharedWithEmployer
      ,RAR.Status                                           as ApplicationStatusRecruitmentView
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
      ,RAR.CandidateId
      ,FC.MigratedCandidateId
  FROM Stg.FAAV2_Application A
  LEFT JOIN ( SELECT *, ROW_NUMBER() OVER (PARTITION BY RAR.CandidateId, RAR.VacancyReference ORDER BY RAR.CreatedDate  DESC) AS rn
        FROM Stg.RCRT_ApplicationReview RAR) RAR 
	ON A.CandidateId = RAR.CandidateId AND A.VacancyReference = CAST(RAR.VacancyReference AS NVARCHAR) AND RAR.rn = 1
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
	    'ImportVaAddInfoApprenticeshipsToPL_Rcrt',
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
