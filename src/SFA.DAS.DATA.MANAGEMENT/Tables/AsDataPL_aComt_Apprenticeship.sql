CREATE TABLE [AsData_PL].[aComt_Apprenticeship]
(
	[Id] bigint NOT NULL 
   ,[ApprenticeId] uniqueidentifier not null
   ,[CreatedOn] datetime2   
   ,[Asdm_UpdatedDateTime] datetime2 default getdate()
   ,CONSTRAINT PK_aComt_Apprenticeship_Id PRIMARY KEY CLUSTERED (Id)
)
