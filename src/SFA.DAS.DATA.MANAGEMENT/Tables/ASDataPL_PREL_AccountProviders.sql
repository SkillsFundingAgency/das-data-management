CREATE TABLE [ASData_PL].[PREL_AccountProviders]
(
	[Id] [bigint] NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[ProviderUkprn] [bigint] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[AsDm_UpdatedDateTime]			[Datetime2](7)		default getdate()
)
