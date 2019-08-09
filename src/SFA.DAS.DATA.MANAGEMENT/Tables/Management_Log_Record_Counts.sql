CREATE TABLE [Mgmt].[Log_Record_Counts](
	[LRC_Id] [int] IDENTITY(1,1) NOT NULL,
	[LogId] [int] NOT NULL,
	[RunId] [int] NOT NULL,
	[SourceTableName] [varchar](255) NULL,
	[TargetTableName] [varchar](255) NULL,
	[SourceRecordCount] [int] NULL,
	[TargetRecordCount] [int] NULL,
	CONSTRAINT PK_LRC_LRCID PRIMARY KEY(LRC_ID),
	CONSTRAINT FK_LRC_LogId FOREIGN KEY ([LogId]) REFERENCES [Mgmt].[Log_Execution_Results] ([LogId]),
	CONSTRAINT FK_LRC_RunId FOREIGN KEY([RunId]) REFERENCES [Mgmt].[Log_RunId] ([Run_Id])
	)
GO
