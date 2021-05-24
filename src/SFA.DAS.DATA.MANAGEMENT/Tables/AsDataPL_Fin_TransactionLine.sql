CREATE TABLE [ASData_PL].[Fin_TransactionLine]
(
	[Id] [bigint] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[SubmissionId] [bigint] NULL,
	[TransactionDate] [datetime] NOT NULL,
	[TransactionType] [tinyint] NOT NULL,
	[LevyDeclared] [decimal](18, 4) NULL,
	[Amount] [decimal](18, 4) NOT NULL,
	[EmpRef] [nvarchar] (500) NULL,
	[PeriodEnd] [nvarchar](50) NULL,
	[Ukprn] [bigint] NULL,
	[SfaCoInvestmentAmount] [decimal](18, 4) NOT NULL,
	[EmployerCoInvestmentAmount] [decimal](18, 4) NOT NULL,
	[EnglishFraction] [decimal](18, 5) NULL,
	[TransferSenderAccountId] [bigint] NULL,
	[TransferSenderAccountName] [nvarchar](100) NULL,
	[TransferReceiverAccountId] [bigint] NULL,
	[TransferReceiverAccountName] [nvarchar](100) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	CONSTRAINT PK_Fin_TransactionLine_Id PRIMARY KEY CLUSTERED (Id)
)ON [PRIMARY]
Go
