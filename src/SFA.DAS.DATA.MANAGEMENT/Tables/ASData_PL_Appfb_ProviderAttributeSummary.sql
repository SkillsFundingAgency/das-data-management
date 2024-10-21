CREATE TABLE [AsData_PL].[Appfb_ProviderAttributeSummary]
(
	[Ukprn] [bigint] NOT NULL,
	[AttributeId] [int] NOT NULL,
	[Agree] [int] NOT NULL,
	[Disagree] [int] NOT NULL,
	[UpdatedOn] [datetime2](7) NULL,
	[TimePeriod] [nvarchar](50) NOT NULL,
	AsDm_UpdatedDateTime datetime2 default getdate()	NULL
PRIMARY KEY
(	[Ukprn],[AttributeId],[TimePeriod])
)