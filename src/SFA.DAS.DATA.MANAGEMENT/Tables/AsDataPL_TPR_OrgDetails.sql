CREATE TABLE [AsData_PL].[Tpr_OrgDetails]
(      
       [TPRUniqueId] bigint
      ,[OrganisationName] varchar(256)
	  ,[AORN] Varchar(13)
      ,[CompaniesHouseNumber] varchar(256)
      ,[EmpRef] varchar(100)
      ,[SchemeStartDate] date
      ,[SchemeEndDate] date
      ,[SchemeEndDateCodeDesc] tinyint
      ,[EmployeeCountDateTaken] date      
      ,[LiveEmployeeCount] int
      ,[RestartDate] date
      ,[TradeClass] varchar(256)
      ,[TradeClassDescription] varchar(100)
      ,[PostCode] varchar(10)
      ,[Asdm_UpdatedDateTime] datetime2 default getdate()
)
GO
CREATE CLUSTERED INDEX [CI_Tpr_UniqueId] ON [AsData_PL].[Tpr_OrgDetails]([TprUniqueId] ASC)
GO
CREATE NONCLUSTERED INDEX [CI_Tpr_PAYEREF] ON [AsData_PL].[Tpr_OrgDetails]([EMPREF] ASC)
GO
