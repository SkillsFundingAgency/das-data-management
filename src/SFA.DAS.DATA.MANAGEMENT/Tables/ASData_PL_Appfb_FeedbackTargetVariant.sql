CREATE TABLE [ASData_PL].[Appfb_FeedbackTargetVariant](
	 [ApprenticeshipId] [bigint] NOT NULL
	,[Variant] VARCHAR(100) NOT NULL 
	,[CreatedOn] [datetime] NOT NULL
	,[AsDm_UpdatedDateTime] datetime2 default getdate())