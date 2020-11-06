CREATE TABLE [AsData_PL].[EI_IncentiveApplicationApprenticeship]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[IncentiveApplicationId] UNIQUEIDENTIFIER NOT NULL,
	[ApprenticeshipId] BIGINT NOT NULL,
	[PlannedStartDate] DATETIME2 NOT NULL,
	[ApprenticeshipEmployerTypeOnApproval] INT NOT NULL,
	[TotalIncentiveAmount] MONEY NOT NULL,
	[EarningsCalculated] bit not null,
	[AsDm_UpdatedDateTime] DateTime2 default(getdate())
)
