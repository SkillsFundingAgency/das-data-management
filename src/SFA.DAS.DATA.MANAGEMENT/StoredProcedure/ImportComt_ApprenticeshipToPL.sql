CREATE PROCEDURE [dbo].[ImportComt_ApprenticeshipToPL]
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
	   ,'ImportComt_ApprenticeshipToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportComt_ApprenticeshipToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

 /* Import Commitments Apprenticeship to PL */


 DECLARE @VSQL1 NVARCHAR(MAX)

---SET @VSQL1=
 MERGE [ASData_PL].[Comt_ApprenticeshipCandidateRegDetails] AS Target
USING (
    SELECT  [Id]
           ,[CommitmentId]
           ,[ULN]
           ,[TrainingType]
           ,[TrainingCode]
           ,[TrainingName]
           ,[TrainingCourseVersion]
           ,[TrainingCourseVersionConfirmed]
           ,[TrainingCourseOption]
           ,[StandardUId]
           ,[Cost]
           ,[StartDate]
           ,[EndDate]
           ,[AgreementStatus]
           ,[PaymentStatus]
           ,[DateOfBirth]
           ,[CreatedOn]
           ,[AgreedOn]
           ,[PaymentOrder]
           ,[StopDate]
           ,[PauseDate]
           ,[HasHadDataLockSuccess]
           ,[PendingUpdateOriginator]
           ,[EPAOrgId]
           ,[CloneOf]
           ,[ReservationId]
           ,[IsApproved]
           ,[CompletionDate]
           ,[ContinuationOfId]
           ,[MadeRedundant]
           ,[OriginalStartDate]
           ,CASE WHEN [DateOfBirth] IS NULL	THEN - 1 
		        WHEN DATEPART([M], [DateOfBirth]) > DATEPART([M], getdate()) 
		          OR DATEPART([M], [DateOfBirth]) = DATEPART([M], getdate()) 
		         AND DATEPART([DD],[DateOfBirth]) > DATEPART([DD], getdate()) 
		        THEN DATEDIFF(YEAR,[DateOfBirth], getdate()) - 1 
		        ELSE DATEDIFF(YEAR,[DateOfBirth], getdate()) 
            END   as Age
           ,[DeliveryModel]
           ,[RecognisePriorLearning]
           ,[IsOnFlexiPaymentPilot]
           ,[TrainingTotalHours]
           ,[ActualStartDate] 
           ,[EmailAddressConfirmed] 
           ,[LastUpdated] 
           ,[UpdatedOn]
           ,[TrainingPrice]
           ,[EndPointAssessmentPrice]
           ,[EmployerHasEditedCost]
    FROM Stg.Comt_Apprenticeship Ap
) AS Source
ON Target.[Id] = Source.[Id]

WHEN MATCHED 
     AND Source.[UpdatedOn] > Target.[UpdatedOn]
      THEN
 UPDATE SET
        Target.[CommitmentId] = Source.[CommitmentId],
        Target.[ULN] = Source.[ULN],
        Target.[TrainingType] = Source.[TrainingType],
        Target.[TrainingCode] = Source.[TrainingCode],
        Target.[TrainingName] = Source.[TrainingName],
        Target.[TrainingCourseVersion] = Source.[TrainingCourseVersion],
        Target.[TrainingCourseVersionConfirmed] = Source.[TrainingCourseVersionConfirmed],
        Target.[TrainingCourseOption] = Source.[TrainingCourseOption],
        Target.[StandardUId] = Source.[StandardUId],
        Target.[Cost] = Source.[Cost],
        Target.[StartDate] = Source.[StartDate],
        Target.[EndDate] = Source.[EndDate],
        Target.[AgreementStatus] = Source.[AgreementStatus],
        Target.[PaymentStatus] = Source.[PaymentStatus],
        Target.[DateOfBirth] = Source.[DateOfBirth],
        Target.[CreatedOn] = Source.[CreatedOn],
        Target.[AgreedOn] = Source.[AgreedOn],
        Target.[PaymentOrder] = Source.[PaymentOrder],
        Target.[StopDate] = Source.[StopDate],
        Target.[PauseDate] = Source.[PauseDate],
        Target.[HasHadDataLockSuccess] = Source.[HasHadDataLockSuccess],
        Target.[PendingUpdateOriginator] = Source.[PendingUpdateOriginator],
        Target.[EPAOrgId] = Source.[EPAOrgId],
        Target.[CloneOf] = Source.[CloneOf],
        Target.[ReservationId] = Source.[ReservationId],
        Target.[IsApproved] = Source.[IsApproved],
        Target.[CompletionDate] = Source.[CompletionDate],
        Target.[ContinuationOfId] = Source.[ContinuationOfId],
        Target.[MadeRedundant] = Source.[MadeRedundant],
        Target.[OriginalStartDate] = Source.[OriginalStartDate],
        Target.[Age] = Source.Age,
        Target.[DeliveryModel] = Source.[DeliveryModel],
        Target.[RecognisePriorLearning] = Source.[RecognisePriorLearning],
        Target.[IsOnFlexiPaymentPilot] = Source.[IsOnFlexiPaymentPilot],
        Target.[TrainingTotalHours] = Source.[TrainingTotalHours],
        Target.[ActualStartDate] = Source.[ActualStartDate],
        Target.[EmailAddressConfirmed] = Source.[EmailAddressConfirmed],
        Target.[LastUpdated] = Source.[LastUpdated],
        Target.[UpdatedOn] = Source.[UpdatedOn],
        Target.[TrainingPrice] = Source.[TrainingPrice],
        Target.[EndPointAssessmentPrice] = Source.[EndPointAssessmentPrice],
        Target.[EmployerHasEditedCost] = Source.[EmployerHasEditedCost]

