/****** Object:  Table [Pmts].[Stg_DataLockEvent]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_DataLockEvent](
	[Id] [bigint] NOT NULL,
	[EventId] [uniqueidentifier] NOT NULL,
	[EarningEventId] [uniqueidentifier] NOT NULL,
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
	[IsPayable] [bit] NOT NULL,
	[DataLockSourceId] [tinyint] NOT NULL,
	[JobId] [bigint] NOT NULL,
	[EventTime] [datetimeoffset](7) NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL
) 