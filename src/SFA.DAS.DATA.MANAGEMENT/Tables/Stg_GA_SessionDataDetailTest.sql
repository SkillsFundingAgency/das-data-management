CREATE TABLE [Stg].[GA_SessionDataDetailTest]
(
		[GASD_Id] BIGINT IDENTITY(1,1)					NOT NULL,
		[FullVisitorId]									[Varbinary](500) NULL,
		[ClientId]										[Varbinary](500) NULL,			
		[VisitId]										[Varbinary](500) NULL,
		[VisitNumber]									[Varbinary](500) NULL,
		[VisitStartDateTime]							[Varbinary](500) NULL,
		[VisitDate]										[Varbinary](500) NULL,
		[VisitorId]										[Varbinary](500) NULL,
		[UserId]										[Varbinary](500) NULL,		
		[Hits_Page_PagePath]							[Varbinary](Max) NULL,
		[Hits_Page_PagePathLevel1]						[Varbinary](Max) NULL,
		[Hits_Page_PagePathLevel2]						[Varbinary](Max) NULL,
		[Hits_Page_PagePathLevel3]						[Varbinary](Max) NULL,
		[Hits_Page_PagePathLevel4]						[Varbinary](Max) NULL,
		[Hits_Time]										[Varbinary](500) NULL,		
		[Hits_IsEntrance]								[Varbinary](500) NULL,
		[Hits_IsExit]									[Varbinary](500) NULL,
		[EmployerId]									[Varbinary](500) NULL,
		[ID2]											[Varbinary](500) NULL,
		[ID3]											[Varbinary](500) NULL,
		[ESFAToken]										[Varbinary](500) NULL,		
		[EventCategory]									[Varbinary](max) NULL,
		[EventAction]									[Varbinary](max) NULL,
		[EventLabel]									[Varbinary](max) NULL,
		[EventLabel_ESFAToken]							[Varbinary](500) NULL,		
		[EventLabel_Keyword]							[Varbinary](2000) NULL,
		[EventLabel_Postcode]							[Varbinary](500) NULL,
		[EventLabel_WithinDistance]						[Varbinary](500) NULL,
		[EventLabel_Level]								[Varbinary](500) NULL,
		[EventValue]									[Varbinary](Max) NULL,
		[CD_ClientId]									[Varbinary](500) NULL, 
		[CD_SearchTerms]								[Varbinary](2000) NULL, 
		[CD_UserId]										[Varbinary](500) NULL, 
		[CD_LevyFlag]									[Varbinary](500) NULL, 
		[CD_EmployerId]									[Varbinary](500) NULL, 
		[CD_ESFAToken]									[Varbinary](500) NULL, 
		[CD_LegalEntityId]								[Varbinary](500) NULL,
		[FileName]										[Varbinary](500) NULL,
		[StgImportDate]									[datetime2](7) DEFAULT (getdate())
)
WITH (DATA_COMPRESSION = PAGE);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetailTest_StgImportDate  ON [Stg].[GA_SessionDataDetailTest] (StgImportDate ASC) WITH (DATA_COMPRESSION = PAGE);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetailTest_clientId  ON [Stg].[GA_SessionDataDetailTest] (ClientId ASC) WITH (DATA_COMPRESSION = PAGE);
GO

