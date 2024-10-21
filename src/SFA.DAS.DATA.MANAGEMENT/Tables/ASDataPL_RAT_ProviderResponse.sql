CREATE TABLE [Asdata_pl].[RAT_ProviderResponse](
	[Id] [uniqueidentifier] PRIMARY KEY,
	[RespondedAt] [datetime2](7) NOT NULL,
	[RespondedBy] [uniqueidentifier] NOT NULL,
	[ValidFrom] [datetime2](0),
	[ValidTo] [datetime2](0) ,
	AsDm_UpdatedDateTime datetime2 default getdate()	NULL
)