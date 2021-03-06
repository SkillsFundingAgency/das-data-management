﻿CREATE TABLE [AsData_PL].[RP_Apply]
(
	ID									UniqueIdentifier			not null
   ,ApplicationId						UniqueIdentifier			not null
   ,OrganisationId						uniqueIdentifier			not null
   ,UKPRN								Int
   ,ReferenceNumber						varchar(20)
   ,OrganisationName					nvarchar(400)
   ,TradingName							nvarchar(400)
   ,ApplicationSubmittedOn				DateTime2
   ,ApplicationSubmittedBy				uniqueIdentifier
   ,ProviderRoute						Int
   ,ProviderRouteName					nvarchar(400)
   ,ApplicationStatus					nvarchar(20)
   ,OutcomeDateTime						datetime2(7)
   ,GatewayReviewStatus					nvarchar(50)
   ,AssessorReviewStatus				nvarchar(20)
   ,ModerationStatus					nvarchar(20)
   ,ApplicationDeterminedDate			datetime2(7) 
   ,ModeratorClarificationRequestedOn	datetime2
   ,Assessor1Name						nvarchar(256)
   ,Assessor1ReviewStatus				nvarchar(20)
   ,Assessor2Name						nvarchar(256)   	
   ,Assessor2ReviewStatus				nvarchar(20) 
   ,FinancialReviewStatus				nvarchar(20)
   ,FinancialGrade						nvarchar(500) 
   ,FinancialClarificationRequestedBy	nvarchar(256)
   ,FinancialClarificationRequestedOn	datetime2(7)   
   ,FinancialReviewGradedBy				nvarchar(256)
   ,GatewayUserName						nvarchar(256)
   ,CreatedAt							datetime2(7)
   ,CreatedBy							nvarchar(256)
   ,UpdatedAt							datetime2(7)
   ,DeletedAt							datetime2(7)
   ,Comments							nvarchar(max)
   ,ExternalComments					nvarchar(max) 
   ,AsDm_UpdatedDateTime				DateTime2 default(getdate())
)