CREATE PROCEDURE [dbo].[LoadFactVacancyData]
(
   @RunId int
)
AS

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

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
	   ,'Step-3'
	   ,'LoadFactVacancyData'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='LoadFactVacancyData'
     AND RunId=@RunID


IF @@TRANCOUNT=0
BEGIN
	BEGIN TRANSACTION

   Truncate table asdata_pl.LoadFactVacancyData


DECLARE @NationalMinimumWageMIN AS FLOAT
DECLARE @NationalMinimumWageMAX AS FLOAT
DECLARE @NationalMinimumWageForApprentices AS FLOAT


SELECT -- Set the upper and lower bands for the current national minimum wages
    @NationalMinimumWageMIN = MIN(WageRateInPounds) -- NMW lower hourly rate
, @NationalMinimumWageMAX  = MAX(WageRateInPounds)
-- NMW upper hourly rate
FROM [Mtd].[NationalMinimumWageRates]
WHERE GETDATE() >= [StartDate] AND GETDATE() < [EndDate] AND AgeGroup <> 'Apprentice'

SELECT -- Set the upper and lower bands for the current national minimum wages
    @NationalMinimumWageForApprentices = MIN(WageRateInPounds)
-- NMW lower hourly rate
FROM [Mtd].[NationalMinimumWageRates]
WHERE GETDATE() >= [StartDate] AND GETDATE() < [EndDate] AND AgeGroup = 'Apprentice'
;

WITH

-- Apprenticeship Level Lookup CTE
ApprenticeshipLevelLookup AS (
    SELECT * FROM (VALUES
        ('Intermediate Level Apprenticeship', 'Intermediate Level 2 (GCSE)', 2, 'Level 2'),
        ('Advanced Level Apprenticeship', 'Advanced Level 3 (A level)', 3, 'Level 3'),
        ('Higher Level Apprenticeship', 'Higher Level 4 (Higher national certificate)', 4, 'Level 4+'),
        ('Higher Level Apprenticeship', 'Higher Level 5 (Higher national diploma)', 5, 'Level 4+'),
        ('Degree Level Apprenticeship', 'Degree Level 6 (Degree with honours)', 6, 'Level 6+'),
        ('Degree Level Apprenticeship', 'Degree Level 7 (Master''s degree)', 7, 'Level 6+')
    ) AS Lookup(ApprenticeshipType, EducationLevel, Vacancy_Standard_Level_Detailed, Vacancy_Standard_Level_Simple)
),

-- Standards CTE
Standards AS (
    SELECT
        vacancy.VacancyId,
        REPLACE(REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(
            vacancy.VacancyDescription, '<ul>', ''), '</ul>', ''), '<li>', ''), '</li>', ','), 
            '<p>', ''), '</p>', ''), CHAR(13), ''), CHAR(10), ' ') AS VacancyDescriptionCleansed,
        REPLACE(REPLACE(vacancy.SkillsRequired, CHAR(13), ''), CHAR(10), ' ') AS SkillsRequiredCleansed,
        REPLACE(REPLACE(vacancy.QualificationsRequired, CHAR(13), ''), CHAR(10), ' ') AS QualificationsRequiredCleansed,
        standards.LarsCode, standards.IfateReferenceNumber, standards.Title, standards.Level, standards.IntegratedDegree,
        standards.MaxFunding, standards.RegulatedBody, standards.Route, standards.RouteCode
    FROM
        [ASData_PL].[Va_Vacancy] AS vacancy
    LEFT JOIN 
        [ASData_PL].[FAT2_StandardSector] AS standards
        ON TRY_CAST(vacancy.FrameworkOrStandardLarsCode AS INT) = standards.LarsCode
        AND vacancy.TrainingTypeFullName = 'Standard'
        AND standards.IsLatestVersion = 1


),
ApplicationsData AS (
    SELECT
        VacancyId, 
        SUM(Applications) AS Applications, 
        SUM(VacanciesFilled) AS VacanciesFilled
    FROM (
        SELECT a.VacancyId, COUNT(*) AS Applications, COUNT(CASE WHEN a.ApplicationStatusDesc = 'Successful' THEN 1 END) AS VacanciesFilled
        FROM [ASData_PL].[Va_Application] a
        WHERE a.SourceDb = 'RAAv1' AND a.ApplicationStatusDesc NOT IN ('Saved','Draft','Unsent','Expired')
        GROUP BY a.VacancyId
        UNION ALL
        SELECT a.VacancyId, COUNT(*) AS Applications, COUNT(CASE WHEN a.Status = 'Successful' THEN 1 END) AS VacanciesFilled
        FROM [ASData_PL].[Va_Apprenticeships] a
        WHERE a.SourceDb IN('RAAv2','FAAv2') AND a.Status NOT IN ('Saved','Draft','Unsent','Expired') AND a.MigrationDate IS NULL
        GROUP BY a.VacancyId
    ) AS AllApplications
    GROUP BY VacancyId

),

