/* Execute Stored Procedure */
EXEC [dbo].[Build_AS_DataMart]

DROP PROCEDURE  IF EXISTS [dbo].[PopulateMarketoFilterConfigForImport]
DROP PROCEDURE  IF EXISTS [dbo].[ImportAppRedundancyAndComtToPL]
DROP TABLE IF EXISTS [Mtd].[MarketoFilterConfigForPrograms]
DROP TABLE IF EXISTS [Mtd].[MarketoFilterConfig]
DROP TABLE IF EXISTS [ASData_PL].[AR_Employer]
DROP TABLE IF EXISTS [ASData_PL].[AR_Apprentice]

 

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