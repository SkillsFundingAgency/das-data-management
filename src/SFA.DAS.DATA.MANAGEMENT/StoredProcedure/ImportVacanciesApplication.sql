CREATE PROCEDURE [dbo].[ImportVacanciesApplicationToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Application Data from v1 and v2
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
	   ,'ImportVacanciesApplicationToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesApplicationToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_Application

INSERT INTO [ASData_PL].[Va_Application]
           ([CandidateId]
           ,[VacancyId]
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
   SELECT
      CASE WHEN C.CandidateId IS NULL THEN C2.CandidateId ELSE c.CandidateId END AS CandidateId 
	   ,v.VacancyId                         as VacancyId
	   ,-1                                  as ApplicationStatusTypeId       
	   ,AR.Status                as ApplicationStatusDesc
	   ,CASE WHEN [FCD].[DateOfBirth] IS NULL	THEN - 1
		      WHEN DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth])) > DATEPART([M], ar.CreatedDate)
			    OR DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth])) = DATEPART([M], ar.CreatedDate)
			   AND DATEPART([DD],dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth])) > DATEPART([DD], ar.CreatedDate)
			  THEN DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth]), ar.CreatedDate) - 1
		      ELSE DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth]), ar.CreatedDate)
		END                                 as CandidateAgeAtApplication
	   ,'N/A'                               as BeingSupportedBy 
	   ,''                                  as LockedForSupportUntil
	   ,CASE WHEN AR.WithdrawnDate is not null  then 1
	         else 0
		 END                                as IsWithdrawn
	   ,[dbo].[Fn_ConvertGuidToBase64](AR.Id)   as ApplicationGuid
	   ,ar.CreatedDate as CreatedDateTime
	   ,'RAAv2'                             as SourceDb
	   ,-1                       as SourceApplicationId
 from Stg.RCRT_ApplicationReview AR
 left
 join ASData_PL.Va_Vacancy V   
   ON V.VacancyReferenceNumber=ar.VacancyReference
  and v.SourceDb='RAAv2'
 left
 join AsData_PL.Va_Candidate C
   on C.SourceCandidateId_v2=[dbo].[Fn_ConvertGuidToBase64](AR.CandidateId)  
 left 
 join AsData_PL.Va_Candidate C2
   on C2.SourceCandidateId_v3=CAST(AR.CandidateId AS varchar(256))  
 left
 join Stg.FAA_CandidateDob FCD
   ON FCD.CandidateId=[dbo].[Fn_ConvertGuidToBase64](AR.CandidateId)  

 UNION ALL 
 SELECT
       c.CandidateId AS CandidateId 
      ,v.VacancyId                         as VacancyId
      ,AR.[ApplicationStatusTypeId]
      ,AR.[ApplicationStatusDesc]
      ,AR.[CandidateAgeAtApplication]
      ,AR.[BeingSupportedBy]
      ,AR.[LockedForSupportUntil]
      ,AR.[IsWithdrawn]
      ,AR.[ApplicationGuid]
      ,AR.[CreatedDateTime]
      ,AR.[SourceDb]
      ,-1
 from [AsData_PL].[Va_Application_Migration_MissingData] AR
 left
 join ASData_PL.Va_Vacancy V   
   ON V.VacancyReferenceNumber=ar.[VacancyReference]
  and v.SourceDb='RAAv2'
 left
 join AsData_PL.Va_Candidate C
   on (C.SourceCandidateId_v2=AR.[SourceCandidateId])  or (C.SourceCandidateId_v3=AR.[SourceCandidateId])






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
	    'ImportVacanciesApplicationToPL',
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
