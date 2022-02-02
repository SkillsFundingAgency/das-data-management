CREATE TABLE [AsData_PL].[Assessor_MergeOrganisationStandardVersion]
(
	[Id]							[int]			NOT NULL,
	[StandardUId]					[varchar](20)	NOT NULL,
	[Version]						[nvarchar](20)	NULL,
	[OrganisationStandardId]		[int]			NOT NULL,
	[EffectiveFrom]					[datetime]		NULL,
	[EffectiveTo]					[datetime]		NULL,
	[DateVersionApproved]			[datetime]		NULL,
	[Comments]						[nvarchar](500) NULL,
	[Status]						[nvarchar](10)	NOT NULL,
	[MergeOrganisationId]			[int]			NOT NULL,
	[Replicates]					[nvarchar](6)	NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default(getdate())
)
