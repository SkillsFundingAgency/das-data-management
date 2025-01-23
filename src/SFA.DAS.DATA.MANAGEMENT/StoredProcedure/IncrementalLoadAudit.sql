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


INSERT INTO Mtd.SourceToStageAudit
(SourceDatabaseName,SourceTableName,SourceSchemaName,SourceQuery,WatermarkColumnName,StagingTableName)
VALUES
 ('Assessor','CertificateLogs','dbo','select [Id],[Action],[CertificateId],[EventTime],[Status],[BatchNumber],[ReasonForChange],[LatestEpaOutcome],[StandardName],[StandardLevel],[StandardPublicationDate],[ContactOrganisation],left(ContactPostCode,len(ContactPostCode)-charindex('''' '''',ContactPostCode)+1) [ContactPostCode],[Registration],[LearningStartDate],[AchievementDate],[CourseOption],[OverallGrade],[Department] FROM ( select [Id],[Action],[CertificateId],[EventTime],[Status],[BatchNumber],[ReasonForChange],[LatestEpaOutcome],JSON_VALUE(CertificateData,''''$.StandardName'''') [StandardName],JSON_VALUE(CertificateData,''''$.StandardLevel'''') [StandardLevel],JSON_VALUE(CertificateData,''''$.StandardPublicationDate'''') [StandardPublicationDate],JSON_VALUE(CertificateData,''''$.ContactOrganisation'''') [ContactOrganisation],JSON_VALUE(CertificateData,''''$.ContactPostCode'''') [ContactPostCode],JSON_VALUE(CertificateData,''''$.Registration'''') [Registration],JSON_VALUE(CertificateData,''''$.LearningStartDate'''') [LearningStartDate],JSON_VALUE(CertificateData,''''$.AchievementDate'''') [AchievementDate],JSON_VALUE(CertificateData,''''$.CourseOption'''') [CourseOption],JSON_VALUE(CertificateData,''''$.OverallGrade'''') [OverallGrade],JSON_VALUE(CertificateData,''''$.Department'''') [Department] from [dbo].[CertificateLogs] ) As Query','EventTime','Assessor_CertificateLogs')
,('Assessor','Learner','dbo','SELECT [Id],[StdCode],[LearnStartDate],[EpaOrgId],[FundingModel],[ApprenticeshipId],[Source],[CompletionStatus],[PlannedEndDate],[LearnActEndDate],[WithdrawReason],[Outcome],[AchDate],[OutGrade],[Version],[VersionConfirmed],[CourseOption],[StandardUId],[StandardReference],[StandardName],[LastUpdated],[EstimatedEndDate],[ApprovalsStopDate],[ApprovalsPauseDate],[ApprovalsCompletionDate],[ApprovalsPaymentStatus],[LatestIlrs],[LatestApprovals],[Uln],[UkPrn],[GivenNames],[FamilyName],[LearnRefNumber],[IsTransfer],[DelLocPostCode] FROM [dbo].[Learner]','Lastupdated','Assessor_Learner')
,('Assessor','Certificates','dbo','select [Id],[ToBePrinted],[CreatedAt],[CreatedBy],[DeletedAt],[DeletedBy],[CertificateReference],[OrganisationId],[BatchNumber],[Status],[UpdatedAt],[UpdatedBy],[StandardCode],[ProviderUkPrn],[CertificateReferenceId],[CreateDay],[IsPrivatelyFunded],[PrivatelyFundedStatus],[StandardUId],[uln],STUFF(LearnerGivenNames,2,len(LearnerGivenNames)-2,REPLICATE(''''X'''', len(LearnerGivenNames)-2)) As LearnerGivenNames,STUFF(LearnerFamilyName,2,len(LearnerFamilyName)-2,REPLICATE(''''X'''',len(LearnerFamilyName)-2)) As LearnerFamilyName,StandardName,StandardLevel,StandardPublicationDate,STUFF(ContactName,2,len(ContactName)-2,REPLICATE(''''X'''',len(ContactName)-2)) As ContactName,ContactOrganisation,left(ContactPostCode,len(ContactPostCode)-charindex('''' '''',ContactPostCode)+1) As ContactPostCode,STUFF(Registration,2,len(Registration)-2,REPLICATE(''''X'''',len(Registration)-2)) As Registration,LearningStartDate,AchievementDate,CourseOption,OverallGrade,Department,ProviderName,StandardReference,EPADate,Version FROM (select [Id],[ToBePrinted],[CreatedAt],[CreatedBy],[DeletedAt],[DeletedBy],[CertificateReference],[OrganisationId],[BatchNumber],[Status],[UpdatedAt],[UpdatedBy],[StandardCode],[ProviderUkPrn],[CertificateReferenceId],[CreateDay],[IsPrivatelyFunded],[PrivatelyFundedStatus],[StandardUId],[uln],JSON_VALUE(certificatedata,''''$.LearnerGivenNames'''') LearnerGivenNames,JSON_VALUE(certificatedata,''''$.LearnerFamilyName'''') LearnerFamilyName,JSON_VALUE(certificatedata,''''$.StandardName'''') StandardName,JSON_VALUE(certificatedata,''''$.StandardLevel'''') StandardLevel,JSON_VALUE(certificatedata,''''$.StandardPublicationDate'''') StandardPublicationDate,JSON_VALUE(certificatedata,''''$.ContactName'''') ContactName,JSON_VALUE(certificatedata,''''$.ContactOrganisation'''') ContactOrganisation,JSON_VALUE(certificatedata,''''$.ContactPostCode'''') ContactPostCode,JSON_VALUE(certificatedata,''''$.Registration'''') Registration,JSON_VALUE(certificatedata,''''$.LearningStartDate'''') LearningStartDate,JSON_VALUE(certificatedata,''''$.AchievementDate'''') AchievementDate,JSON_VALUE(certificatedata,''''$.CourseOption'''') CourseOption,JSON_VALUE(certificatedata,''''$.OverallGrade'''') OverallGrade,JSON_VALUE(certificatedata,''''$.Department'''') Department,JSON_VALUE(certificatedata,''''$.FullName'''') FullName,JSON_VALUE(certificatedata,''''$.ProviderName'''') ProviderName,JSON_VALUE(certificatedata,''''$.StandardReference'''') StandardReference,JSON_VALUE(certificatedata,''''$.EpaDetails.LatestEpaDate'''') EPADate,JSON_VALUE([CertificateData],''''$.Version'''') As Version from [dbo].[Certificates]) As Query ','UpdatedAt','Assessor_Certificates')



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