
CREATE TABLE [Mgmt].[Log_Execution_Results](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NOT NULL,
	[ErrorId] [int] NULL,
	[StepNo] [varchar](100) NULL,
	[StoredProcedureName] [varchar](100) NOT NULL,
	[Execution_Status] [bit] NOT NULL,
	[Execution_Status_Desc]  AS (case when [Execution_Status]=(1) then 'Success' else 'Fail' end),
	[StartDateTime] [datetime2](7) NULL,
	[EndDateTime] [datetime2](7) NULL,
    CONSTRAINT PK_LER_LogId PRIMARY KEY(LogId),
    CONSTRAINT FK_LER_ErrorId FOREIGN KEY([ErrorId]) REFERENCES [Mgmt].[Log_Error_Details] ([ErrorId]),
	CONSTRAINT FK_LER_RunId FOREIGN KEY([RunId]) REFERENCES [Mgmt].[Log_RunId] ([Run_Id])
	)
GO



