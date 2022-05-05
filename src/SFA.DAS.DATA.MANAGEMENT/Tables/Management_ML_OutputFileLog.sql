CREATE TABLE [Mgmt].[ML_OutputFileLog]
(
	[MlOutputLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] bigint,
	[BlobOutputFolderName] varchar(256),
	[FileName] [varchar](100) ,
	[FileModifiedDateTime] [datetime] DEFAULT(GETDATE()) NOT NULL,
	[IsLoadedToStaging] bit,
	[IsLoadedToPL] bit,
	[LogDateTime] datetime2(7) default(getdate()),
	CONSTRAINT [PK_ML_ID] PRIMARY KEY CLUSTERED (MlOutputLogId ASC),
	CONSTRAINT [FK_ML_RunID] FOREIGN KEY ([RunId]) REFERENCES [Mgmt].[Log_RunId] ([RunId])
 )