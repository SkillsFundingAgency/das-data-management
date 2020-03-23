/****** Object:  Table [Pmts].[Stg_SubmittedLearnerAim]    Script Date: 18/03/2020 16:02:00 ******/


CREATE TABLE [StgPmts].[SubmittedLearnerAim](
	[Id] [bigint] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[LearnerReferenceNumber] [nvarchar](12) NOT NULL,
	[LearningAimFrameworkCode] [int] NOT NULL,
	[LearningAimPathwayCode] [int] NOT NULL,
	[LearningAimProgrammeType] [int] NOT NULL,
	[LearningAimStandardCode] [int] NOT NULL,
	[LearningAimReference] [nvarchar](8) NOT NULL,
	[CollectionPeriod] [tinyint] NOT NULL,
	[AcademicYear] [smallint] NOT NULL,
	[IlrSubmissionDateTime] [datetime2](7) NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[LearnerUln] [bigint] NULL,
	[JobId] [bigint] NOT NULL,
	[ContractType] [tinyint] NOT NULL
) 