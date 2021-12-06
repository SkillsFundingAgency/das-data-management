CREATE TABLE [lkp].[LARS_Framework]
(
	[FworkCode]							[int] NOT NULL,
	[ProgType]							[int] NOT NULL,
	[PwayCode]							[int] NOT NULL,
	[PathwayName]						[varchar](256) NULL,
	[EffectiveFrom]						[date] NULL,
	[EffectiveTo]						[date] NULL,
	[SectorSubjectAreaTier1]			[decimal](5, 2) NULL,
	[SectorSubjectAreaTier2]			[decimal](5, 2) NULL,
	[NASTitle]							[varchar](750) NULL,
	[ImplementDate]						[date] NULL,
	[IssuingAuthorityTitle]				[varchar](256) NULL,
	[IssuingAuthority]					[varchar](15) NULL,
	[DataReceivedDate]					[date] NULL,
	[MI_FullLevel2]						[int] NULL,
	[MI_FullLevel2Percent]				[decimal](5, 2) NULL,
	[MI_FullLevel3]						[int] NULL,
	[MI_FullLevel3Percent]				[decimal](5, 2) NULL,
	[CurrentVersion]					[varchar](10) NULL,
	[Created_On]						[datetime] NOT NULL,
	[Created_By]						[varchar](100) NOT NULL,
	[Modified_On]						[datetime] NOT NULL,
	[Modified_By]						[varchar](100) NOT NULL
) ON [Primary]
GO