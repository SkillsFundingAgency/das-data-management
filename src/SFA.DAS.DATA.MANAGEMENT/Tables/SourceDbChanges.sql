CREATE TABLE [dbo].[SourceDbChanges]
(
	[SDC_Id] INT NOT NULL 
   ,[SourceDatabaseName] Varchar(256)
   ,[SouceTableName] Varchar(256)
   ,[ChangesDetected] Varchar(256)
   ,DetectedDate DateTime2 default(getdate())
)
