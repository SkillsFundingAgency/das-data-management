CREATE TABLE [AsData_PL].[Assessor_OrganisationType](
	[Id] [int]  NOT NULL,
	[Type] [nvarchar](256)  NULL,
	[Status] [nvarchar](10)  NULL,
	[TypeDescription] [nvarchar](500) NULL,
	[FinancialExempt] [bit] NOT NULL,
	[AsDm_UpdatedDateTime]			[Datetime2](7)		default getdate()
)