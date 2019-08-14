CREATE TABLE [dbo].[EmployerAccountLegalEntity]
(
  [Id] INT IDENTITY(1,1) NOT NULL 
 ,LegalEntityId nvarchar(50)
 ,EmployerAccountId int not null
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
 ,Source_AccountId int
 ,RunId bigint
 ,AsDm_CreatedDate datetime2 default(getdate())
 ,AsDm_UpdatedDate datetime2 default(getdate())
 ,CONSTRAINT PK_EmployerAccLE PRIMARY KEY(ID)
 ,CONSTRAINT FK_EmployerAccLE_EAID Foreign Key(EmployerAccountId) References dbo.EmployerAccount(Id)
)
