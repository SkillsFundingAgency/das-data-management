CREATE TABLE [AsData_PL].[RP_ModeratorPageReviewOutcome]
(
	[Id]							[uniqueidentifier] PRIMARY KEY	NOT NULL,
	[ApplicationId]					[uniqueidentifier]				NULL,
	[SequenceNumber]				[int]							NULL,
	[SectionNumber]					[int]							NULL,
	[PageId]						[nvarchar](50)					NULL,
	[ModeratorUserId]				[nvarchar](256)					NULL,	
	[ModeratorReviewStatus]			[nvarchar](20)					NULL,
	[ModeratorReviewComment]		[nvarchar](max)					NULL,
	[ClarificationUserId]			[nvarchar](256)					NULL,	
	[ClarificationStatus]			[nvarchar](20)					NULL,
	[ClarificationComment]			[nvarchar](max)					NULL,
	[ClarificationResponse]			[nvarchar](max)					NULL,
	[ClarificationFile]				[nvarchar](256)					NULL,
	[ClarificationUpdatedAt]		[datetime2](7)					NULL,
	[CreatedAt]						[datetime2](7)					NULL,
	[UpdatedAt]						[datetime2](7)					NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)	default getdate()	NULL
 )
