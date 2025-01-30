CREATE PROCEDURE [dbo].[ImportAssessor_CertificateLogsToPL]
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
	   ,'ImportAssessor_CertificateLogsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportAssessor_CertificateLogsToPL'
     AND RunId=@RunID


BEGIN TRANSACTION


    /* Import Assessor_CertificateLogs Details */


 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_Certificatelogs' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')

Set @DynSQL1 = '

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
        [ContactPostcode] ,
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

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Assessor_CertificateLogs' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Assessor_CertificateLogs]

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
	    'ImportAssessor_CertificateLogsToPL',
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
