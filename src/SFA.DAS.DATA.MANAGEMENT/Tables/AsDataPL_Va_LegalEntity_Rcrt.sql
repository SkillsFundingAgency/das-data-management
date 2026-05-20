CREATE TABLE [AsData_PL].[Va_LegalEntity_Rcrt]
(
	[LegalEntityId] BIGINT IDENTITY(1,1) PRIMARY KEY
   ,[LegalEntityPublicHashedId] VARCHAR(256)
   ,[EmployerId] BIGINT
   ,[EmployerAccountId] BIGINT
   ,[LegalEntityName] VARCHAR(256)
   ,[SourceLegalEntityId] BIGINT
   ,[SourceDb] VARCHAR(100)
   ,[AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())
)
