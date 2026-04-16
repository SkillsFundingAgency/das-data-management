CREATE TABLE [AsData_PL].[CPG_UnsubscribedContacts]
(
	[Id] int NOT NULL,
	[ExternalId] varchar(100) NULL,
	[CampaignId] int NOT NULL,
	[ContactEmail] varchar(250) NULL,
	[UnsubscribedDate] datetime NULL,
	[IsGlobalUnscribe] bit NULL,
	[IsComplaint] bit NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_UnsubscribedContacts] PRIMARY KEY CLUSTERED ([Id])
)
