CREATE TABLE [ASData_PL].[APAR_ROATP_Organisations]
(
	[Id] NVARCHAR(255), 
	[CreatedAt] datetime2, 
	[UpdatedAt] datetime2, 
	[StatusId] INT, 
	[ProviderTypeId] INT, 
	[OrganisationTypeId] INT,
	[UKPRN] BigINT,
	[LegalName] NVARCHAR(200),
	[TradingName] NVARCHAR(200),
	[OrganisationData] NVARCHAR(Max) Null,
	[StatusDate] datetime,
	[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
)
