CREATE TABLE [AsData_PL].[CPG_ClickedLinks]
(
	[Id] bigint NOT NULL,
	[ExternalId] int NULL,
	[CampaignId] bigint NULL,
	[ContactEmail] varchar(255) NULL,
	[ClickedDate] datetime2(7) NULL,
	[FriendlyUrlName] varchar(255) NULL,
	[LinkId] int NULL,
	[Url] varchar(max) NULL,
	[IsMonitored] bit NULL,
	[EmailFormat] varchar(255) NULL,
	[IsSuspectedBot] bit NULL,
	[Device] varchar(255) NULL,
	[ClientName] varchar(255) NULL,
	[Os] varchar(255) NULL,
	[OsFamily] varchar(255) NULL,
	[IpAddress] varchar(15) NULL,
	[ClientType] varchar(255) NULL,
	[ClientFamily] varchar(255) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_ClickedLinks] PRIMARY KEY CLUSTERED ([Id])
)
