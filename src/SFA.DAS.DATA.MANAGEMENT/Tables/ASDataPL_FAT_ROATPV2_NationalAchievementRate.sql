CREATE TABLE [ASData_PL].[FAT_ROATPV2_NationalAchievementRate]
(
	[Id]							bigint					NOT NULL,
	[Age]							smallint				NULL,
	[ApprenticeshipLevel]			smallint				NULL,
	[OverallCohort]					int						NULL,
	[OverallAchievementRate]		decimal(10,4)			NULL,
	[SectorSubjectAreaTier1]        INT Not NULL,
    [Ukprn]                         INT NOT NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)			DEFAULT (getdate())
)

