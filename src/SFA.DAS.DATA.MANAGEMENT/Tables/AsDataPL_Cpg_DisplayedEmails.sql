CREATE TABLE [AsData_PL].[CPG_DisplayedEmails]
(
	[Id] bigint NOT NULL,
	[ExternalId] int NULL,
	[CampaignId] bigint NULL,
	[ContactEmail] varchar(255) NULL,
	[DisplayedDate] datetime2(7) NULL,
	[Format] varchar(255) NULL,
	[TimeDisplayed] int NULL,
	[IsSuspectedBot] bit NULL,
	[Device] varchar(255) NULL,
	[ClientName] varchar(255) NULL,
	[Os] varchar(255) NULL,
	[OsFamily] varchar(255) NULL,
	[IpAddress] varchar(15) NULL,
	[ClientType] varchar(255) NULL,
	[ClientFamily] varchar(255) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_DisplayedEmails] PRIMARY KEY CLUSTERED ([Id])
)
