CREATE VIEW [Data_Pub].[DAS_Employer_Account_Transfers_V2]	
AS 
	SELECT 
     ISNULL(CAST(AT.Id AS bigint),-1)									As TransferId
	 ,ISNULL(CAST(p.TransferSenderAccountId AS bigint),-1)						As SenderAccountId
	, ISNULL(CAST(p.AccountId AS bigint),-1)					As ReceiverAccountId
	, ISNULL(p.EventId,'00000000-0000-0000-0000-000000000000')		As RequiredPaymentId
	, ISNULL(CAST(A.ID AS bigint),-1)									As CommitmentId
	, CAST(p.Amount as decimal(18,5))									As Amount
	, ISNULL(CAST(case when p.ApprenticeshipEmployerType = 1 then 'Levy' else 'Non-Levy' end as nvarchar(50)),'NA')						As Type
	, ISNULL(CAST (p.PeriodEnd AS NVARCHAR(10)),'XXXX')					As CollectionPeriodName
	, ISNULL(CAST(p.CreationDate AS datetime) ,'9999-12-31')  							As UpdateDateTime
	FROM
	(
		 Select
		 TransferSenderAccountId,
		 AccountId,
		 EventId,
		 Amount,
		 ApprenticeshipEmployerType,
		 Cast( sp.AcademicYear AS varchar) + '-R' + RIGHT( '0' + Cast (sp.CollectionPeriod AS varchar),2)  As PeriodEnd,
		 ApprenticeshipId, 
		 CreationDate		 
		 from [StgPmts].[Payment] As sp  
		 WHERE sp.Fundingsource = 5 
	) AS p
	INNER JOIN [ASData_PL].[Comt_Apprenticeship] A 
	ON p.ApprenticeshipId = A.ID
	Left join [ASData_PL].[Fin_AccountTransfers] AT
	ON AT.RequiredPaymentId = p.EventId
GO