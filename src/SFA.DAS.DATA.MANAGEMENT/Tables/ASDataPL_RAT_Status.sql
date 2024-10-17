CREATE TABLE  [Asdata_pl].[RAT_Status](
	[Id] [int] PRIMARY KEY NOT NULL,
	[Description] [varchar](25) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()	NULL)