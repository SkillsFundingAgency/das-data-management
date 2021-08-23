CREATE TABLE [dbo].[ASDataPL_LTM_PledgeLocation]
(
	[Id] [int]					NOT NULL,
	[PledgeId] [int]			NOT NULL,
	[Name] [varchar](max)		NOT NULL,
	[Latitude] [float]			NOT NULL,
	[Longitude] [float]			NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
