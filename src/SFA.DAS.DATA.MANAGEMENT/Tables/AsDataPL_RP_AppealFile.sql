CREATE TABLE [AsData_PL].[RP_AppealFile]
(
	[Id]					[uniqueidentifier]		NOT NULL,
	[ApplicationId]			[uniqueidentifier]		NULL,
	[Filename]				[nvarchar](256)			NULL,
	[ContentType]			[nvarchar](256)			NULL,
	[Size]					[int]					NULL,
	[UserId]				[nvarchar](256)			NULL,
	[Username]				[nvarchar](256)			NULL,	
	[CreatedOn]				[datetime2](7)			NULL,
	[AsDm_UpdatedDateTime]	[datetime2](7) default getdate()	NULL
) 
