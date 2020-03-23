/****** Object:  Table [Pmts].[Stg_JobProviderEarnings]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_JobProviderEarnings](
	[JobId] [bigint] NOT NULL,
	[DCJobId] [bigint] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[IlrSubmissionTime] [datetime2](7) NOT NULL,
	[CollectionYear] [varchar](4) NOT NULL,
	[CollectionPeriod] [tinyint] NOT NULL
) 