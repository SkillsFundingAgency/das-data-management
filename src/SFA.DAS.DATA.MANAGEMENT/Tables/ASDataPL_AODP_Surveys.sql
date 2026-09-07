CREATE TABLE [ASData_PL].[AODP_Surveys]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Page] [nvarchar](500) NOT NULL,
	[SatisfactionScore] [int] NOT NULL,
	[Comments] [nvarchar](1200) NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
);
