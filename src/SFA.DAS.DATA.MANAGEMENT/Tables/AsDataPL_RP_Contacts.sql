﻿CREATE TABLE [AsData_PL].[RP_Contacts]
(
	[Id]							[uniqueidentifier]					NOT NULL,
	[Email]							[nvarchar](250)						NULL,
	[SigninId]						[uniqueidentifier]					NULL,
	[SigninType]					[nvarchar](20)						NULL,
	[ApplyOrganisationID]			[uniqueidentifier]					NULL,	
	[Status]						[nvarchar](20)						NULL,
	[CreatedAt]						[datetime2](7)						NULL,
	[CreatedBy]						[nvarchar](256)						NULL,
	[UpdatedAt]						[datetime2](7)						NULL,
	[DeletedAt]						[datetime2](7)						NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) default getdate()	NULL
)