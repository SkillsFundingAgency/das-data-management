﻿CREATE TABLE [ASData_PL].[Comt_ApprenticeshipUpdate]
(
	[Id]								[bigint]			NOT NULL,
	[ApprenticeshipId]					[bigint]			NOT NULL,
	[Originator]						[tinyint]			NOT NULL,
	[Status]							[tinyint]			NOT NULL,	
	[TrainingType]						[int]				NULL,
	[TrainingCode]						[nvarchar](20)		NULL,
	[TrainingName]						[nvarchar](126)		NULL,
	[TrainingCourseVersion]				[nvarchar](10)		NULL,
	[TrainingCourseOption]				[nvarchar](126)		NULL,
	[Cost]								[decimal](18, 0)	NULL,
	[StartDate]							[datetime]			NULL,
	[EndDate]							[datetime]			NULL,
	[CreatedOn]							[datetime]			NULL,
	[UpdateOrigin]						[tinyint]			NULL,
	[EffectiveFromDate]					[datetime]			NULL,
	[EffectiveToDate]					[datetime]			NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)