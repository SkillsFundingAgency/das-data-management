CREATE TABLE [ASData_PL].[CRSDel_ProviderStandard]
(
		[StandardId]			int					NOT NULL,
		[UkPrn]					int					NOT NULL,
		[StandardInfoUrl]		varchar(1000)		NULL,
		[Email]					varchar(260)		NULL,		
		[AsDm_UpdatedDateTime] [datetime2](7)		DEFAULT (getdate())		
)