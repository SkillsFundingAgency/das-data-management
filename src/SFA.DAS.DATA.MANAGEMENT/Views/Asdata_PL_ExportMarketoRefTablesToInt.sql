CREATE VIEW [AsData_PL].[ExportMarketoRefTablesToInt]
As

WITH CTE_EmployerAgreement AS (
    SELECT DISTINCT 
        a.id, 
        'Y' AS Task4CompleteSignedOrAcknowledged
    FROM 
        [asdata_pl].[acc_account] a
    JOIN 
        [asdata_pl].[acc_accountlegalentity] ale ON ale.accountid = a.id
    JOIN 
        [asdata_pl].[acc_employeragreement] ea ON ea.accountlegalentityid = ale.id
    WHERE 
        ale.signedagreementid IS NOT NULL OR (ea.acknowledged = 1 AND ale.signedagreementid IS NULL)
),
CTE_ProviderAdded AS (
    SELECT 
        [accountid],
        CAST(MIN(created) AS DATE) AS [FirstProviderAddDate],
        CAST(MAX(created) AS DATE) AS [LastProviderAddDate],
        COUNT([providerukprn]) AS [Providers],
        1 AS [HasTrainingProvider]
    FROM 
        [ASData_PL].[PREL_AccountProviders] p
    GROUP BY 
        [accountid]
),
CTE_PayeAdded AS (
    SELECT
        [accountid],
        COUNT(DISTINCT [payeref]) AS [PayeAdded],
        CAST(MIN([addeddate]) AS DATE) AS [PayeEarliestDate],
        CAST(MAX([addeddate]) AS DATE) AS [PayeLatestDate]
    FROM 
        [ASData_PL].[Acc_AccountHistory]
    GROUP BY 
        [accountid]
),
CTE_PartialRegBugAccounts AS (
    SELECT DISTINCT
        x.id
    FROM 
        [asdata_pl].[acc_account] a
    LEFT JOIN 
        [asdata_pl].[acc_accountuserrole] ur ON a.id = ur.accountid
    LEFT JOIN 
        [asdata_pl].[acc_user] u ON ur.userid = u.id
    LEFT JOIN (
        SELECT 
            a.id, 
            a.name, 
            a.ApprenticeshipEmployerType, 
            u.email
        FROM 
            [asdata_pl].[acc_account] a
        LEFT JOIN 
            [asdata_pl].[acc_accountuserrole] ur ON a.id = ur.accountid
        LEFT JOIN 
            [asdata_pl].[acc_user] u ON ur.userid = u.id
        WHERE 
            a.ApprenticeshipEmployerType = 2
    ) x ON u.Email = x.email
    WHERE 
        a.ApprenticeshipEmployerType <> 2 AND x.id IS NOT NULL
)
SELECT 
    a.Id AS AccountID,
    a.[Name] AS Employer,
    au.email AS Email,
    CASE WHEN au.Email IS NOT NULL THEN 'true' ELSE 'false' END AS [Stage1a_UserAccount],
    CASE WHEN ur.Role IS NOT NULL THEN 'true' ELSE 'false' END AS [Stage1b_UserAccountRole],
    CASE WHEN paye.[PayeAdded] IS NOT NULL THEN 'true' ELSE 'false' END AS [Stage2_PayeAdded],
    CASE 
        WHEN a.[NameConfirmed] = 0 THEN 'false'
        WHEN a.[NameConfirmed] = 1 AND a.ApprenticeshipEmployerType = 2 THEN 'false'
        WHEN a.[NameConfirmed] = 1 AND a.Name = 'MY ACCOUNT' THEN 'false'
        WHEN a.[NameConfirmed] = 1 THEN 'true' 
        ELSE 'false' 
    END AS [Stage3_AccountNameConfirmed],
    CASE WHEN ea.id IS NULL THEN 'false' ELSE 'true' END AS [Stage4_EmployerAgreementSigned],
    CASE
        WHEN a.AddTrainingProviderAcknowledged = 1 THEN 'true'
        WHEN prov.AccountId IS NULL THEN 'false' 
        ELSE 'true' 
    END AS [Stage5_ProviderAdded],
    (
        CAST(
            (
            CASE WHEN au.Email IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN ur.Role IS NOT NULL THEN 1 ELSE 0 END +
            CASE WHEN paye.[PayeAdded] IS NOT NULL THEN 1 ELSE 0 END +
            CASE 
                WHEN a.[NameConfirmed] = 0 THEN 0
                WHEN a.[NameConfirmed] = 1 AND a.ApprenticeshipEmployerType = 2 THEN 0
                WHEN a.[NameConfirmed] = 1 AND a.Name = 'MY ACCOUNT' THEN 0
                WHEN a.[NameConfirmed] = 1 THEN 1 
                ELSE 0 
            END +
            CASE WHEN ea.id IS NULL THEN 0 ELSE 1 END +
            CASE
                WHEN a.AddTrainingProviderAcknowledged = 1 THEN 1
                WHEN prov.AccountId IS NULL THEN 0 
                ELSE 1 
            END
        ) * 100.0 / 6.0 As Float
        )    ) AS [regPerComplete],
 GETUTCDATE() UpdatedOn
FROM 
    [ASData_PL].[Acc_Account] AS a
LEFT JOIN 
    CTE_EmployerAgreement ea ON a.id = ea.id
LEFT JOIN 
    CTE_ProviderAdded prov ON a.id = prov.AccountId
LEFT JOIN 
    [ASData_PL].[Acc_AccountUserRole] ur ON a.Id = ur.AccountId
LEFT JOIN 
    [ASData_PL].[Acc_User] au ON ur.UserId = au.id
LEFT JOIN 
    CTE_PayeAdded paye ON a.id = paye.AccountId
LEFT JOIN 
    CTE_PartialRegBugAccounts prb ON a.id = prb.Id
WHERE
    ur.Role IN (1, 2) 
    AND prb.id IS NULL 
    AND au.Email NOT LIKE '%education.gov.uk'
;