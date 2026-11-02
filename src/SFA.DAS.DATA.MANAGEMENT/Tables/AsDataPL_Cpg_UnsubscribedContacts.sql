CREATE TABLE [AsData_PL].[CPG_UnsubscribedContacts]
(
	[Id] bigint NOT NULL,
	[ExternalId] int NULL,
	[CampaignId] bigint NULL,
	[ContactEmail] varchar(255) NULL,
	[UnsubscribedDate] datetime2(7) NULL,
	[IsGlobalUnscribe] bit NULL,
	[IsComplaint] bit NULL,
	[Asdm_UpdatedDateTime] datetime2 DEFAULT getdate(),
    CONSTRAINT [PK_CPG_UnsubscribedContacts] PRIMARY KEY CLUSTERED ([Id])
)
