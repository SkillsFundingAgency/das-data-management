

CREATE TABLE [StgPmts].[JobEvent](
	[JobEventId] [bigint] NOT NULL,
	[JobId] [bigint] NOT NULL,
	[EventId] [uniqueidentifier] NOT NULL,
	[ParentEventId] [uniqueidentifier] NULL,
	[Status] [tinyint] NOT NULL,
	[StartTime] [datetimeoffset](7) NULL,
	[EndTime] [datetimeoffset](7) NULL,
	[MessageName] [nvarchar](250) NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL
) 