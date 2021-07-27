﻿CREATE TABLE [AsData_PL].[aComt_CommitmentStatement]
(
  	[Id] [bigint] NOT NULL,
	[ApprenticeshipId] [bigint] NOT NULL,
	[CommitmentsApprenticeshipId] [bigint] NOT NULL,
	[CommitmentsApprovedOn] [datetime2](7) NOT NULL,
	[EmployerAccountLegalEntityId] [bigint] NOT NULL,
	[EmployerName] [nvarchar](100) NOT NULL,
	[TrainingProviderId] [bigint] NOT NULL,
	[TrainingProviderName] [nvarchar](100) NOT NULL,
	[CourseName] [nvarchar](max) NOT NULL,
	[CourseLevel] [int] NOT NULL,
	[CourseOption] [nvarchar](max) NULL,
	[PlannedStartDate] [datetime2](7) NOT NULL,
	[PlannedEndDate] [datetime2](7) NOT NULL,
	[TrainingProviderCorrect] [bit] NULL,
	[EmployerCorrect] [bit] NULL,
	[RolesAndResponsibilitiesCorrect] [bit] NULL,
	[ApprenticeshipDetailsCorrect] [bit] NULL,
	[HowApprenticeshipDeliveredCorrect] [bit] NULL,
	[ConfirmBefore] [datetime2](7) NOT NULL,
	[ConfirmedOn] [datetime2](7) NULL,
	[CourseDuration] [int] NULL,
 CONSTRAINT PK_aComt_CS_Id PRIMARY KEY CLUSTERED (Id)
)
