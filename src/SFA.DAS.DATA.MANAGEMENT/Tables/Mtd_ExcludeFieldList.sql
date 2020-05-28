CREATE TABLE [Mtd].[ExcludeFieldList]
(
	[EFL_Id] BIGINT IDENTITY(1,1) NOT NULL 
   ,STL_ID BIGINT
   ,[TableName] Varchar(256)
   ,[ColumnNameToExclude] Varchar(256)
   ,IsEnabled BIT DEFAULT(1)
   ,AddedDate DateTime2 default(getdate())
   ,UpdatedDate DateTime2
   ,CONSTRAINT [PK_ExcludeFieldList_EFLId] PRIMARY KEY CLUSTERED (EFL_ID ASC)
   ,CONSTRAINT [FK_ExcludeFieldList_EID] FOREIGN KEY (STL_ID) REFERENCES [Mtd].[SourceTableList] (STL_ID)
)
