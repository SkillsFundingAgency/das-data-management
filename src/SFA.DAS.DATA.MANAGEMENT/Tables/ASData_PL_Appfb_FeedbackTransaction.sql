CREATE TABLE [ASData_PL].[Appfb_FeedbackTransaction](
	[Id] [bigint] NOT NULL,
	[ApprenticeFeedbackTargetId] [uniqueidentifier] NOT NULL,
	[TemplateId] [uniqueidentifier] NULL,
	[CreatedOn] [datetime] NOT NULL,
	[SendAfter] [datetime] NULL,
	[SentDate] [datetime] NULL,
	[TemplateName] [varchar](100) NULL,
	[IsSuppressed] BIT NULL,
	[Variant] VARCHAR(100) NULL , 
	[AsDm_UpdatedDateTime] datetime2 default getdate())