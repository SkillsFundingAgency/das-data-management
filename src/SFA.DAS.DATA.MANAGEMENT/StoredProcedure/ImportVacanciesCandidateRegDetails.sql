CREATE PROCEDURE [dbo].[ImportVacanciesCandidateRegDetailsToPL]
(
   @RunId int
)
AS
-- ================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 12/05/2022
-- Description: Import and Integrate Vacancies Candidate Reg Details from FAA Cosmos and AVMS Dbs
-- ================================================================================================

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
	   ,'ImportVacanciesCandidateRegDetailsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesCandidateRegDetailsToPL'
     AND RunId=@RunID


BEGIN TRANSACTION


DELETE FROM ASData_PL.Va_CandidateRegDetails


INSERT INTO [ASData_PL].[Va_CandidateRegDetails]
           (
		    [CandidateId] 
           ,[CandidateFirstName]
		   ,[CandidateLastName]
		   ,[CandidateMiddleName]
		   ,[CandidateFullName]
		   ,[CandidateEmail]
           ,[SourceDb] 
		   )
SELECT      VC.[CandidateId] 
           ,FCD.[FirstName]
		   ,FCD.[LastName]
		   ,FCD.[MiddleName]
		   ,FCD.[FullName]
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
		   ,[CandidateEmail]
           ,[SourceDb] 
		   )
SELECT      VC.[CandidateId] 
           ,ACD.[FirstName]
		   ,ACD.[LastName]
		   ,ACD.[MiddleName]
		   ,ACD.[FullName]
		   ,ACD.[EmailAddress]
	       ,'FAA-Avms'
  FROM Stg.Avms_CandidateRegDetails ACD
  JOIN ASData_PL.Va_Candidate VC
    ON VC.SourceCandidateId_v1=ACD.CandidateId
 WHERE NOT EXISTS (SELECT 1 FROM stg.FAA_CandidateRegDetails where CandidateId=vc.SourceCandidateId_v2)

   

     
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
	    'ImportVacanciesCandidateRegDetailsToPL',
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
