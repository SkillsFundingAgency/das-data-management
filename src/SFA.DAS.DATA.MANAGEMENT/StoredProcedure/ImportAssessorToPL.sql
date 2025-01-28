CREATE PROCEDURE [dbo].[ImportAssessorToPL]
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
	   ,'ImportAssessorToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportAssessorToPL_INC'
     AND RunId=@RunID


BEGIN TRANSACTION

/* Import Assessor_Learner Details */


IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Learner' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')

MERGE INTO [ASDATA_PL].[Assessor_Learner] AS Target
USING (
    SELECT 
        AL.[Id],
        AL.[Uln],
        AL.[UkPrn],
        AL.[StdCode],
        AL.[LearnStartDate],
        AL.[EpaOrgId],
        AL.[FundingModel],
        AL.[ApprenticeshipId],
        AL.[Source],
        AL.[CompletionStatus],
        AL.[PlannedEndDate],
        AL.[LearnActEndDate],
        AL.[WithdrawReason],
        AL.[Outcome],
        AL.[AchDate],
        AL.[OutGrade],
        AL.[Version],
        AL.[VersionConfirmed],
        AL.[CourseOption],
        AL.[StandardUId],
        AL.[StandardReference],
        AL.[StandardName],
        AL.[LastUpdated],
        AL.[EstimatedEndDate],
        AL.[ApprovalsStopDate],
        AL.[ApprovalsPauseDate],
        AL.[ApprovalsCompletionDate],
        AL.[ApprovalsPaymentStatus],
        AL.[LatestIlrs],
        AL.[LatestApprovals],
        AL.[IsTransfer],
        lkpg.[Pst_Lower_Layer_SOA],
        lkpg.[Pst_Lower_Layer_SOA2001]
    FROM [Stg].[Assessor_Learner] AL
    LEFT JOIN [LKP].[Postcode_GeographicalAttributes] lkpg
        ON lkpg.[Pst_Postcode] = AL.[dellocpostcode]
) AS Source
ON Target.[Id] = Source.[Id]


WHEN MATCHED 
     AND Source.[LastUpdated] >= Target.[LastUpdated]
      THEN
    UPDATE SET
        [Uln] = Source.[Uln],
        [UkPrn] = Source.[UkPrn],
        [StdCode] = Source.[StdCode],
        [LearnStartDate] = Source.[LearnStartDate],
        [EpaOrgId] = Source.[EpaOrgId],
        [FundingModel] = Source.[FundingModel],
        [ApprenticeshipId] = Source.[ApprenticeshipId],
        [Source] = Source.[Source],
        [CompletionStatus] = Source.[CompletionStatus],
        [PlannedEndDate] = Source.[PlannedEndDate],
        [LearnActEndDate] = Source.[LearnActEndDate],
        [WithdrawReason] = Source.[WithdrawReason],
        [Outcome] = Source.[Outcome],
        [AchDate] = Source.[AchDate],
        [OutGrade] = Source.[OutGrade],
        [Version] = Source.[Version],
        [VersionConfirmed] = Source.[VersionConfirmed],
        [CourseOption] = Source.[CourseOption],
        [StandardUId] = Source.[StandardUId],
        [StandardReference] = Source.[StandardReference],
        [StandardName] = Source.[StandardName],
        [LastUpdated] = Source.[LastUpdated],
        [EstimatedEndDate] = Source.[EstimatedEndDate],
        [ApprovalsStopDate] = Source.[ApprovalsStopDate],
        [ApprovalsPauseDate] = Source.[ApprovalsPauseDate],
        [ApprovalsCompletionDate] = Source.[ApprovalsCompletionDate],
        [ApprovalsPaymentStatus] = Source.[ApprovalsPaymentStatus],
        [LatestIlrs] = Source.[LatestIlrs],
        [LatestApprovals] = Source.[LatestApprovals],
        [IsTransfer] = Source.[IsTransfer],
        [DelLoc_Pst_Lower_Layer_SOA] = Source.[Pst_Lower_Layer_SOA],
        [DelLoc_Pst_Lower_Layer_SOA2001] = Source.[Pst_Lower_Layer_SOA2001],
        [AsDm_UpdatedDateTime]   = Getdate()

