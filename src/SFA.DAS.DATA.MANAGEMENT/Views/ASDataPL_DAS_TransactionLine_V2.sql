 CREATE VIEW [ASData_PL].[DAS_TransactionLine_V2]  
 AS 
 		SELECT 
					[Id], 
					[AccountId],  
					[DateCreated],  
					[SubmissionId],  
					[TransactionDate],  
					[TransactionType],  
					[LevyDeclared],  
					[Amount], 
 					[EmpRef],	 
					[PeriodEnd],  
					[Ukprn],  
					[SfaCoInvestmentAmount],  
					[EmployerCoInvestmentAmount],  
					[EnglishFraction],  
					[TransferSenderAccountId],  
					CAST([TransferSenderAccountName] AS NVARCHAR(100)) As [TransferSenderAccountName],  
					[TransferReceiverAccountId],  
					CAST([TransferReceiverAccountName] AS NVARCHAR(100)) As [TransferReceiverAccountName]  
			FROM [ASData_PL].[Fin_TransactionLine]
			
GO
