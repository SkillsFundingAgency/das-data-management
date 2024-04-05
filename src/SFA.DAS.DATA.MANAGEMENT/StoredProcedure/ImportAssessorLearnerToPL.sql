CREATE PROCEDURE [dbo].[ImportAssessorLearnerToPL]
(
   @RunId int
)
AS


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
	   ,'ImportAssessorLearnerToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportAssessorLearnerToPL'
     AND RunId=@RunID


BEGIN TRANSACTION

/* Import Vacancies Candidate Reg Details */

TRUNCATE TABLE ASData_PL.Assessor_Learner


INSERT INTO [ASData_PL].[Assessor_Learner]
           (
		    [Id]
           ,[Uln]
           ,[UkPrn]
           ,[StdCode]
           ,[LearnStartDate]
           ,[EpaOrgId]
           ,[FundingModel]
           ,[ApprenticeshipId]
           ,[Source]
           ,[CompletionStatus]
           ,[PlannedEndDate]
           ,[LearnActEndDate]
           ,[WithdrawReason]
           ,[Outcome]
           ,[AchDate]
           ,[OutGrade]
           ,[Version]
           ,[VersionConfirmed]
           ,[CourseOption]
           ,[StandardUId]
           ,[StandardReference]
           ,[StandardName]
           ,[LastUpdated]
           ,[EstimatedEndDate]
           ,[ApprovalsStopDate]
           ,[ApprovalsPauseDate]
           ,[ApprovalsCompletionDate]
           ,[ApprovalsPaymentStatus]
           ,[LatestIlrs]
           ,[LatestApprovals]
           ,[IsTransfer]
           ,[DelLoc_Pst_Lower_Layer_SOA]
           ,[DelLoc_Pst_Lower_Layer_SOA2001]
		   )
SELECT         AL.[Id]
              ,AL.[UlnlUl]
              ,AL.[UknrkPrn]
              ,AL.[StdCode]
              ,AL.[LearnStartDate]
              ,AL.[EpaOrgId]
              ,AL.[FundingModel]
              ,AL.[ApprenticeshipId]
              ,AL.[Source]
              ,AL.[CompletionStatus]
              ,AL.[PlannedEndDate]
              ,AL.[LearnActEndDate]
              ,AL.[WithdrawReason]
              ,AL.[Outcome]
              ,AL.[AchDate]
              ,AL.[OutGrade]
              ,AL.[Version]
              ,AL.[VersionConfirmed]
              ,AL.[CourseOption]
              ,AL.[StandardUId]
              ,AL.[StandardReference]
              ,AL.[StandardName]
              ,AL.[LastUpdated]
              ,AL.[EstimatedEndDate]
              ,AL.[ApprovalsStopDate]
              ,AL.[ApprovalsPauseDate]
              ,AL.[ApprovalsCompletionDate]
              ,AL.[ApprovalsPaymentStatus]
              ,AL.[LatestIlrs]
              ,AL.[LatestApprovals]
              ,AL.[IsTransfer]
			  ,lkpg.[Pst_Lower_Layer_SOA]
              ,lkpg.[Pst_Lower_Layer_SOA2001]
  FROM Stg.Assessor_Learner AL
  LEFT OUTER JOIN LKP.[Postcode_GeographicalAttributes] lkpg
  ON lkpg.Pst_Postcode = AL.dellocpostcode


COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

/* Truncate staging tables after loading to PL */

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Learner' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Assessor_Learner]

 
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
	    'ImportAssessorLearnerToPL',
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

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Learner' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Assessor_Learner]
  END CATCH

GO
