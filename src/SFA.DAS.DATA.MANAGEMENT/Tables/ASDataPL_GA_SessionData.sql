﻿CREATE TABLE [ASData_PL].[GA_SessionData](
	[GASD_Id]						[bigint] IDENTITY(1,1) NOT NULL,
	[FullVisitorId]					[nvarchar](500) NULL,
	[ClientId]						[nvarchar](500) NULL,
	[VisitId]						[nvarchar](500) NULL,
	[VisitNumber]					[nvarchar](500) NULL,
	[VisitStartDateTime]			[nvarchar](500) NULL,
	[VisitDate]						[nvarchar](500) NULL,
	[VisitorId]						[nvarchar](500) NULL,
	[UserId]						[nvarchar](500) NULL,
	[Hits_Page_PagePath]			[nvarchar](max) NULL,	
	[Hits_Time]						[nvarchar](500) NULL,
	[Hits_IsEntrance]				[nvarchar](500) NULL,
	[Hits_IsExit]					[nvarchar](500) NULL,
	[EmployerId]					[nvarchar](500) NULL,
	[ID2]							[nvarchar](500) NULL,
	[ID3]							[nvarchar](500) NULL,
	[ESFAToken]						[nvarchar](500) NULL,
	[EventCategory]					[nvarchar](max) NULL,
	[EventAction]					[nvarchar](max) NULL,	
	[EventLabel_ESFAToken]			[nvarchar](500) NULL,
	[EventLabel_Keyword]			[nvarchar](2000) NULL,
	[EventLabel_Postcode]			[nvarchar](500) NULL,
	[EventLabel_WithinDistance]		[nvarchar](500) NULL,
	[EventLabel_Level]				[nvarchar](500) NULL,	
	[CD_ClientId]					[nvarchar](500) NULL,
	[CD_SearchTerms]				[nvarchar](2000) NULL,
	[CD_UserId]						[nvarchar](500) NULL,
	[CD_LevyFlag]					[nvarchar](500) NULL,
	[CD_EmployerId]					[nvarchar](500) NULL,
	[CD_ESFAToken]					[nvarchar](500) NULL,
	[CD_LegalEntityId]				[nvarchar](500) NULL,	
	[GA_ImportDate]					[datetime2](7) DEFAULT getdate()
) 
GO