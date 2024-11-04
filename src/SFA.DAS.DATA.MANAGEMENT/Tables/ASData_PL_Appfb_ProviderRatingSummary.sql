CREATE TABLE [Asdata_PL].[Appfb_ProviderRatingSummary](
	[Ukprn] [bigint] NOT NULL,
	[Rating] [nvarchar](20) NOT NULL,
	[RatingCount] [int] NOT NULL,
	[UpdatedOn] [datetime2](7) NULL,
	[TimePeriod] [nvarchar](50) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()	NULL
PRIMARY KEY ([Ukprn] ,[Rating] ,[TimePeriod] ))