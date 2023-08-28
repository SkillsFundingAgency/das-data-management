CREATE TABLE [ASData_PL].[Comt_ApprenticeshipPriorLearning]
(	[ApprenticeshipId] [bigint] PRIMARY KEY NOT NULL,
	[DurationReducedBy] [int] NULL,
	[PriceReducedBy] [int] NULL,
	[IsAccelerated] bit DEFAULT (0),
	[DurationReducedByHours] [int] NULL,
	[WeightageReducedBy] [int] NULL,
	[ReasonForRplReduction] [nvarchar](1000) NULL,
	[QualificationsForRplReduction] [text] NULL,
	[IsDurationReducedByRpl] [bit] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)
