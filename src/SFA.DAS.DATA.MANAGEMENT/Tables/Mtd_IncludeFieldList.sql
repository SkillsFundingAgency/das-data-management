CREATE TABLE [Mtd].[IncludeFieldList]
(
	[IFL_Id] BIGINT IDENTITY(1,1) NOT NULL 
   ,STL_ID BIGINT
   ,[TableName] Varchar(256)
   ,[ColumnNameToInclude] Varchar(256)
   ,IsEnabled BIT
   ,AddedDate DateTime2 Default(Getdate())
   ,UpdatedDate DateTime2
   ,CONSTRAINT [PK_IncludeFieldList_IFLId] PRIMARY KEY CLUSTERED (IFL_ID ASC)
   ,CONSTRAINT [FK_IncludeFieldList_EID] FOREIGN KEY (STL_ID) REFERENCES [Mtd].[SourceTableList] (STL_ID)
)
