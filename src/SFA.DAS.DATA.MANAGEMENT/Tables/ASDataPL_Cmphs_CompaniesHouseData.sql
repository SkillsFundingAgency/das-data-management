CREATE TABLE [ASData_PL].[Cmphs_CompaniesHouseData]
(	[CompanyNumber]						[varchar](255)		NULL,	
	[CompanyCategory]					[varchar](100)		NULL,
	[CompanyStatus]						[varchar](100)		NULL,	
	[SICCodeSicText_1]					[varchar](250)		NULL,
	[ImportDateTime]					[datetime] DEFAULT (getdate()),
	[ID]                                bigint              NULL
) ON [PRIMARY]
