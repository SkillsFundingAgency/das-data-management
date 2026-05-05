CREATE TABLE [AsData_PL].[CPG_ClickedLinks]
(
	[Id] int NOT NULL,
	[ExternalId] varchar(100) NULL,
	[CampaignId] int NOT NULL,
	[ContactEmail] varchar(250) NULL,
	[ClickedDate] datetime NULL,
	[FriendlyUrlName] varchar(500) NULL,
	[LinkId] varchar(100) NULL,
	[Url] varchar(2000) NULL,
	[IsMonitored] bit NULL,
	[EmailFormat] varchar(100) NULL,
	[IsSuspectedBot] bit NULL,
	[Device] varchar(100) NULL,
	[ClientName] varchar(250) NULL,
	[Os] varchar(250) NULL,
	[OsFamily] varchar(250) NULL,
	[IpAddress] varchar(100) NULL,
	[ClientType] varchar(100) NULL,
	[ClientFamily] varchar(100) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_ClickedLinks] PRIMARY KEY CLUSTERED ([Id])
)
