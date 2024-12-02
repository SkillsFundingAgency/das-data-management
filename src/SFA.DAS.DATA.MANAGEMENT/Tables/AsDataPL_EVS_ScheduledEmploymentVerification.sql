CREATE TABLE [AsData_PL].[EVS_ScheduledEmploymentVerification](
	[ScheduledEmploymentVerificationId] [bigint] NOT NULL PRIMARY KEY,
	[CommitmentId] [bigint] NULL,
	[ApprenticeshipId] [bigint] NULL,
	[ULN] [bigint] NOT NULL,
	[UKPRN] [bigint] NULL,
	[EmployerAccountId] [bigint] NOT NULL,
	[CommitmentStartDate] [date] NOT NULL,
	[CommitmentStatusId] [smallint] NOT NULL,
	[PaymentStatusId] [smallint] NOT NULL,
	[ApprovalsStatusId] [smallint] NOT NULL,
	[EmployerAndProviderApprovedOn] [datetime2](7) NULL,
	[TransferApprovalActionedOn] [datetime2](7) NULL,
	[EmploymentCheckCount] [smallint] NULL,
	[CreatedOn] [datetime2](7) NULL,
	[LastUpdatedOn] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime]	DateTime2 default(getdate())
)