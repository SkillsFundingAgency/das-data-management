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

/* Import Vacancies Employer Data to Presentation Layer */



EXEC dbo.ImportVacanciesEmployerToPL @RunId


/* Import Vacancies Provider Data to Presentation Layer */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesEmployerToPL' and Execution_Status=1 and RunId=@RunId) 
BEGIN
EXEC dbo.ImportVacanciesProviderToPL @RunId
END
ELSE RAISERROR( 'Import Data From Vacancies Provider Failed -Check Log Table For Errors',1,1)


/* Import Vacancies LegalEntity Data to Presentation Layer */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesProviderToPL' and Execution_Status=1 and RunId=@RunId) 
BEGIN
EXEC dbo.ImportVacanciesLegalEntityToPL @RunId
END
ELSE RAISERROR( 'Import Data From Vacancies Legal Entity Failed -Check Log Table For Errors',1,1)

/* Import Vacancies Apprenticeship Framework , Standard and Education Level To Presentation Layer */


IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesLegalEntityToPL' and Execution_Status=1 and RunId=@RunId) 
BEGIN
EXEC dbo.ImportVacanciesApprenticeshipFrameworkStandardELToPL @RunId
END
ELSE RAISERROR( 'Import Data From Vacancies Apprenticeship Framework , Standard And Education Level Failed -Check Log Table For Errors',1,1)



/* Import Vacancies Data to Presentation Layer */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesApprenticeshipFrameworkStandardELToPL' and Execution_Status=1 and RunId=@RunId)
BEGIN
EXEC dbo.ImportVacanciesToPL @RunId
END
ELSE RAISERROR( 'Import Data From Vacancies Failed -Check Log Table For Errors',1,1)




/* Import Vacancies Candidate Data to Presentation Layer */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesToPL' and Execution_Status=1 and RunId=@RunId)
BEGIN
EXEC dbo.ImportVacanciesCandidateToPL @RunId
END
RAISERROR( 'Import Data From Vacancies Candidate Failed -Check Log Table For Errors',1,1)

/* Import Vacancies Application Data to Presentation Layer */

IF EXISTS (SELECT * FROM Mgmt.Log_Execution_Results where StoredProcedureName='ImportVacanciesCandidateToPL' and Execution_Status=1 and RunId=@RunId)
BEGIN
EXEC dbo.ImportVacanciesApplicationToPL @RunId
END
RAISERROR( 'Import Data From Vacancies Application To PL Failed -Check Log Table For Errors',1,1)







END



