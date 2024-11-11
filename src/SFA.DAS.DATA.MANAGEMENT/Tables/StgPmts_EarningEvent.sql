

CREATE TABLE [StgPmts].[EarningEvent](
	[Id] [bigint] NOT NULL,
	[EventId] [uniqueidentifier] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[ContractType] [tinyint] NOT NULL,
	[CollectionPeriod] [tinyint] NOT NULL,
	[AcademicYear] [smallint] NOT NULL,
	[LearnerReferenceNumber] [nvarchar](50) NOT NULL,
	[LearnerUln] [bigint] NOT NULL,
	[LearningAimReference] [nvarchar](8) NOT NULL,
	[LearningAimProgrammeType] [int] NOT NULL,
	[LearningAimStandardCode] [int] NOT NULL,
	[LearningAimFrameworkCode] [int] NOT NULL,
	[LearningAimPathwayCode] [int] NOT NULL,
	[LearningAimFundingLineType] [nvarchar](100) NULL,
	[LearningStartDate] [datetime2](7) NULL,
	[AgreementId] [nvarchar](255) NULL,
	[IlrSubmissionDateTime] [datetime2](7) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[EventTime] [datetimeoffset](7) NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[LearningAimSequenceNumber] [bigint] NULL,
	[SfaContributionPercentage] [decimal](15, 5) NULL,
	[IlrFileName] [nvarchar](400) NULL,
	[EventType] [nvarchar](4000) NULL
) 