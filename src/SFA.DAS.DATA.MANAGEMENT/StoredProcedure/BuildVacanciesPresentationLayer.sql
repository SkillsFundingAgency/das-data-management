CREATE PROCEDURE [dbo].[BuildVacanciesPresentationLayer]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Build Vacancies Presentation Layer
-- ===============================================================================
BEGIN


IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesEmployerToPL' and Execution_Status=1 and RunId=@RunId)
BEGIN 
EXEC dbo.ImportVacanciesEmpImportVacanciesEmployerToPL @RunId
END
ELSE RAISERROR( 'Import Data From File Failed -Check Log Table For Errors',1,1)



/* Import Valid Records to Target Clone Tables */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesProviderToPL' and Execution_Status=1 and RunId=@RunId) 
BEGIN
EXEC dbo.ImportVacanciesProviderToPL@RunId
END
ELSE RAISERROR( 'Validation Checks Failed-Check Log Table For Errors',1,1)


/* Swap Clone Tables With Live */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesLegalEntityToPL' and Execution_Status=1 and RunId=@RunId) 
BEGIN
EXEC dbo.ImportVacanciesLegalEntityToPL @RunId
END
ELSE RAISERROR( 'Loading Clone Tables Failed-Check Log Table For Errors',1,1)



--/* Update History Table with Processed File */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesToPL' and Execution_Status=1 and RunId=@RunId)
BEGIN
EXEC dbo.ImportVacanciesToPL @RunId
END
ELSE RAISERROR( 'Loading Target Tables Failed-Check Log Table For Errors',1,1)




--/* Raise Error if Updating History Table Failed */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesCandidateToPL' and Execution_Status=1 and RunId=@RunId)
BEGIN
EXEC dbo.ImportVacanciesCandidateToPL @RunId
END
RAISERROR( 'Updating History Table Failed-Check Log Table For Errors',1,1)
END



