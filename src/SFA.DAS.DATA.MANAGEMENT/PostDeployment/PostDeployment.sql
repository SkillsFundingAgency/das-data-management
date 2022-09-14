/* Execute Stored Procedure */
EXEC [dbo].[Build_AS_DataMart]

/*As per the CRQ  CHG0065021 and ASINTEL- 2257 Move Roatp Lookup Tables to AsData_Lkp Schema need to be removed after the change */

DROP TABLE IF EXISTS [Mtd].[RP_LookupOversightReviewStatus]

DROP TABLE IF EXISTS [Mtd].[RP_LookupPageTitles]

DROP TABLE IF EXISTS [Mtd].[RP_LookupQuestionTitles]

DROP TABLE IF EXISTS [Mtd].[RP_LookupSectionTitles]

DROP TABLE IF EXISTS [Mtd].[RP_LookupSequenceTitles]