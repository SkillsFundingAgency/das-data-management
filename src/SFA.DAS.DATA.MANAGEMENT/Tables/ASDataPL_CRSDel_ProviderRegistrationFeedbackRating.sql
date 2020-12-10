CREATE TABLE [ASData_PL].[CRSDel_ProviderRegistrationFeedbackRating]
(
		[UkPrn]						int			NOT NULL,
		[FeedbackName]				varchar     NOT NULL,
		[FeedbackCount]				int			NULL,
		[AsDm_UpdatedDateTime]		[datetime2](7) DEFAULT (getdate())	
)
