CREATE TABLE [AsData_PL].[Va_Candidate]
(
       [CandidateId] Int PRIMARY KEY 
      ,[CandidateStatusTypeId] Int
	  ,[CandidateStatusTypeDesc] Varchar(255)
      ,[CountyId] Int
	  ,[CountyName] Varchar(255)
      ,[PostCode] nvarchar(10)
      ,[LocalAuthorityId] int
	  ,[LocalAuthorityName] Varchar(255)
      ,[VoucherReferenceNumber] Int
      ,[UniqueLearnerNumber] Bigint
      ,[Gender] Int
      ,[ApplicationLimitEnforced] Bit
      ,[LastAccessedDate] DateTime
      ,[LastAccessedManageApplications] datetime
      ,[ReferralPoints] smallint
      ,[BeingSupportedBy] nvarchar(50)
      ,[LockedForSupportUntil] datetime
      ,[AllowMarketingMessages] bit
      ,[CandidateGuid] uniqueidentifier
      ,[Age] int
	 , Foreign Key (CountyId) References [AsData_PL].[Va_County](CountyId)
	 ,Foreign Key (LocalAuthorityId) References [AsData_PL].[Va_LocalAuthority](LocalAuthorityId)
	  
)
