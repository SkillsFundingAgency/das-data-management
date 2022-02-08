CREATE TABLE [AsData_PL].[Va_Application]
(     
       [ApplicationId] BigInt IDENTITY(1,1) PRIMARY KEY
      ,[CandidateId] Bigint 
      ,[VacancyId] Bigint 
	  ,[ApplicationStatusTypeId] Int
	  ,[ApplicationStatusDesc] Varchar(255)
	  ,[CandidateAgeAtApplication] int
      ,[BeingSupportedBy] nvarchar(50)
      ,[LockedForSupportUntil] datetime
      ,[IsWithdrawn] bit
      ,[ApplicationGuid] Varchar(256)
	  ,[CreatedDateTime] DateTime
	  ,[SourceDb] Varchar(100)
	  ,[SourceApplicationId] INT
	  ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
	  ,Foreign Key (CandidateId)  References [AsData_PL].[Va_Candidate](CandidateId)
	  ,Foreign Key (VacancyId)  References [AsData_PL].[Va_Vacancy](VacancyId)
 
 )