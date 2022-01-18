CREATE TABLE [AsData_PL].[EI_IncentiveApplicationApprenticeship]
(
	[Id]										UNIQUEIDENTIFIER		NOT NULL PRIMARY KEY,
	[IncentiveApplicationId]					UNIQUEIDENTIFIER		NOT NULL,
	[ApprenticeshipId]							BIGINT					NOT NULL,
	[PlannedStartDate]							DATETIME2				NOT NULL,
	[ApprenticeshipEmployerTypeOnApproval]		INT						NOT NULL,
	[EarningsCalculated]						bit						null,
	[UKPRN]										BIGINT					NULL,
	[WithdrawnByEmployer]						bit						NULL,
	[WithdrawnByCompliance]						bit						NULL,
	[CourseName]								nvarchar(126)			NULL,
	[EmploymentStartDate]						datetime2(7)			NULL,
	[Phase]										nvarchar(50)			NULL,	
	[AsDm_UpdatedDateTime]						DateTime2 default(getdate())
)
