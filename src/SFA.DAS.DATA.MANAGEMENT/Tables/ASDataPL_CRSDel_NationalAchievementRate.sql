CREATE TABLE [ASData_PL].[CRSDel_NationalAchievementRate]
(
	[Id]							bigint					NOT NULL,
	[UkPrn]						    int						NOT NULL,
	[Age]							smallint				NOT NULL,
	[SectorSubjectArea]				varchar(1000)			NOT NULL,
	[ApprenticeshipLevel]			smallint				NOT NULL,
	[OverallCohort]					int						NULL,
	[OverallAchievementRate]		decimal(10,4)			NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)			DEFAULT (getdate())
)