MainVacancy AS (
SELECT
  v.VacancyReferenceNumber
, v.VacancyId
, concat('https://www.findapprenticeship.service.gov.uk/apprenticeship/',v.VacancyReferenceNumber) AS [VacancyURL]
, CASE WHEN cast(v.ApplicationClosingDate AS DATE) < cast(GETDATE() AS DATE) THEN 'Closed'
    ELSE v.VacancyStatus 
    END AS [Vacancy_CurrentStatus]
, v.HasHadLiveStatus AS [Vacancy_HasBeenLive]
, CASE WHEN cast(v.ApplicationClosingDate AS DATE) < cast(GETDATE() AS DATE) THEN 0
       WHEN v.VacancyStatus = 'Live' THEN 1 
       ELSE 0 END AS [VacancyIsLive]
, v.VacancyTitle AS [Vacancy_Title]
, CASE  WHEN charindex(',',REVERSE(ss.VacancyDescriptionCleansed)) =1 THEN LEFT(ss.VacancyDescriptionCleansed,len(ss.VacancyDescriptionCleansed)-1)				
	    ELSE ss.VacancyDescriptionCleansed				
		END AS [Vacancy_Description]
-- , CASE WHEN charindex(',',REVERSE(ss.SkillsRequiredCleansed)) =1 THEN LEFT(ss.SkillsRequiredCleansed,len(ss.SkillsRequiredCleansed)-1)				
-- 	         ELSE ss.SkillsRequiredCleansed				
-- 			 END  AS [Vacancy - SkillsRequired]
-- Not sure why the above is not working, going with the SkillsRequired from Va_Vacancy version for now
, v.SkillsRequired as SkillsRequired
-- , CASE WHEN charindex(',',REVERSE(ss.QualificationsRequiredCleansed)) =1 THEN LEFT(ss.QualificationsRequiredCleansed,len(ss.QualificationsRequiredCleansed)-1)				
-- 	         ELSE ss.QualificationsRequiredCleansed				
-- 			 END  AS [Vacancy - QualificationsRequired]
-- Not sure why the above is not working, going with the QualificationRequired from Va_Vacancies version for now
, v.QualificationsRequired as QualificationsRequired
, v.EmployerFullName AS [Vacancy_Employer]
, dem.EmployeeSize1 AS [Vacancy_EmployerSize1]
, dem.EmployeeSize2 AS [Vacancy_EmployerSize2]
, acc.HashedId AS [Vacancy_EmployerhashedId]
, dem.EmployerType AS [Vacancy_EmployerType]
, p.FullName AS [Vacancy_Trainingprovider]
, v.ProviderUkprn AS [Vacancy_TrainingProviderUKPRN] 
-- Vacancy standards informatio 
, ss.LarsCode AS [Vacancy- standard LARS code]
, ss.IfateReferenceNumber AS [Vacancy_standardIFATEnumber]
, ss.Title AS [Vacancy_Standard]
, ss.Level AS [Vacancy_StandardLevel]
, ss.IntegratedDegree AS [Vacancy_StandardIntegratedDegree]
, ss.Route AS [IFATE_OccupationalRoute]
, ss.RouteCode AS [IFATE_OccupationalRouteCode]
, ss.MaxFunding AS [Vacancy_StandardMaxFunding]
, ss.RegulatedBody AS [Vacancy_StandardRegulatedBody]
, v.TrainingTypeFullName AS [ Vacancy_StandardTrainingType]
, CASE  WHEN v.TrainingTypeFullName = 'Unknown' THEN 'Traineeship' 
        ELSE REPLACE(REPLACE(REPLACE(REPLACE(v.TrainingTypeFullName,',',' '),CHAR(13),' '),CHAR(10),' '),CHAR(9),' ') 
        END AS [VacancyTool_Programme] --Logic from the Vacancy tool
, CASE  WHEN TrainingTypeFullName = 'Unknown' THEN 'Traineeship' 
        ELSE v.ApprenticeshipType 
        END AS [ VacancyTool_VacancyType] --Logic from the Vacancy tool
, v.[ApprenticeshipType] AS [Vacancy_StandardApprenticeshipType]
, v.[EducationLevel] AS [Vacancy_StandardEducationLevel]
, al.Vacancy_Standard_level_detailed AS [Vacancy_StandardLevel_Detailed] 
, al.Vacancy_Standard_level_simple AS [Vacancy_StandardLevel_Simple]
, CASE WHEN v.EducationLevel LIKE 'Degree Level%' THEN 'Yes' 
       WHEN v.ApprenticeshipType = 'Degree Level%' THEN 'Yes' 
       ELSE 'No'
  END AS [ Vacancy_StandardDegreeLevel]
, v.SectorName AS [Vacancy_StandardFAASector]
, CASE  WHEN TrainingTypeFullName = 'Unknown' THEN 'Traineeship' 
        ELSE REPLACE(REPLACE(REPLACE(REPLACE(v.SectorName,',',' '),CHAR(13),' '),CHAR(10),' '),CHAR(9),' ') 
        END AS [VacancyTool_Sector] --Logic from the Vacancy tool
-- , ss.Route AS [Vacancy - Standard IFATE occupational route]
, v.WageType
, v.WageText
, CASE -- CASE STATEMENT EDITED 09/10/2024 Ryan Slender
WHEN TrainingTypeFullName = 'Unknown' THEN 'Traineeship Unwaged'
WHEN v.[ApprenticeshipType]= 'Traineeship' THEN 'Traineeship Unwaged'
WHEN v.WageText IS  NULL AND v.[WageType] IN ('Legacy Text Wage','Legacy Weekly Wage') THEN 'To be agreed upon appointment'
WHEN v.WageText IN ('£unknown','unknown') THEN 'To be agreed upon appointment'
WHEN v.WageText IS  NULL THEN v.[WageUnitDesc]
WHEN v.WageType = 'FixedWage' THEN CONCAT('£',WageText)
WHEN v.WageType = 'NationalMinimumWageForApprentices' THEN CONCAT('£',CAST(@NationalMinimumWageForApprentices * HoursPerWeek * 52 AS VARCHAR))
WHEN v.WageType = 'NationalMinimumWage' THEN CONCAT('£',CAST(@NationalMinimumWageMIN * HoursPerWeek * 52 AS VARCHAR),' to £',CAST(@NationalMinimumWageMAX * HoursPerWeek * 52 AS VARCHAR))
WHEN v.WageType = 'CompetitiveSalary' THEN 'Competitive'
ELSE REPLACE(REPLACE(REPLACE(REPLACE(CAST(v.WageText AS VARCHAR(250)),',','.'),CHAR(13),' '),CHAR(10),' '),CHAR(9),' ')
 END[VacancyTool_Wage]
, v.WageUnitDesc
, v.HoursPerWeek
, v.WorkingWeek -- Working week added 09/10/2024 Ryan Slender

-- 3 wage fields removed 09/10/2024 Ryan Slender
-- , w.[Annual Minimum wage]
-- , w.[Annual Maximum wage]
-- , w.[Average Wage]

, v.SourceDb 
-- Vacancy geographies 
, v.VacancyPostcode AS [VacancyPostcode]
, v.VacancyTown AS [VacancyTown]
, g.Constituency AS [VacancyConstituency]
, g.[Local authority] AS [VacancyLocalAuthority]
, g.County AS [VacancyCounty]
, g.[Government Office Region] AS [VacancyRegion]
, g.[Local Enterprise Partnership Primary] AS [VacancyLocalEnterprisePartnershipPrimary]
, g.[Local Enterprise Partnership Secondary] AS [VacancyLocalEnterprisePartnershipSecondary]
, g.National_Apprenticeship_Service_Area as    NationalApprenticeshipServiceArea
, g.National_Apprenticeship_Service_Division as NationalApprenticeshipServiceDivision
-- Vacancy posted dates
, cast(v.DatePosted AS DATE) AS [VacancyDatePosted]
, cast(DATEADD(month, DATEDIFF(month, 0, v.DatePosted), 0) AS DATE) AS [VacancyDatePosted_FirstDayOfMonth]
, cast(v.ApplicationClosingDate AS DATE) AS [VacancyClosingDate]
, CASE WHEN  DATEDIFF(day,GETDATE(),v.ApplicationClosingDate) < 0 THEN 0 
       ELSE DATEDIFF(day,GETDATE(),v.ApplicationClosingDate)  
 END AS [DaysLeftToVacancyClosingDate] -- Set negative values to zero
, d.Academic_Year_Id AS [DatePosted_AcademicYear]
, d.Financial_Year_Id AS [DatePosted_FinancialYear]
, d.Month_Id AS [ DatePosted_CalendarMonthNumber]
, d.Academic_Month_Number_In_Year AS [DatePosted_AcademicMonthNumber]
, d.Month_Name_Long AS [DatePosted_MonthLongName]
, d.Month_Name_Short AS [ DatePosted_MonthShortName]
, d.Financial_Month_Number_In_Year AS [  DatePosted_FinancialMonthNumber] 
-- Expected start dates
, cast(v.ExpectedStartDate AS DATE) AS [ Vacancy_ExpectedStartDate]
, v.ExpectedDuration AS [ExpectedDuration]
, de.Academic_Year_Id AS [ExpectedStartDate_AcademicYear]
, de.Financial_Year_Id AS [ExpectedStartDate_FinancialYear ]
, de.Month_Id AS [ExpectedStartDate_CalendarMonthNumber]
, de.Academic_Month_Number_In_Year AS [ ExpectedStartDate_AcademicMonthNumber]
, de.Month_Name_Long AS [ExpectedStartDate_MonthLongName]
, de.Month_Name_Short AS [ExpectedStartDate_MonthShortName]
, de.Financial_Month_Number_In_Year AS [ExpectedStartDate_FinancialMonthNumber]

--Apprenticeship
, CASE 
    WHEN v.FrameworkOrStandardName IS NULL THEN ss.Title
    WHEN v.TrainingTypeFullName = 'Unknown' THEN 'Traineeship' 
    ELSE REPLACE(REPLACE(REPLACE(REPLACE(v.FrameworkOrStandardName,',',' '),CHAR(13),' '),CHAR(10),' '),CHAR(9),' ') 
    END AS [ ApprenticeshipName]

-- Can applications be counted? If they are handled via employer website they can't and will always show as zero
, [Vacancy_ApplicationsHandledOnEmployerWebsite] = CASE 
  WHEN v.[ApplyOutsideNAVMS_v1] = 0 THEN 'No' WHEN v.[ApplyOutsideNAVMS_v1] = 1 THEN 'Yes'
  WHEN raa.ApplicationMethod = 'ThroughFindAnApprenticeship' THEN 'No'
  WHEN raa.ApplicationMethod = 'ThroughFindATraineeship' THEN 'No'
  WHEN raa.ApplicationMethod = 'ThroughExternalApplicationSite' THEN 'Yes'
  ELSE '?' END
, [Vacancy_CanApplicationsBeCounted] = CASE 
  WHEN v.[ApplyOutsideNAVMS_v1] = 0 THEN 'Yes' WHEN v.[ApplyOutsideNAVMS_v1] = 1 THEN 'No'
  WHEN raa.ApplicationMethod = 'ThroughFindAnApprenticeship' THEN 'Yes'
  WHEN raa.ApplicationMethod = 'ThroughFindATraineeship' THEN 'Yes'
  WHEN raa.ApplicationMethod = 'ThroughExternalApplicationSite' THEN 'No'
  ELSE '?' END

, [Vacancy_ApplicationsLiveVacancyToolFlag ] = CASE 
  WHEN  v.[ApplyOutsideNAVMS_v1] = 1 THEN 'Apply outside of FAA'
  WHEN  raa.ApplicationMethod = 'ThroughExternalApplicationSite' THEN 'Apply outside of FAA'
  WHEN applications.Applications = 0 THEN 'No applications for this vacancy'
  WHEN applications.Applications < 5 THEN '1-4 applications received for this vacancy' 
  ELSE '5+ applications received for this vacancy' END 
, [RAFDuplicateFlag]
, 1 AS  [Vacancy_Adverts]
, v.NumberofPositions AS [Vacancy_NumberofPositions]
, ISNULL(applications.Applications,0) AS [Vacancy_Applications]
, COALESCE(applications.Applications,0) AS [VacancyTool_NumberOfApplicantsPerAdvert]
, CASE 
    WHEN applications.VacancyId IS NOT NULL THEN GREATEST(v.NumberofPositions - applications.VacanciesFilled, 0)
    ELSE v.NumberofPositions 
    END AS [ VacancyTool_NumberOfVacanciesAvailable] 
-- , CASE WHEN v.RAFDuplicateFlag = 0 THEN v.NumberofPositions ELSE 0 END AS [NumberOfPositions No RAF Duplicates]

-- Not for FACT common table - these are specific to bespoke analysis
--, CASE WHEN CAST(v.DatePosted AS DATE) < '2024-09-01' AND CAST(v.ApplicationClosingDate AS DATE) >= '2024-08-01' THEN 1 ELSE 0 END AS 'Live in August 2024'
--, CASE WHEN CAST(v.DatePosted AS DATE) < '2023-09-01' AND CAST(v.ApplicationClosingDate AS DATE) >= '2023-08-01' THEN 1 ELSE 0 END AS 'Live in August 2023'
--, CASE WHEN CAST(v.DatePosted AS DATE) < '2022-09-01' AND CAST(v.ApplicationClosingDate AS DATE) >= '2022-08-01' THEN 1 ELSE 0 END AS 'Live in August 2022'

,ROW_NUMBER() OVER (PARTITION BY v.VacancyTitle, v.NumberofPositions,v.EmployerFullName,v.EducationLevel,datepart(year,v.DatePosted), datepart(month,v.DatePosted) ORDER BY v.VacancyReferenceNumber) as RowNumber

    FROM ASData_PL.Va_Vacancy v
	LEFT JOIN ApprenticeshipLevelLookup al
	ON v.ApprenticeshipType = al.ApprenticeshipType AND  v.EducationLevel = al.EducationLevel
   	LEFT JOIN [ASData_PL].[DimDate] d -- Vacancy posted dates
    ON cast(v.DatePosted AS DATE) = d.Date_DT_Id 
	 LEFT JOIN -- DISTINCT needed due to duplicate issue on PK Postcode var in DimGeography - flagged with Karthik / Shafana 05/08/2024
    [ASData_PL].[DimGeography]  g -- Vacancy geographies
    ON v.VacancyPostcode = g.Postcode
    LEFT JOIN [ASData_PL].[DimDate] dc -- Vacancy closing dates
    ON cast(v.ClosedDateTimeStamp AS DATE) = dc.Date_DT_Id
    LEFT JOIN [ASData_PL].[DimDate] de -- Vacancy expected start dates
    ON cast(v.ExpectedStartDate AS DATE) = de.Date_DT_Id
	LEFT JOIN [Stg].[RAA_Vacancies] raa
    ON v.VacancyReferenceNumber = raa.VacancyReference
    LEFT JOIN [ASData_PL].[Va_Provider] p -- Provider details
    ON v.ProviderId = p.ProviderID
    LEFT JOIN [ASData_PL].[Va_Employer] e -- Employer details
    ON v.EmployerId = e.EmployerId
    LEFT JOIN [ASData_PL].[Acc_Account] acc
    ON e.DasAccountId_v2 = acc.HashedId
    LEFT JOIN [ASData_PL].[DimEmployer] dem
    ON acc.id = dem.EmployerAccountId
    LEFT JOIN Standards ss ON v.VacancyId = ss.VacancyId
    LEFT JOIN ApplicationsData applications ON v.VacancyId = applications.VacancyId
	WHERE 
  v.HasHadLiveStatus = 1
    AND v.TrainingTypeFullName NOT LIKE '%Traineeship%'
    AND v.TrainingTypeFullName NOT LIKE '%Unknown%'
    AND v.DatePosted >= '2017-05-01' -- THIS RESTRICTION ADDED 09/10/2024 Ryan Slender. Date links to levy and start of funding reforms
	

  )
