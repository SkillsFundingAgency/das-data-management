CREATE PROCEDURE [dbo].[ImportComtToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Manju Nagarajan
-- Create Date: 26/10/2023
-- Description: Import, Transform and Load Apprenticeship Redundancy and Commitments Presentation Layer Table
-- ==========================================================================================================

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
	   ,'ImportComtToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportComtToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

 /* Import Commitments Apprenticeship to PL */

 TRUNCATE TABLE [ASData_PL].[Comt_Apprenticeship]

 DECLARE @VSQL3 NVARCHAR(MAX)

SET @VSQL3='
 
INSERT INTO [ASData_PL].[Comt_Apprenticeship]
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
           ,[CostBeforeRpl]
           )
 SELECT    [Id]
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
            END                 as Age
           ,[DeliveryModel]
           ,[RecognisePriorLearning]
           ,[IsOnFlexiPaymentPilot]
           ,[TrainingTotalHours]
           ,[CostBeforeRpl]
    FROM Stg.Comt_Apprenticeship
'

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
	    'ImportComtToPL',
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

