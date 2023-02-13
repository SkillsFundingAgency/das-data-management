CREATE TABLE [ASData_PL].[Appfb_FeedbackTransaction](
	[Id] [bigint] NOT NULL,
	[ApprenticeFeedbackTargetId] [uniqueidentifier] NOT NULL,
	[TemplateId] [uniqueidentifier] NULL,
	[CreatedOn] [datetime] NOT NULL,
	[SendAfter] [datetime] NULL,
	[SendDate] [datetime] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate())