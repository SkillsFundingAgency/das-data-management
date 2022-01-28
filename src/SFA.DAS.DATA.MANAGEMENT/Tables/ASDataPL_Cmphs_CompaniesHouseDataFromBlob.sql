CREATE TABLE [ASData_PL].[Cmphs_CompaniesHouseDataFromBlob]
(	
	[CompanyNumber]						[varchar](255)		NULL,	
	[Equity]                            decimal(18,2) NULL,
	[CurrentAssets]                     decimal(18,2) NULL,
	[ImportDateTime]					[datetime] DEFAULT (getdate())
) ON [PRIMARY]
