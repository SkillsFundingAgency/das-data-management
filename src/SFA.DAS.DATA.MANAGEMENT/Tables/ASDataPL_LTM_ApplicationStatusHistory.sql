CREATE TABLE [ASData_PL].[LTM_ApplicationStatusHistory]
(
	[Id] [int]					NOT NULL,
	[ApplicationId] [int]		NULL,
	[CreatedOn] [datetime2](7)	NULL,
	[Status] [tinyint]			NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
