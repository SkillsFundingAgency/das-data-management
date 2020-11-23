CREATE VIEW [Data_Pub].[DAS_Employer_AccountTransactions_V2]
	AS 
		With LevyDeclarationAndTopUp
		AS
		(SELECT AccountId
			   ,CreatedDate
			   ,SubmissionDate
			   ,PayrollMonth
			   ,PayrollYear
			   ,EnglishFraction
			   ,LevyDeclaredInMonth
			   ,TopUp
		   FROM [ASData_PL].[Fin_GetLevyDeclarationAndTopUp]
		  WHERE LastSubmission=1
		)
			SELECT   CAST(DasAccountID as nvarchar(100))                  as DasAccountId
					,ISNULL(CAST(CreatedDate as DateTime),'9999-12-31') as CreatedDate
					,CAST(SubmissionDate as DateTime)                     as SubmissionDate
					,CAST(PayrollMonth as tinyint)                        as PayrollMonth
					,CAST(PayrollYear as nvarchar(10))                    as PayrollYear
					,CAST(CollectionMonth as int)                         as CollectionMonth
					,CAST(CollectionYear as int)                          as CollectionYear
					,CAST(TransactionType as nvarchar(54))                as TransactionType
					,Cast(Amount AS decimal(37,10))                       as Amount
			FROM (
			SELECT    EA.HashedId AS DasAccountID
				,    LD.CreatedDate
				,	   LD.SubmissionDate
				,    LD.PayrollMonth
				,    LD.PayrollYear
				,    NULL AS CollectionMonth
				,    NULL AS CollectionYear
				,    'IN Levy Money from HMRC' AS TransactionType
				,    ROUND((LD.LevyDeclaredInMonth * LD.EnglishFraction),2) AS Amount
			FROM LevyDeclarationAndTopUp AS LD
			LEFT
			JOIN [ASData_PL].[Acc_Account] EA ON EA.Id = LD.AccountId 
			UNION ALL
			-- Top Up Amount  
			SELECT     EA.HashedId 
					,     LD.CreatedDate
  					,     LD.SubmissionDate
					,     LD.PayrollMonth
					,    LD.PayrollYear
					,    NULL AS CollectionMonth
					,    NULL AS CollectionYear
					,    'IN Levy Top Up Amount' AS TransactionType
					,    ROUND(LD.TopUp,2) AS Amount
				FROM LevyDeclarationAndTopUp AS LD
				LEFT
				JOIN [ASData_PL].[Acc_Account] EA ON EA.Id = LD.AccountId 
				UNION ALL
			-- Payments 
				SELECT       EA.HashedId AS DasAccountId
						,    PS.EvidenceSubmittedOn AS CreatedDate
						,     NULL as SubmissionDate
						,     NULL as PayrollMonth
						,	   NULL as PayrollYear
						,     PS.CollectionPeriodMonth
						,     ps.CollectionPeriodYear
						,    'OUT'+  TT.FieldDesc   AS TransactionType
						,    ROUND((PS.Amount*-1),2) AS Amount -- Made negative as Payment
					FROM [ASData_PL].[Fin_Payment] AS PS
 					LEFT
					JOIN dbo.ReferenceData TT
					ON TT.FieldValue=PS.TransactionType
					AND TT.Category='Payments'
					AND TT.FieldName='TransactionType'
					LEFT 
					JOIN [ASData_PL].[Acc_Account] EA ON EA.Id = [PS].AccountId 
					WHERE PS.FundingSource = 1  -- Only Month coming from balances
					) T
		GO

