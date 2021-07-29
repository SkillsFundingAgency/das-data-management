CREATE TABLE [AsData_PL].[aComt_Apprentice]
(
  [Id] uniqueidentifier not null 
 ,[CreatedOn] datetime2 not null
 ,[Asdm_UpdatedDateTime] datetime2 default getdate()
 ,CONSTRAINT PK_aComt_Apprentice_Id PRIMARY KEY CLUSTERED (Id)
)
