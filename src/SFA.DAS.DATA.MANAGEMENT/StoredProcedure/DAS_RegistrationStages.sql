DROP PROCEDURE IF EXISTS [dbo].[DAS_RegistrationStages];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DAS_RegistrationStages]
AS
BEGIN
    WITH cte_Agreement AS
    (
        -- Reduce agreements/legal entities down to one row per account.
        SELECT
            ale.AccountId,
            MAX(
                CASE
                    WHEN ale.SignedAgreementId IS NOT NULL
                    THEN 1
                    ELSE 0
                END
            ) AS HasSignedAgreement,
            MAX(
                CASE
                    WHEN ea.Acknowledged = 1
                    AND ale.SignedAgreementId IS NULL
                    THEN 1
                    ELSE 0
                END
            ) AS HasAcknowledgedUnsignedAgreement
        FROM ASData_PL.Acc_AccountLegalEntity ale
        INNER JOIN ASData_PL.Acc_EmployerAgreement ea
            ON ea.AccountLegalEntityId = ale.Id
        GROUP BY
            ale.AccountId
    ),
    cte_UserAccounts AS
    (
        -- Reduce multiple roles down to one User/Account combination.
        SELECT DISTINCT
            aur.UserId,
            aur.AccountId
        FROM ASData_PL.Acc_AccountUserRole aur
    ),
    -- sonar-ignore-start
    cte_Stages AS
    (
        SELECT
            a.Id AS EmployerAccountId,
            a.Name AS EmployerName,
            u.Email AS UserEmail,

            -- Stage 1a - User exists / has email
            CASE
                WHEN u.Email IS NOT NULL
                THEN 'true'
                ELSE 'false'
            END AS Stage1a,

            -- Stage 1b - User has an account role
            CASE
                WHEN ua.UserId IS NOT NULL
                THEN 'true'
                ELSE 'false'
            END AS Stage1b,

            -- Stage 2 - PAYE added
            CASE
                WHEN EXISTS
                (
                    SELECT 1
                    FROM ASData_PL.Acc_AccountHistory ah
                    WHERE ah.AccountId = a.Id
                )
                THEN 'true'
                ELSE 'false'
            END AS Stage2,

            -- Stage 3 - Account details confirmed
            CASE
                WHEN a.NameConfirmed = 1
                AND a.ApprenticeshipEmployerType <> 2
                AND a.Name <> 'MY ACCOUNT'
                THEN 'true'
                ELSE 'false'
            END AS Stage3,

            -- Stage 4a - Signed agreement exists
            CASE
                WHEN ag.HasSignedAgreement = 1
                THEN 'true'
                ELSE 'false'
            END AS Stage4a,

            -- Stage 4b - Agreement acknowledged but not signed
            CASE
                WHEN ag.HasAcknowledgedUnsignedAgreement = 1
                THEN 'true'
                ELSE 'false'
            END AS Stage4b,

            -- Stage 5 - Provider added / acknowledged
            CASE
                WHEN a.AddTrainingProviderAcknowledged = 1
                OR EXISTS
                    (
                        SELECT 1
                        FROM ASData_PL.PREL_AccountProviders p
                        WHERE p.AccountId = a.Id
                    )
                THEN 'true'
                ELSE 'false'
            END AS Stage5

        FROM ASData_PL.Acc_User u

        LEFT JOIN cte_UserAccounts ua
            ON ua.UserId = u.Id

        LEFT JOIN ASData_PL.Acc_Account a
            ON a.Id = ua.AccountId

        LEFT JOIN cte_Agreement ag
            ON ag.AccountId = a.Id

        WHERE
            a.Name <> 'MY ACCOUNT'
            OR a.Name IS NULL
    )
    -- sonar-ignore-end

    SELECT
        UserEmail,
        COUNT(EmployerAccountId) AS AccountCount,

        -- Only expose EmployerAccountId when the user
        -- is associated with exactly one account.
        CASE
            WHEN COUNT(EmployerAccountId) = 1
            THEN MAX(EmployerAccountId)
            ELSE NULL
        END AS EmployerAccountId,

        MAX(EmployerName) AS EmployerName,

        -- Return the stage value when it is the same
        -- across all accounts for the user.
        -- Otherwise return blank.
        CASE
            WHEN MIN(Stage1a) = MAX(Stage1a)
            THEN MIN(Stage1a)
            ELSE ''
        END AS Stage1a,

        CASE
            WHEN MIN(Stage1b) = MAX(Stage1b)
            THEN MIN(Stage1b)
            ELSE ''
        END AS Stage1b,

        CASE
            WHEN MIN(Stage2) = MAX(Stage2)
            THEN MIN(Stage2)
            ELSE ''
        END AS Stage2,

        CASE
            WHEN MIN(Stage3) = MAX(Stage3)
            THEN MIN(Stage3)
            ELSE ''
        END AS Stage3,

        CASE
            WHEN MIN(Stage4a) = MAX(Stage4a)
            THEN MIN(Stage4a)
            ELSE ''
        END AS Stage4a,

        CASE
            WHEN MIN(Stage4b) = MAX(Stage4b)
            THEN MIN(Stage4b)
            ELSE ''
        END AS Stage4b,

        CASE
            WHEN MIN(Stage5) = MAX(Stage5)
            THEN MIN(Stage5)
            ELSE ''
        END AS Stage5

    FROM cte_Stages

    GROUP BY
        UserEmail;
END;
GO