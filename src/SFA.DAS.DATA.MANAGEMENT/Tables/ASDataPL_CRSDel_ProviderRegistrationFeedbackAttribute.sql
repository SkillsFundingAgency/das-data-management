CREATE TABLE [ASData_PL].[CRSDel_ProviderRegistrationFeedbackAttribute]
(
		[UkPrn]				int			NOT NULL,
		[AttributeName]     varchar		NOT NULL,
		[Weakness]			int			NULL,
		[Strength]			int			NULL,
		[AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())		
)

