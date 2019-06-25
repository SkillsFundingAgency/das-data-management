
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
PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Mgmt].[Log_Execution_Results]  WITH CHECK ADD FOREIGN KEY([ErrorId])
REFERENCES [Mgmt].[Log_Error_Details] ([ErrorId])
GO

ALTER TABLE [Mgmt].[Log_Execution_Results]  WITH CHECK ADD FOREIGN KEY([RunId])
REFERENCES [Mgmt].[Log_RunId] ([Run_Id])
GO



