CREATE TABLE [ASData_PL].[Acc_TransferConnectionInvitation]
(
	[Id] [int] NOT NULL,
	[SenderAccountId] [bigint] NOT NULL,
	[ReceiverAccountId] [bigint] NOT NULL,
	[Status] [int] NOT NULL,
	[DeletedBySender] [bit] NOT NULL,
	[DeletedByReceiver] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	CONSTRAINT Acc_TransferConnectionInvitation_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY]