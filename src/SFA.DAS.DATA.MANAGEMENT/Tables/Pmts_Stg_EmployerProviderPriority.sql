/****** Object:  Table [Pmts].[Stg_EmployerProviderPriority]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_EmployerProviderPriority](
	[Id] [bigint] NOT NULL,
	[EmployerAccountId] [bigint] NOT NULL,
	[Ukprn] [bigint] NOT NULL,
	[Order] [int] NOT NULL
) ON [PRIMARY]
GO
