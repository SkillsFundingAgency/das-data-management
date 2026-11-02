CREATE PROCEDURE [dbo].[ImportDASEmailIntegrationProvider]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Harish N
-- Create Date: 10/07/2025
-- Description: Import DAS EmailIntegrationProvider
-- ==========================================================================================================

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-6'
	   ,'ImportDASEmailIntegrationProvider'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportDASEmailIntegrationProvider'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.DAS_EmailIntegration_Provider;

 -- Step 1: Get base provider users with their email/name/UKPRN
WITH ProviderUsersBase AS (
    SELECT
        u.Email,
        u.DisplayName,
        u.Ukprn
    FROM ASData_PL.PAS_User u
    WHERE u.Email IS NOT NULL
),

-- Step 2: Aggregate provider registration details per UKPRN
ProviderRegistrationAggregate AS (
    SELECT
        p.Ukprn,
        -- ProviderTypeId consistency rule (unique value per UKPRN)
        CASE
            WHEN COUNT(DISTINCT p.ProviderTypeId) = 1
                THEN MAX(p.ProviderTypeId)
            ELSE NULL
        END AS ProviderTypeId,
        -- IsEmployer: true if any provider for this UKPRN is ProviderTypeId = 2 AND StatusId != 0
        CAST(
            CASE
                WHEN MAX(CASE WHEN p.ProviderTypeId = 2 AND p.StatusId != 0 THEN 1 ELSE 0 END) = 1
                    THEN 1
                ELSE 0
            END
        AS BIT) AS IsEmployerProvider
    FROM ASData_PL.FAT_ROATPV2_ProviderRegistrationDetail p
    GROUP BY p.Ukprn
),

-- Step 3: Aggregate active apprentices per UKPRN
ProviderApprenticesAggregate AS (
    SELECT
        c.ProviderId AS Ukprn,
        -- Active Apprentices: true if any active apprentices exist (CompletionStatus = 1)
        CAST(
            CASE
                WHEN SUM(CASE WHEN l.CompletionStatus = 1 THEN 1 ELSE 0 END) > 0
                    THEN 1
                ELSE 0
            END
        AS BIT) AS HasActiveApprentices
    FROM ASData_PL.Comt_Commitment c
    INNER JOIN ASData_PL.Comt_Apprenticeship a
        ON c.Id = a.CommitmentId
    LEFT JOIN ASData_PL.Assessor_Learner l
        ON a.Id = l.ApprenticeshipId
        AND l.CompletionStatus = 1
    WHERE c.ProviderId IS NOT NULL
    GROUP BY c.ProviderId
),

-- Step 4: Aggregate active vacancies per UKPRN
ProviderVacanciesAggregate AS (
    SELECT
        v.ProviderId AS Ukprn,
        -- Active Vacancies: true if any vacancies exist for the provider
        CAST(
            CASE
                WHEN COUNT(v.VacancyId) > 0
                    THEN 1
                ELSE 0
            END
        AS BIT) AS HasActiveVacancies
    FROM ASData_PL.Va_Vacancy v
    WHERE v.ProviderId IS NOT NULL
    GROUP BY v.ProviderId
),

-- Step 5: Aggregate all provider data per email
ProviderEmailAggregate AS (
    SELECT
        pub.Email,
        
        -- FirstName from DisplayName (consistency rule)
        CASE
            WHEN COUNT(DISTINCT pub.DisplayName) = 1
                THEN MAX(pub.DisplayName)
            ELSE ''
        END AS DisplayName,

        -- UKPRN consistency rule
        CASE
            WHEN COUNT(DISTINCT pub.Ukprn) = 1
                THEN MAX(pub.Ukprn)
            ELSE NULL
        END AS Ukprn,

        -- ProviderTypeId consistency rule (unique value per email)
        CASE
            WHEN COUNT(DISTINCT pra.ProviderTypeId) = 1
                THEN MAX(pra.ProviderTypeId)
            ELSE NULL
        END AS ProviderTypeId,

        -- IsEmployer: true if any provider for this email is employer provider
        CAST(
            CASE
                WHEN MAX(COALESCE(pra.IsEmployerProvider, 0)) = 1
                    THEN 1
                ELSE 0
            END
        AS BIT) AS IsEmployerProvider,

        -- Active Apprentices: true if any UKPRN has active apprentices
        CAST(
            CASE
                WHEN MAX(COALESCE(paa.HasActiveApprentices, 0)) = 1
                    THEN 1
                ELSE 0
            END
        AS BIT) AS HasActiveApprentices,

        -- Active Vacancies: true if any UKPRN has active vacancies
        CAST(
            CASE
                WHEN MAX(COALESCE(pva.HasActiveVacancies, 0)) = 1
                    THEN 1
                ELSE 0
            END
        AS BIT) AS HasActiveVacancies

    FROM ProviderUsersBase pub
    LEFT JOIN ProviderRegistrationAggregate pra
        ON pub.Ukprn = pra.Ukprn
    LEFT JOIN ProviderApprenticesAggregate paa
        ON pub.Ukprn = paa.Ukprn
    LEFT JOIN ProviderVacanciesAggregate pva
        ON pub.Ukprn = pva.Ukprn
    GROUP BY pub.Email
)
 INSERT INTO ASData_PL.DAS_EmailIntegration_Provider
 (
     Email,
     FirstName,
     LastName,
     EmployerAccountID,
     AccountCount,
     LevyStatus,
     LastLogin,
     DateOfLastAPIAutoSync,
     ReservedFunding,
     HasActiveReservation,
     EmployerSize,
     SectorEstimate,
     AccountCreationDate,
     Registrationtype,
     DateOfFirstStart,
     DateOfLastStart,
     DateOfLastCompletion,
     ActiveApprentices,
     ActiveVacancies,
     AccountUserRole,
     Foundationappinlast24months,
     ApprenticeshipUnit,
     Stage1a,
     Stage1b,
     Stage2,
     Stage3,
     Stage4a,
     Stage4b,
     Stage5,
     RegistrationProgressScore,
     CurrentRegistrationStage,
     UkEmployerSize,
     PrimaryIndustry,
     PrimaryLocation,
     AppsgovSignUpDate,
     PersonOrigin,
     IncludeInUR,
     RecordSource,
     Ukprn,
     ProviderType,
     ProviderTypeId,
     Employerprovider,
     IsProvider,
     Providersactivelinkedapps,
     Providersactivelinkedvacancies,
     IsEmployer
 )
