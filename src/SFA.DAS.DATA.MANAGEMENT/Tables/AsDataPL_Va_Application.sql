CREATE TABLE [AsData_PL].[Va_Application]
(     
       [ApplicationId] Int PRIMARY KEY
      ,[CandidateId] Int 
      ,[VacancyId] Int 
      ,[ApplicationStatusTypeId] Int
	  ,[ApplicationStatusDesc] Varchar(255)
      ,[BeingSupportedBy] nvarchar(50)
      ,[LockedForSupportUntil] datetime
      ,[WithdrawalAcknowledged] bit
      ,[ApplicationGuid] uniqueidentifier
	  ,Foreign Key (CandidateId)  References [AsData_PL].[Va1_Candidate](CandidateId)
	  ,Foreign Key (VacancyId) References [AsData_PL].[Va1_Vacancy](VacancyId)
 
 )