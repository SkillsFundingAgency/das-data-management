CREATE TABLE [Stg].[FAA_CandidatePostCode]
(
	[SourceSK] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] Varchar(256)
   ,[LegacyCandidateId] BIGINT
   ,[PostCode] varchar(256)
   ,[RunID] BIGINT
)
