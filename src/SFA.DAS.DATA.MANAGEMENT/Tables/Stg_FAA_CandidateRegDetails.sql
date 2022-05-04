CREATE TABLE [Stg].[FAA_CandidateRegDetails]
(
	[SourceSK] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] Varchar(256)
   ,[LegacyCandidateId] BIGINT
   ,[FirstName] nvarchar(512)
   ,[MiddleName] nvarchar(512)
   ,[LastName] nvarchar(512)
   ,[DateOfBirth] nvarchar(512)
   ,[RunID] BIGINT
)
