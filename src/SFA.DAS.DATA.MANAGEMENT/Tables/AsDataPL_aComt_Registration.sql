CREATE TABLE [AsData_PL].[aComt_Registration]
(
  	  [ApprenticeId] uniqueidentifier not null
	 ,[CommitmentsApprenticeshipId] bigint not null
	 ,[CommitmentsApprovedOn] datetime2
	 ,[EmployerAccountLegalEntityId] [bigint] NOT NULL
	 ,[EmployerName] [nvarchar](100) NOT NULL
	 ,[TrainingProviderId] [bigint] NOT NULL
	 ,[TrainingProviderName] [nvarchar](100) NOT NULL
	 ,[CourseName] [nvarchar](max) NOT NULL
	 ,[CourseLevel] [int] NOT NULL
	 ,[CourseOption] [nvarchar](max) NULL
	 ,[CourseDuration] [int] NULL
	 ,[PlannedStartDate] [datetime2](7) NOT NULL
	 ,[PlannedEndDate] [datetime2](7) NOT NULL
	 ,[UserIdentityId] uniqueidentifier
	 ,[CreatedOn] datetime2
	 ,[FirstViewedOn] datetime2
	 ,[SignUpReminderSentOn] datetime2
	 ,[Asdm_UpdatedDateTime] datetime2 default getdate()
 ,CONSTRAINT PK_aComt_Reg_Id PRIMARY KEY CLUSTERED (RegistrationId)
)
