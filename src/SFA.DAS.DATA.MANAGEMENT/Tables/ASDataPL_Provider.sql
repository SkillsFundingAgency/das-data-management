CREATE TABLE [ASData_PL].[Provider]
(
	[Id]					bigint	IDENTITY(1,1)	NOT NULL,
	[UkPrn]					int						NOT NULL,
	[Name]					varchar					NOT NULL,
	[TradingName]			varchar					NULL,
	[EmployerSatisfaction]  decimal					NULL,
	[LearnerSatisfaction]   decimal					NULL,
	[Email]					varchar					NULL,
	[AsDm_UpdatedDateTime] [datetime2](7)			DEFAULT (getdate()),
	PRIMARY KEY CLUSTERED ([UkPrn] ASC) ON [PRIMARY]
)