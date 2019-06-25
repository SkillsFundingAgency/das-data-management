CREATE TABLE [Mgmt].[Log_Error_Details](
	[ErrorId] [int] IDENTITY(1,1) NOT NULL,
	[Run_Id] [int] NOT NULL,
	[UserName] [varchar](100) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](max) NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ErrorDateTime] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[ErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Mgmt].[Log_Error_Details]  WITH CHECK ADD FOREIGN KEY([Run_Id])
REFERENCES [Mgmt].[Log_RunId] ([Run_Id])
GO

