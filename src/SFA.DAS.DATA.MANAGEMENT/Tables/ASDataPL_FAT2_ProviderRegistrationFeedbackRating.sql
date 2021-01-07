CREATE TABLE [ASData_PL].[FAT2_ProviderRegistrationFeedbackRating]
(
		[UkPrn]						int					NOT NULL,
		[FeedbackName]				varchar(100)		NOT NULL,
		[FeedbackCount]				int					NULL,
		[AsDm_UpdatedDateTime]		[datetime2](7) DEFAULT (getdate())	
)
