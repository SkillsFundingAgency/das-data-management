CREATE PROCEDURE [dbo].[ImportVacanciesEmployer_Rcrt]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Employer Data from v1 and v2
--              Fields that are in v1 but not in v2 or viceversa are replaced with Defaults/Dummy Values
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
	   ,'ImportVacanciesEmployerToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesEmployerToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_Employer

INSERT INTO [ASData_PL].[Va_Employer]
           ([FullName]
           ,[TradingName]
           ,[SourceEmployerId_v1]
           ,[DasAccountId_v2]
           ,[LocalAuthorityId]
           ,[OwnerOrgnistaion_v1]
           ,[EdsUrn_v1]
           ,[EmployerStatusTypeId_v1]
           ,[EmployerStatusTypeDesc_v1]
           ,[SourceDb])
 SELECT     E.FullName               as EmployerFullName
           ,E.TradingName            as TradingName
           ,EmployerId               as SourceEmployerId_v1
	       ,'N/A'                    as DasAccountId_v2
		   ,-1                       as LocalAuthorityId
		   ,OwnerOrgnistaion         as OwnerOrganisation
		   ,-1                       as EdsUrn_v1
		   ,EmployerStatusTypeId     as EmployerStatusTypeId_v1
		   ,ETPS.FullName            as EmployerStatusTypeDesc_v1
		   ,'RAAv1'                  as SourceDb
	   FROM Stg.Avms_Employer E
	   LEFT JOIN Stg.Avms_EmployerTrainingProviderStatus ETPS
	     ON E.EmployerStatusTypeId=ETPS.EmployerTrainingProviderStatusId
	  UNION
	 SELECT DISTINCT
	        TradingName              as EmployerFullName
	       ,TradingName              as TradingName
		   ,-1                       as SourceEmployerId_v1
		   ,AccountId        		 as DasAccountId_v2
		   ,-1                       as LocalAuthorityId
		   ,'N/A'                    as OwnerOrganisation
		   ,-1                       as EdsUrn_v1
		   ,-1                       as EmployerStatusTypeId_v1
		   ,'N/A'                    as EmployerStatusTypeDesc_v1
		   ,'RAAv2'                  as SourceDb
	   FROM Stg.RCRT_EmployerProfile v
	  


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
	    'ImportVacanciesEmployerToPL',
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
