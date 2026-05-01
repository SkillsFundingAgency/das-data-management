CREATE TABLE [AsData_PL].[CPG_Campaigns]
(
	[Id] int NOT NULL,
	[ExternalId] varchar(100) NULL,
	[Name] varchar(500) NULL,
	[Type] varchar(100) NULL,
	[CreatedBy] varchar(250) NULL,
	[CreatedOn] datetime NULL,
	[ModifiedBy] varchar(250) NULL,
	[ModifiedOn] datetime NULL,
	[FirstSendDate] datetime NULL,
	[LastSendDate] datetime NULL,
	[FromEmailAddress] varchar(250) NULL,
	[FromName] varchar(250) NULL,
	[ReplyEmailAddress] varchar(250) NULL,
	[Subject] varchar(1000) NULL,
	[SubStatus] varchar(100) NULL,
	[ContactCount] int NULL,
	[Account] varchar(250) NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_Campaigns] PRIMARY KEY CLUSTERED ([Id])
)
