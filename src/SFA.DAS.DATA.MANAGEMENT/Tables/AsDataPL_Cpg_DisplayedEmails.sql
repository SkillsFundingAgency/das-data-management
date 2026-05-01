CREATE TABLE [AsData_PL].[CPG_DisplayedEmails]
(
	[Id] int NOT NULL,
	[ExternalId] varchar(100) NULL,
	[CampaignId] int NOT NULL,
	[ContactEmail] varchar(250) NULL,
	[DisplayedDate] datetime NULL,
	[Format] varchar(100) NULL,
	[TimeDisplayed] int NULL,
	[IsSuspectedBot] bit NULL,
	[Device] varchar(100) NULL,
	[ClientName] varchar(250) NULL,
	[Os] varchar(250) NULL,
	[OsFamily] varchar(250) NULL,
	[IpAddress] varchar(100) NULL,
	[ClientType] varchar(100) NULL,
	[ClientFamily] varchar(100) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_DisplayedEmails] PRIMARY KEY CLUSTERED ([Id])
)
