CREATE TABLE [AsData_PL].[RP_EmailTemplates]
(
	[Id]							[uniqueidentifier]					PRIMARY KEY NOT NULL,
	[Status]						[nvarchar](20)						NULL,
	[TemplateName]					[nvarchar](max)						NULL,
	[TemplateId]					[nvarchar](max)						NULL,	
	[RecipientTemplate]				[nvarchar](max)						NULL,
	[CreatedAt]						[datetime2](7)						NULL,
	[CreatedBy]						[nvarchar](256)						NULL,
	[UpdatedAt]						[datetime2](7)						NULL,
	[UpdatedBy]						[nvarchar](256)						NULL,
	[DeletedAt]						[datetime2](7)						NULL,
	[DeletedBy]						[nvarchar](256)						NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) default getdate()	NULL
)

