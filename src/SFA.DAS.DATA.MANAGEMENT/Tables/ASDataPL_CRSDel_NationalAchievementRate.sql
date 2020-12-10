CREATE TABLE [ASData_PL].[CRSDel_NationalAchievementRate]
(
	[Id]							bigint					NOT NULL,
	[UkPrn]						    int						NOT NULL,
	[Age]							smallint				NOT NULL,
	[SectorSubjectArea]				varchar					NOT NULL,
	[ApprenticeshipLevel]			smallint				NOT NULL,
	[OverallCohort]					int						NULL,
	[OverallAchievementRate]		decimal					NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)			DEFAULT (getdate())
)