WHEN NOT MATCHED THEN
    INSERT (
        [Id],
        [Uln],
        [UkPrn],
        [StdCode],
        [LearnStartDate],
        [EpaOrgId],
        [FundingModel],
        [ApprenticeshipId],
        [Source],
        [CompletionStatus],
        [PlannedEndDate],
        [LearnActEndDate],
        [WithdrawReason],
        [Outcome],
        [AchDate],
        [OutGrade],
        [Version],
        [VersionConfirmed],
        [CourseOption],
        [StandardUId],
        [StandardReference],
        [StandardName],
        [LastUpdated],
        [EstimatedEndDate],
        [ApprovalsStopDate],
        [ApprovalsPauseDate],
        [ApprovalsCompletionDate],
        [ApprovalsPaymentStatus],
        [LatestIlrs],
        [LatestApprovals],
        [IsTransfer],
        [DelLoc_Pst_Lower_Layer_SOA],
        [DelLoc_Pst_Lower_Layer_SOA2001],
        [AsDm_UpdatedDateTime] 
    )
    VALUES (
        Source.[Id],
        Source.[Uln],
        Source.[UkPrn],
        Source.[StdCode],
        Source.[LearnStartDate],
        Source.[EpaOrgId],
        Source.[FundingModel],
        Source.[ApprenticeshipId],
        Source.[Source],
        Source.[CompletionStatus],
        Source.[PlannedEndDate],
        Source.[LearnActEndDate],
        Source.[WithdrawReason],
        Source.[Outcome],
        Source.[AchDate],
        Source.[OutGrade],
        Source.[Version],
        Source.[VersionConfirmed],
        Source.[CourseOption],
        Source.[StandardUId],
        Source.[StandardReference],
        Source.[StandardName],
        Source.[LastUpdated],
        Source.[EstimatedEndDate],
        Source.[ApprovalsStopDate],
        Source.[ApprovalsPauseDate],
        Source.[ApprovalsCompletionDate],
        Source.[ApprovalsPaymentStatus],
        Source.[LatestIlrs],
        Source.[LatestApprovals],
        Source.[IsTransfer],
        Source.[Pst_Lower_Layer_SOA],
        Source.[Pst_Lower_Layer_SOA2001],
        GETDATE()
    );



    /* Import Assessor_CertificateLogs Details */


 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Certificatelogs' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')


MERGE INTO [ASData_PL].[Assessor_CertificateLogs] AS Target
USING (
    SELECT 
        [Id],
        [Action],
        [CertificateId],
        [EventTime],
        [Status],
        [BatchNumber],
        [ReasonForChange],
        [LatestEpaOutcome],
        [StandardName],
        [StandardLevel],
        [StandardPublicationDate],
        [ContactOrganisation],
        [ContactPostcode],
        [Registration],
        [LearningStartDate],
        [AchievementDate],
        [CourseOption],
        [OverallGrade],
        [Department]
    FROM [Stg].[Assessor_CertificateLogs]
) AS Source
ON Target.[Id] = Source.[Id]

WHEN MATCHED 
     AND Source.[EventTime] >= Target.[EventTime]
THEN 
    UPDATE SET
        [Action] = Source.[Action],
        [CertificateId] = Source.[CertificateId],
        [EventTime] = Source.[EventTime],
        [Status] = Source.[Status],
        [BatchNumber] = Source.[BatchNumber],
        [ReasonForChange] = Source.[ReasonForChange],
        [LatestEpaOutcome] = Source.[LatestEpaOutcome],
        [StandardName] = Source.[StandardName],
        [StandardLevel] = Source.[StandardLevel],
        [StandardPublicationDate] = Source.[StandardPublicationDate],
        [ContactOrganisation] = Source.[ContactOrganisation],
        [ContactPostcode] = Source.[ContactPostcode],
        [Registration] = Source.[Registration],
        [LearningStartDate] = Source.[LearningStartDate],
        [AchievementDate] = Source.[AchievementDate],
        [CourseOption] = Source.[CourseOption],
        [OverallGrade] = Source.[OverallGrade],
        [Department] = Source.[Department],
        [AsDm_UpdatedDateTime] = Getdate()

WHEN NOT MATCHED THEN
    INSERT (
        [Id],
        [Action],
        [CertificateId],
        [EventTime],
        [Status],
        [BatchNumber],
        [ReasonForChange],
        [LatestEpaOutcome],
        [StandardName],
        [StandardLevel],
        [StandardPublicationDate],
        [ContactOrganisation],
        [ContactPostcode],
        [Registration],
        [LearningStartDate],
        [AchievementDate],
        [CourseOption],
        [OverallGrade],
        [Department],
        [AsDm_UpdatedDateTime]
    )
    VALUES (
        Source.[Id],
        Source.[Action],
        Source.[CertificateId],
        Source.[EventTime],
        Source.[Status],
        Source.[BatchNumber],
        Source.[ReasonForChange],
        Source.[LatestEpaOutcome],
        Source.[StandardName],
        Source.[StandardLevel],
        Source.[StandardPublicationDate],
        Source.[ContactOrganisation],
        Source.[ContactPostcode],
        Source.[Registration],
        Source.[LearningStartDate],
        Source.[AchievementDate],
        Source.[CourseOption],
        Source.[OverallGrade],
        Source.[Department],
        Getdate()
    );



 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Certificates' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       

