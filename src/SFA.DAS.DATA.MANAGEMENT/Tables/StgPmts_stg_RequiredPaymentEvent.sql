CREATE TABLE [StgPmts].[stg_RequiredPaymentEvent](
	[Id] [bigint] NOT NULL,
	[EventId] [uniqueidentifier] NOT NULL,
	[EarningEventId] [uniqueidentifier] NOT NULL,
	[ClawbackSourcePaymentEventId] [uniqueidentifier] NULL,
	[PriceEpisodeIdentifier] [nvarchar](50) NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[ContractType] [tinyint] NOT NULL,
	[TransactionType] [tinyint] NOT NULL,
	[SfaContributionPercentage] [decimal](15, 5) NOT NULL,
	[Amount] [decimal](15, 5) NOT NULL,
	[CollectionPeriod] [tinyint] NOT NULL,
	[AcademicYear] [smallint] NOT NULL,
	[DeliveryPeriod] [tinyint] NOT NULL,
	[LearnerReferenceNumber] [nvarchar](50) NOT NULL,
	[LearnerUln] [bigint] NOT NULL,
	[LearningAimReference] [nvarchar](8) NOT NULL,
	[LearningAimProgrammeType] [int] NOT NULL,
	[LearningAimStandardCode] [int] NOT NULL,
	[LearningAimFrameworkCode] [int] NOT NULL,
	[LearningAimPathwayCode] [int] NOT NULL,
	[LearningAimFundingLineType] [nvarchar](100) NOT NULL,
	[AgreementId] [nvarchar](255) NULL,
	[IlrSubmissionDateTime] [datetime2](7) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[EventTime] [datetimeoffset](7) NOT NULL,
	[AccountId] [bigint] NULL,
	[TransferSenderAccountId] [bigint] NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[EarningsStartDate] [datetime] NOT NULL,
	[EarningsPlannedEndDate] [datetime] NULL,
	[EarningsActualEndDate] [datetime] NULL,
	[EarningsCompletionStatus] [tinyint] NOT NULL,
	[EarningsCompletionAmount] [decimal](15, 5) NULL,
	[EarningsInstalmentAmount] [decimal](15, 5) NULL,
	[EarningsNumberOfInstalments] [smallint] NOT NULL,
	[LearningStartDate] [datetime2](7) NULL,
	[ApprenticeshipId] [bigint] NULL,
	[ApprenticeshipPriceEpisodeId] [bigint] NULL,
	[ApprenticeshipEmployerType] [tinyint] NULL,
	[NonPaymentReason] [tinyint] NULL,
	[EventType] [nvarchar](4000) NULL,
	[DuplicateNumber] [int] NULL,
	[AgeAtStartOfLearning] [tinyint] NULL
) 