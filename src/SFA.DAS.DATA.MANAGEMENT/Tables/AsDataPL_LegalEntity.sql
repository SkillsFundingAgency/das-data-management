CREATE TABLE [AsData_PL].[LegalEntity]
(
	[Id] BIGINT
   ,[Code] nvarchar(50)
   ,[DateOfIncorporation] datetime
   ,[Status] nvarchar(50)
   ,[PublicSectorDataSource] tinyint
   ,[Sector] nvarchar(100)
   ,[AsDm_UpdatedDateTime] datetime2 default(getdate())
)
