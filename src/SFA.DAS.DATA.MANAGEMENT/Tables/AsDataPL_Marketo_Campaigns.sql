CREATE TABLE [AsData_PL].[MarketoCampaigns]
(
	[CampaignId] [bigint] NULL,
	[CampaignName] [nvarchar](max) NULL,
	[CampaignType] [nvarchar](max) NULL,
	[ProgramName] [nvarchar](max) NULL,
	[ProgramId] [bigint] NULL,
	[WorkspaceName] [nvarchar](max) NULL,
	[createdAt] DATETIME2 NULL,
	[updatedAt] DATETIME2 NULL,
	[active] [bit] NULL
)
