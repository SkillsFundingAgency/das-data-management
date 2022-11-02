CREATE TABLE [ASData_PL].[Comt_ApprenticeshipPriorLearning]
(	[ApprenticeshipId] [bigint] PRIMARY KEY NOT NULL,
	[DurationReducedBy] [int] NULL,
	[PriceReducedBy] [int] NULL,
	[IsAccelerated] bit DEFAULT (0)
)
