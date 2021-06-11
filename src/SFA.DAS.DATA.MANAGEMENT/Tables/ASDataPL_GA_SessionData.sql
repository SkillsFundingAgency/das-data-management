﻿CREATE TABLE [ASData_PL].[GA_SessionData](
	[GASD_Id]						[bigint] IDENTITY(1,1) NOT NULL,
	[FullVisitorId]					[nvarchar](500) NULL,
	[ClientId]						[nvarchar](200) NULL,
	[VisitId]						[nvarchar](500) NULL,
	[VisitNumber]					[nvarchar](500) NULL,
	[VisitStartDateTime]			[nvarchar](500) NULL,
	[VisitDate]						date NULL,
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
	[Hits_Page_Hostname]			[NVarchar](500) NULL,
	[Hits_Page_PageTitle]			[NVarchar](500) NULL,
	[TrafficSource_Campaign]		[NVarchar](500) NULL,
	[Hits_Type]						[NVarchar](50) NULL,
	[CD_IsCookieLess]				[SmallInt] NULL,
	[ESFATokenFlag]					[SmallInt] NULL,
	[SignIn]						[TinyInt],
	[SignedAgreement]				[TinyInt],
	[SignUp]						[TinyInt],
	[ReservedFunding]				[TinyInt],
	[Commitment]					[TinyInt],
	[CreatedAccount]				[TinyInt],
	[GovernmentGateway]				[TinyInt],
	[AORN]							[TinyInt],
	[ApplyNowIncentives]			[TinyInt],
	[IncentivesApplyNow]			[TinyInt],
	[GA_ImportDate]					[datetime2](7) DEFAULT getdate(),
	[ClientId_Calc]            as   convert(decimal(38,0),REPLACE(ClientId,'.','')) 
) 
GO

CREATE CLUSTERED INDEX IX_GASessionData_GASD_ID ON AsData_PL.GA_SessionData (VisitDate,ClientId_Calc)
  WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
  ON PS_DatePartition(VisitDate)
GO

CREATE NONCLUSTERED INDEX NIX_GASessionData_ClientIdToken ON AsData_PL.GA_SessionData(Clientid,ESFAToken,[EventLabel_ESFAToken],[CD_ESFAToken]) INCLUDE (cd_employerId)
  WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
GO