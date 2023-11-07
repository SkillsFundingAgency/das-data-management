CREATE TABLE [ASData_PL].[EI_Learner]
(
	[Id]								[uniqueidentifier]	NOT NULL PRIMARY KEY,
	[ApprenticeshipIncentiveId]			[uniqueidentifier]	NULL,
	[ApprenticeshipId]					[bigint]			NULL,
	[Ukprn]								[bigint]			NULL,	
	[SubmissionFound]					[bit]				NULL,
	[SubmissionDate]					[datetime2](7)		NULL,
	[LearningFound]						[bit]				NULL,
	[HasDataLock]						[bit]				NULL,
	[StartDate]							[datetime2](7)		NULL,
	[InLearning]						[bit]				NULL,	
	[LearningStoppedDate]				[datetime2](7)		NULL,
	[LearningResumedDate]				[datetime2](7)		NULL,
	[CreatedDate]						[datetime2](7)		NULL,
	[UpdatedDate]						[datetime2](7)		NULL,
	[RefreshDate]						[datetime2](7)		NULL,
	[SuccessfulLearnerMatchExecution]	bit 				NULL,
	[AsDm_UpdatedDateTime]				[datetime2](7)	DEFAULT (getdate())
) 