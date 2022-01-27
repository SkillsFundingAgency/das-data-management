CREATE TABLE [Stg].[CmphsDataFromBlob]
(
	[Id] BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY
   ,[Name] nvarchar(255)
   ,[Value] nvarchar(max)
   ,[Unit] nvarchar(255)
   ,[CHN] nvarchar(100)
   ,[RunId] bigint
   ,[SourceFileName] varchar(255)
   ,[ImportedDateTime] datetime2 default(getdate())
)
GO
CREATE NONCLUSTERED INDEX NCI_Staging_CHN ON [Stg].[CmphsDataFromBlob]([CHN] ASC)

