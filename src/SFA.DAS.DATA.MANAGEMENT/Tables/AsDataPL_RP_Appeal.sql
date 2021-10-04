CREATE TABLE [AsData_PL].[RP_Appeal]
(
	[Id]										[uniqueidentifier]			NOT NULL,
	[ApplicationId]								[uniqueidentifier]			NOT NULL,
	[Status]									[nvarchar](30)				NOT NULL,
	[HowFailedOnPolicyOrProcesses]				[nvarchar](max)				NULL,
	[HowFailedOnEvidenceSubmitted]				[nvarchar](max)				NULL,
	[AppealSubmittedDate]						[datetime2](7)				NULL,
	[AppealDeterminedDate]						[datetime2](7)				NULL,
	[InternalComments]							[nvarchar](max)				NULL,
	[ExternalComments]							[nvarchar](max)				NULL,
	[UserId]									[nvarchar](256)				NULL,
	[UserName]									[nvarchar](256)				NULL,
	[InProgressDate]							[datetime2](7)				NULL,
	[InProgressUserId]							[nvarchar](256)				NULL,
	[InProgressUserName]						[nvarchar](256)				NULL,
	[InProgressInternalComments]				[nvarchar](max)				NULL,
	[InProgressExternalComments]				[nvarchar](max)				NULL,
	[CreatedOn]									[datetime2](7)				NOT NULL,
	[UpdatedOn]									[datetime2](7)				NULL,
	[AsDm_UpdatedDateTime]						[datetime2](7) default getdate()	NULL
)