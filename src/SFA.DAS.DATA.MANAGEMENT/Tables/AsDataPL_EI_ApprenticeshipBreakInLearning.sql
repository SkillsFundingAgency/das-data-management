CREATE TABLE [AsData_PL].[EI_ApprenticeshipBreakInLearning]
(
	[ApprenticeshipIncentiveId]				uniqueidentifier		NOT NULL,
	[StartDate]								datetime2(7)			NULL,
	[EndDate]								datetime2(7)			NULL,
	[AsDm_UpdatedDateTime]					datetime2				default getdate()
)
