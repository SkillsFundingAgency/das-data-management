/* Execute Stored Procedure */
EXEC [dbo].[Build_AS_DataMart]

DROP PROCEDURE  IF EXISTS [dbo].[PopulateMarketoFilterConfigForImport]
DROP PROCEDURE  IF EXISTS [dbo].[ImportAppRedundancyAndComtToPL]
DROP PROCEDURE IF EXISTS [dbo].[ImportVaAddInfoApprenticeshipsToPL_Rcrt]
DROP PROCEDURE IF EXISTS [dbo].[ImportVaAddInfoVacancyReviewsAutoQAoutcomeIDToPL_rcrt]
DROP PROCEDURE IF EXISTS [dbo].[ImportVaAddInfoVacancyReviewsAutoQAoutcomeToPL_rcrt]
DROP PROCEDURE IF EXISTS [dbo].[ImportVacanciesEmployer_Rcrt]
DROP PROCEDURE IF EXISTS [dbo].[ImportVacanciesLegalEntityToPL_Rcrt]
DROP PROCEDURE IF EXISTS [dbo].[ImportVacanciesProviderToPL_Rcrt]
DROP PROCEDURE IF EXISTS [dbo].[ImportVacancyLocationsToPL_Rcrt]
DROP TABLE IF EXISTS [ASData_PL].[Va_Apprenticeships_Rcrt]
DROP TABLE IF EXISTS [ASData_PL].[Va_Employer_Rcrt]
DROP TABLE IF EXISTS [ASData_PL].[Va_LegalEntity_Rcrt]
DROP TABLE IF EXISTS [ASData_PL].[Va_Provider_Rcrt]
DROP TABLE IF EXISTS [ASData_PL].[Va_Vacancy_Rcrt]
DROP TABLE IF EXISTS [ASData_PL].[Va_VacancyLocations_Rcrt]
DROP TABLE IF EXISTS [ASData_PL].[va_VacancyReviewsAutoQAOutcomeID_rcrt]
DROP TABLE IF EXISTS [ASData_PL].[va_VacancyReviewsAutoQAOutcome_rcrt]
DROP TABLE IF EXISTS [Mtd].[MarketoFilterConfigForPrograms]
DROP TABLE IF EXISTS [Mtd].[MarketoFilterConfig]
DROP TABLE IF EXISTS [ASData_PL].[AR_Employer]
DROP TABLE IF EXISTS [ASData_PL].[AR_Apprentice]

UPDATE  [Mtd].[SourceToStageAudit]
SET WatermarkValue='2000-03-24 12:24:48.1846476'
WHERE SourceTableName IN (
'Certificates')  
AND  NOT EXISTS (select 1 from [ASData_PL].[Assessor_Certificates] where len([PrintRequestedBy])>0)




IF NOT EXISTS (
    SELECT 1
    FROM ASData_PL.Assessor_CertificateLogs
    WHERE LEN([Username]) > 0
)
BEGIN
    TRUNCATE TABLE ASData_PL.Assessor_Certificates;
    TRUNCATE TABLE [ASData_PL].[Assessor_CertificateLogs];
END

--EXEC [dbo].[ImportDimDate] 6
 /* Ryan's Power BI dashboard still pointing towards to these outdated tables.
 The tables will be removed once Ryan repoint his dashboard */

--DROP TABLE IF EXISTS [ASData_PL].[FAT2_NationalAchievementRate]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_NationalAchievementRateOverall]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_ProviderRegistration]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_ProviderRegistrationFeedbackAttribute]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_ProviderRegistrationFeedbackRating]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_ProviderStandardLocation]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_ShortList]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_StandardLocation]
--DROP TABLE IF EXISTS [ASData_PL].[FAT2_ProviderStandard]
--DROP TABLE IF EXISTS [ASData_PL].[Provider]

--DROP VIEW IF EXISTS [Pds_AI].[PT_E]
