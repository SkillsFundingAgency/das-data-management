CREATE TABLE [AsData_PL].[Acc_AccountLegalEntity]
(
	[Id] BIGINT NOT NULL
   ,[Name] nvarchar(100)  NOT NULL
   ,[AccountId] BIGINT NOT NULL
   ,[LegalEntityId] BIGINT NOT NULL
   ,[Created] DateTime NOT NULL
   ,[Modified] DateTime NULL
   ,[SignedAgreementVersion] INT NULL
   ,[SignedAgreementId] BIGINT NULL
   ,[PendingAgreementVersion] INT NULL
   ,[PendingAgreementId] BIGINT NULL
   ,[Deleted] DateTime NULL   
   ,[HasSignedIncentivesTerms] [bit] NULL
   ,[IncentivesVrfVendorId] nvarchar(100) null
   ,[IncentivesVrfCaseId] nvarchar(100) null
   ,[IncentivesVrfCaseStatus] nvarchar(100) null
   ,[IncentivesVrfCaseStatusLastUpdatedDateTime] datetime2(7) null
   ,[Address] nvarchar(256) null
   ,[AsDm_UpdatedDateTime] datetime2 Default(getdate())
   ,CONSTRAINT PK_Acc_AccountLegalEntity_Id PRIMARY KEY CLUSTERED (Id)
)
GO

CREATE NONCLUSTERED INDEX [NCI_ALE_SignedAgreementId] ON [AsData_PL].[Acc_AccountLegalEntity]([SignedAgreementId] ASC)
GO

