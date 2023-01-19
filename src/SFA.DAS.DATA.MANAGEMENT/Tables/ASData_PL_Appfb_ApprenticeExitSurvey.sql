CREATE TABLE [ASData_PL].[Appfb_ApprenticeExitSurvey](
	[Id] [uniqueidentifier] NOT NULL,
	[ApprenticeFeedbackTargetId] [uniqueidentifier] NOT NULL,
	[StandardUId] [nvarchar](12) NULL,
	[DateTimeCompleted] [datetime2](7) NOT NULL,
	[DidNotCompleteApprenticeship] [bit] NULL,
	[AllowContact] [bit] NULL,
	[PrimaryReason] [int] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate())