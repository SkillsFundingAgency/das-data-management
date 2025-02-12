CREATE TABLE [AsData_PL].[Assessor_CertificateLogs]
(
	[Id]						[uniqueidentifier]	PRIMARY KEY	NOT NULL,
	[Action]					[nvarchar](500)		NULL,
	[CertificateId]				[uniqueidentifier]	NULL,
	[EventTime]					[datetime2](7)		NULL,
	[Status]					[nvarchar](50)		NULL,
	[BatchNumber]				[int]				NULL,
	[ReasonForChange]			[nvarchar](max)		NULL,
	[LatestEpaOutcome]			[nvarchar](4000)	NULL,
	[StandardName]				[NVarchar](300)		NULL,
	[StandardLevel]				[Int]				NULL,
	[StandardPublicationDate]	[DateTime2](7)		NULL,
	[ContactOrganisation]		[NVarchar](300)		NULL,
	[ContactPostcode]			[NVarchar](50)		NULL,
	[Registration]				[NVarchar](300)		NULL,
	[LearningStartDate]			[DateTime2](7)		NULL,
	[AchievementDate]			[DateTime2](7)		NULL,
	[CourseOption]				[NVarchar](300)		NULL,
	[OverallGrade]				[NVarchar](300)		NULL,
	[Department]				[NVarchar](300)		NULL,
	[AsDm_UpdatedDateTime]		[Datetime2](7)		default getdate()
)

GO


CREATE NONCLUSTERED INDEX IDX_CertificateLogs_WatermarkColumn
ON [ASData_PL].[Assessor_CertificateLogs] (EventTime);