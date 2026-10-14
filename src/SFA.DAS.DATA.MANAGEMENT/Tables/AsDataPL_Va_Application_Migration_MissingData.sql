CREATE TABLE [AsData_PL].[Va_Application_Migration_MissingData]
(     
	   [VacancyReference] Bigint
      ,[SourceCandidateId]  Varchar(256) 
	  ,[ApplicationStatusTypeId] Int
	  ,[ApplicationStatusDesc] Varchar(255)
	  ,[CandidateAgeAtApplication] int
      ,[BeingSupportedBy] nvarchar(50)
      ,[LockedForSupportUntil] datetime
      ,[IsWithdrawn] bit
      ,[ApplicationGuid] Varchar(256)
	  ,[CreatedDateTime] DateTime
	  ,[SourceDb] Varchar(100)
	  ,[SourceApplicationId] Varchar(256) 
	  ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
	
 
 )