CREATE VIEW [ASData_PL].[DimEmployer]
As
WITH EmployerDataWithEmployeeCountsAndSicGroup AS (
    SELECT 
        EmployerAccounts.id AS EmployerAccountId,
        EmployerAccounts.name AS EmployerAccountName,
        EmployerAccounts.HashedId AS EmployerAccountHashedId,
        CASE 
            WHEN EmployerAccounts.ApprenticeshipEmployerType = 0 THEN 'Non levy' 
            ELSE 'Levy' 
        END AS EmployerType,
        sic.SICGroup,
        SUM(EmployerDetails.LiveEmployeeCount) AS SumEmployeeCountPerSicGroup
    FROM [ASData_PL].[Acc_Account] AS EmployerAccounts
    LEFT JOIN [ASData_PL].[Acc_AccountHistory] AS EmployerAccountsHistory 
        ON EmployerAccounts.id = EmployerAccountsHistory.accountid
    LEFT JOIN [ASData_PL].[Tpr_OrgDetails] AS EmployerDetails 
        ON EmployerAccountsHistory.PayeRef = EmployerDetails.EmpRef
    LEFT JOIN [ASData_PL].[Cmphs_CompaniesHouseData] AS CompaniesHouseData 
        ON EmployerDetails.CompaniesHouseNumber = CompaniesHouseData.CompanyNumber
    LEFT JOIN [lkp].[Pst_SIC] sic 
        ON TRIM(LEFT(CompaniesHouseData.SICCodeSicText_1, 5)) = sic.SICCode
    GROUP BY 
        EmployerAccounts.id, 
        EmployerAccounts.name, 
        EmployerAccounts.HashedId, 
        CASE 
            WHEN EmployerAccounts.ApprenticeshipEmployerType = 0 THEN 'Non levy' 
            ELSE 'Levy' 
        END, 
        sic.SICGroup
),
OrderingTheSumEmployeeCountAndTotalEmployeeCountPerSicGroup AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY EmployerAccountId ORDER BY SumEmployeeCountPerSicGroup DESC) AS SumEmployeeCountRowOrder,
        SUM(SumEmployeeCountPerSicGroup) OVER (PARTITION BY EmployerAccountId) AS TotalEmployeeCountPerEmployer
    FROM EmployerDataWithEmployeeCountsAndSicGroup
),
EmployerDataWithEmployeeCountsOrderingTheSumEmployeeCountTotalEmployeeCountAndEmployeeSizeCategories AS (
    SELECT *,
        CASE 
            WHEN TotalEmployeeCountPerEmployer < 10 THEN 'A) 1-9 (Micro)'
            WHEN TotalEmployeeCountPerEmployer < 50 THEN 'B) 10-49 (Small)'
            WHEN TotalEmployeeCountPerEmployer < 250 THEN 'C) 50-249 (Medium)'
            WHEN TotalEmployeeCountPerEmployer < 5000 THEN 'D) 250-4999 (Large)'
            WHEN TotalEmployeeCountPerEmployer >= 5000 THEN 'E) 5000+ (Macro)' 
            ELSE 'F) Not known' 
        END AS EmployeeSize1,
        CASE 
            WHEN TotalEmployeeCountPerEmployer < 250 THEN 'A) SME'
            WHEN TotalEmployeeCountPerEmployer >= 250 THEN 'B) Large'
            ELSE 'C) Not known' 
        END AS EmployeeSize2
    FROM OrderingTheSumEmployeeCountAndTotalEmployeeCountPerSicGroup
    WHERE SumEmployeeCountRowOrder = 1
),
EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize AS (
    SELECT *,
        CASE 
            WHEN SICGroup = 'Z Unknown' THEN 'Z:Unknown'
            WHEN SICGroup IS NULL THEN 'Z:Unknown'
            ELSE SICGroup 
        END AS EmployerSector
    FROM EmployerDataWithEmployeeCountsOrderingTheSumEmployeeCountTotalEmployeeCountAndEmployeeSizeCategories
),
EmployerIDWithEmployeeCountsAndSicCodeSicText_1 AS (
    SELECT 
        EmployerAccounts.id AS EmployerAccountId2,
        EmployerAccounts.name AS EmployerAccountName2,
        CompaniesHouseData.SICCodeSicText_1 AS SicCodeText,
        SUM(EmployerDetails.LiveEmployeeCount) AS SumEmployeeCountPerSicCodeText_1
    FROM [ASData_PL].[Acc_Account] AS EmployerAccounts
    LEFT JOIN [ASData_PL].[Acc_AccountHistory] AS EmployerAccountsHistory 
        ON EmployerAccounts.id = EmployerAccountsHistory.accountid
    LEFT JOIN [ASData_PL].[Tpr_OrgDetails] AS EmployerDetails 
        ON EmployerAccountsHistory.PayeRef = EmployerDetails.EmpRef
    LEFT JOIN [ASData_PL].[Cmphs_CompaniesHouseData] AS CompaniesHouseData 
        ON EmployerDetails.CompaniesHouseNumber = CompaniesHouseData.CompanyNumber
    LEFT JOIN [lkp].[Pst_SIC] sic 
        ON TRIM(LEFT(CompaniesHouseData.SICCodeSicText_1, 5)) = sic.SICCode
    GROUP BY 
        EmployerAccounts.id, 
        EmployerAccounts.name, 
        CompaniesHouseData.SICCodeSicText_1
),
OrderingTheSumEmployeeCountAndTotalEmployeeCountPerSicText_1 AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY EmployerAccountId2 ORDER BY SumEmployeeCountPerSicCodeText_1 DESC) AS SumEmployeeCountRowOrder2,
        SUM(SumEmployeeCountPerSicCodeText_1) OVER (PARTITION BY EmployerAccountId2) AS TotalEmployeeCountPerEmployer2
    FROM EmployerIDWithEmployeeCountsAndSicCodeSicText_1
),
EmployerIDFilteredtoHighestTotalEmployeesPerSicCodeText_1 AS (
    SELECT * 
    FROM OrderingTheSumEmployeeCountAndTotalEmployeeCountPerSicText_1
    WHERE SumEmployeeCountRowOrder2 = 1
)
SELECT 
    EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployerAccountId,
    EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployerAccountHashedId,
    EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployerAccountName,
    EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployerType,
    EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployerSector AS EmployerSectorEstimate,
    EmployerIDFilteredtoHighestTotalEmployeesPerSicCodeText_1.SicCodeText AS EmployerSectorDetailEstimate,
    CASE 
        WHEN EmployerAccountId IN (2) THEN 'E) 5000+ (Macro)' 
        ELSE EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployeeSize1 
    END AS EmployeeSize1,
    CASE
        WHEN EmployerAccountId IN (2) THEN 'B) Large' 
        ELSE EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployeeSize2 
    END AS EmployeeSize2,
    EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.TotalEmployeeCountPerEmployer
FROM EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize
LEFT JOIN EmployerIDFilteredtoHighestTotalEmployeesPerSicCodeText_1
    ON EmployerDataWithEmployeeCountsSicCodesSICGroupAndEmployeeSize.EmployerAccountId = EmployerIDFilteredtoHighestTotalEmployeesPerSicCodeText_1.EmployerAccountId2
ORDER BY EmployerAccountId;
