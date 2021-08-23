CREATE TABLE [ASData_PL].[LTM_PledgeSector]
(
	[PledgeSectorId] [int] NOT NULL,
	[SectorId] [tinyint] NOT NULL,
	[PledgeId] [int] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
