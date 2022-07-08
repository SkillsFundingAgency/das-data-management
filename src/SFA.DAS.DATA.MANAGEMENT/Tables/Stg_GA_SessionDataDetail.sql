CREATE TABLE [Stg].[GA_SessionDataDetail]
(
		[GASD_Id] BIGINT IDENTITY(1,1)					NOT NULL,
		[ClientId]										[NVarchar](500) NULL,			
		[VisitDate]										[NVarchar](500) NULL,
		[ESFAToken]                                     [NVarchar](500) NULL,
		[Hits_Page_PagePath]							[NVarchar](Max) NULL,
		[EventLabel_ESFAToken]                          [NVarchar](2000) NULL, 
		[CD_SearchTerms]								[NVarchar](2000) NULL, 
		[CD_UserId]										[NVarchar](500) NULL, 
		[CD_EmployerId]									[NVarchar](500) NULL, 
		[CD_ESFAToken]									[NVarchar](500) NULL, 		
		[FileName]										[Nvarchar](500) NULL,
		[StgImportDate]									[datetime2](7) DEFAULT (getdate()),
		[TrafficSource_Campaign]						[NVarchar](500) NULL,
		[CD_VacancyId]								    [NVarchar](500) NULL,
		[CD_ApprenticeshipID]						    [NVarchar](500) NULL,
		[TrafficSource_Source]                          [NVarchar](max) NULL
)
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetail_StgImportDate  ON [Stg].[GA_SessionDataDetail] (StgImportDate ASC);
GO
CREATE NONCLUSTERED INDEX NCI_GA_SessionDataDetail_clientId  ON [Stg].[GA_SessionDataDetail] (ClientId ASC);
GO

