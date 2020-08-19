-- ApprenticeshipStdRoute 
Go
CREATE TABLE [AsData_PL].[ApprenticeshipStdRoute](
       [StdRouteID]  Int  IDENTITY(1,1) PRIMARY KEY,
       [Reference] [varchar](20),
       [LARSCode] [varchar](20),
       [Route] [varchar](200) NULL,
       AppendDateTime DateTime Default getdate()
) ON [PRIMARY]
GO
