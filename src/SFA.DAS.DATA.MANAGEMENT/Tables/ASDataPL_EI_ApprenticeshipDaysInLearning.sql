CREATE TABLE [ASData_PL].[EI_ApprenticeshipDaysInLearning]
(
	[LearnerId]							[uniqueidentifier]	NOT NULL,
	[NumberOfDaysInLearning]			[int]				NULL,
	[CollectionPeriodNumber]			[tinyint]			NULL,
	[CollectionPeriodYear]				[smallint]			NULL,
	[CreatedDate]						[datetime2](7)		NULL,
	[UpdatedDate]						[datetime2](7)		NULL,
	[AsDm_UpdatedDateTime]				[datetime2](7)		DEFAULT (getdate())	
) 
GO
