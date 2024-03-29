﻿CREATE TABLE [ASData_PL].[Appfb_ApprenticeFeedbackTarget](
	[Id] UNIQUEIDENTIFIER NULL,
	[ApprenticeId] UNIQUEIDENTIFIER NULL,
	[ApprenticeshipId] BIGINT NULL,
	[Status] [int] NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[Ukprn] [bigint] NULL,
	[ProviderName] [nvarchar](120) NULL,
	[StandardUId] [nvarchar](12) NULL,
	[LarsCode] [int] NULL,
	[StandardName] [nvarchar](120) NULL,
	[FeedbackEligibility] [int] NULL,
	[EligibilityCalculationDate] [datetime2](7) NULL,
	[CreatedOn] [datetime2](7) NULL DEFAULT (getdate()),
	[UpdatedOn] [datetime2](7) NULL DEFAULT (getdate()),
	[Withdrawn]  bit DEFAULT (0),
    [IsTransfer] bit DEFAULT (0),
    [DateTransferIdentified] [datetime2](7) NULL DEFAULT (getdate()),
	[ApprenticeshipStatus] [int] null,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)