-- Step 6: Final output with all fields
SELECT
    pea.Email,
    CASE 
        WHEN CHARINDEX(' ', pea.DisplayName) > 0 
        THEN LEFT(pea.DisplayName, LEN(pea.DisplayName) - CHARINDEX(' ', REVERSE(pea.DisplayName)))
        ELSE pea.DisplayName      
    END AS FirstName,

    CASE 
        WHEN CHARINDEX(' ', pea.DisplayName) > 0 
        THEN RIGHT(pea.DisplayName, CHARINDEX(' ', REVERSE(pea.DisplayName)) - 1)
        ELSE ''
    END AS LastName,
    '' AS EmployerAccountID,
    0 AS AccountCount,
    'Unknown' AS LevyStatus,
    CAST(NULL AS VARCHAR(10)) AS LastLogin,
    CAST(NULL AS VARCHAR(10)) AS DateOfLastAPIAutoSync,
    '' AS ReservedFunding,
    '' AS HasActiveReservation,
    '' AS EmployerSize,
    '' AS SectorEstimate,
    CAST(NULL AS VARCHAR(10)) AS AccountCreationDate,
    '' AS Registrationtype,
    CAST(NULL AS VARCHAR(10)) AS DateOfFirstStart,
    CAST(NULL AS VARCHAR(10)) AS DateOfLastStart,
    CAST(NULL AS VARCHAR(10)) AS DateOfLastCompletion,
    '' AS ActiveApprentices,
    '' AS ActiveVacancies,
    '' AS AccountUserRole,
    '' AS Foundationappinlast24months,
    '' AS ApprenticeshipUnit,
    '' AS Stage1a,
    '' AS Stage1b,
    '' AS Stage2,
    '' AS Stage3,
    '' AS Stage4a,
    '' AS Stage4b,
    '' AS Stage5,
    0 AS RegistrationProgressScore,
    '' AS CurrentRegistrationStage,
    '' AS UkEmployerSize,
    '' AS PrimaryIndustry,
    '' AS PrimaryLocation,
    CAST(NULL AS VARCHAR(10)) AS AppsgovSignUpDate,
    '' AS PersonOrigin,
    '' AS IncludeInUR,
    'Provider' AS RecordSource,
    CAST(pea.Ukprn AS VARCHAR(100)) AS Ukprn,
    CASE
        WHEN pea.ProviderTypeId = 1 THEN 'Main Provider'
        WHEN pea.ProviderTypeId = 2 THEN 'Employer Provider'
        WHEN pea.ProviderTypeId = 3 THEN 'Supporting Provider'
        ELSE ''
    END AS ProviderType,
    CAST(pea.ProviderTypeId AS VARCHAR(100)) AS ProviderTypeId,
    CASE
        WHEN pea.IsEmployerProvider = 1 THEN 'true'
        ELSE 'false'
    END AS Employerprovider,
    'true' AS IsProvider,
    CASE
        WHEN pea.HasActiveApprentices = 1 THEN 'true'
        ELSE 'false'
    END AS Providersactivelinkedapps,
    CASE
        WHEN pea.HasActiveVacancies = 1 THEN 'true'
        ELSE 'false'
    END AS Providersactivelinkedvacancies,
    'false' AS IsEmployer
FROM ProviderEmailAggregate pea
WHERE pea.Ukprn IS NOT NULL  -- Only include emails with valid UKPRN


COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'ImportDASEmailIntegrationProvider',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH

GO
