CREATE TABLE [dbo].[EmployerAccountLegalEntity]
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,LegalEntityId nvarchar(50)
 ,LegalEntityPublicHashedId nchar(6)
 ,LegalEntityName nvarchar(100)
 ,OrganisationType smallint
 ,OrganisationTypeDesc nvarchar(255)
 ,LegalEntityAddress nvarchar(255)
 ,LegalEntityCreatedDate datetime2
 ,LegalEntityUpdatedDate datetime2
 ,LegalEntityDeletedDate datetime2
  ,Data_Source varchar(255)
 ,Source_AccountLegalEntityId int
 ,AsDm_CreatedDate datetime2 default(getdate())
 ,AsDm_UpdatedDate datetime2 default(getdate())
)
