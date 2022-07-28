CREATE TABLE [dbo].[SourceDbChanges]
(
	[SDC_Id] INT IDENTITY(1,1) NOT NULL 
   ,[SourceDatabaseName] Varchar(256)
   ,[SourceTableName] Varchar(256)
   ,[SourceSchemaName] Varchar(256)
   ,[ChangesDetected] Varchar(256)
   ,DetectedDate DateTime2 default(getdate())
   ,CONSTRAINT [PK_SourceDbChanges_SDCId] PRIMARY KEY CLUSTERED (SDC_ID ASC)
)
