CREATE TABLE [ASData_PL].[LTM_Application]
(
	[Id] [int]						NOT NULL,
	[EmployerAccountId] [bigint]	NOT NULL,
	[PledgeId] [int]				NOT NULL,
	[Details] [nvarchar](max)		NOT NULL,
	[NumberOfApprentices] [int]		NOT NULL,
	[StandardId] [varchar](20)		NOT NULL,
	[StartDate] [datetime2](7)		NOT NULL,
	[Amount] [int]					NOT NULL,
	[HasTrainingProvider] [bit]		NOT NULL,
	[Sectors] [int]					NOT NULL,	
	[CreatedOn] [datetime2](7)		NOT NULL,
	[Status] [Tinyint]				NOT NULL,
	[UpdatedOn] [Datetime2](7)		NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
