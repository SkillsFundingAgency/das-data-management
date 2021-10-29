CREATE VIEW [AsData_AI].[DAS_TPROrgDetails]
As
SELECT [TPRUniqueId]             AS A1
	  ,[AORN]                    AS A2
      ,[CompaniesHouseNumber]    AS A3
      ,[EmpRef]                  AS A4
      ,[PostCode]                AS A5
      ,[SchemeStartDate]         AS A6 
      ,[SchemeEndDate]           AS A7
      ,[SchemeEndDateCodeDesc]   AS A8
      ,[EmployeeCountDateTaken]  AS A9      
      ,[LiveEmployeeCount]       AS A10
      ,[RestartDate]             AS A11
      ,[TradeClass]              AS A12
      ,[TradeClassDescription]   AS A13 
      ,[Asdm_UpdatedDateTime]    AS A14
  FROM [ASData_PL].[Tpr_OrgDetails] TOD

