

CREATE TABLE [Comt].[Stg_Load_Commitment]
(
	[Id] BIGINT NOT NULL PRIMARY KEY , 
    [Reference] NVARCHAR(100) MASKED WITH (FUNCTION='PARTIAL(1,"######",0)') NOT NULL, 
    [EmployerAccountId] BIGINT MASKED WITH (FUNCTION='RANDOM(1,5)') NOT NULL, 
    [LegalEntityId] NVARCHAR(50) NOT NULL, 
    [LegalEntityName] NVARCHAR(100) NOT NULL, 
	[LegalEntityAddress] NVARCHAR(256) NOT NULL,
	[LegalEntityOrganisationType] TINYINT NOT NULL,
    [ProviderId] BIGINT NULL,
    [ProviderName] NVARCHAR(100) NULL,
    [CommitmentStatus] SMALLINT NOT NULL DEFAULT 0, 
    [EditStatus] SMALLINT NOT NULL DEFAULT 0,
    [CreatedOn] DATETIME NULL, 
    [LastAction] SMALLINT NOT NULL DEFAULT 0, 
	[LastUpdatedByEmployerName] NVARCHAR(255) NULL,
    [LastUpdatedByEmployerEmail] NVARCHAR(255) NULL, 
    [LastUpdatedByProviderName] NVARCHAR(255) NULL, 
    [LastUpdatedByProviderEmail] NVARCHAR(255) NULL,
    [TransferSenderId] BIGINT SPARSE,
    [TransferSenderName] NVARCHAR(100) SPARSE,
	[TransferApprovalStatus] TINYINT SPARSE,
	[TransferApprovalActionedByEmployerName] NVARCHAR(255),
	[TransferApprovalActionedByEmployerEmail] NVARCHAR(255),
	[TransferApprovalActionedOn] DATETIME2,
	[AccountLegalEntityPublicHashedId] CHAR(6) NULL,
	[Originator] TINYINT NOT NULL DEFAULT 0
)
GO


CREATE NONCLUSTERED INDEX [IX_Commitment_ProviderId_CommitmentStatus]
ON [Comt].[Stg_Load_Commitment] ([ProviderId], [CommitmentStatus]) 
INCLUDE ([AccountLegalEntityPublicHashedId], [CreatedOn], [EditStatus], [EmployerAccountId], [LastAction], [LastUpdatedByEmployerEmail], [LastUpdatedByEmployerName], [LastUpdatedByProviderEmail], [LastUpdatedByProviderName], [LegalEntityAddress], [LegalEntityId], [LegalEntityName], [LegalEntityOrganisationType], [ProviderName], [Reference], [TransferApprovalActionedByEmployerEmail], [TransferApprovalActionedByEmployerName], [TransferApprovalActionedOn], [TransferApprovalStatus], [TransferSenderId], [TransferSenderName]) WITH (ONLINE = ON)
GO


CREATE NONCLUSTERED INDEX [IX_Commitment_EmployerAccountId_CommitmentStatus]
ON [Comt].[Stg_Load_Commitment] ([EmployerAccountId], [CommitmentStatus]) 
GO

CREATE NONCLUSTERED INDEX [IX_Commitment_TransferSenderId] ON [Comt].[Stg_Load_Commitment] ([TransferSenderId]) WHERE [TransferSenderId] IS NOT NULL 
GO