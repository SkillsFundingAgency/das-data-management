/****** Object:  Table [Pmts].[Stg_EarningEventPriceEpisode]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_EarningEventPriceEpisode](
	[Id] [bigint] NOT NULL,
	[EarningEventId] [uniqueidentifier] NOT NULL,
	[PriceEpisodeIdentifier] [nvarchar](50) NOT NULL,
	[SfaContributionPercentage] [decimal](15, 5) NOT NULL,
	[TotalNegotiatedPrice1] [decimal](15, 5) NOT NULL,
	[TotalNegotiatedPrice2] [decimal](15, 5) NULL,
	[TotalNegotiatedPrice3] [decimal](15, 5) NULL,
	[TotalNegotiatedPrice4] [decimal](15, 5) NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EffectiveTotalNegotiatedPriceStartDate] [datetime2](7) NULL,
	[PlannedEndDate] [datetime2](7) NOT NULL,
	[ActualEndDate] [datetime2](7) NULL,
	[NumberOfInstalments] [int] NOT NULL,
	[InstalmentAmount] [decimal](15, 5) NOT NULL,
	[CompletionAmount] [decimal](15, 5) NOT NULL,
	[Completed] [bit] NOT NULL,
	[EmployerContribution] [decimal](15, 5) NULL,
	[CompletionHoldBackExemptionCode] [int] NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[AgreedPrice] [decimal](15, 5) NULL,
	[CourseStartDate] [datetime2](7) NULL
) 
