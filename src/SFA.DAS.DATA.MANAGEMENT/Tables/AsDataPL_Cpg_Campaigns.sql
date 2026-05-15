CREATE TABLE [AsData_PL].[CPG_Campaigns]
(
	[Id] bigint NOT NULL,
	[ExternalId] int NULL,
	[CampaignId] bigint NULL,
	[CampaignName] varchar(max) NULL,
	[Name] varchar(max) NULL,
	[Type] varchar(255) NULL,
	[CreatedBy] varchar(255) NULL,
	[CreatedOn] datetime2(7) NULL,
	[ModifiedBy] varchar(255) NULL,
	[ModifiedOn] datetime2(7) NULL,
	[FirstSendDate] datetime2(7) NULL,
	[LastSendDate] datetime2(7) NULL,
	[FromEmailAddress] varchar(255) NULL,
	[FromName] varchar(255) NULL,
	[ReplyEmailAddress] varchar(255) NULL,
	[Subject] varchar(max) NULL,
	[SubStatus] varchar(255) NULL,
	[ContactCount] int NULL,
	[Account] varchar(255) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_Campaigns] PRIMARY KEY CLUSTERED ([Id])
)
