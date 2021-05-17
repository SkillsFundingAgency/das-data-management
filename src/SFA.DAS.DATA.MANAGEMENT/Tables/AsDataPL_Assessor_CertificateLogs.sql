CREATE TABLE [AsData_PL].[Assessor_CertificateLogs]
(
	[Id]						[uniqueidentifier]	PRIMARY KEY	NOT NULL,
	[Action]					[nvarchar](400)		NULL,
	[CertificateId]				[uniqueidentifier]	NULL,
	[EventTime]					[datetime2](7)		NULL,
	[Status]					[nvarchar](20)		NULL,
	[BatchNumber]				[int]				NULL,
	[ReasonForChange]			[nvarchar](max)		NULL,
	[LatestEpaOutcome]			[nvarchar](100)		NULL,
	[StandardName]				[NVarchar](200)		NULL,
	[StandardLevel]				[Int]				NULL,
	[StandardPublicationDate]	[DateTime2](7)		NULL,
	[ContactOrganisation]		[NVarchar](100)		NULL,
	[ContactPostcode]			[NVarchar](20)		NULL,
	[Registration]				[NVarchar](100)		NULL,
	[LearningStartDate]			[DateTime2](7)		NULL,
	[AchievementDate]			[DateTime2](7)		NULL,
	[CourseOption]				[NVarchar](100)		NULL,
	[OverallGrade]				[NVarchar](50)		NULL,
	[Department]				[NVarchar](100)		NULL,
	[AsDm_UpdatedDateTime]		[Datetime2](7)		default getdate()
)
