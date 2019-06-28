CREATE TABLE dbo.Employer
( Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL
 ,EmpHashedId NCHAR(6)
 ,EmpPublicHashedId NCHAR(6)
 ,EmpName nvarchar(255)
 ,LegalEntityId nvarchar(50)
 ,LegalEntityPublicHashedId nchar(6)
 ,LegalEntityName nvarchar(100)
 ,OrganisationType smallint
 ,OrganisationTypeDesc nvarchar(255)
 ,LegalEntityAddress nvarchar(255)
 ,LegalEntityCreatedDate datetime2
 ,LegalEntityUpdatedDate datetime2
 ,LegalEntityDeletedDate datetime2
 ,AsDm_CreatedDate datetime2 default(getdate())
 ,AsDm_UpdatedDate datetime2 default(getdate())
 )
