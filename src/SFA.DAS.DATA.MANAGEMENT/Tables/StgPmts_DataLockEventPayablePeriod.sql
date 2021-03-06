
CREATE TABLE [StgPmts].[DataLockEventPayablePeriod](
	[Id] [bigint] NOT NULL,
	[DataLockEventId] [uniqueidentifier] NOT NULL,
	[PriceEpisodeIdentifier] [nvarchar](50) NULL,
	[TransactionType] [tinyint] NOT NULL,
	[DeliveryPeriod] [tinyint] NOT NULL,
	[Amount] [decimal](15, 5) NOT NULL,
	[SfaContributionPercentage] [decimal](15, 5) NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[LearningStartDate] [datetime2](7) NULL,
	[ApprenticeshipId] [bigint] NULL,
	[ApprenticeshipPriceEpisodeId] [bigint] NULL,
	[ApprenticeshipEmployerType] [tinyint] NULL
) 