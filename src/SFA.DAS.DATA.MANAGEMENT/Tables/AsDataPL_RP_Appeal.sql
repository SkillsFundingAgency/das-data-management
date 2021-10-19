CREATE TABLE [AsData_PL].[RP_Appeal]
(
	[Id]										[uniqueidentifier]			NOT NULL,
	[ApplicationId]								[uniqueidentifier]			NOT NULL,
	[Status]									[nvarchar](30)				NOT NULL,
	[AppealSubmittedDate]						[datetime2](7)				NULL,
	[AppealDeterminedDate]						[datetime2](7)				NULL,	
	[UserId]									[nvarchar](256)				NULL,
	[UserName]									[nvarchar](256)				NULL,
	[InProgressDate]							[datetime2](7)				NULL,
	[InProgressUserId]							[nvarchar](256)				NULL,
	[InProgressUserName]						[nvarchar](256)				NULL,		
	[CreatedOn]									[datetime2](7)				NOT NULL,
	[UpdatedOn]									[datetime2](7)				NULL,
	[AsDm_UpdatedDateTime]						[datetime2](7) default getdate()	NULL
)