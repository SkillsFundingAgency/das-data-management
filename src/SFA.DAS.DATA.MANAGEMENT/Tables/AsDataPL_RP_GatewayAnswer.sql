CREATE TABLE [AsData_PL].[RP_GatewayAnswer]
(
	[Id]									[uniqueidentifier]	NOT NULL,
	[ApplicationId]							[uniqueidentifier]	NULL,
	[PageId]								[nvarchar](50)		NULL,
	[Status]								[nvarchar](20)		NULL,
	[Comments]								[nvarchar](max)		NULL,
	[ClarificationComments]					[nvarchar](max)		NULL,
	[ClarificationDate]						[datetime2](7)		NULL,
	[ClarificationBy]						[nvarchar](256)		NULL,
	[ClarificationAnswer]					[nvarchar](max)		NULL,
	[GatewayPageData]						[nvarchar](max)		NULL,
	[UpdatedAt]								[datetime2](7)		NULL,
	[UpdatedBy]								[nvarchar](256)		NULL,
	[AsDm_UpdatedDateTime]					[datetime2](7)		default getdate()	NULL
)