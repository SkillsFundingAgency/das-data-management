CREATE TABLE [dbo].[Provider]
(
	Id INT IDENTITY(1,1) NOT NULL 
   ,Ukprn int
   ,ProviderName varchar(255)
   ,RunId bigint
   ,Asdm_CreatedDate datetime2 Default(getdate())
   ,Asdm_UpdatedDate datetime2 Default(getdate())
   ,CONSTRAINT PK_Provider_Id PRIMARY KEY(ID)
)
