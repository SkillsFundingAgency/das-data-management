CREATE TABLE AsData_PL.[Va_LegalEntity]
(
	LegalEntityId INT PRIMARY KEY
   ,LegalEntityPublicHashedId Varchar(256)
   ,EmployerId INT
   ,[EmployerAccountId] varchar(100)
   ,LegalEntityName Varchar(256)
   ,SourceLegalEntityId INT
   ,SourceDb varchar(100)
)
