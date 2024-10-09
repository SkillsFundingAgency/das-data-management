CREATE TABLE [Asdata_pl].[RAT_Region]
(
	[Id] INT IDENTITY(1,1) PRIMARY KEY,
	[SubregionName] [varchar](250) NULL,
	[RegionName] [varchar](25) NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL,
	[ValidFrom] [datetime2](0) ,
	[ValidTo] [datetime2](0) ,
	AsDm_UpdatedDateTime datetime2 default getdate()	NULL
)