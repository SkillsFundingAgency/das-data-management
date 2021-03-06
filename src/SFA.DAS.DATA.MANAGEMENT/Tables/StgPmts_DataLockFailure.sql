

CREATE TABLE [StgPmts].[DataLockFailure](
	[Id] [bigint] NOT NULL,
	[DataLockEventId] [uniqueidentifier] NULL,
	[EarningEventId] [uniqueidentifier] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[LearnerUln] [bigint] NOT NULL,
	[LearnerReferenceNumber] [nvarchar](50) NOT NULL,
	[LearningAimReference] [nvarchar](8) NOT NULL,
	[LearningAimProgrammeType] [int] NOT NULL,
	[LearningAimStandardCode] [int] NOT NULL,
	[LearningAimFrameworkCode] [int] NOT NULL,
	[LearningAimPathwayCode] [int] NOT NULL,
	[AcademicYear] [smallint] NOT NULL,
	[TransactionType] [tinyint] NOT NULL,
	[DeliveryPeriod] [tinyint] NOT NULL,
	[CollectionPeriod] [tinyint] NOT NULL,
	[EarningPeriod] [nvarchar](max) NOT NULL,
	[Amount] [decimal](15, 5) NOT NULL,
	[CreationDate] [datetime2](7) NOT NULL
) 
