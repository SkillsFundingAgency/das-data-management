/****** Object:  Table [Pmts].[Stg_JobEvent]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_JobEvent](
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