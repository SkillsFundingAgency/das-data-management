CREATE TABLE [AsData_PL].[Comt_StandardFunding]
(
	[Id]					[int]		NOT NULL,
	[EffectiveFrom]			[datetime]	NULL,
	[EffectiveTo]			[datetime]	NULL,
	[FundingCap]			[int] NOT	NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)
