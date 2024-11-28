CREATE TABLE [AsData_PL].[PFBE_ProviderAttributeSummary]
(
	[Ukprn] [bigint] NOT NULL,
	[AttributeId] [int] NOT NULL,
	[Strength] [int] NOT NULL,
	[Weakness] [int] NOT NULL,
	[TimePeriod] [nvarchar](50) NOT NULL,
	[UpdatedOn] [datetime2](7) NULL,
	AsDm_UpdatedDateTime datetime2 default getdate()	NULL
PRIMARY KEY
(	[Ukprn],[AttributeId],[TimePeriod])
)