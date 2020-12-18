CREATE TABLE [ASData_PL].[FAT2_ProviderRegistrationFeedbackAttribute]
(
		[UkPrn]				int					NOT NULL,
		[AttributeName]     varchar(100)		NOT NULL,
		[Weakness]			int					NULL,
		[Strength]			int					NULL,
		[AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())		
)

