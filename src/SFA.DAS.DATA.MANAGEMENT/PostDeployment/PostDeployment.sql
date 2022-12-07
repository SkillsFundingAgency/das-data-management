/* Execute Stored Procedure */
EXEC [dbo].[Build_AS_DataMart]

DROP TABLE IF EXISTS  [ASData_PL].[GA_DataForReporting]
DROP TABLE IF EXISTS  [Stg].[GA_SessionDataDetail]
DROP TABLE IF EXISTS  [ASData_PL].[GA_SessionData]
DROP PROCEDURE IF EXISTS [dbo].[ImportGASessionDataToPL]
DROP TABLE IF EXISTS [ASData_PL].[GASessionData]