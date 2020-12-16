CREATE TABLE [ASData_PL].[CRS_ApprenticeshipFunding](
	[Id]					[uniqueidentifier]	NOT NULL,
	[StandardId]			[int]				NOT NULL,
	[EffectiveFrom]			[datetime]			NOT NULL,
	[EffectiveTo]			[datetime]			NULL,
	[MaxEmployerLevyCap]	[int]				NOT NULL,
	[Duration]				[int]				NOT NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7) DEFAULT (getdate())	
)