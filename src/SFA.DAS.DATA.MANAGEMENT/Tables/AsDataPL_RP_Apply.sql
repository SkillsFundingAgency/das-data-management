CREATE TABLE [AsData_PL].[RP_Apply]
(
	ID UniqueIdentifier not null
   ,ApplicationId UniqueIdentifier  not null
   ,OrganisationId uniqueIdentifier not null
   ,UKPRN Int
   ,ReferenceNumber varchar(20)
   ,OrganisationName nvarchar(400)
   ,TradingName nvarchar(400)
   ,ApplicationSubmittedOn DateTime2
   ,ApplicationSubmittedBy uniqueIdentifier
   ,ProviderRoute Int
   ,ProviderRouteName nvarchar(400)
   ,ApplicationStatus nvarchar(20)
   ,OutcomeDateTime datetime2(7)
   ,GatewayReviewStatus nvarchar(50)
   ,AssessorReviewStatus nvarchar(20)
   ,ModerationStatus nvarchar(20)
   ,ModeratorClarificationRequestedOn datetime2
   ,Assessor1Name nvarchar(256)
   ,Assessor2Name nvarchar(256)
   ,FinancialReviewStatus nvarchar(20)
   ,FinancialClarificationRequestedBy nvarchar(256)
   ,FinancialClarificationRequestedOn datetime2(7)
   ,FinancialReviewGradedBy nvarchar(256)
   ,CreatedAt datetime2(7)
   ,CreatedBy nvarchar(256)
   ,UpdatedAt datetime2(7)
   ,UpdatedBy nvarchar(256)
   ,DeletedAt datetime2(7)
   ,DeletedBy nvarchar(256)
)
