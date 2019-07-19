CREATE TABLE [dbo].[Provider]
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
   ,Ukprn int
   ,ProviderName varchar(255)
   ,Data_Source varchar(255)
   ,Source_ProviderId int
   ,Asdm_CreatedDate datetime2 Default(getdate())
   ,Asdm_UpdatedDate datetime2 Default(getdate())
)
