CREATE TABLE [AsData_PL].[Acc_LegalEntity]
(
	[Id] BIGINT
   ,[Code] nvarchar(50)
   ,[DateOfIncorporation] datetime
   ,[Status] nvarchar(50)
   ,[PublicSectorDataSource] tinyint
   ,[Sector] nvarchar(100)
   ,[Source] smallint
   ,[AsDm_UpdatedDateTime] datetime2 default(getdate())
)
