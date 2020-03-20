/****** Object:  Table [Pmts].[Stg_DataLockEventNonPayablePeriodFailures]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [StgPmts].[DataLockEventNonPayablePeriodFailures](
	[Id] [bigint] NOT NULL,
	[DataLockEventNonPayablePeriodId] [uniqueidentifier] NOT NULL,
	[DataLockFailureId] [tinyint] NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL,
	[ApprenticeshipId] [bigint] NULL
) 