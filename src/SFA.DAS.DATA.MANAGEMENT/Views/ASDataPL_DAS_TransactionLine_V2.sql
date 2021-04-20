 CREATE VIEW [ASData_PL].[DAS_TransactionLine_V2]  
 AS 
 		with saltkeydata as 
		(
			Select TOP 1 SaltKeyID,SaltKey From AsData_PL.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC 
		)
		SELECT 
					[Id], 
					[AccountId],  
					[DateCreated],  
					[SubmissionId],  
					[TransactionDate],  
					[TransactionType],  
					[LevyDeclared],  
					[Amount], 
 					CASE 
						WHEN EmpRef IS NOT NULL THEN convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(EmpRef, saltkeydata.SaltKey)))),2) 
					END AS EmpRef,	 
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
			CROSS JOIN saltkeydata
GO
