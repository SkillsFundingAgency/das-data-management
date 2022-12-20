CREATE TABLE [ASData_PL].[Fin_TransferConnectionInvitationChange]
(
	[Id] [int] NOT NULL,
	[TransferConnectionInvitationId] [int] NOT NULL,
	[SenderAccountId] [bigint] NULL,
	[ReceiverAccountId] [bigint] NULL,
	[Status] [int] NULL,
	[DeletedBySender] [bit] NULL,
	[DeletedByReceiver] [bit] NULL,
	[UserId] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	CONSTRAINT PK_Fin_TransferConnectionInvitationChange_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY]