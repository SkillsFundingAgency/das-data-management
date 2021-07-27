CREATE TABLE [AsData_PL].[aComt_Apprenticeship]
(
	[Id] bigint NOT NULL 
   ,[ApprenticeId] uniqueidentifier not null
   ,[CreatedOn] datetime2
   ,[LastViewed] datetime2
   ,CONSTRAINT PK_aComt_Apprenticeship_Id PRIMARY KEY CLUSTERED (Id)
)
