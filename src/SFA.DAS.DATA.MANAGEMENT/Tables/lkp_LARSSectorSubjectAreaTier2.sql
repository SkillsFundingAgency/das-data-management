CREATE TABLE [lkp].[LARS_SectorSubjectAreaTier2](
	[SectorSubjectAreaTier2] [decimal](5, 2) NOT NULL,
	[SectorSubjectAreaTier2_Integer] [varchar](5) NOT NULL,
	[SectorSubjectAreaTier2_Desc] [varchar](60) NULL,
	[SectorSubjectAreaTier2_Desc2] [varchar](30) NULL,
	[File_Code] [varchar](50) NULL,
	[File_Alias] [varchar](50) NULL,
	[LoadDate] [int] NULL,
	[LoadID] [int] NULL,
	[Load_SourceFile_Row] [bigint] NULL,
	[AsDm_UpdatedDateTime] datetime2(7) default(Getdate()) null
) ON [Primary]
GO