MERGE INTO [ASData_PL].[Assessor_Certificates] AS Target
USING (
    SELECT 
           [Id],
           [AchievementDate],
           [BatchNumber],
           [CertificateReference],
           [CertificateReferenceId],
           [ContactOrganisation],
           [ContactPostCode],
           [CourseOption],
           [EPADate],
           [CreatedAt],
           [CreatedBy],
           [CreateDay],
           [DeletedAt],
           [Department],
           [IsPrivatelyFunded],
           [LearningStartDate],
           [OrganisationId],
           [OverallGrade],
           [PrivatelyFundedStatus],
           [ProviderName],
           [ProviderUkPrn],
           [Registration],
           [StandardCode],
           [StandardLevel],
           [StandardName],
           [StandardPublicationDate],
           [StandardReference],
           [StandardUId],
           [Status],
           [ToBePrinted],
           [Uln],
           [UpdatedAt],
           [Version]
    FROM [stg].[Assessor_Certificates]
) AS Source
ON Target.[Id] = Source.[Id]

-- Perform an UPDATE if the record already exists and the source has newer data
WHEN MATCHED AND Source.[UpdatedAt] > Target.[UpdatedAt]
THEN
UPDATE
SET 
    [AchievementDate] = Source.[AchievementDate],
    [BatchNumber] = Source.[BatchNumber],
    [CertificateReference] = Source.[CertificateReference],
    [CertificateReferenceId] = Source.[CertificateReferenceId],
    [ContactOrganisation] = Source.[ContactOrganisation],
    [ContactPostCode] = Source.[ContactPostCode],
    [CourseOption] = Source.[CourseOption],
    [EPADate] = Source.[EPADate],
    [CreatedAt] = Source.[CreatedAt],
    [CreatedBy] = Source.[CreatedBy],
    [CreateDay] = Source.[CreateDay],
    [DeletedAt] = Source.[DeletedAt],
    [Department] = Source.[Department],
    [IsPrivatelyFunded] = Source.[IsPrivatelyFunded],
    [LearningStartDate] = Source.[LearningStartDate],
    [OrganisationId] = Source.[OrganisationId],
    [OverallGrade] = Source.[OverallGrade],
    [PrivatelyFundedStatus] = Source.[PrivatelyFundedStatus],
    [ProviderName] = Source.[ProviderName],
    [ProviderUkPrn] = Source.[ProviderUkPrn],
    [Registration] = Source.[Registration],
    [StandardCode] = Source.[StandardCode],
    [StandardLevel] = Source.[StandardLevel],
    [StandardName] = Source.[StandardName],
    [StandardPublicationDate] = Source.[StandardPublicationDate],
    [StandardReference] = Source.[StandardReference],
    [StandardUId] = Source.[StandardUId],
    [Status] = Source.[Status],
    [ToBePrinted] = Source.[ToBePrinted],
    [Uln] = Source.[Uln],
    [UpdatedAt] = Source.[UpdatedAt],
    [Version] = Source.[Version],
    [AsDm_UpdatedDateTime] = GETDATE()

-- Perform an INSERT if the record does not exist in the target table
WHEN NOT MATCHED BY TARGET
THEN
INSERT (
    [Id],
    [AchievementDate],
    [BatchNumber],
    [CertificateReference],
    [CertificateReferenceId],
    [ContactOrganisation],
    [ContactPostCode],
    [CourseOption],
    [EPADate],
    [CreatedAt],
    [CreatedBy],
    [CreateDay],
    [DeletedAt],
    [Department],
    [IsPrivatelyFunded],
    [LearningStartDate],
    [OrganisationId],
    [OverallGrade],
    [PrivatelyFundedStatus],
    [ProviderName],
    [ProviderUkPrn],
    [Registration],
    [StandardCode],
    [StandardLevel],
    [StandardName],
    [StandardPublicationDate],
    [StandardReference],
    [StandardUId],
    [Status],
    [ToBePrinted],
    [Uln],
    [UpdatedAt],
    [Version],
    [AsDm_UpdatedDateTime]
)
VALUES (
    Source.[Id],
    Source.[AchievementDate],
    Source.[BatchNumber],
    Source.[CertificateReference],
    Source.[CertificateReferenceId],
    Source.[ContactOrganisation],
    Source.[ContactPostCode],
    Source.[CourseOption],
    Source.[EPADate],
    Source.[CreatedAt],
    Source.[CreatedBy],
    Source.[CreateDay],
    Source.[DeletedAt],
    Source.[Department],
    Source.[IsPrivatelyFunded],
    Source.[LearningStartDate],
    Source.[OrganisationId],
    Source.[OverallGrade],
    Source.[PrivatelyFundedStatus],
    Source.[ProviderName],
    Source.[ProviderUkPrn],
    Source.[Registration],
    Source.[StandardCode],
    Source.[StandardLevel],
    Source.[StandardName],
    Source.[StandardPublicationDate],
    Source.[StandardReference],
    Source.[StandardUId],
    Source.[Status],
    Source.[ToBePrinted],
    Source.[Uln],
    Source.[UpdatedAt],
    Source.[Version],
    GETDATE()
);

-- Optional: Add output to review actions performed
-- OUTPUT $action, Inserted.*, Deleted.*;



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

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Certificates' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [stg].[Assessor_Certificates]

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Certificatelogs' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [stg].[Assessor_Certificatelogs]

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
