CREATE TABLE [ASData_PL].[FAT2_SectorSubjectAreaTier2](
	[SectorSubjectAreaTier2]		[decimal](10, 4)	NOT NULL,
	[SectorSubjectAreaTier2Desc]	[varchar](500)		NOT NULL,
	[Name]							[varchar](500)		NOT NULL,
	[EffectiveFrom]					[datetime]			NOT NULL,
	[EffectiveTo]					[datetime]			NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) DEFAULT (getdate())	
) 
