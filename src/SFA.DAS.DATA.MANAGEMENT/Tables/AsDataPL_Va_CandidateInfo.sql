CREATE TABLE [dbo].[AsData_PL}.[Va_CandidateInfo]
(
	[CDId] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] BIGINT NOT NULL
   ,[Gender] nvarchar(50)
   ,[DisabilityStatus] nvarchar(255)
   ,[InstitutionName] nvarchar(max)
   ,[SourceDb] Varchar(256)
   ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
