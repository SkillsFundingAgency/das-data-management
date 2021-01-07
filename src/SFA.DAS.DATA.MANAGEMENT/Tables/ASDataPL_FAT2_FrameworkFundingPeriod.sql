CREATE TABLE [ASData_PL].[FAT2_FrameworkFundingPeriod](
	[Id]							[int]			NOT NULL,
	[FrameworkId]					[varchar](15)	NOT NULL,
	[EffectiveFrom]					[datetime]		NOT NULL,
	[EffectiveTo]					[datetime]		NULL,
	[FundingCap]					[int]			NOT NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)	DEFAULT (getdate())
) 
