CREATE TABLE [ASData_PL].[LTM_PledgeLevel]
(
	[PledgeLevelId] [int]		NOT NULL,
	[LevelId] [tinyint]			NOT NULL,
	[PledgeId] [int]			NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
