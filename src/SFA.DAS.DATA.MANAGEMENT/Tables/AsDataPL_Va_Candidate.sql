CREATE TABLE [AsData_PL].[Va_Candidate]
(
       [CandidateId] BIGINT IDENTITY(1,1) PRIMARY KEY 
      ,[CandidateStatusTypeId] Int
	  ,[CandidateStatusTypeDesc] Varchar(255)
      ,[CountyId] Int
	  ,[CountyName] Varchar(255)
      ,[PostCode] nvarchar(10)
      ,[LocalAuthorityId] int
	  ,[LocalAuthorityName] Varchar(255)
      ,[UniqueLearnerNumber] Bigint
      ,[Gender] Int
      ,[ApplicationLimitEnforced_v1] Bit
      ,[LastAccessedDate_v1] DateTime
      ,[LastAccessedManageApplications_v1] datetime
      ,[BeingSupportedBy_v1] nvarchar(50)
      ,[LockedForSupportUntil_v1] datetime
      ,[AllowMarketingMessages_v1] bit
      ,[CandidateGuid] varchar(256)
      ,[Age] int
	  ,[DateOfBirth] datetime2
	  ,[RegistrationDate] DateTime2
	  ,[LastAccessedDate] DateTime2
	  ,[SourceDb] varchar(100)
	  ,[SourceCandidateId_v1] Varchar(256)
	  ,[SourceCandidateId_v2] Varchar(256)
	 , Foreign Key (CountyId) References [AsData_PL].[Va_County](CountyId)
	 ,Foreign Key (LocalAuthorityId) References [AsData_PL].[Va_LocalAuthority](LocalAuthorityId)
	  
)
