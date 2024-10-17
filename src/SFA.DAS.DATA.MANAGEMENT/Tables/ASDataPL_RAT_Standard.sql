CREATE TABLE  [Asdata_pl].[RAT_Standard](
	[StandardReference] [varchar](6) PRIMARY KEY NOT NULL,
	[StandardTitle] [nvarchar](100) NOT NULL,
	[StandardLevel] [int] NOT NULL,
	[StandardSector] [nvarchar](100) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()	NULL)