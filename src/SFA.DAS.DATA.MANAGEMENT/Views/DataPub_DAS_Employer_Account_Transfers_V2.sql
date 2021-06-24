CREATE VIEW [Data_Pub].[DAS_Employer_Account_Transfers_V2]	
AS 
	SELECT
	  ISNULL(CAST(AT.Id AS bigint),-1)									As TransferId
	, ISNULL(CAST(AT.SenderAccountId AS bigint),-1)						As SenderAccountId
	, ISNULL(CAST(AT.ReceiverAccountId AS bigint),-1)					As ReceiverAccountId
	, ISNULL(p.PaymentID,'00000000-0000-0000-0000-000000000000')		As RequiredPaymentId
	, ISNULL(CAST(A.ID AS bigint),-1)									As CommitmentId
	, CAST(p.Amount as decimal(18,5))									As Amount
	, ISNULL(CAST(AT.Type as nvarchar(50)),'NA')						As Type
	, ISNULL(CAST (p.PeriodEnd AS NVARCHAR(10)),'XXXX')					As CollectionPeriodName
	, ISNULL(AT.CreatedDate,'9999-12-31')								As UpdateDateTime
	FROM [ASData_PL].[Fin_AccountTransfers] AT
	INNER JOIN [ASData_PL].[Comt_Apprenticeship] A 
	  ON AT.ApprenticeshipId = A.ID
	LEFT OUTER JOIN 
	(
	  select sp.EventId  As PaymentID,
			 sp.ApprenticeshipId,
			 Cast( sp.AcademicYear AS varchar) + '-R' + RIGHT( '0' + Cast (sp.CollectionPeriod AS varchar),2)  As PeriodEnd,
			 sp.Amount 
	  from [StgPmts].[Payment] As sp  
	  WHERE sp.Fundingsource = 5 
	) AS p ON at.ApprenticeshipId=p.ApprenticeshipId and at.periodend=p.periodend
GO