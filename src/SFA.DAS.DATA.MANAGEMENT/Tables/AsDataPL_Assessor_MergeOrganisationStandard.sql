CREATE TABLE [AsData_PL].[Assessor_MergeOrganisationStandard]
(
	[Id]											[int]			NOT NULL,
	[EndPointAssessorOrganisationId]				[nvarchar](12)	NOT NULL,
	[StandardCode]									[int]			NOT NULL,
	[EffectiveFrom]									[datetime]		NULL,
	[EffectiveTo]									[datetime]		NULL,
	[DateStandardApprovedOnRegister]				[datetime]		NULL,
	[Comments]										[nvarchar](500) NULL,
	[Status]										[nvarchar](10) NOT NULL,
	[ContactId]										[uniqueidentifier] NULL,
	[OrganisationStandardData]						[nvarchar](max) NULL,
	[StandardReference]								[nvarchar](10) NULL,
	[MergeOrganisationId]							[int] NOT NULL,
	[OrganisationStandardId]						[int] NOT NULL,
	[Replicates]									[nvarchar](6) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default(getdate())
)
