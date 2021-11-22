CREATE TABLE [AsData_PL].[RP_FinancialReview]
(
	[Id]									[uniqueidentifier]			NOT NULL,
	[ApplicationId]							[uniqueidentifier]			NOT NULL,
	[Status]								[nvarchar](20)				NOT NULL,
	[SelectedGrade]							[nvarchar](20)				NULL,
	[FinancialDueDate]						[datetime2](7)				NULL,	
	[GradedOn]								[datetime2](7)				NULL,
	[Comments]								[nvarchar](max)				NULL,
	[ExternalComments]						[nvarchar](max)				NULL,	
	[ClarificationRequestedOn]				[datetime2](7)				NULL,	
	[ClarificationResponse]					[nvarchar](max)				NULL,
	[AsDm_UpdatedDateTime]					[datetime2](7)		default getdate()	NULL
)
