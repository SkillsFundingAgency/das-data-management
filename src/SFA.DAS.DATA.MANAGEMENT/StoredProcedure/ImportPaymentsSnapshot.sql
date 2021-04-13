
CREATE PROCEDURE ImportPaymentsSnapshot
(
   @RunId int
)
AS
-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 03/02/2020
-- Description: Import Payments Snapshot Data to help with Data Science Metadata Refresh Issue
--              ADM- 1036
-- Change Control
--     
-- Date				Author        Jira      Description
-- 06/05/2020 S Heath       ADM-1312  Change to StgPmnts.Payment instead of external table.
-- ==================================================

BEGIN TRY

		 SET NOCOUNT ON
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
			   ,'Step-2'
			   ,'ImportPaymentsSnapshot'
			   ,getdate()
			   ,0

			SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		   WHERE StoredProcedureName='ImportPaymentsSnapshot'
			 AND RunId=@RunID


		/* Import Payments Snapshot for Data Science */
		/* Make it dynamic sql to avoid compile errors while deploying */

		Declare @vsql nvarchar(max)

		set @vsql='
				Delete From ASData_PL.Payments_SS

				INSERT INTO ASData_PL.Payments_SS
				  (
						[PaymentId]
					   ,[UkPrn]
					   ,[Uln]
					   ,[EmployerAccountId]
					   ,DasAccountId
					   ,CommitmentID
					   ,DeliveryMonth
					   ,DeliveryYear
					   ,CollectionMonth
					   ,CollectionYear
					   ,EvidenceSubmittedOn
					   ,EmployerAccountVersion
					   ,ApprenticeshipVersion
					   ,FundingSource
					   ,FundingAccountId
					   ,TransactionType
					   ,Amount
					   ,StdCode
					   ,FworkCode
					   ,ProgType
					   ,PwayCode
					   ,ContractType
					   ,UpdateDateTime
					   ,UpdateDate
					   ,Flag_Latest
					   ,Flag_FirstPayment
					   ,PaymentAge
					   ,PaymentAgeBand
					   ,DeliveryMonthShortNameYear
					   ,DASAccountName
					   ,CollectionPeriodName
					   ,CollectionPeriodMonth
					   ,CollectionPeriodYear
					   ,LearningAimFundingLineType
				  )

				  select 
						[PaymentID], 
						[UKPRN], 
						[ULN], 
						[EmployerAccountID], 
						[DasAccountId], 
						[CommitmentID], 
						[DeliveryMonth], 
						[DeliveryYear], 
						[CollectionMonth], 
						[CollectionYear], 
						[EvidenceSubmittedOn], 
						[EmployerAccountVersion], 
						[ApprenticeshipVersion], 
						[FundingSource], 
						[FundingAccountId], 
						[TransactionType], 
						[Amount], 
						[StdCode], 
						[FworkCode], 
						[ProgType], 
						[PwayCode], 
						[ContractType], 
						[UpdateDateTime], 
						[UpdateDate], 
						[Flag_Latest], 
						[Flag_FirstPayment], 
						[PaymentAge], 
						[PaymentAgeBand], 
						[DeliveryMonthShortNameYear], 
						[DASAccountName], 
						[CollectionPeriodName], 
						[CollectionPeriodMonth], 
						[CollectionPeriodYear],
						[LearningAimFundingLineType]
				From	[Data_Pub].[DAS_Payments]
				'

    EXEC SP_EXECUTESQL @VSQL
 
		 /* Update Log Execution Results as Success if the query ran succesfully*/

		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=1
			  ,EndDateTime=getdate()
			  ,FullJobStatus='Pending'
		 WHERE LogId=@LogID
		   AND RunID=@RunId

END TRY

BEGIN CATCH
			IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION

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
				'ImportPaymentsSnapshot',
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
