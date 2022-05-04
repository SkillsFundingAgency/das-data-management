CREATE TABLE [Stg].[FAA_CandidateRegDetails]
(
	[SourceSK] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] Varchar(256)
   ,[LegacyCandidateId] BIGINT
   ,[FirstName] varchar(255)
   ,[MiddleName] varchar(255)
   ,[LastName] varchar(255)
   ,[RunID] BIGINT
)
