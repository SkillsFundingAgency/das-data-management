CREATE PROCEDURE [dbo].[ImportFinanceToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 18/05/2021
-- Description: Import, Transform and Load Finance Presentation Layer Tables
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
			   ,'ImportFinanceToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		   WHERE StoredProcedureName='ImportFinanceToPL'
			 AND RunId=@RunID

		BEGIN TRANSACTION

								
               -- Delete and Transform Paye Data ---

                TRUNCATE TABLE ASData_PL.Fin_TransactionLine

				
                DECLARE @VSQL NVARCHAR(MAX)

                SET @VSQL='

				INSERT INTO ASData_PL.Fin_TransactionLine
				(     
				  [Id]
                 ,[AccountId]
                 ,[DateCreated]
                 ,[SubmissionId]
                 ,[TransactionDate]
                 ,[TransactionType]
                 ,[LevyDeclared]
                 ,[Amount]
                 ,[EmpRef]
                 ,[PeriodEnd]
                 ,[Ukprn]
                 ,[SfaCoInvestmentAmount]
                 ,[EmployerCoInvestmentAmount]
                 ,[EnglishFraction]
                 ,[TransferSenderAccountId]
                 ,[TransferSenderAccountName]
                 ,[TransferReceiverAccountId]
                 ,[TransferReceiverAccountName]
				)
				SELECT [Id]
                      ,[AccountId]
                      ,[DateCreated]
                      ,[SubmissionId]
                      ,[TransactionDate]
                      ,[TransactionType]
                      ,[LevyDeclared]
                      ,[Amount]
                      ,convert(NVarchar(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(EmpRef, saltkeydata.SaltKey)))),2) [EmpRef]
                      ,[PeriodEnd]
                      ,[Ukprn]
                      ,[SfaCoInvestmentAmount]
                      ,[EmployerCoInvestmentAmount]
                      ,[EnglishFraction]
                      ,[TransferSenderAccountId]
                      ,[TransferSenderAccountName]
                      ,[TransferReceiverAccountId]
                      ,[TransferReceiverAccountName]
				 FROM Stg.Fin_TransactionLine FT
				CROSS JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType =''EmployerReference''  Order by SaltKeyID DESC ) SaltKeyData
				'

				EXEC SP_EXECUTESQL @VSQL

				 

				/* Delete and Transform LevyDeclarationsAndTopUp Data */

				
				
				DELETE FROM ASData_PL.Fin_GetLevyDeclarationAndTopUp

				SET @VSQL=''
				SET @VSQL='
				INSERT INTO ASData_PL.Fin_GetLevyDeclarationAndTopUp
				(      [Id]
                      ,[AccountId]
                      ,[EmpRef]
                      ,[SubmissionDate]
					  ,[SubmissionId]
                      ,[LevyDueYTD]
                      ,[EnglishFraction]
                      ,[TopUpPercentage]
                      ,[PayrollYear]
                      ,[PayrollMonth]
                      ,[LastSubmission]
                      ,[CreatedDate]
                      ,[EndOfYearAdjustment]
                      ,[EndOfYearAdjustmentAmount]
                      ,[LevyAllowanceForYear]
                      ,[DateCeased]
                      ,[InactiveFrom]
                      ,[InactiveTo]
                      ,[HmrcSubmissionId]
                      ,[NoPaymentForPeriod]
                      ,[LevyDeclaredInMonth]
                      ,[TopUp]
                      ,[TotalAmount]
				)
				SELECT [Id]
                      ,[AccountId]
                      ,convert(NVarchar(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(EmpRef, saltkeydata.SaltKey)))),2) [EmpRef]
                      ,[SubmissionDate]
					  ,[SubmissionId]
                      ,[LevyDueYTD]
                      ,[EnglishFraction]
                      ,[TopUpPercentage]
                      ,[PayrollYear]
                      ,[PayrollMonth]
                      ,[LastSubmission]
                      ,[CreatedDate]
                      ,[EndOfYearAdjustment]
                      ,[EndOfYearAdjustmentAmount]
                      ,[LevyAllowanceForYear]
                      ,[DateCeased]
                      ,[InactiveFrom]
                      ,[InactiveTo]
                      ,[HmrcSubmissionId]
                      ,[NoPaymentForPeriod]
                      ,[LevyDeclaredInMonth]
                      ,[TopUp]
                      ,[TotalAmount]
				 FROM Stg.Fin_GetLevyDeclarationAndTopUp LD
				 CROSS JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType =''EmployerReference''  Order by SaltKeyID DESC ) SaltKeyData
				 '

				 EXEC SP_EXECUTESQL @VSQL


				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_GetLevyDeclarationAndTopUp' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Fin_GetLevyDeclarationAndTopUp]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_TransactionLine' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				DROP TABLE [Stg].[Fin_TransactionLine] 

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

		  /* Drop Staging Table even if the Job Fails */

		  	IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_GetLevyDeclarationAndTopUp' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
			DROP TABLE [Stg].[Fin_GetLevyDeclarationAndTopUp]

			IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_TransactionLine' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
			DROP TABLE [Stg].[Fin_TransactionLine]

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
				'ImportFinanceToPL',
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
