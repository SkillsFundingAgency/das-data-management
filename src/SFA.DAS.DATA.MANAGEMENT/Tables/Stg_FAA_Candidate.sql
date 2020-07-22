CREATE TABLE [Stg].[FAA_Candidate]
(
	[SourceSK] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] Varchar(256)
   ,[LegacyCandidateId] BIGINT
   ,[EID] BIGINT
)
