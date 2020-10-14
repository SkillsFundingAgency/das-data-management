CREATE TABLE [AsData_PL].[Marketo_SmartCampaigns]
(
	[SmartCampaignId] [bigint] NULL,
	[SmartCampaignName] [nvarchar](526) NULL,
	[SmartCampaignDesc] nvarchar(max),
	[SmartCampaignType] [nvarchar](255) NULL,
	[Status] nvarchar(100),
	[IsActive] nvarchar(100),
	[SmartListId] bigint,
	[ParentProgramId] [bigint] NULL,
	[WorkspaceName] [nvarchar](max) NULL,
	[createdAt] DATETIME2 NULL,
	[updatedAt] DATETIME2 NULL,
	[active] [bit] NULL,
    AsDm_CreatedDate Datetime2,
    AsDm_UpdatedDate datetime2
)
