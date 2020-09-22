CREATE TABLE [dbo].[AsDataPL_AR_Apprentice]
(
	   [Id]  bigint primary Key not null
	  ,[ApprenticeshipId] bigint
      ,[UpdatesWanted] bit not null
      ,[ContactableForFeedback] bit not null
      ,[PreviousTraining] nvarchar(100) not null
      ,[Employer] nvarchar(100) not null
      ,[TrainingProvider] nvarchar(100) not null
      ,[LeftOnApprenticeshipMonths] int 
      ,[LeftOnApprenticeshipYears] int
      ,[Sectors] int
      ,[CreatedOn] datetime2(7) not null
	  ,[FirstName] nvarchar(100) not null
      ,[LastName] nvarchar(100) not null
      ,[DateOfBirth] datetime2(7) not null
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
)
