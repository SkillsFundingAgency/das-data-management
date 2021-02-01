CREATE TABLE [Stg].[GA_SessionDataDetailTest]
(
	[GASD_Id] BIGINT IDENTITY(1,1)						NOT NULL,
	[FullVisitorId]					[nvarchar](50)		NULL,
	[ClientId]						[nvarchar](50)		NULL,
	[VisitId]						[nvarchar](50)		NULL,
	[VisitNumber]					[nvarchar](20)		NULL,
	[VisitStartDateTime]			[nvarchar](50)		NULL,
	[VisitDate]						[nvarchar](20)		NULL,
	[VisitorId]						[nvarchar](50)		NULL,
	[UserId]						[nvarchar](50)		NULL,
	[Hits_Page_PagePath]			[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel1]		[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel2]		[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel3]		[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel4]		[varbinary](200)	NULL,
	[Hits_Time]						[nvarchar](50)		NULL,
	[Hits_IsEntrance]				[nvarchar](20)		NULL,
	[Hits_IsExit]					[nvarchar](20)		NULL,
	[EmployerId]					[nvarchar](100)		NULL,
	[ID2]							[nvarchar](100)		NULL,
	[ID3]							[nvarchar](100)		NULL,
	[ESFAToken]						[nvarchar](100)		NULL,
	[EventCategory]					[varbinary](200)	NULL,
	[EventAction]					[varbinary](500)	NULL,
	[EventLabel]					[varbinary](500)	NULL,
	[EventLabel_ESFAToken]			[nvarchar](100)		NULL,
	[EventLabel_Keyword]			[varbinary](200)	NULL,
	[EventLabel_Postcode]			[nvarchar](50)		NULL,
	[EventLabel_WithinDistance]		[nvarchar](50)		NULL,
	[EventLabel_Level]				[nvarchar](50)		NULL,
	[EventValue]					[varbinary](50)		NULL,
	[CD_ClientId]					[nvarchar](100)		NULL,
	[CD_SearchTerms]				[varbinary](200)	NULL,
	[CD_UserId]						[nvarchar](100)		NULL,
	[CD_LevyFlag]					[nvarchar](50)		NULL,
	[CD_EmployerId]					[nvarchar](50)		NULL,
	[CD_ESFAToken]					[nvarchar](200)		NULL,
	[CD_LegalEntityId]				[nvarchar](50)		NULL,
	[FileName]						[nvarchar](50)		NULL,
	[StgImportDate]					[datetime2](7) DEFAULT (getdate())
)
WITH (DATA_COMPRESSION = PAGE);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetailTest_StgImportDate  ON [Stg].[GA_SessionDataDetailTest] (StgImportDate ASC) WITH (DATA_COMPRESSION = PAGE);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetailTest_clientId  ON [Stg].[GA_SessionDataDetailTest] (ClientId ASC) WITH (DATA_COMPRESSION = PAGE);
GO

