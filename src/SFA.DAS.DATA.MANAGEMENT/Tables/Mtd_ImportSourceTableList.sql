CREATE TABLE [Mtd].[SourceTableList]
(
	STL_ID  [bigint] IDENTITY(1,1) NOT NULL,
	SourceDatabaseName Varchar(256),
	SourceTableName Varchar(256),
	IsEnabled BIT,
	AddedDate DateTime2 Default(Getdate()),
	UpdatedDate DateTime2,
    CONSTRAINT [PK_SrcTableList_STLId] PRIMARY KEY CLUSTERED (STL_ID ASC)
)
