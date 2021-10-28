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
      ,[Asdm_UpdatedDateTime]
  FROM [ASData_PL].[Tpr_OrgDetails] TOD

