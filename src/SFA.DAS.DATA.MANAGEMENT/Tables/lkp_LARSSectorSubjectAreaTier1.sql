CREATE TABLE [lkp].[LARS_SectorSubjectAreaTier1](
    [SectorSubjectAreaTier1] [decimal](5, 2) NOT NULL,
	[SectorSubjectAreaTier1_Integer] [varchar](5) NOT NULL,
	[SectorSubjectAreaTier1_Desc] [varchar](50) NULL,
	[SectorSubjectAreaTier1_Desc2] [varchar](30) NULL,
	[File_Code] [varchar](50) NULL,
	[File_Alias] [varchar](50) NULL,
	[LoadDate] [int] NULL,
	[LoadID] [int] NULL,
	[Load_SourceFile_Row] [bigint] NULL,
	[AsDm_UpdatedDateTime] datetime2(7) default(getdate()) null
) ON [Primary]
GO
