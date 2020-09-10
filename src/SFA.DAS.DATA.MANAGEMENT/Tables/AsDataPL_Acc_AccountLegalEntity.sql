CREATE TABLE [AsData_PL].[Acc_AccountLegalEntity]
(
	[Id] BIGINT NOT NULL
   ,[Name] nvarchar(100) MASKED WITH (FUNCTION = 'default()') NOT NULL
   ,[AccountId] BIGINT NOT NULL
   ,[LegalEntityId] BIGINT NOT NULL
   ,[Created] DateTime NOT NULL
   ,[Modified] DateTime NULL
   ,[SignedAgreementVersion] INT NULL
   ,[SignedAgreementId] BIGINT NULL
   ,[PendingAgreementVersion] INT NULL
   ,[PendingAgreementId] BIGINT NULL
   ,[Deleted] DateTime NULL
   ,[AsDm_UpdatedDateTime] datetime2 Default(getdate())
)
