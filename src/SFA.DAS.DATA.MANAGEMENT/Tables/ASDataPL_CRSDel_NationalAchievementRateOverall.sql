CREATE TABLE [ASData_PL].[CRSDel_NationalAchievementRateOverall]
(
	[Id]							bigint		NOT NULL,
	[Age]							smallint	NOT NULL,
	[SectorSubjectArea]				varchar     NOT NULL,
	[ApprenticeshipLevel]			smallint    NOT NULL,
	[OverallCohort]					int			NULL,
	[OverallAchievementRate]		decimal     NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) DEFAULT (getdate())	
)

