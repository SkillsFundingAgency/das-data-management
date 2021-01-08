CREATE TABLE  [ASData_PL].[EI_LearningPeriod]
(
	[LearnerId]							[uniqueidentifier]	NULL,
	[StartDate]							[datetime2](7)		NULL,
	[EndDate]							[datetime2](7)		NULL,
	[CreatedDate]						[datetime2](7)		NULL,
	[AsDm_UpdatedDateTime]				[datetime2](7)		DEFAULT (getdate())
) 
