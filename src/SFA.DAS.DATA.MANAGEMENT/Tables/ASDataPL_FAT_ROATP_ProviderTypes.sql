CREATE TABLE [ASData_PL].[FAT_ROATP_ProviderTypes]
(
	[Id]					bigint								NULL,
	[ProviderType]          NVARCHAR(100)                       NOT NULL,
	[Status]                NVARCHAR(20)						NOT NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
