CREATE TABLE [AsData_PL].[CPG_CampaignImportMetadata]
(
	[Id] bigint NOT NULL,
	[SendId] int NULL,
	[CampaignId] bigint NULL,
	[IsImportComplete] bit NULL,
	[ImportStartDate] datetime2(7) NULL,
	[ImportEndDate] datetime2(7) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_CampaignImportMetadata] PRIMARY KEY CLUSTERED ([Id])
)
