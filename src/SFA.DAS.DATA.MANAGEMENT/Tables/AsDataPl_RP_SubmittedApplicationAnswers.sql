CREATE TABLE [AsData_PL].[RP_SubmittedApplicationAnswers](
	[Id]						[int]					PRIMARY KEY NOT NULL,
	[ApplicationId]				[uniqueidentifier]		NULL,
	[PageId]					[nvarchar](25)			NULL,
	[QuestionId]				[nvarchar](25)			NULL,
	[QuestionType]				[nvarchar](25)			NULL,
	[Answer]					[nvarchar](max)			NULL,
	[ColumnHeading]				[nvarchar](100)			NULL,
	[AsDm_UpdatedDateTime]		[datetime2](7)	default getdate()	NULL
)