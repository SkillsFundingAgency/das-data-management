CREATE PROCEDURE [dbo].[ImportAssessor_CertificatesToPL]
(
   @RunId int
)
AS


BEGIN TRY

DECLARE @LogID int
DECLARE @DynSQL1   NVarchar(max)


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
	   ,'ImportAssessor_CertificatesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportAssessor_CertificatesToPL'
     AND RunId=@RunID


BEGIN TRANSACTION



 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Certificates' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       
 Set @DynSQL1 = '
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
);'

exec SP_EXECUTESQL @DynSQL1

-- Optional: Add output to review actions performed
-- OUTPUT $action, Inserted.*, Deleted.*;



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
	    'ImportAssessor_certificatesToPL',
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
