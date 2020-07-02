CREATE PROCEDURE [dbo].[ImportVacanciesApplicationToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Application Data from v1 and v2
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

DELETE FROM ASData_PL.Va_Application

INSERT INTO [ASData_PL].[Va_Application]
           ([CandidateId]
           ,[VacancyId]
           ,[ApplicationStatusTypeId]
           ,[ApplicationStatusDesc]
           ,[BeingSupportedBy]
           ,[LockedForSupportUntil]
           ,[IsWithdrawn]
           ,[ApplicationGuid]
           ,[CreatedDateTime]
           ,[SourceDb]
           ,[SourceApplicationId])
    SELECT  CAST(c.CandidateId AS Varchar)
           ,v.[VacancyId]
           ,AA.[ApplicationStatusTypeId]
	       ,AST.FullName as ApplicationStatusDesc
           ,[BeingSupportedBy]
           ,[LockedForSupportUntil]
          ,Case when AA.ApplicationStatusTypeId in (4,8) THEN 1
	            ELSE 0
	        END
          ,cast([ApplicationGuid] as varchar(256))
		  ,AH.HistoryDate as CreatedDateTime
		  ,'RAAv1'
		  ,AA.ApplicationId
  FROM [Stg].[Avms_Application] AA
  LEFT
  JOIN ASData_PL.Va_Vacancy v
    ON v.SourceVacancyId=AA.VacancyId
   AND v.SourceDb='RAAv1'
  LEFT
  JOIN Stg.Avms_ApplicationStatusType AST
    ON AA.ApplicationStatusTypeId=AST.ApplicationStatusTypeId
  left
  join (select ApplicationId,min(ApplicationHistoryEventDate) HistoryDate
          from Stg.Avms_ApplicationHistory Ah
		 group by ApplicationId) AH
          ON AH.ApplicationId=AA.ApplicationId
  left
  join ASData_PL.Va_Candidate C
    on c.SourceCandidateId_v1=AA.CandidateId
   AND C.SourceDb='RAAv1'
 UNION
 SELECT C.CandidateId
	   ,v.VacancyId
	   ,-1
	   ,AR.ApplicationStatus
	   ,'N/A'
	   ,''
	   ,CASE WHEN AR.IsWithDrawn='False' then 0
	         WHEN AR.IsWithDrawn='True' then 1
		 END 
	   ,CAST(AR.BinaryId as varchar(256))
	   ,dbo.Fn_ConvertTimeStampToDateTime(ar.CreatedDateTimeStamp)
	   ,'RAAv2'
	   ,AR.SourseSK
 from Stg.RAA_ApplicationReviews AR
 left
 join ASData_PL.Va_Vacancy V   
   ON V.VacancyReferenceNumber=ar.VacancyReference
  and v.SourceDb='RAAv2'
 left
 join AsData_PL.Va_Candidate C
   on C.CandidateGuid=CAST(AR.CandidateId as Varchar(256))
  and C.SourceDb='RAAv2'




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
