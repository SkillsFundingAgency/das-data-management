CREATE TABLE [AsData_PL].[Assessor_Organisations]
(
	[Id]								[uniqueidentifier]			PRIMARY KEY NOT NULL,
	[CreatedAt]							[datetime2](7)				NOT NULL,
	[DeletedAt]							[datetime2](7)				NULL,
	[EndPointAssessorName]				[nvarchar](100)				NULL,
	[EndPointAssessorOrganisationId]	[nvarchar](12)				NULL,
	[EndPointAssessorUkprn]				[int]						NULL,
	[Status]							[nvarchar](10)				NULL,
	[UpdatedAt]							[datetime2](7)				NULL,
	[OrganisationTypeId]				[int]						NULL,	
	[ApiEnabled]						[bit]						NULL,
	[ApiUser]							[nvarchar](100)				NULL,
	[RecognitionNumber]					[nvarchar](100)				NULL,
	[AsDm_UpdatedDateTime]				[Datetime2](7)				default getdate()
)
