/****** Object:  Table [Pmts].[Stg_DataMatchReport]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_DataMatchReport](
	[CollectionType] [varchar](6) NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[LearnerReferenceNumber] [nvarchar](50) NOT NULL,
	[LearnerUln] [bigint] NOT NULL,
	[DataLockFailureId] [tinyint] NOT NULL,
	[LearningAimSequenceNumber] [bigint] NULL,
	[CollectionPeriod] [tinyint] NOT NULL,
	[AcademicYear] [smallint] NOT NULL,
	[IlrSubmissionDateTime] [datetime2](7) NOT NULL,
	[DeliveryPeriod] [tinyint] NOT NULL,
	[DataLockSourceId] [tinyint] NOT NULL,
	[IsPayable] [bit] NOT NULL,
	[LearningAimReference] [nvarchar](8) NOT NULL,
	[JobId] [bigint] NOT NULL
) 