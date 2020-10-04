CREATE TABLE [AsData_PL].[AR_Apprentice]
(
	   [ApprenticeId]  bigint not null
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
	  ,[Email] nvarchar(255) 
      ,[DateOfBirth] datetime2(7) not null
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
	  , CONSTRAINT [PK_App_ApprenticeId] PRIMARY KEY CLUSTERED([ApprenticeId] ASC)
)
