CREATE TABLE [ASData_PL].[Fin_Payment]
(
	[PaymentId] [uniqueidentifier] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[Uln] [bigint] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[ApprenticeshipId] [bigint] NOT NULL,
	[DeliveryPeriodMonth] [int] NOT NULL,
	[DeliveryPeriodYear] [int] NOT NULL,
	[CollectionPeriodId] [char](20) NOT NULL,
	[CollectionPeriodMonth] [int] NOT NULL,
	[CollectionPeriodYear] [int] NOT NULL,
	[EvidenceSubmittedOn] [datetime] NOT NULL,
	[EmployerAccountVersion] [varchar](50) NOT NULL,
	[ApprenticeshipVersion] [varchar](25) NOT NULL,
	[FundingSource] [varchar](25) NOT NULL,
	[TransactionType] [varchar](25) NOT NULL,
	[Amount] [decimal](18, 5) NOT NULL,
	[PeriodEnd] [varchar](25) NOT NULL,
	[PaymentMetaDataId] [bigint] NOT NULL,
	[DateImported] [datetime] NULL,
	CONSTRAINT PK_Fin_Payment_PaymentId PRIMARY KEY CLUSTERED (PaymentId)
)ON [PRIMARY]