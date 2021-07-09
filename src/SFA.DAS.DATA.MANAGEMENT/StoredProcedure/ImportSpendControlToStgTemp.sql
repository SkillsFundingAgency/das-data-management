CREATE PROCEDURE [dbo].[ImportSpendControlToStgTemp]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 09/07/2021
-- Description: Temporary Staging Table to Mitigate Data Extract Issues from Data Science
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
			   ,'ImportSpendControlToStgTemp'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		   WHERE StoredProcedureName='ImportSpendControlToStgTemp'
			 AND RunId=@RunID

		BEGIN TRANSACTION

		DECLARE @VSQL NVARCHAR(MAX)

		/* Spend Control Temp Staging */

		DELETE FROM [Stg].[SpendControl_v2]

        INSERT INTO [Stg].[SpendControl_V2]
           ([EmployerAccountId]
           ,[DasAccountId]
           ,[DasAccountName]
           ,[AccountCreatedDate]
           ,[AccountModifiedDate]
           ,[AccountApprenticeshipEmployerType]
           ,[DasLegalEntityId]
           ,[LegalEntityName]
           ,[AccountLegalEntityCreatedDate]
           ,[AccountSignedAgreementVersion]
           ,[AccountLegalEntityIsDeleted]
           ,[AccountLegalEntityDeletedDate]
           ,[EmployerSignedAgreementId]
           ,[AgreementSignedDate]
           ,[AgreementSignedByUserId]
           ,[ReservationId]
           ,[ReservationIsLevyAccount]
           ,[ReservationCreatedDate]
           ,[ReservationStartDate]
           ,[ReservationExpiryDate]
           ,[ReservationStatus]
           ,[ReservationCourseId]
           ,[CourseTitle]
           ,[CourseLevel]
           ,[ApprenticeshipCommitmentId]
           ,[ApprenticeshipId]
           ,[ApprenticeshipCreatedOn]
           ,[ApprenticeshipStartDate]
           ,[ApprenticeshipTrainingType]
           ,[ApprenticeshipTrainingName]
           ,[ApprenticeshipTrainingCode]
           ,[ApprenticeshipIsApproved]
           ,[ApprenticeshipAgreedOn]
           ,[ApprenticeshipAgreedCost]
           ,[ReservationByEmployerOrProvider]
           ,[CommitmentProviderId]
           ,[CommitmentProviderName]
           ,[CommitmentAgeAtStart]
           ,[CommitmentAgeAtStartBand]
           ,[ApprenticeshipAgreementStatus]
           ,[ApprenticeshipPaymentStatus]
           ,[ApprenticeshipEmployerTypeOnApproval]
           ,[CommitmentTransferSenderId]
           ,[PaymentId]
           ,[PaymentPeriodEnd]
           ,[PaymentFundingSource]
           ,[PaymentTransactionType]
           ,[PaymentApprenticeshipId]
           ,[PaymentAmount])
				SELECT 
					[EmployerAccountId]
           ,[DasAccountId]
           ,[DasAccountName]
           ,[AccountCreatedDate]
           ,[AccountModifiedDate]
           ,[AccountApprenticeshipEmployerType]
           ,[DasLegalEntityId]
           ,[LegalEntityName]
           ,[AccountLegalEntityCreatedDate]
           ,[AccountSignedAgreementVersion]
           ,[AccountLegalEntityIsDeleted]
           ,[AccountLegalEntityDeletedDate]
           ,[EmployerSignedAgreementId]
           ,[AgreementSignedDate]
           ,[AgreementSignedByUserId]
           ,[ReservationId]
           ,[ReservationIsLevyAccount]
           ,[ReservationCreatedDate]
           ,[ReservationStartDate]
           ,[ReservationExpiryDate]
           ,[ReservationStatus]
           ,[ReservationCourseId]
           ,[CourseTitle]
           ,[CourseLevel]
           ,[ApprenticeshipCommitmentId]
           ,[ApprenticeshipId]
           ,[ApprenticeshipCreatedOn]
           ,[ApprenticeshipStartDate]
           ,[ApprenticeshipTrainingType]
           ,[ApprenticeshipTrainingName]
           ,[ApprenticeshipTrainingCode]
           ,[ApprenticeshipIsApproved]
           ,[ApprenticeshipAgreedOn]
           ,[ApprenticeshipAgreedCost]
           ,[ReservationByEmployerOrProvider]
           ,[CommitmentProviderId]
           ,[CommitmentProviderName]
           ,[CommitmentAgeAtStart]
           ,[CommitmentAgeAtStartBand]
           ,[ApprenticeshipAgreementStatus]
           ,[ApprenticeshipPaymentStatus]
           ,[ApprenticeshipEmployerTypeOnApproval]
           ,[CommitmentTransferSenderId]
           ,[PaymentId]
           ,[PaymentPeriodEnd]
           ,[PaymentFundingSource]
           ,[PaymentTransactionType]
           ,[PaymentApprenticeshipId]
           ,[PaymentAmount]
		FROM [ASData_PL].[DAS_SpendControl_V2]
              

		/* Spend Control Non Levy Temp Staging */	  
				

				DELETE FROM [Stg].[SpendControlNonLevy_v2]
        INSERT INTO [Stg].[SpendControlNonLevy_V2]
           ([EmployerAccountId]
           ,[DasAccountId]
           ,[DasAccountName]
           ,[LegalEntityName]
           ,[AccountLegalEntityCreatedDate]
           ,[ReservationId]
           ,[ReservationIsLevyAccount]
           ,[ReservationCreatedDate]
           ,[ReservationStartDate]
           ,[ReservationExpiryDate]
           ,[ReservationStatus]
           ,[ReservationCourseId]
           ,[CourseTitle]
           ,[CourseLevel]
           ,[ApprenticeshipCommitmentId]
           ,[ApprenticeshipId]
           ,[ApprenticeshipCreatedOn]
           ,[ApprenticeshipStartDate]
           ,[ApprenticeshipTrainingType]
           ,[ApprenticeshipTrainingName]
           ,[ApprenticeshipTrainingCode]
           ,[ApprenticeshipIsApproved]
           ,[ApprenticeshipAgreedOn]
           ,[ApprenticeshipAgreedCost]
           ,[ReservationByEmployerOrProvider]
           ,[CommitmentProviderId]
           ,[CommitmentProviderName]
           ,[ApprenticeshipAgreementStatus]
           ,[ApprenticeshipPaymentStatus]
           ,[PaymentId]
           ,[PaymentPeriodEnd]
           ,[PaymentFundingSource]
           ,[PaymentTransactionType]
           ,[PaymentApprenticeshipId]
           ,[PaymentAmount])
				Select [EmployerAccountId]
           ,[DasAccountId]
           ,[DasAccountName]
           ,[LegalEntityName]
           ,[AccountLegalEntityCreatedDate]
           ,[ReservationId]
           ,[ReservationIsLevyAccount]
           ,[ReservationCreatedDate]
           ,[ReservationStartDate]
           ,[ReservationExpiryDate]
           ,[ReservationStatus]
           ,[ReservationCourseId]
           ,[CourseTitle]
           ,[CourseLevel]
           ,[ApprenticeshipCommitmentId]
           ,[ApprenticeshipId]
           ,[ApprenticeshipCreatedOn]
           ,[ApprenticeshipStartDate]
           ,[ApprenticeshipTrainingType]
           ,[ApprenticeshipTrainingName]
           ,[ApprenticeshipTrainingCode]
           ,[ApprenticeshipIsApproved]
           ,[ApprenticeshipAgreedOn]
           ,[ApprenticeshipAgreedCost]
           ,[ReservationByEmployerOrProvider]
           ,[CommitmentProviderId]
           ,[CommitmentProviderName]
           ,[ApprenticeshipAgreementStatus]
           ,[ApprenticeshipPaymentStatus]
           ,[PaymentId]
           ,[PaymentPeriodEnd]
           ,[PaymentFundingSource]
           ,[PaymentTransactionType]
           ,[PaymentApprenticeshipId]
           ,[PaymentAmount]
           FROM AsData_PL.Das_SpendControlNonLevy_v2
							
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
				'ImportSpendControlToStgTemp',
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