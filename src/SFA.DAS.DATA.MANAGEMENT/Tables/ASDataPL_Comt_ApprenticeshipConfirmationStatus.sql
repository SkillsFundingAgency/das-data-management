CREATE TABLE [ASData_PL].[Comt_ApprenticeshipConfirmationStatus]
(
	[ApprenticeshipId] [bigint] PRIMARY KEY NOT NULL,
	[ApprenticeshipConfirmedOn] [datetime2](7) NULL,
	[CommitmentsApprovedOn] [datetime2](7) NULL,
	[ConfirmationOverdueOn] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)
