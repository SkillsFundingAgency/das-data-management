CREATE TABLE [Stg].[FAA_CandidatePostCode]
(
	[SourceSK] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] Varchar(256)
   ,[LegacyCandidateId] BIGINT
   ,[PostCode] varchar(256)
   ,[RunID] BIGINT
   ,AsDm_CreatedDate datetime2 default(getdate()) 
   ,AsDm_UpdatedDate datetime2 default(getdatE())
)
