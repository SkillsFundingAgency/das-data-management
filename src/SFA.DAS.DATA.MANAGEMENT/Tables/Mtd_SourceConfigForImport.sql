CREATE TABLE [Mtd].[SourceConfigForImport]
(
	[SCFI_Id] INT IDENTITY(1,1) NOT NULL 
   ,SourceDatabaseName Varchar(256)
   ,SourceTableName Varchar(256)
   ,SourceSchemaName Varchar(256)
   ,ColumnNamesToInclude Varchar(MAX)
   ,ColumnNamesToExclude Varchar(MAX)
   ,ColumnNamesToMask varchar(max) NULL
   ,IsEnabled bit default(1)
   ,PLTableName [varchar](256) NULL
   ,FullCopyToPL [bit] default(1)
   ,ModelDataToPL [bit] NULL
   ,IsQueryBasedImport [bit] NULL default(0)
   ,SourceQuery varchar(max)
   ,StagingTableName varchar(256) NULL
   ,AddedDate DateTime2 default(getdate())
   ,UpdatedDate DateTime2
   ,CONSTRAINT [PK_SourceConfigForImport_SCFIId] PRIMARY KEY CLUSTERED (SCFI_ID ASC)
)
