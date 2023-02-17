CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderAddress]
(
	[Id]					bigint					NOT NULL,
	[ProviderId]			int						NOT NULL,
	[Postcode]              varchar(25)     NULL,
    [Latitude]              float			NULL,
    [Longitude]             float			NULL,
    [AddressUpdateDate]     [datetime2](7)	NULL,
    [CoordinatesUpdateDate]      [datetime2](7)	NULL,
    [AsDm_UpdatedDateTime]			[datetime2](7)			DEFAULT (getdate())
)
