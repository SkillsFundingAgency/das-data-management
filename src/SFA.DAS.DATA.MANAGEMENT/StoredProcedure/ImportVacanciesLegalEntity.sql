CREATE PROCEDURE [dbo].[ImportVacanciesLegalEntityToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Legal Entity Data from v1 and v2
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
	   ,'ImportVacanciesLegalEntityToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesLegalEntityToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_LegalEntity

INSERT INTO [ASData_PL].[Va_LegalEntity]
           ([LegalEntityPublicHashedId]
           ,[EmployerId]
           ,[EmployerAccountId]
           ,[LegalEntityName]
           ,[SourceLegalEntityId]
           ,[SourceDb])
     SELECT AccountLegalEntityPublicHashedId
		   ,E.EmployerId
		   ,EmployerAccountId
		   ,LegalEntityName
		   ,LegalEntityId
		   ,'RAAv2'
	   FROM (SELECT DISTINCT LegalEntityId
	                        ,AccountLegalEntityPublicHashedId
							,EmployerAccountId
							,LegalEntityName
			                ,ROW_NUMBER() OVER (PARTITION BY EmployerAccountId,LegalEntityId
							                        ORDER BY LegalEntityName Desc) rn
			   FROM Stg.RAA_Vacancies) v
	   LEFT
	   JOIN ASData_PL.Va_Employer E
	     ON E.DasAccountId_v2=V.EmployerAccountId
		AND E.SourceDb='RAAv2'
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
	    'ImportVacanciesLegalEntityToPL',
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
