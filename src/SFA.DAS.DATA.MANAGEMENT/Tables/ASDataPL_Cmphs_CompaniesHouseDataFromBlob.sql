CREATE TABLE [ASData_PL].[Cmphs_CompaniesHouseDataFromBlob]
(	
	[CompanyNumber]						[varchar](255)		NULL,	
	[Equity]                            decimal(18,2) NULL,
	[CurrentAssets]                     decimal(18,2) NULL,
	[AsDm_UpdatedDateTime]			    [Datetime2](7)		default getdate()
) ON [PRIMARY]
