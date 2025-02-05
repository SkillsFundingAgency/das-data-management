CREATE PROCEDURE [dbo].[IncrementalLoadAudit]
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
	   ,'IncrementalLoadAudit'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='IncrementalLoadAudit'
     AND RunId=@RunID

BEGIN TRANSACTION

CREATE TABLE #Temp_SourceToStageAudit
    (
        AuditID INT IDENTITY(1,1) NOT NULL,
        SourceDatabaseName NVARCHAR(100) NOT NULL,
        SourceSchemaName NVARCHAR(100) NOT NULL,
        SourceTableName NVARCHAR(100) NOT NULL,
        SourceQuery NVARCHAR(MAX) NULL,
        WatermarkColumnName NVARCHAR(100) NOT NULL,
        WatermarkValue DATETIME2(7) NULL,
        StagingTableName NVARCHAR(100) NULL,
        LastUpdatedTimestamp DATETIME NULL,
        SpName NVARCHAR(100) NULL
    );

    -- Step 2: Insert existing records into the temp table
    INSERT INTO #Temp_SourceToStageAudit 
	(
    SourceDatabaseName,
    SourceSchemaName,
    SourceTableName,
    SourceQuery,
    WatermarkColumnName,
    WatermarkValue,
    StagingTableName,
    LastUpdatedTimestamp,
    SpName
    )
    SELECT 
    SourceDatabaseName,
    SourceSchemaName,
    SourceTableName,
    SourceQuery,
    WatermarkColumnName,
    WatermarkValue,
    StagingTableName,
    LastUpdatedTimestamp,
    SpName
    FROM Mtd.SourceToStageAudit;

    -- Step 3: Truncate the original table
    TRUNCATE TABLE Mtd.SourceToStageAudit;

INSERT INTO Mtd.SourceToStageAudit
(SourceDatabaseName,SourceTableName,SourceSchemaName,SourceQuery,WatermarkColumnName,WaterMarkValue,StagingTableName,Lastupdatedtimestamp,SpName)
VALUES
 ('Assessor','CertificateLogs','dbo','select [Id],[Action],[CertificateId],[EventTime],[Status],[BatchNumber],[ReasonForChange],[LatestEpaOutcome],[StandardName],[StandardLevel],[StandardPublicationDate],[ContactOrganisation],left(ContactPostCode,len(ContactPostCode)-charindex('''' '''',ContactPostCode)+1) [ContactPostCode],[Registration],[LearningStartDate],[AchievementDate],[CourseOption],[OverallGrade],[Department] FROM ( select [Id],[Action],[CertificateId],[EventTime],[Status],[BatchNumber],[ReasonForChange],[LatestEpaOutcome],JSON_VALUE(CertificateData,''''$.StandardName'''') [StandardName],JSON_VALUE(CertificateData,''''$.StandardLevel'''') [StandardLevel],JSON_VALUE(CertificateData,''''$.StandardPublicationDate'''') [StandardPublicationDate],JSON_VALUE(CertificateData,''''$.ContactOrganisation'''') [ContactOrganisation],JSON_VALUE(CertificateData,''''$.ContactPostCode'''') [ContactPostCode],JSON_VALUE(CertificateData,''''$.Registration'''') [Registration],JSON_VALUE(CertificateData,''''$.LearningStartDate'''') [LearningStartDate],JSON_VALUE(CertificateData,''''$.AchievementDate'''') [AchievementDate],JSON_VALUE(CertificateData,''''$.CourseOption'''') [CourseOption],JSON_VALUE(CertificateData,''''$.OverallGrade'''') [OverallGrade],JSON_VALUE(CertificateData,''''$.Department'''') [Department] from [dbo].[CertificateLogs] ) As Query','EventTime','1900-01-01','Assessor_CertificateLogs',Getdate(),'ImportAssessor_CertificateLogsToPL')
