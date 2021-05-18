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
	  ,[Ethnicity] tinyint null
      ,[EthnicitySubgroup] tinyint null
	  ,[EthnicityText] nvarchar(200) null
	  ,[Gender] tinyint null
	  ,[GenderText] nvarchar(200) null
      ,[Age] int null
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
)
GO
CREATE NONCLUSTERED INDEX [NCI_AR_App_ApprenticeId] ON [AsData_PL].[AR_Apprentice]([ApprenticeId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_AR_App_ApprenticeshipId] ON [AsData_PL].[AR_Apprentice]([ApprenticeshipId] ASC)
GO