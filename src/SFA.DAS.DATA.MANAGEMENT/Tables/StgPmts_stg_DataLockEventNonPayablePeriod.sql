CREATE TABLE [StgPmts].[stg_DataLockEventNonPayablePeriod](
	[Id] [bigint] NOT NULL,
	[DataLockEventId] [uniqueidentifier] NOT NULL,
	[DataLockEventNonPayablePeriodId] [uniqueidentifier] NOT NULL,
	[PriceEpisodeIdentifier] [nvarchar](50) NULL,
	[TransactionType] [tinyint] NOT NULL,
	[DeliveryPeriod] [tinyint] NOT NULL,
	[Amount] [decimal](15, 5) NOT NULL,
	[SfaContributionPercentage] [decimal](15, 5) NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[LearningStartDate] [datetime2](7) NULL,
	[AcademicYear] [smallint] NULL,
    [CollectionPeriod] [tinyint] NULL
) 