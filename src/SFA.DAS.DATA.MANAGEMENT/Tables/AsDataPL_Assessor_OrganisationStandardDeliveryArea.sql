CREATE TABLE [AsData_PL].[Assessor_OrganisationStandardDeliveryArea]
(
	[Id]						[int]			PRIMARY KEY	NOT NULL,
	[OrganisationStandardId]	[int]						NOT NULL,
	[DeliveryAreaId]			[int]						NOT NULL,
	[Comments]					[nvarchar](500)				NULL,
	[Status]					[nvarchar](10)				NULL
)
