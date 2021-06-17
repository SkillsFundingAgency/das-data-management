CREATE TABLE [ASData_PL].[GA_DataForReporting](
	[GDFR_Id]						[bigint] IDENTITY(1,1) NOT NULL
   ,[CD_EmployerId]                 [nvarchar](50)
   ,[ESFATOKEN]                     [bigint]
   ,[ClientId]                      [nvarchar](200)
   ,[VisitDate]	                    [date]
   ,[GA_ImportDate]					[datetime2](7) DEFAULT getdate()
   ,CONSTRAINT PK_GA_DataForReporting PRIMARY KEY CLUSTERED (GDFR_Id)
) 
GO
