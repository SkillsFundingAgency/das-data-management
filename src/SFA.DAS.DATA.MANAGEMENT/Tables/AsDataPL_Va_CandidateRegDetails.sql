CREATE TABLE [AsData_PL].[Va_CandidateRegDetails]
(
	[CandidateRegDetailsId] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] BIGINT NOT NULL
   ,[CandidateFirstName] nvarchar(512) --MASKED WITH (FUNCTION = 'default()')
   ,[CandidateLastName] nvarchar(512) --MASKED WITH (FUNCTION = 'default()')
   ,[CandidateMiddleName] nvarchar(512)
   ,[CandidateFullName] nvarchar(512)
   ,[CandidateDateOfBirth] nvarchar(512)
   ,[CandidateEmail] nvarchar(512)
   ,[SourceDb] Varchar(256)
   ,[Migrated_EMailID] Varchar(255)
   ,[Migrated_CandidateID] UNIQUEIDENTIFIER NULL
   ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
