/****** Object:  Table [Pmts].[Stg_ProviderAdjustmentPayments]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_ProviderAdjustmentPayments](
	[Ukprn] [bigint] NOT NULL,
	[SubmissionId] [uniqueidentifier] NOT NULL,
	[SubmissionCollectionPeriod] [int] NOT NULL,
	[SubmissionAcademicYear] [int] NOT NULL,
	[PaymentType] [int] NOT NULL,
	[PaymentTypeName] [nvarchar](250) NOT NULL,
	[Amount] [decimal](15, 5) NOT NULL,
	[CollectionPeriodName] [varchar](8) NOT NULL,
	[CollectionPeriodMonth] [int] NOT NULL,
	[CollectionPeriodYear] [int] NOT NULL
) 