WHEN NOT MATCHED THEN
  INSERT  
            ([Id]
           ,[CommitmentId]
           ,[ULN]
           ,[TrainingType]
           ,[TrainingCode]
           ,[TrainingName]
           ,[TrainingCourseVersion]
           ,[TrainingCourseVersionConfirmed]
           ,[TrainingCourseOption]
           ,[StandardUId]
           ,[Cost]
           ,[StartDate]
           ,[EndDate]
           ,[AgreementStatus]
           ,[PaymentStatus]
           ,[DateOfBirth]
           ,[CreatedOn]
           ,[AgreedOn]
           ,[PaymentOrder]
           ,[StopDate]
           ,[PauseDate]
           ,[HasHadDataLockSuccess]
           ,[PendingUpdateOriginator]
           ,[EPAOrgId]
           ,[CloneOf]
           ,[ReservationId]
           ,[IsApproved]
           ,[CompletionDate]
           ,[ContinuationOfId]
           ,[MadeRedundant]
           ,[OriginalStartDate]
           ,[Age]
           ,[DeliveryModel]
           ,[RecognisePriorLearning]
           ,[IsOnFlexiPaymentPilot]
           ,[TrainingTotalHours]
           ,[ActualStartDate] 
           ,[EmailAddressConfirmed] 
           ,[LastUpdated] 
           ,[UpdatedOn] 
           ,[TrainingPrice]
           ,[EndPointAssessmentPrice]
           ,[EmployerHasEditedCost]
           ,[AsDm_UpdatedDateTime] 
           )

    VALUES (
        Source.[Id],
        Source.[CommitmentId],
        Source.[ULN],
        Source.[TrainingType],
        Source.[TrainingCode],
        Source.[TrainingName],
        Source.[TrainingCourseVersion],
        Source.[TrainingCourseVersionConfirmed],
        Source.[TrainingCourseOption],
        Source.[StandardUId],
        Source.[Cost],
        Source.[StartDate],
        Source.[EndDate],
        Source.[AgreementStatus],
        Source.[PaymentStatus],
        Source.[DateOfBirth],
        Source.[CreatedOn],
        Source.[AgreedOn],
        Source.[PaymentOrder],
        Source.[StopDate],
        Source.[PauseDate],
        Source.[HasHadDataLockSuccess],
        Source.[PendingUpdateOriginator],
        Source.[EPAOrgId],
        Source.[CloneOf],
        Source.[ReservationId],
        Source.[IsApproved],
        Source.[CompletionDate],
        Source.[ContinuationOfId],
        Source.[MadeRedundant],
        Source.[OriginalStartDate],
        Source.[Age],
        Source.[DeliveryModel],
        Source.[RecognisePriorLearning],
        Source.[IsOnFlexiPaymentPilot],
        Source.[TrainingTotalHours],
        Source.[ActualStartDate],
        Source.[EmailAddressConfirmed],
        Source.[LastUpdated],
        Source.[UpdatedOn],
        Source.[TrainingPrice],
        Source.[EndPointAssessmentPrice],
        Source.[EmployerHasEditedCost],
        GetDate()
    );


EXEC SP_EXECUTESQL @VSQL3

  /* Drop Staging Table as it's no longer required */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_Apprenticeship' AND TABLE_SCHEMA=N'Stg') 
DROP TABLE [Stg].Comt_Apprenticeship


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

	/* Drop Staging Table even if it fails */

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_Apprenticeship' AND TABLE_SCHEMA=N'Stg')
     DROP TABLE [Stg].Comt_Apprenticeship

	

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
	    'ImportComt_ApprenticeshipToPL',
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

