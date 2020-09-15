CREATE TABLE [ASData_PL].[Acc_AccountHistory]

(
	[Id] [bigint] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[PayeRef] [varchar](20) NOT NULL,
	[AddedDate] [datetime] NOT NULL,
	[RemovedDate] [datetime] NULL,
	CONSTRAINT PK_Acct_AccountHistory_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]