CREATE TABLE [Mtd].[SourceConfigForImport]
(
	[SCFI_Id] INT IDENTITY(1,1) NOT NULL 
   ,SourceDatabaseName Varchar(256)
   ,SourceTableName Varchar(256)
   ,SourceSchemaName Varchar(256)
   ,ColumnNamesToInclude Varchar(MAX)
   ,ColumnNamesToExclude Varchar(MAX)
   ,ColumnNamesToMask varchar(max)
   ,IsEnabled bit default(1)
   ,PLTableName varchar(256)
   ,FullCopyToPL BIT DEFAULT(1)
   ,ModelDataToPL BIT 
   ,AddedDate DateTime2 default(getdate())
   ,UpdatedDate DateTime2
   ,CONSTRAINT [PK_SourceConfigForImport_SCFIId] PRIMARY KEY CLUSTERED (SCFI_ID ASC)
)
