CREATE TABLE [ASData_PL].[Appfb_ApprenticeFeedbackResult]
(
	[Id] [uniqueidentifier] NULL,
	[ApprenticeFeedbackTargetId] [uniqueidentifier] NULL,
	[StandardUId] [nvarchar](12) NULL,
	[DateTimeCompleted] [datetime2](7) NULL,
	[ProviderRating] [nvarchar](10) NULL,
	[AllowContact] [bit] NULL
)