CREATE TABLE [ASData_PL].[CRSDel_ProviderStandard]
(
		[StandardId]			int			NOT NULL,
		[UkPrn]					int			NOT NULL,
		[StandardInfoUrl]		varchar		NULL,
		[Email]					varchar		NULL,		
		[AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())		
)