CREATE TABLE [ASData_PL].[EI_ApprenticeshipDaysInLearning]
(
	[LearnerId]							[uniqueidentifier]	NOT NULL,
	[NumberOfDaysInLearning]			[int]				NULL,
	[CollectionPeriodNumber]			[tinyint]			NOT NULL,
	[CollectionPeriodYear]				[smallint]			NOT NULL,
	[CreatedDate]						[datetime2](7)		NULL,
	[UpdatedDate]						[datetime2](7)		NULL,
	[AsDm_UpdatedDateTime]				[datetime2](7)		DEFAULT (getdate())
) 