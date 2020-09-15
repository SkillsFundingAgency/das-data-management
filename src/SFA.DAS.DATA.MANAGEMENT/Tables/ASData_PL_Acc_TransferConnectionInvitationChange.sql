CREATE TABLE [ASData_PL].[Acc_TransferConnectionInvitationChange]
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
	CONSTRAINT PK_Acc_TransferConnectionInvitationChange_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY]