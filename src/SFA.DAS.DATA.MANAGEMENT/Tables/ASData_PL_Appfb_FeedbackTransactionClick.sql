CREATE TABLE [ASData_PL].[Appfb_FeedbackTransactionClick](
	[Id] [uniqueidentifier] NOT NULL,
	[FeedbackTransactionId] [bigint] NOT NULL,
	[ApprenticeFeedbackTargetId] [uniqueidentifier] NOT NULL,
	[LinkName] [varchar](200) NULL,
	[LinkUrl] [nvarchar](max) NULL,
	[ClickedOn] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate())