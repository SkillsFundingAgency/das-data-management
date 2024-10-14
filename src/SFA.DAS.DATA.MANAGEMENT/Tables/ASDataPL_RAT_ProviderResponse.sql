CREATE TABLE [Asdata_pl].[RAT_ProviderResponse](
	[Id] [uniqueidentifier] PRIMARY KEY,
	[RespondedAt] [datetime2](7) NOT NULL,
	[RespondedBy] [uniqueidentifier] NOT NULL,
	[ValidFrom] [datetime2](0),
	[ValidTo] [datetime2](0) ,
	[ContactName] [nvarchar](256) NOT NULL,
	[Email] [varchar](256) NOT NULL,
	[Website] [varchar](256) NULL,
	[PhoneNumber] [varchar](25) NULL,
	AsDm_UpdatedDateTime datetime2 default getdate()	NULL
)