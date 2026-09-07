CREATE TABLE [AsData_PL].[CPG_BouncedEmails]
(
	[Id] bigint NOT NULL,
	[ExternalId] int NULL,
	[CampaignId] bigint NULL,
	[ContactEmail] varchar(255) NULL,
	[BounceDate] datetime2(7) NULL,
	[BounceReason] varchar(255) NULL,
	[BounceType] varchar(255) NULL,
	[ResponseText] varchar(max) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_BouncedEmails] PRIMARY KEY CLUSTERED ([Id])
)
