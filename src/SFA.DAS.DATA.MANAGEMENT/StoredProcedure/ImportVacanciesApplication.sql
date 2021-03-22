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

DELETE FROM ASData_PL.Va_Application

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
    SELECT  c.CandidateId                  as CandidateId
           ,v.[VacancyId]                  as VacancyId
           ,AA.[ApplicationStatusTypeId]   as ApplicationStatusTypeId
	       ,AST.FullName                   as ApplicationStatusDesc
		   ,SAA.AgeAtApplication           as CandidateAgeAtApplication
           ,[BeingSupportedBy]             as BeingSupportedBy        
           ,[LockedForSupportUntil]        as LockedForSupportUntil
          ,Case when AA.ApplicationStatusTypeId in (4,8) THEN 1
	            ELSE 0
	        END                            as IsWithdrawn
          ,cast([ApplicationGuid] as varchar(256)) as ApplicationGuid
		  ,AH.HistoryDate                  as CreatedDateTime
		  ,'RAAv1'                         as SourceDb
		  ,AA.ApplicationId                as SourceApplicationId
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
  left
  join Stg.Avms_AgeAtApplication SAA
    on SAA.ApplicationId=AA.ApplicationId
 UNION
 SELECT C.CandidateId                       as CandidateId
	   ,v.VacancyId                         as VacancyId
	   ,-1                                  as ApplicationStatusTypeId       
	   ,AR.ApplicationStatus                as ApplicationStatusDesc
	   ,CASE WHEN [FCD].[DateOfBirth] IS NULL	THEN - 1
		      WHEN DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth])) > DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(ar.CreatedDateTimeStamp))
			    OR DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth])) = DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(ar.CreatedDateTimeStamp))
			   AND DATEPART([DD],dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth])) > DATEPART([DD], dbo.Fn_ConvertTimeStampToDateTime(ar.CreatedDateTimeStamp))
			  THEN DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(ar.CreatedDateTimeStamp)) - 1
		      ELSE DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([FCD].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(ar.CreatedDateTimeStamp))
		END                                 as CandidateAgeAtApplication
	   ,'N/A'                               as BeingSupportedBy 
	   ,''                                  as LockedForSupportUntil
	   ,CASE WHEN AR.IsWithDrawn='False' then 0
	         WHEN AR.IsWithDrawn='True' then 1
		 END                                as IsWithdrawn
	   ,CAST(AR.BinaryId as varchar(256))   as ApplicationGuid
	   ,dbo.Fn_ConvertTimeStampToDateTime(ar.CreatedDateTimeStamp) as CreatedDateTime
	   ,'RAAv2'                             as SourceDb
	   ,AR.SourseSK                         as SourceApplicationId
 from Stg.RAA_ApplicationReviews AR
 left
 join ASData_PL.Va_Vacancy V   
   ON V.VacancyReferenceNumber=ar.VacancyReference
  and v.SourceDb='RAAv2'
 left
 join AsData_PL.Va_Candidate C
   on C.SourceCandidateId_v2=CAST(AR.CandidateId as Varchar(256))
 left
 join Stg.FAA_CandidateDob FCD
   ON FCD.CandidateId=AR.CandidateId
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
