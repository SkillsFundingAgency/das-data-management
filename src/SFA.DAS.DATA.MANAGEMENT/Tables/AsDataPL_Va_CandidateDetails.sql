CREATE TABLE [AsData_PL].[Va_CandidateDetails]
(
	[CandidateDetailsId] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] BIGINT NOT NULL
   ,[CandidateEthnicCode] Varchar(25) --MASKED WITH (FUNCTION = 'default()')
   ,[CandidateEthnicDesc] Varchar(256) --MASKED WITH (FUNCTION = 'default()')
   ,[SourceDb] Varchar(256)
   ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
