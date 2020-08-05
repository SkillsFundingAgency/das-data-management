CREATE TABLE [Stg].[FAA_CandidateDetails]
(
	[SourceSK] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] Varchar(256)
   ,[LegacyCandidateId] BIGINT
   ,[EID] BIGINT
   ,[RunID] BIGINT
)
