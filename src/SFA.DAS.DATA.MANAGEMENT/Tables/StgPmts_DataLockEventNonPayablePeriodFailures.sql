

CREATE TABLE [StgPmts].[DataLockEventNonPayablePeriodFailures](
	[Id] [bigint] NOT NULL,
	[DataLockEventNonPayablePeriodId] [uniqueidentifier] NOT NULL,
	[DataLockFailureId] [tinyint] NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[ApprenticeshipId] [bigint] NULL,
	[AcademicYear] [smallint] NULL,
    [CollectionPeriod] [tinyint] NULL
) 