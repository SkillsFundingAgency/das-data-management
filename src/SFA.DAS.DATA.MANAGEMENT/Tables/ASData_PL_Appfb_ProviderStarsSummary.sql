CREATE TABLE [Asdata_PL].[Appfb_ProviderStarsSummary]
(
	[Ukprn] [bigint] NOT NULL,
	[ReviewCount] [int] NOT NULL,
	[Stars] [int] NOT NULL,
	[TimePeriod] [nvarchar](50) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()	NULL
PRIMARY KEY([Ukprn],[TimePeriod] ))