
CREATE TABLE [Mgmt].[Log_RunId](
	[Run_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[StartDateTime] [datetime2](7) NOT NULL,
	[EndDateTime] [datetime2](7) NULL,
	CONSTRAINT [PK_LogRunId_RunId] PRIMARY KEY CLUSTERED ([Run_Id] ASC)
	)