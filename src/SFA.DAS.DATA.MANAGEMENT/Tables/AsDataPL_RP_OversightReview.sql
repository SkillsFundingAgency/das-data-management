CREATE TABLE [AsData_PL].[RP_OversightReview](
	[Id]							[uniqueidentifier] PRIMARY KEY		NOT NULL,
	[ApplicationId]					[uniqueidentifier]					NULL,
	[GatewayApproved]				[bit]								NULL,
	[ModerationApproved]			[bit]								NULL,
	[Status]						[tinyint]							NULL,
	[ApplicationDeterminedDate]		[datetime2](7)						NULL,
	[InternalComments]				[nvarchar](max)						NULL,
	[ExternalComments]				[nvarchar](max)						NULL,
	[UserId]						[nvarchar](256)						NULL,	
	[InProgressDate]				[datetime2](7)						NULL,
	[InProgressUserId]				[nvarchar](256)						NULL,	
	[InProgressInternalComments]	[nvarchar](max)						NULL,
	[InProgressExternalComments]	[nvarchar](max)						NULL,
	[CreatedOn]						[datetime2](7)						NULL,
	[UpdatedOn]						[datetime2](7)						NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) default getdate()	NULL
)