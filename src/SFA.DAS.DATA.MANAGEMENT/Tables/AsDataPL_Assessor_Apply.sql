CREATE TABLE [AsData_PL].[Assessor_Apply]
(
	[Id]							[uniqueidentifier] PRIMARY KEY	NOT NULL,
	[ApplicationId]					[uniqueidentifier] NOT NULL,
	[OrganisationId]				[uniqueidentifier] NOT NULL,
	[ApplicationStatus]				[nvarchar](20) NULL,
	[ReviewStatus]					[nvarchar](20) NULL,
	[FinancialReviewStatus]			[nvarchar](20) NULL,	
	[SelectedGrade]					[Varchar](100) NULL,
	[GradedBy]						[Varchar](100) NULL,	
	[FinancialDueDate]				[datetime2](7) NULL,
	[StandardCode]					[int] NULL,
	[CreatedAt]						[datetime2](7) NULL,
	[CreatedBy]						[nvarchar](256) NULL,
	[UpdatedAt]						[datetime2](7) NULL,	
	[DeletedAt]						[datetime2](7) NULL,	
	[StandardApplicationType]		[nvarchar](60) NULL,
	[StandardReference]				[nvarchar](10) NULL,
	[AsDm_UpdatedDateTime]			[Datetime2](7)		default getdate()
)
