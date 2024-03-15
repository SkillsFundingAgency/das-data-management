CREATE TABLE [ASData_PL].[FAT_ROATPV2_NationalAchievementRateOverall]
(
	[Id]							bigint			NOT NULL,
	[Age]							smallint		NOT NULL,
	[ApprenticeshipLevel]			smallint		NOT NULL,
	[OverallCohort]					int				NULL,
	[OverallAchievementRate]		decimal(10,4)	NULL,
	[SectorSubjectAreaTier1]        INT NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) DEFAULT (getdate())	
)
