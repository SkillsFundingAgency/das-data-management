CREATE TABLE [Mtd].[RolesAndPermissions]
(
	[RP_Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY
   ,[RoleName] varchar(25)
   ,[SchemaName] varchar(25)
   ,[TableOrViewName] varchar(256)
   ,[IsSchemaLevelAccess] bit default(0)
   ,[IsEnabled] bit default(1)
)