,('Assessor','Learner','dbo','SELECT [Id],[StdCode],[LearnStartDate],[EpaOrgId],[FundingModel],[ApprenticeshipId],[Source],[CompletionStatus],[PlannedEndDate],[LearnActEndDate],[WithdrawReason],[Outcome],[AchDate],[OutGrade],[Version],[VersionConfirmed],[CourseOption],[StandardUId],[StandardReference],[StandardName],[LastUpdated],[EstimatedEndDate],[ApprovalsStopDate],[ApprovalsPauseDate],[ApprovalsCompletionDate],[ApprovalsPaymentStatus],[LatestIlrs],[LatestApprovals],[Uln],[UkPrn],[GivenNames],[FamilyName],[LearnRefNumber],[IsTransfer],[DelLocPostCode] FROM [dbo].[Learner]','Lastupdated','1900-01-01','Assessor_Learner',Getdate(),'ImportAssessor_LearnerToPL')
,('Assessor','Certificates','dbo','select [Id],[ToBePrinted],[CreatedAt],[CreatedBy],[DeletedAt],[DeletedBy],[CertificateReference],[OrganisationId],[BatchNumber],[Status],[UpdatedAt],[UpdatedBy],[StandardCode],[ProviderUkPrn],[CertificateReferenceId],[CreateDay],[IsPrivatelyFunded],[PrivatelyFundedStatus],[StandardUId],[uln],STUFF(LearnerGivenNames,2,len(LearnerGivenNames)-2,REPLICATE(''''X'''', len(LearnerGivenNames)-2)) As LearnerGivenNames,STUFF(LearnerFamilyName,2,len(LearnerFamilyName)-2,REPLICATE(''''X'''',len(LearnerFamilyName)-2)) As LearnerFamilyName,StandardName,StandardLevel,StandardPublicationDate,STUFF(ContactName,2,len(ContactName)-2,REPLICATE(''''X'''',len(ContactName)-2)) As ContactName,ContactOrganisation,left(ContactPostCode,len(ContactPostCode)-charindex('''' '''',ContactPostCode)+1) As ContactPostCode,STUFF(Registration,2,len(Registration)-2,REPLICATE(''''X'''',len(Registration)-2)) As Registration,LearningStartDate,AchievementDate,CourseOption,OverallGrade,Department,ProviderName,StandardReference,EPADate,Version FROM (select [Id],[ToBePrinted],[CreatedAt],[CreatedBy],[DeletedAt],[DeletedBy],[CertificateReference],[OrganisationId],[BatchNumber],[Status],[UpdatedAt],[UpdatedBy],[StandardCode],[ProviderUkPrn],[CertificateReferenceId],[CreateDay],[IsPrivatelyFunded],[PrivatelyFundedStatus],[StandardUId],[uln],JSON_VALUE(certificatedata,''''$.LearnerGivenNames'''') LearnerGivenNames,JSON_VALUE(certificatedata,''''$.LearnerFamilyName'''') LearnerFamilyName,JSON_VALUE(certificatedata,''''$.StandardName'''') StandardName,JSON_VALUE(certificatedata,''''$.StandardLevel'''') StandardLevel,JSON_VALUE(certificatedata,''''$.StandardPublicationDate'''') StandardPublicationDate,JSON_VALUE(certificatedata,''''$.ContactName'''') ContactName,JSON_VALUE(certificatedata,''''$.ContactOrganisation'''') ContactOrganisation,JSON_VALUE(certificatedata,''''$.ContactPostCode'''') ContactPostCode,JSON_VALUE(certificatedata,''''$.Registration'''') Registration,JSON_VALUE(certificatedata,''''$.LearningStartDate'''') LearningStartDate,JSON_VALUE(certificatedata,''''$.AchievementDate'''') AchievementDate,JSON_VALUE(certificatedata,''''$.CourseOption'''') CourseOption,JSON_VALUE(certificatedata,''''$.OverallGrade'''') OverallGrade,JSON_VALUE(certificatedata,''''$.Department'''') Department,JSON_VALUE(certificatedata,''''$.FullName'''') FullName,JSON_VALUE(certificatedata,''''$.ProviderName'''') ProviderName,JSON_VALUE(certificatedata,''''$.StandardReference'''') StandardReference,JSON_VALUE(certificatedata,''''$.EpaDetails.LatestEpaDate'''') EPADate,JSON_VALUE([CertificateData],''''$.Version'''') As Version from [dbo].[Certificates]) As Query ','UpdatedAt','1900-01-01','Assessor_Certificates',getdate(),'ImportAssessor_CertificatesToPL')
,('Finance','Payment','employer_financial','SELECT [PaymentId],[Ukprn],[Uln],[AccountId],[ApprenticeshipId],[DeliveryPeriodMonth],[DeliveryPeriodYear],[CollectionPeriodId],[CollectionPeriodMonth],[CollectionPeriodYear],[EvidenceSubmittedOn],[EmployerAccountVersion],[ApprenticeshipVersion],[FundingSource],[TransactionType],[Amount],[PeriodEnd],[PaymentMetaDataId],[DateImported]  FROM [employer_financial].[Payment]','[DateImported]','1900-01-01','Fin_Payment',Getdate(),'ImportFin_PaymentToPL')
,('Finance','TransactionLine','employer_financial','SELECT [Id],[AccountId],[DateCreated],[SubmissionId],[TransactionDate],[TransactionType],[LevyDeclared],[Amount],[EmpRef],[PeriodEnd],[Ukprn],[SfaCoInvestmentAmount],[EmployerCoInvestmentAmount],[EnglishFraction],[TransferSenderAccountId],[TransferSenderAccountName],[TransferReceiverAccountId],[TransferReceiverAccountName]  FROM [employer_financial].[TransactionLine]','[DateCreated]','1900-01-01','Fin_TransactionLine',Getdate(),'ImportFin_TransactionLineToPL')


UPDATE tgt
    SET 
        tgt.WatermarkValue = tmp.WatermarkValue,
        tgt.LastUpdatedTimestamp = tmp.LastUpdatedTimestamp
    FROM Mtd.SourceToStageAudit tgt
    INNER JOIN #Temp_SourceToStageAudit tmp
    ON tgt.SourceDatabaseName = tmp.SourceDatabaseName 
    AND tgt.SourceTableName = tmp.SourceTableName;

DROP TABLE #Temp_SourceToStageAudit

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
	    'IncrementalLoadAudit',
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