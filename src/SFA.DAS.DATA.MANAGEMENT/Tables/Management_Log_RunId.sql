CREATE TABLE [Mgmt].[Log_RunId](
	[Run_Id] [int] IDENTITY(1,1) NOT NULL,
	[StartDateTime] [datetime2](7) NOT NULL,
	[EndDateTime] [datetime2](7) NULL,
	CONSTRAINT PK_LR_RunId PRIMARY KEY ([Run_Id])
) 
GO

