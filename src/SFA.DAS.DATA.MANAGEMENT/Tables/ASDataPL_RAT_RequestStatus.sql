CREATE TABLE  [Asdata_pl].[RAT_RequestStatus](
	[Id] [int] PRIMARY KEY,
	[Description] [varchar](25) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()	NULL)