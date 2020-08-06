CREATE TABLE [AsData_PL].[Va_CandidateDetails]
(
	[CandidateDetailsId] BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY
   ,[CandidateId] BIGINT
   ,[CandidateEthnicCode] Varchar(25)
   ,[CandidateEthnicDesc] Varchar(256)
   ,[SourceDb] Varchar(256)
   ,Foreign Key (CandidateId) References [AsData_PL].[Va_Candidate](CandidateId)
)
