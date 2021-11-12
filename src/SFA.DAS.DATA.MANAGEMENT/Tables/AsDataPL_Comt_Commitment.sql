CREATE TABLE [ASData_PL].[Comt_Commitment]
(
	[Id] [bigint] NOT NULL,
	[Reference] [nvarchar](100) NOT NULL,
	[EmployerAccountId] [bigint] NOT NULL,
	[ProviderId] [bigint] NULL,
	[CommitmentStatus] [smallint] NOT NULL,
	[EditStatus] [smallint] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[LastAction] [smallint] NOT NULL,	
	[TransferSenderId] [bigint] NULL,
	[TransferApprovalStatus] [tinyint] NULL,	
	[TransferApprovalActionedOn] [datetime2](7) NULL,
	[Originator] [tinyint] NOT NULL,
	[ApprenticeshipEmployerTypeOnApproval] [tinyint] NULL,
	[IsFullApprovalProcessed] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AccountLegalEntityId] [bigint] NULL,
	[IsDraft] [bit] NOT NULL,
	[WithParty] [smallint] NOT NULL,
	[RowVersion] [timestamp] NULL,
	[LastUpdatedOn] [datetime2](7) NOT NULL,
	[Approvals] [smallint] NOT NULL,
	[EmployerAndProviderApprovedOn] [datetime2](7) NULL,
	[ChangeOfPartyRequestId] [bigint] NULL,
	[PledgeApplicationId]	[int] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	[IsRetentionApplied] bit DEFAULT (0),
	[RetentionAppliedDate]  DateTime2(7),
	CONSTRAINT PK_Comt_Commitment_Id PRIMARY KEY CLUSTERED (Id)
)ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NCI_Comt_ProviderId] ON [AsData_PL].[Comt_Commitment]([ProviderId] ASC)
GO