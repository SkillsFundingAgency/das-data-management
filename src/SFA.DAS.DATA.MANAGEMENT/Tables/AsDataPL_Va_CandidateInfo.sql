CREATE TABLE [AsData_PL].[Va_CandidateInfo]
(
	[CDId] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
    ,[SourceCandidateId_v1] Varchar(256)
	,[SourceCandidateId_v2] Varchar(256)
   ,[Gender] nvarchar(50)
   ,[IsGenderIdentifySameSexAtBirth] nvarchar(50)
   ,[DisabilityStatus] nvarchar(255)
   ,[InstitutionName] nvarchar(max)
   ,[SourceDb] Varchar(256)
   ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
