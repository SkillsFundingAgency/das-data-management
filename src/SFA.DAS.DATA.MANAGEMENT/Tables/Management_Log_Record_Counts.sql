CREATE TABLE [Mgmt].[Log_Record_Counts](
	[LRC_Id] [int] IDENTITY(1,1) NOT NULL,
	[LogId] [int] NOT NULL,
	[RunId] [int] NOT NULL,
	[SourceTableName] [varchar](255) NULL,
	[TargetTableName] [varchar](255) NULL,
	[SourceRecordCount] [int] NULL,
	[TargetRecordCount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LRC_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Mgmt].[Log_Record_Counts]  WITH CHECK ADD FOREIGN KEY([LogId])
REFERENCES [Mgmt].[Log_Execution_Results] ([LogId])
GO

ALTER TABLE [Mgmt].[Log_Record_Counts]  WITH CHECK ADD FOREIGN KEY([RunId])
REFERENCES [Mgmt].[Log_RunId] ([Run_Id])
GO
