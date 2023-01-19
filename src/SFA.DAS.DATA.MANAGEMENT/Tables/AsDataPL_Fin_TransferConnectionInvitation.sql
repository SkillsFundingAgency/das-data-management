CREATE TABLE [ASData_PL].[Fin_TransferConnectionInvitation]
(
	[Id] [int] NOT NULL,
	[SenderAccountId] [bigint] NOT NULL,
	[ReceiverAccountId] [bigint] NOT NULL,
	[Status] [int] NOT NULL,
	[DeletedBySender] [bit] NOT NULL,
	[DeletedByReceiver] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	CONSTRAINT Fin_TransferConnectionInvitation_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY]