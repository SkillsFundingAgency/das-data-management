CREATE VIEW [ASData_PL].[EmployerDim]
As
 SELECT EmployerAccountId,EmployerAccountName,EmployerAccountHashedId,EmployerType,EmployerSector AS EmployerSectorEstimate
		, CASE -- DFE fix
          WHEN EmployerAccountId IN(2) then 'E) 5000+ (Macro)' 
          ELSE EmployeeSize1 END as EmployeeSize1
		, CASE
          WHEN EmployerAccountId IN(2) then 'B) Large' 
          ELSE EmployeeSize2 END as EmployeeSize2
        ,TotalEmployeeCountPerEmployer
          
  FROM /*EmployerDataWithEmployeeCountsOrderingTheSumEmployeeCountTotalEmployeeCountAndEmployeeSizeCategories*/	
	  (SELECT EmployerAccountId,EmployerAccountName,EmployerAccountHashedId,EmployerType,SICGroup,EmployerSector,TotalEmployeeCountPerEmployer,
		CASE 
		WHEN TotalEmployeeCountPerEmployer<10 THEN 'A) 1-9 (Micro)'
		WHEN TotalEmployeeCountPerEmployer<50 THEN 'B) 10-49 (Small)'
		WHEN TotalEmployeeCountPerEmployer<250 THEN 'C) 50-249 (Medium)'
		WHEN TotalEmployeeCountPerEmployer<5000 THEN 'D) 250-4999 (Large)'
		WHEN TotalEmployeeCountPerEmployer>=5000 THEN 'E) 5000+ (Macro)' 
		ELSE 'F) Not known' 
		END AS EmployeeSize1
	  , CASE 
		WHEN TotalEmployeeCountPerEmployer<250 THEN 'A) SME'
		WHEN TotalEmployeeCountPerEmployer>=250 THEN 'B) Large'
		ELSE 'C) Not known' 
		END AS EmployeeSize2
        FROM	/*EmployerDataWithEmployeeCountsOrderingTheSumEmployeeCountAndTotalEmployeeCount*/
			(SELECT EmployerAccountId,EmployerAccountName,EmployerAccountHashedId,EmployerType,SICGroup,EmployerSector
	              ,ROW_NUMBER() OVER(Partition BY EmployerAccountId ORDER BY SumEmployeeCountPerSicCode DESC) AS SumEmployeeCountRowOrder
	              ,SUM(SumEmployeeCountPerSicCode) OVER (Partition BY EmployerAccountId) AS TotalEmployeeCountPerEmployer   
		     FROM  /*EmployerDataWithEmployeeCountsAndSicCode AND  Adding SiCGroup to the main table and converting nulls into 'Z:Unknown' and reformatting 'Z Unknown' to 'Z:Unknown' */
				   (SELECT EmployerAccounts.id AS EmployerAccountId
                   	, EmployerAccounts.name AS EmployerAccountName
                   	, EmployerAccounts.HashedId AS EmployerAccountHashedId
                   	, CASE WHEN EmployerAccounts.ApprenticeshipEmployerType=0 THEN 'Non levy' ELSE 'Levy' END AS EmployerType
					, SIC.SICGroup
                    ,CASE WHEN SICGroup = 'Z Unknown' THEN 'Z:Unknown'
		                  WHEN SICGroup IS NULL THEN 'Z:Unknown'
		             ELSE SICGroup 
		              END AS EmployerSector
                   	, SUM(EmployerDetails.LiveEmployeeCount) AS SumEmployeeCountPerSicCode
                    FROM [ASData_PL].[Acc_Account] AS EmployerAccounts
                        LEFT JOIN [ASData_PL].[Acc_AccountHistory] AS EmployerAccountsHistory --Needed to get the PAYE ref in order to join to the [Tpr_OrgDetails] table
                        ON EmployerAccounts.id = EmployerAccountsHistory.accountid
                        LEFT JOIN [ASData_PL].[Tpr_OrgDetails] AS EmployerDetails
                        ON EmployerAccountsHistory.PayeRef = EmployerDetails.EmpRef
                        LEFT JOIN [ASData_PL].[Cmphs_CompaniesHouseData] AS CompaniesHouseData
                        ON EmployerDetails.CompaniesHouseNumber = CompaniesHouseData.CompanyNumber
                        LEFT JOIN [lkp].[Pst_SIC] sic
                        ON trim(LEFT(CompaniesHouseData.SICCodeSicText_1,5)) = sic.SICCode
                   
                     GROUP BY 
                   	 EmployerAccounts.id 
                   	,EmployerAccounts.name
                   	,EmployerAccounts.HashedId
                   	,CASE WHEN EmployerAccounts.ApprenticeshipEmployerType=0 THEN 'Non levy' ELSE 'Levy' END
                    ,sic.SICGroup
                   	) as EcSc
			) as EcSecTE
		WHERE SumEmployeeCountRowOrder = 1
     ) as SecTcEsc
