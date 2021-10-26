CREATE VIEW [AsData_AI].[DAS_TPROrgDetails]
As
SELECT [TPRUniqueId] 
	  ,[AORN] 
      ,[CompaniesHouseNumber] 
      ,[EmpRef] 
      ,[PostCode]
      ,[SchemeStartDate] 
      ,[SchemeEndDate] 
      ,[SchemeEndDateCodeDesc] 
      ,[EmployeeCountDateTaken]       
      ,[LiveEmployeeCount] 
      ,[RestartDate] 
      ,[TradeClass] 
      ,[TradeClassDescription] 
  FROM [ASData_PL].[Tpr_OrgDetails] TOD

