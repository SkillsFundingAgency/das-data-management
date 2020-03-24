

CREATE TABLE [StgPmts].[ApprenticeshipPriceEpisode](
	[Id] [bigint] NOT NULL,
	[ApprenticeshipId] [bigint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[Cost] [decimal](15, 5) NOT NULL,
	[Removed] [bit] NOT NULL,
	[CreationDate] [datetimeoffset](7) NOT NULL
) 

