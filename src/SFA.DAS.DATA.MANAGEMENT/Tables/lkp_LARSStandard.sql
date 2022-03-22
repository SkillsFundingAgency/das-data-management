CREATE TABLE [lkp].[LARS_Standard]
(
	[StandardCode] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[StandardName] [varchar](750) NULL,
	[StandardSectorCode] [varchar](25) NULL,
	[NotionalEndLevel] [varchar](5) NULL,
	[EffectiveFrom] [date] NULL,
	[LastDateStarts] [date] NULL,
	[EffectiveTo] [date] NULL,
	[URLLink] [varchar](1200) NULL,
	[SectorSubjectAreaTier1] [decimal](5, 2) NULL,
	[SectorSubjectAreaTier2] [decimal](5, 2) NULL,
	[IntegratedDegreeStandard] [char](1) NULL,
	[OtherBodyApprovalRequired] [varchar](20) NULL,
	[Created_On] [datetime] NOT NULL,
	[Created_By] [varchar](100) NOT NULL,
	[Modified_On] [datetime] NOT NULL,
	[Modified_By] [varchar](100) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2(7) default(getdate()) null
) ON [Primary]
GO
