﻿CREATE TABLE [ASData_PL].[Provider]
(
	[Id]					[bigint]							NOT NULL,
	[UkPrn]					[int]								NOT NULL,
	[Name]					[varchar](1000)						NOT NULL,
	[TradingName]			[varchar](1000)						NULL,
	[EmployerSatisfaction]  [decimal](18,0)						NULL,
	[LearnerSatisfaction]   [decimal](18,0)						NULL,
	[Email]					[varchar](260)						NULL,
	[Created]				[datetime2](7)						NULL,
	[Updated]				[datetime2](7)						NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate()),
	PRIMARY KEY CLUSTERED ([UkPrn] ASC) ON [PRIMARY]
)