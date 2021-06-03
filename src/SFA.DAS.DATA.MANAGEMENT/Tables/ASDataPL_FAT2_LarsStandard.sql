CREATE TABLE [ASData_PL].[FAT2_LarsStandard](
	[LarsCode]					[int]				PRIMARY KEY NOT NULL,
	[Version]					[int]				NOT NULL,
	[EffectiveFrom]				[datetime]			NOT NULL,
	[EffectiveTo]				[datetime]			NULL,
	[LastDateStarts]			[datetime]			NULL,
	[SectorSubjectAreaTier2]	[decimal](10, 4)	NOT NULL,
	[OtherBodyApprovalRequired] [bit]				NOT NULL,
	[SectorCode]				[int]				NULL,
	[AsDm_UpdatedDateTime]		[datetime2](7) DEFAULT (getdate())
)