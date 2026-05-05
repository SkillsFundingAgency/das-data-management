CREATE TABLE [AsData_PL].[CPG_BouncedEmails]
(
	[Id] int NOT NULL,
	[ExternalId] varchar(100) NULL,
	[CampaignId] int NOT NULL,
	[ContactEmail] varchar(250) NULL,
	[BounceDate] datetime NULL,
	[BounceReason] varchar(500) NULL,
	[BounceType] varchar(100) NULL,
	[ResponseText] varchar(max) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_BouncedEmails] PRIMARY KEY CLUSTERED ([Id])
)
