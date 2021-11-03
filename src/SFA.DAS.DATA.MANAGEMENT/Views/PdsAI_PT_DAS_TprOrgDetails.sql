CREATE VIEW [Pds_AI].[PT_D]
As
SELECT [TPRUniqueId]                 AS D1
	  ,[AORN]                        AS D2
      ,[CompaniesHouseNumber]        AS D3
      ,[EmpRef]                  AS D4
      ,[PostCode]                    AS D5
      ,[SchemeStartDate]             AS D6 
      ,[SchemeEndDate]               AS D7
      ,COALESCE(sedc.rn,-1)          AS D8
      ,[EmployeeCountDateTaken]      AS D9      
      ,[LiveEmployeeCount]           AS D10
      ,[RestartDate]                 AS D11
      ,TOD.TradeClass                AS D12
      ,TOD.[Asdm_UpdatedDateTime]    AS D14
      ,COALESCE(AH.AccountId,-1)     AS D15
  FROM [ASData_PL].[Tpr_OrgDetails] TOD
  left
  join (SELECT  SchemeEndDateCodeDesc,rank() over (order by SchemeEndDateCodeDesc desc) rn
          FROM (select distinct SchemeEndDateCodeDesc from AsData_PL.TPR_OrgDetails) a) sedc
    on sedc.SchemeEndDateCodeDesc=tod.SchemeEndDateCodeDesc
  left
  join [ASData_PL].[Acc_AccountHistory] AH
    ON AH.PayeRef=TOD.EmpRef

