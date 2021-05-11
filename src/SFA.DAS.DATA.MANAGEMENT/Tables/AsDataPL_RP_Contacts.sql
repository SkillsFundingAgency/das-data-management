CREATE TABLE [AsData_PL].[RP_Contacts]
(
	[Id]							[uniqueidentifier]					NOT NULL,
	[SigninId]						[uniqueidentifier]					NULL,
	[SigninType]					[nvarchar](20)						NULL,
	[ApplyOrganisationID]			[uniqueidentifier]					NULL,	
	[Status]						[nvarchar](20)						NULL,
	[IsApproved]					[bit]								NULL,
	[CreatedAt]						[datetime2](7)						NULL,
	[UpdatedAt]						[datetime2](7)						NULL,
	[UpdatedBy]						[nvarchar](256)						NULL,
	[DeletedAt]						[datetime2](7)						NULL,
	[DeletedBy]						[nvarchar](256)						NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) default getdate()	NULL
)