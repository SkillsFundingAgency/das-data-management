CREATE TABLE [AsData_PL].[RP_Appeal]
(
	[Id]							[uniqueidentifier]					NOT NULL,
	[OversightReviewId]				[uniqueidentifier]					NULL,
	[Message]						[nvarchar](max)						NULL,
	[UserId]						[nvarchar](256)						NULL,	
	[CreatedOn]						[datetime2](7)						NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) default getdate()	NULL
)