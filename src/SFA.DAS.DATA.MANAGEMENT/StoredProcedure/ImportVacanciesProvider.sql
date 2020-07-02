CREATE PROCEDURE [dbo].[ImportVacanciesProviderToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Provider Data from v1 and v2
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
	   ,'ImportVacanciesProviderToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesProviderToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_Provider

INSERT INTO [ASData_PL].[Va_Provider]
           ([UPIN_v1]
           ,[SourceProviderID_v1]
           ,[UKPRN]
           ,[FullName]
           ,[TradingName]
           ,[IsContracted_v1]
           ,[ContractedFrom_v1]
           ,[ContractedTo_v1]
           ,[ProviderStatusTypeID]
           ,[ProviderStatusTypeDesc]
           ,[IsNASProvider_v1]
           ,[ProviderToUseFAA_v1]
           ,[SourceDb])
 SELECT -1
       ,ProviderID
	   ,UKPRN
	   ,P.FullName
	   ,TradingName
	   ,IsContracted
	   ,ContractedFrom
	   ,ContractedTo
	   ,ProviderStatusTypeID
	   ,ETPS.FullName
	   ,IsNASProvider
	   ,ProviderToUseFAA
	   ,'RAAv1'
   FROM Stg.Avms_Provider P
   LEFT
   JOIN Stg.Avms_EmployerTrainingProviderStatus ETPS
     ON P.ProviderStatusTypeID=ETPS.EmployerTrainingProviderStatusId
  UNION
 SELECT DISTINCT
        -1
       ,-1
	   ,TrainingProviderUkprn
	   ,TrainingProviderName
	   ,TrainingProviderName
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,'RAAv2'
   FROM  (SELECT DISTINCT TrainingProviderUkprn
                         ,TrainingProviderName
						 ,Row_Number() Over (Partition by TrainingProviderUkprn 
						                         order by TrainingProviderName Desc) rn
		    FROM Stg.RAA_Vacancies) sv
  WHERE rn=1






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
	    'ImportVacanciesProviderToPL',
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
