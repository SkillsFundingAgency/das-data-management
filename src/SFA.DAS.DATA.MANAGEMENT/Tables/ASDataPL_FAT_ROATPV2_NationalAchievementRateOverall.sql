CREATE TABLE [ASData_PL].[FAT_ROATPV2_NationalAchievementRateOverall]
(
	[Id]							bigint			NOT NULL,
	[Age]							smallint		NOT NULL,
	[SectorSubjectArea]				varchar(1000)   NULL,
	[ApprenticeshipLevel]			smallint		NOT NULL,
	[OverallCohort]					int				NULL,
	[OverallAchievementRate]		decimal(10,4)	NULL,
	[SectorSubjectAreaTier1]        int 			NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) DEFAULT (getdate())
)
