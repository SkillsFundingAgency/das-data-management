CREATE TABLE [ASData_PL].[FAT2_ApprenticeshipFunding](
	[Id]					[uniqueidentifier]	PRIMARY KEY NOT NULL,
	[StandardUId]			[varchar](20)					NOT NULL,
	[EffectiveFrom]			[datetime]						NOT NULL,
	[EffectiveTo]			[datetime]						NULL,
	[MaxEmployerLevyCap]	[int]							NOT NULL,
	[Duration]				[int]							NOT NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7) DEFAULT (getdate())	
)