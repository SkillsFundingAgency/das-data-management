CREATE TABLE [Mgmt].[Log_Record_Counts](
	[LRC_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LogId] [bigint] NOT NULL,
	[RunId] [bigint] NOT NULL,
	[SourceTableName] [varchar](255) NULL,
	[TargetTableName] [varchar](255) NULL,
	[SourceRecordCount] [int] NULL,
	[TargetRecordCount] [int] NULL,
	[InvalidRecordCount] [int] NULL,
    CONSTRAINT [PK_LRC_LRCID] PRIMARY KEY CLUSTERED ([LRC_Id] ASC),
	CONSTRAINT [FK_LRC_LogId] FOREIGN KEY(LogId) REFERENCES [Mgmt].[Log_Execution_Results] ([LogId]),
	CONSTRAINT [FK_LRC_RunId] FOREIGN KEY(RunId) REFERENCES [Mgmt].[Log_RunId] ([RunId])
	)

