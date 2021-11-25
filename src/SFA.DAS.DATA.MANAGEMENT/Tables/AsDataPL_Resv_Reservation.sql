CREATE TABLE [ASData_PL].[Resv_Reservation]
(
	[Id] [uniqueidentifier] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[IsLevyAccount] [tinyint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[StartDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[CourseId] [varchar](20) NULL,
	[AccountLegalEntityId] [bigint] NULL,
	[ProviderId] [int] NULL,	
	[TransferSenderAccountId] [bigint] NULL,
	[UserId] [uniqueidentifier] NULL,
	[ClonedReservationId] [uniqueidentifier] NULL,
	[ConfirmedDate] [datetime] NULL,
	[CohortId] [bigint] NULL,
	[DraftApprenticeshipId] [bigint] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
    PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NCI_Resv_CourseId] ON [AsData_PL].[Resv_Reservation]([CourseId] ASC)
GO

CREATE NONCLUSTERED INDEX [NCI_Resv_Date_IsLevy] ON [AsData_PL].[Resv_Reservation]([CreatedDate],[IsLevyAccount])
GO

CREATE NONCLUSTERED INDEX [NCI_Resv_IsLevyAccount]
ON [ASData_PL].[Resv_Reservation] ([IsLevyAccount]) INCLUDE ([AccountId],[CreatedDate],[StartDate],[ExpiryDate],[Status],[CourseId],[AsDm_UpdatedDateTime])
GO
