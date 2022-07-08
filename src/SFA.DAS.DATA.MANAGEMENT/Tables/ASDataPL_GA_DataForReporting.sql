CREATE TABLE [ASData_PL].[GA_DataForReporting](
	[GDFR_Id]						[bigint] IDENTITY(1,1) NOT NULL
   ,[CD_EmployerId]                 [nvarchar](50)
   ,[ESFATOKEN]                     [bigint]
   ,[ClientId]                      [nvarchar](200)
   ,[VisitDate]	                    [date]
   ,[GA_ImportDate]					[datetime2](7) DEFAULT getdate()
   ,[TrafficSource_Campaign]        [nvarchar](500)
   ,[Hits_Page_PagePath]            [nvarchar](max)
   ,[CD_Search_Terms]               [nvarchar](2000)
   ,[CD_UserID]                     [nvarchar](500)
   ,[CD_VacancyID]                  [nvarchar](500)
   ,[CD_ApprenticeshipID]           [NVarchar](500)
   ,[TrafficSource_Source]          [NVarchar](max)
   ,CONSTRAINT PK_GA_DataForReporting PRIMARY KEY CLUSTERED (GDFR_Id)
) 
GO
