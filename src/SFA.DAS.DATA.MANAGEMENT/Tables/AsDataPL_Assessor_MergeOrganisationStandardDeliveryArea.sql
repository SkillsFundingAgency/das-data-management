CREATE TABLE [AsData_PL].[Assessor_MergeOrganisationStandardDeliveryArea]
(
	[Id]									[int] NOT NULL,
	[OrganisationStandardId]				[int] NOT NULL,
	[DeliveryAreaId]						[int] NOT NULL,
	[Comments]								[nvarchar](500) NULL,
	[Status]								[nvarchar](10) NOT NULL,
	[MergeOrganisationId]					[int] NOT NULL,
	[OrganisationStandardDeliveryAreaId]	[int] NOT NULL,
	[Replicates]							[nvarchar](6) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default(getdate())
)
