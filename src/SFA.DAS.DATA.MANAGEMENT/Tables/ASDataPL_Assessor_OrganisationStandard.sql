CREATE TABLE [AsData_PL].[Assessor_OrganisationStandard]
(
	[Id]								[int]				Primary Key NOT NULL,
	[EndPointAssessorOrganisationId]	[nvarchar](12)					NULL,
	[StandardCode]						[int]							NULL,
	[EffectiveFrom]						[datetime]						NULL,
	[EffectiveTo]						[datetime]						NULL,
	[DateStandardApprovedOnRegister]	[datetime]						NULL,
	[Comments]							[nvarchar](500)					NULL,
	[Status]							[nvarchar](10)					NULL,
	[ContactId]							[uniqueidentifier]				NULL,
	[DeliveryAreasComments]				[NVarchar](500)					NULL,
	[StandardReference]					[nvarchar](10)					NULL,
	[AsDm_UpdatedDateTime]				[Datetime2](7)					default getdate(),
)
