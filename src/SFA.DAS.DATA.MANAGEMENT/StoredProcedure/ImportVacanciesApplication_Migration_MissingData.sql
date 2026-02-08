CREATE PROCEDURE [dbo].[ImportVacanciesApplicationToPL_Migration_MissingData]
(
   @RunId int
)
AS

-- ===============================================================================
-- Author:      Harish N
-- Create Date: 06/02/2026
-- Description: Table to hold missing vacancy application details during cosmos to sql migration
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
	   ,'ImportVacanciesApplicationToPL_Migration_MissingData'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesApplicationToPL_Migration_MissingData'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE [AsData_PL].[Va_Application_Migration_MissingData]

INSERT INTO [AsData_PL].[Va_Application_Migration_MissingData]
           (       [VacancyReference]
                  ,[SourceCandidateId] 
                  ,[ApplicationStatusTypeId]
                  ,[ApplicationStatusDesc]
                  ,[CandidateAgeAtApplication]
                  ,[BeingSupportedBy]
                  ,[LockedForSupportUntil]
                  ,[IsWithdrawn]
                  ,[ApplicationGuid]
                  ,[CreatedDateTime]
                  ,[SourceDb]
                  ,[SourceApplicationId])
    select 
        V.VacancyReferenceNumber,
        Coalesce(c.SourceCandidateId_v2,c.SourceCandidateId_v3) AS SourceCandidateId
      ,a.[ApplicationStatusTypeId]
      ,a.[ApplicationStatusDesc]
      ,a.[CandidateAgeAtApplication]
      ,a.[BeingSupportedBy]
      ,a.[LockedForSupportUntil]
      ,a.[IsWithdrawn]
      ,a.[ApplicationGuid]
      ,a.[CreatedDateTime]
      ,a.[SourceDb]
      ,a.[SourceApplicationId]
      from ASData_PL.Va_Application a
 join ASData_PL.Va_Vacancy V   
   ON V.VacancyId=a.VacancyId
  and v.SourceDb='RAAv2'
  join AsData_PL.Va_Candidate c on a.Candidateid=c.CandidateId
  WHERE  V.VacancyReferenceNumber IN (
select a.VacancyReference from stg.RAA_ApplicationReviews a 
where not exists( select 1 from Stg.RCRT_ApplicationReview b where a.VacancyReference=b.VacancyReference))
--  and C.SourceDb='RAAv2'




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
	    'ImportVacanciesApplicationToPL_Migration_MissingData',
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
