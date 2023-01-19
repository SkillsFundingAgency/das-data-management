CREATE TABLE [ASData_PL].[Appfb_ExitSurveyAttribute](
	[ApprenticeExitSurveyId] [uniqueidentifier] NOT NULL,
	[AttributeId] [int] NOT NULL,
	[AttributeValue] [int] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate())