CREATE TABLE [Mgmt].[ExcludeFieldList]
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY
   ,[TableName] Varchar(256)
   ,[ColumnNameToExclude] Varchar(256)
)
