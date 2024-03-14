CREATE TABLE [ASData_PL].[FAT2_SectorSubjectAreaTier1](
	[SectorSubjectAreaTier1]		int	NOT NULL,
	[SectorSubjectAreaTier1Desc]	[varchar](500)		NOT NULL,
	[EffectiveFrom]					[datetime]			NULL,
	[EffectiveTo]					[datetime]			NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) DEFAULT (getdate())	
) 
