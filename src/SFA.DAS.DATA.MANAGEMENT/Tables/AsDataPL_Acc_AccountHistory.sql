﻿CREATE TABLE [ASData_PL].[Acc_AccountHistory]

(
	[Id] [bigint] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[PayeRef] [nvarchar](500) NOT NULL,
	[AddedDate] [datetime] NOT NULL,
	[RemovedDate] [datetime] NULL,
	[IsRetentionApplied] bit DEFAULT (0),
    [RetentionAppliedDate]  DateTime2(7),
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	CONSTRAINT PK_Acc_AccountHistory_Id PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]