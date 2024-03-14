CREATE TABLE [ASData_PL].[FAT_ROATPV2_NationalAchievementRate]
(
	[Id]							bigint					NOT NULL,
	[ProviderId]					int						NOT NULL,
	[Age]							smallint				NULL,
	[SectorSubjectArea]				varchar(1000)			NULL,
	[ApprenticeshipLevel]			smallint				NULL,
	[OverallCohort]					int						NULL,
	[OverallAchievementRate]		decimal(10,4)			NULL,
	[SectorSubjectAreaTier1]        int 					NOT NULL,
	[Ukprn] 						int 					NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)			DEFAULT (getdate())
)

