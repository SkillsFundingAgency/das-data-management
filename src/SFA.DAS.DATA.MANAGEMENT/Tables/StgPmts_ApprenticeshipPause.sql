/****** Object:  Table [Pmts].[Stg_ApprenticeshipPause]    Script Date: 18/03/2020 16:01:59 ******/
CREATE TABLE [StgPmts].[ApprenticeshipPause](
	[Id] [bigint] NOT NULL,
	[ApprenticeshipId] [bigint] NOT NULL,
	[PauseDate] [date] NOT NULL,
	[ResumeDate] [date] NULL
) 

