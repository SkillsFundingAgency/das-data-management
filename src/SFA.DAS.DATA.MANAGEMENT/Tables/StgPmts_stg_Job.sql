CREATE TABLE [StgPmts].[stg_Job](
	[JobId] [bigint] NOT NULL,
	[JobType] [tinyint] NOT NULL,
	[StartTime] [datetimeoffset](7) NOT NULL,
	[EndTime] [datetimeoffset](7) NULL,
	[Status] [tinyint] NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[DCJobId] [bigint] NULL,
	[Ukprn] [bigint] NULL,
	[IlrSubmissionTime] [datetime] NULL,
	[LearnerCount] [int] NULL,
	[AcademicYear] [smallint] NOT NULL,
	[CollectionPeriod] [tinyint] NOT NULL,
	[DataLocksCompletionTime] [datetimeoffset](7) NULL,
	[DCJobSucceeded] [bit] NULL,
	[DCJobEndTime] [datetimeoffset](7) NULL
) 