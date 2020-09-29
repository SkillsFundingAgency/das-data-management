CREATE TABLE [ASData_PL].[Fin_AccountTransfers]
(
	[Id] [bigint] NOT NULL,
	[SenderAccountId] [bigint] NOT NULL,	
	[ReceiverAccountId] [bigint] NOT NULL,	
	[ApprenticeshipId] [bigint] NOT NULL,
	[CourseName] [varchar](max) NOT NULL,
	[CourseLevel] [int] NULL,
	[PeriodEnd] [nvarchar](20) NOT NULL,
	[Amount] [decimal](18, 5) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[RequiredPaymentId] [uniqueidentifier] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	CONSTRAINT PK_Fin_AccountTransfers_Id PRIMARY KEY CLUSTERED (Id)
)ON [PRIMARY]