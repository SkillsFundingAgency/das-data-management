CREATE PROCEDURE [dbo].[ImportVacanciesLegalEntityToPL_Rcrt]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Legal Entity Data from RCRT
-- ===============================================================================

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
	   ,'ImportVacanciesLegalEntityToPL_Rcrt'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesLegalEntityToPL_Rcrt'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_LegalEntity_Rcrt

INSERT INTO [ASData_PL].[Va_LegalEntity_Rcrt]
           ([LegalEntityPublicHashedId]
           ,[EmployerId]
           ,[EmployerAccountId]
           ,[LegalEntityName]
           ,[SourceLegalEntityId]
           ,[SourceDb])
     SELECT ALE.HashedLegalEntityId              as LegalEntityPublicHashedId
		   ,E.EmployerId                         as EmployerId
		   ,V.AccountId                          as EmployerAccountId
		   ,V.LegalEntityName                    as LegalEntityName
		   ,V.AccountLegalEntityId               as SourceLegalEntityId
		   ,'RCRT'                               as SourceDb
	   FROM (SELECT DISTINCT AccountId
	                        ,AccountLegalEntityId
							,LegalEntityName
			                ,ROW_NUMBER() OVER (PARTITION BY AccountId,AccountLegalEntityId
							                        ORDER BY LegalEntityName Desc) rn
			   FROM Stg.RCRT_Vacancy) V
	   LEFT
	   JOIN ASData_PL.Va_Employer_Rcrt E
	     ON E.DasAccountId_v2=V.AccountId
		AND E.SourceDb='RCRT'
	   LEFT
	   JOIN ASData_PL.Acc_AccountLegalEntity ALE
	     ON ALE.Id=V.AccountLegalEntityId
		AND ALE.AccountId=V.AccountId
	  WHERE V.rn=1

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
	    'ImportVacanciesLegalEntityToPL_Rcrt',
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
