CREATE TABLE [ASData_PL].[RP_ApplySnapshots](
	[Id]						[uniqueidentifier]	NOT NULL,
	[ApplicationId]				[uniqueidentifier]	NULL,
	[SnapshotApplicationId]		[uniqueidentifier]  NULL,
	[SnapshotDate]				[datetime2](7)		NULL,
	[OrganisationId]			[uniqueidentifier]  NULL,
	[ApplicationStatus]			[nvarchar](20)		NULL,
	[ApplyData]					[nvarchar](max)		NULL,
	[GatewayReviewStatus]		[nvarchar](20)		NULL,
	[AssessorReviewStatus]		[nvarchar](20)		NULL,
	[FinancialReviewStatus]		[nvarchar](20)		NULL,
	[FinancialGrade]			[nvarchar](max)		NULL,
	[AsDm_UpdatedDateTime]		[datetime2](7) default getdate()	NULL
)