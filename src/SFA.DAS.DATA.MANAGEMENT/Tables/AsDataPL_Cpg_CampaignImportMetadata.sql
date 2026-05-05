CREATE TABLE [AsData_PL].[CPG_CampaignImportMetadata]
(
	[Id] int NOT NULL,
	[CampaignId] int NOT NULL,
	[IsImportComplete] bit NULL,
	[ImportStartDate] datetime NULL,
	[ImportEndDate] datetime NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_CampaignImportMetadata] PRIMARY KEY CLUSTERED ([Id])
)
