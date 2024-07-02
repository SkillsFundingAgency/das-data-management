CREATE PROCEDURE [dbo].[PopulateStgPmnts]
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
	   ,'Step-3'
	   ,'PopulateStgPmnts'
	   ,getdate()
	   ,0

SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
WHERE StoredProcedureName='PopulateStgPmnts'
    AND RunId=@RunId
	
BEGIN TRANSACTION

DELETE FROM [Mgmt].[Config_StgPmnts]

INSERT INTO [Mgmt].[Config_StgPmnts]
           (SourceDBName, SourceTable, DestSchema, DestTable, LoadType, WhereClause, ColumnsToInclude)
     VALUES	
('DASPayments','[Payments2].[Apprenticeship]','StgPmts','Apprenticeship','Full','','Id,AccountId,AgreementId,AgreedOnDate,Uln,Ukprn,EstimatedStartDate,EstimatedEndDate,Priority,StandardCode,ProgrammeType,FrameworkCode,PathwayCode,LegalEntityName,TransferSendingEmployerAccountId,StopDate,Status,IsLevyPayer,CreationDate,ApprenticeshipEmployerType')
,('DASPayments','[Payments2].[ApprenticeshipPause]','StgPmts','ApprenticeshipPause','Full','','Id,ApprenticeshipId,PauseDate,ResumeDate')
,('DASPayments','[Payments2].[ApprenticeshipPriceEpisode]','StgPmts','ApprenticeshipPriceEpisode','Full','','Id,ApprenticeshipId,StartDate,EndDate,Cost,Removed,CreationDate')
,('DASPayments','[Payments2].[ApprenticeshipStatus]','StgPmts','ApprenticeshipStatus','Full','','Id,Description')
,('DASPayments','[Payments2].[EmployerProviderPriority]','StgPmts','EmployerProviderPriority','Full','','Id,EmployerAccountId,Ukprn,Order')
,('DASPayments','[Payments2].[Job]','StgPmts','stg_Job','Incremental','where AcademicYear = ParamAcademicYear and collectionPeriod = ParamCollectionPeriod','JobId,JobType,StartTime,EndTime,Status,CreationDate,DCJobId,Ukprn,IlrSubmissionTime,LearnerCount,AcademicYear,CollectionPeriod,DataLocksCompletionTime,DCJobSucceeded,DCJobEndTime')
,('DASPayments','[Payments2].[JobStatus]','StgPmts','JobStatus','Full','','Id,Description')
,('DASPayments','[Payments2].[JobType]','StgPmts','JobType','Full','','Id,Description')
,('DASPayments','[Payments2].[LevyAccount]','StgPmts','LevyAccount','Full','','AccountId,AccountName,Balance,IsLevyPayer,TransferAllowance')
,('DASPayments','[Payments2].[Payment]','StgPmts','stg_Payment','Incremental','where AcademicYear = ParamAcademicYear and collectionPeriod = ParamCollectionPeriod','Id,EventId,EarningEventId,FundingSourceEventId,EventTime,JobId,DeliveryPeriod,CollectionPeriod,AcademicYear,Ukprn,LearnerReferenceNumber,LearningAimSequenceNumber,LearnerUln,PriceEpisodeIdentifier,Amount,LearningAimReference,LearningAimProgrammeType,LearningAimStandardCode,LearningAimFrameworkCode,LearningAimPathwayCode,LearningAimFundingLineType,ContractType,TransactionType,FundingSource,IlrSubmissionDateTime,SfaContributionPercentage,AgreementId,AccountId,TransferSenderAccountId,CreationDate,EarningsStartDate,EarningsPlannedEndDate,EarningsActualEndDate,EarningsCompletionStatus,EarningsCompletionAmount,EarningsInstalmentAmount,EarningsNumberOfInstalments,LearningStartDate,ApprenticeshipId,ApprenticeshipPriceEpisodeId,ApprenticeshipEmployerType,ReportingAimFundingLineType,NonPaymentReason,DuplicateNumber')
,('DASPayments','[Payments2].[ProviderAdjustmentPayments]','StgPmts','stg_ProviderAdjustmentPayments','Incremental','CONCAT(''ParamAcademicYear'',''-R'',RIGHT(''00''+''ParamCollectionPeriod'',2)) ','Ukprn,SubmissionId,SubmissionCollectionPeriod,SubmissionAcademicYear,PaymentType,PaymentTypeName,Amount,CollectionPeriodName,CollectionPeriodMonth,CollectionPeriodYear')
,('DASPayments','[Payments2].[SubmittedLearnerAim]','StgPmts','SubmittedLearnerAim','Full','','Id,Ukprn,LearnerReferenceNumber,LearningAimFrameworkCode,LearningAimPathwayCode,LearningAimProgrammeType,LearningAimStandardCode,LearningAimReference,CollectionPeriod,AcademicYear,IlrSubmissionDateTime,CreationDate,LearnerUln,JobId,ContractType')




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
	    'PopulateStgPmnts',
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