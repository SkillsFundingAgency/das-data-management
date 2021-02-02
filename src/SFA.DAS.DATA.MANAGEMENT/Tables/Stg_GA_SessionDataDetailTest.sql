CREATE TABLE [Stg].[GA_SessionDataDetailTest]
(
	[GASD_Id] BIGINT IDENTITY(1,1)						NOT NULL,
	[FullVisitorId]					[varchar](50)		NULL,
	[ClientId]						[varchar](50)		NULL,
	[VisitId]						[varchar](30)		NULL,
	[VisitNumber]					[varchar](20)		NULL,
	[VisitStartDateTime]			[varchar](30)		NULL,
	[VisitDate]						[varchar](20)		NULL,
	[VisitorId]						[varchar](50)		NULL,
	[UserId]						[varchar](50)		NULL,
	[Hits_Page_PagePath]			[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel1]		[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel2]		[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel3]		[varbinary](200)	NULL,
	[Hits_Page_PagePathLevel4]		[varbinary](200)	NULL,
	[Hits_Time]						[varchar](20)		NULL,
	[Hits_IsEntrance]				[varchar](10)		NULL,
	[Hits_IsExit]					[varchar](10)		NULL,
	[EmployerId]					[varchar](50)		NULL,
	[ID2]							[varchar](50)		NULL,
	[ID3]							[varchar](50)		NULL,
	[ESFAToken]						[varchar](50)		NULL,
	[EventCategory]					[varbinary](200)	NULL,
	[EventAction]					[varbinary](500)	NULL,
	[EventLabel]					[varbinary](500)	NULL,
	[EventLabel_ESFAToken]			[varchar](50)		NULL,
	[EventLabel_Keyword]			[varbinary](200)	NULL,
	[EventLabel_Postcode]			[varchar](20)		NULL,
	[EventLabel_WithinDistance]		[varchar](50)		NULL,
	[EventLabel_Level]				[varchar](50)		NULL,
	[EventValue]					[varbinary](50)		NULL,
	[CD_ClientId]					[varchar](50)		NULL,
	[CD_SearchTerms]				[varbinary](200)	NULL,
	[CD_UserId]						[varchar](50)		NULL,
	[CD_LevyFlag]					[varchar](20)		NULL,
	[CD_EmployerId]					[varchar](50)		NULL,
	[CD_ESFAToken]					[varchar](100)		NULL,
	[CD_LegalEntityId]				[varchar](20)		NULL,
	[FileName]						[varchar](50)		NULL,
	[StgImportDate]					[datetime2](7) DEFAULT (getdate())
)
WITH (DATA_COMPRESSION = PAGE);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetailTest_StgImportDate  ON [Stg].[GA_SessionDataDetailTest] (StgImportDate ASC) WITH (DATA_COMPRESSION = PAGE);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetailTest_clientId  ON [Stg].[GA_SessionDataDetailTest] (ClientId ASC) WITH (DATA_COMPRESSION = PAGE);
GO

