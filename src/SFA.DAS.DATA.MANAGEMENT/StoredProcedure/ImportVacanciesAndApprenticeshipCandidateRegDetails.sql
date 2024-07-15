CREATE PROCEDURE [dbo].[ImportVacanciesAndApprenticeshipCandidateRegDetailsToPL]
(
   @RunId int
)
AS
-- ======================================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 12/05/2022
-- Description: Import and Integrate Vacancies and Apprenticeship Candidate Reg Details from FAA Cosmos and AVMS Dbs
-- ======================================================================================================================

BEGIN TRY

DECLARE @LogID int

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
	   ,'ImportVacanciesAndApprenticeshipCandidateRegDetailsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesAndApprenticeshipCandidateRegDetailsToPL'
     AND RunId=@RunID


BEGIN TRANSACTION

/* Import Vacancies Candidate Reg Details */

TRUNCATE TABLE ASData_PL.Va_CandidateRegDetails


INSERT INTO [ASData_PL].[Va_CandidateRegDetails]
           (
		    [CandidateId] 
           ,[CandidateFirstName]
		   ,[CandidateLastName]
		   ,[CandidateMiddleName]
		   ,[CandidateFullName]
		   ,[CandidateDateOfBirth]
		   ,[CandidateEmail]
           ,[SourceDb] 
		   )
SELECT      VC.[CandidateId] 
           ,FCD.[FirstName]
		   ,FCD.[LastName]
		   ,FCD.[MiddleName]
		   ,FCD.[FullName]
		   ,FCD.[DateOfBirth]
		   ,FCD.[EmailAddress]
     	   ,'FAA-Cosmos'
  FROM Stg.FAA_CandidateRegDetails FCD
  JOIN ASData_PL.Va_Candidate VC
    ON VC.SourceCandidateId_v2=FCD.CandidateId



INSERT INTO [ASData_PL].[Va_CandidateRegDetails]
           (
		    [CandidateId] 
           ,[CandidateFirstName]
		   ,[CandidateLastName]
		   ,[CandidateMiddleName]
		   ,[CandidateFullName]
		   ,[CandidateDateOfBirth]
		   ,[CandidateEmail]
           ,[SourceDb] 
		   )
SELECT      VC.[CandidateId] 
           ,ACD.[FirstName]
		   ,ACD.[SurName]
		   ,ACD.[MiddleName]
		   ,ACD.[FullName]
		   ,ACD.[DateOfBirth]
		   ,ACD.[EmailAddress]
	       ,'FAA-Avms'
  FROM Stg.Avms_CandidateRegDetails ACD
  JOIN ASData_PL.Va_Candidate VC
    ON VC.SourceCandidateId_v1=ACD.CandidateId
 WHERE NOT EXISTS (SELECT 1 FROM stg.FAA_CandidateRegDetails where CandidateId=vc.SourceCandidateId_v2)


 INSERT INTO [ASData_PL].[Va_CandidateRegDetails]
           (
		    [CandidateId] 
           ,[CandidateFirstName]
		   ,[CandidateLastName]
		   ,[CandidateMiddleName]
		   ,[CandidateFullName]
		   ,[CandidateDateOfBirth]
		   ,[CandidateEmail]
		   ,[Migrated_EMailID]
		   ,[Migrated_CandidateID]
           ,[SourceDb] 
		   )
SELECT      VC.[CandidateId] 
           ,C.[FirstName]
		   ,C.[LastName]
		   ,C.[MiddleNames]
		   ,C.[FullName]
		   ,C.[DateOfBirth]
		   ,C.[EmailAddress]
		   ,C.[MigratedEmail]
		   ,C.[MigratedCandidateId]
	       ,'FAAV2'
  FROM Stg.FAAV2_Candidate C
  JOIN ASData_PL.Va_Candidate VC
    ON VC.SourceCandidateId_v3=C.Id
 WHERE NOT EXISTS (SELECT 1 FROM Stg.FAAV2_Candidate where c.Id=vc.SourceCandidateId_v3)



 /* Import Commitments Candidate Reg Details */

 TRUNCATE TABLE [ASData_PL].[Comt_ApprenticeshipCandidateRegDetails]

 INSERT INTO [ASData_PL].[Comt_ApprenticeshipCandidateRegDetails]
           ([ApprenticeshipId]
           ,[CommitmentId]
           ,[CandidateFirstName]
           ,[CandidateLastName]
           ,[CandidateFullName]
           ,[CandidateDateOfBirth]
           ,[CandidateEmail]
		   )
SELECT [ApprenticeshipId]
           ,[CommitmentId]
           ,[CandidateFirstName]
           ,[CandidateLastName]
           ,[CandidateFullName]
           ,[CandidateDateOfBirth]
           ,[CandidateEmail]
  FROM Stg.Comt_ApprenticeshipCandidateRegDetails


COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

/* Truncate staging tables after loading to PL */

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Avms_CandidateRegDetails' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Avms_CandidateRegDetails]


 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Comt_ApprenticeshipCandidateRegDetails' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Comt_ApprenticeshipCandidateRegDetails]


TRUNCATE TABLE [Stg].[Faa_CandidateRegDetails]


 
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
	    'ImportVacanciesAndApprenticeshipCandidateRegDetailsToPL',
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

/* Truncate staging tables even if it fails */

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Avms_CandidateRegDetails' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Avms_CandidateRegDetails]


 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Comt_ApprenticeshipCandidateRegDetails' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Comt_ApprenticeshipCandidateRegDetails]


TRUNCATE TABLE [Stg].[Faa_CandidateRegDetails]

  END CATCH

GO
