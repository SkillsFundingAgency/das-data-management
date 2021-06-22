CREATE TABLE [ASData_PL].[Fin_GetLevyDeclarationAndTopUp]
(
	[Id] [bigint] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[EmpRef] [nvarchar](500) NOT NULL,
	[SubmissionDate] [datetime] NULL,
	[SubmissionId] [bigint] NOT NULL,
	[LevyDueYTD] [decimal](18, 4) NULL,
	[EnglishFraction] [decimal](18, 5) NULL,
	[TopUpPercentage] [decimal](18, 4) NULL,
	[PayrollYear] [nvarchar](10) NULL,
	[PayrollMonth] [tinyint] NULL,
	[LastSubmission] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[EndOfYearAdjustment] [bit] NOT NULL,
	[EndOfYearAdjustmentAmount] [decimal](18, 4) NULL,
	[LevyAllowanceForYear] [decimal](18, 4) NULL,
	[DateCeased] [datetime] NULL,
	[InactiveFrom] [datetime] NULL,
	[InactiveTo] [datetime] NULL,
	[HmrcSubmissionId] [bigint] NULL,
	[NoPaymentForPeriod] [bit] NULL,
	[LevyDeclaredInMonth] [decimal](19, 4) NULL,
	[TopUp] [decimal](38, 6) NULL,
	[TotalAmount] [decimal](38, 6) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	CONSTRAINT PK_Fin_GetLevyDeclarationAndTopUp_Id PRIMARY KEY CLUSTERED (Id)
)ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX NCI_Fin_GetLevyDeclarationAndTopUp_Id	 ON [ASData_PL].[Fin_GetLevyDeclarationAndTopUp] (AccountId) INCLUDE (LastSubmission)