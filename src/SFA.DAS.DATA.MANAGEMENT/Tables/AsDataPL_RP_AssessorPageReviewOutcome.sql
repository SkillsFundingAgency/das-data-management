CREATE TABLE [AsData_PL].[RP_AssessorPageReviewOutcome]
(
	[Id]							[uniqueidentifier]					PRIMARY KEY NOT NULL,
	[ApplicationId]					[uniqueidentifier]					NULL,
	[SequenceNumber]				[int]								NULL,
	[SectionNumber]					[int]								NULL,
	[PageId]						[nvarchar](50)						NULL,
	[Assessor1UserId]				[nvarchar](256)						NULL,
	[Assessor1ReviewStatus]			[nvarchar](20)						NULL,
	[Assessor1ReviewComment]		[nvarchar](max)						NULL,
	[Assessor2UserId]				[nvarchar](256)						NULL,
	[Assessor2ReviewStatus]			[nvarchar](20)						NULL,
	[Assessor2ReviewComment]		[nvarchar](max)						NULL,
	[CreatedAt]						[datetime2](7)						NULL,
	[UpdatedAt]						[datetime2](7)						NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7) default getdate()	NULL
 )