CREATE TABLE [ASData_PL].[Appfb_FeedbackTargetVariant_Staging](
	 [ApprenticeshipId] [bigint] NOT NULL
	,[Variant] VARCHAR(100) NOT NULL 
	,[AsDm_UpdatedDateTime] datetime2 default getdate()
	)