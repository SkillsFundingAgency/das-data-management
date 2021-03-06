

CREATE TABLE [StgPmts].[EarningEventPeriod](
	[Id] [bigint] NOT NULL,
	[EarningEventId] [uniqueidentifier] NOT NULL,
	[PriceEpisodeIdentifier] [nvarchar](50) NULL,
	[TransactionType] [tinyint] NOT NULL,
	[DeliveryPeriod] [tinyint] NOT NULL,
	[Amount] [decimal](15, 5) NOT NULL,
	[SfaContributionPercentage] [decimal](15, 5) NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[CensusDate] [datetime2](7) NULL
) 
