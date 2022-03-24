CREATE TABLE [Mgmt].[ML_OutputFileLog]
(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] bigint,
	[LogId] bigint,
	[BlobOutputFolderName] varchar(256),
	[FileName] [varchar](100) ,
	[FileModifiedDateTime] [datetime] DEFAULT(GETDATE()) NOT NULL,
	CONSTRAINT [PK_ML_ID] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_ML_RunID] FOREIGN KEY ([RunId]) REFERENCES [Mgmt].[Log_RunId] ([RunId]),
	CONSTRAINT [FK_ML_LogID] FOREIGN KEY ([LogId]) REFERENCES [Mgmt].[Log_Execution_Results] ([LogId])
 )