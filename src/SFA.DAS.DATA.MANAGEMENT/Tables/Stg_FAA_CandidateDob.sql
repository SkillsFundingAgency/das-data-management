CREATE TABLE [Stg].[FAA_CandidateDob]
(
	[SourceSK] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] Varchar(256)
   ,[LegacyCandidateId] BIGINT
   ,[DateOfBirth] varchar(256)
   ,[RunID] BIGINT
)
