CREATE TABLE [AsData_PL].[Comt_Standard](
	[Duration] [int] NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL,
	[IFateReferenceNumber] [nvarchar](10) NULL,
	[IsLatestVersion] [bit] NULL,
	[LarsCode] [int] NULL,
	[Level] [tinyint] NULL,
	[MaxFunding] [int] NULL,
	[Route] [nvarchar](500) NULL,
	[StandardPageUrl] [nvarchar](500) NULL,
	[StandardUId] [nvarchar](20) NOT NULL,
	[Status] [nvarchar](50) NULL,
	[Title] [nvarchar](512) NULL,
	[Version] [nvarchar](10) NULL,
	[VersionEarliestStartDate] [datetime] NULL,
	[VersionLatestStartDate] [datetime] NULL,
	[VersionMajor] [int] NULL,
	[VersionMinor] [int] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
    CONSTRAINT PK_Comt_Standard_StandardUId PRIMARY KEY CLUSTERED (StandardUId)
)ON [PRIMARY]

GO