Insert into Asdata_PL.FactVacancy
SELECT MV.*
,case -- Flagging duplicates to discount - replicating approach from Matt Rolfe in external stats - set NumberofPositions to zerp for duplicates
when RowNumber > 1 and [Vacancy_NumberofPositions] >= 20 and [VacancyDatePosted] >= '01-Mar-2023' and [Vacancy_Employer] = 'Royal Air Force' then 0
when RowNumber > 1 and [Vacancy_NumberofPositions] >= 20 and [VacancyDatePosted] >= '01-Jan-2024' and [Vacancy_Employer] = 'KPMG LLP' then 0
else [Vacancy_NumberofPositions] end as [Vacancy_NumberOfPositions_NoDuplicates]

,case -- Flagging duplicates to discount - replicating approach from Matt Rolfe in external stats - Flag current duplicates
when RowNumber > 1 and [Vacancy_NumberofPositions] >= 20 and [VacancyDatePosted] >= '01-Mar-2023' and [Vacancy_Employer] = 'Royal Air Force' then 1
when RowNumber > 1 and [Vacancy_NumberofPositions] >= 20 and [VacancyDatePosted] >= '01-Jan-2024' and [Vacancy_Employer] = 'KPMG LLP' then 1
else 0 end as  VacancyDuplicateFlag

,case -- Flagging duplicates to discount - replicating approach from Matt Rolfe in external stats - Identify current duplicates
when RowNumber > 1 and [Vacancy_NumberofPositions] >= 20 and [VacancyDatePosted] >= '01-Mar-2023' and [Vacancy_Employer] = 'Royal Air Force' then 'Royal Air Force' 
when RowNumber > 1 and [Vacancy_NumberofPositions] >= 20 and [VacancyDatePosted] >= '01-Jan-2024' and [Vacancy_Employer] = 'KPMG LLP' then 'KPMG LLP'
else NULL end as VacancyDuplicateFlagIdentity
,Getdate() as AsDm_UpdatedDateTime
FROM MainVacancy as Mv

COMMIT TRANSACTION
END

/* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
	    'LoadFactVacancyData',
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