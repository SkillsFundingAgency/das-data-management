CREATE PROCEDURE [dbo].[ImportVacanciesCandidateToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Candidate Data from v1 and v2
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
	   ,'ImportVacanciesCandidateToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesCandidateToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_Candidate

INSERT INTO [ASData_PL].[Va_Candidate]
           ([CandidateStatusTypeId]
           ,[CandidateStatusTypeDesc]
           --,[CountyId]
           --,[CountyName]
           ,[PostCode]
           --,[LocalAuthorityId]
           --,[LocalAuthorityName]
           --,[UniqueLearnerNumber]
           --,[Gender]
           ,[ApplicationLimitEnforced_v1]
           ,[LastAccessedDate_v1]
           ,[LastAccessedManageApplications_v1]
           ,[BeingSupportedBy_v1]
           ,[LockedForSupportUntil_v1]
           ,[AllowMarketingMessages_v1]
           ,[CandidateGuid]
           ,[AgeAtRegistration]
		   ,[RegistrationDate]
		   ,[LastAccessedDate]
           ,[SourceDb]
           ,[SourceCandidateId_v1]
		   ,[SourceCandidateId_v2])
/* Candidates that are In AVMS but not in FAA Cosmos Db */
SELECT C.CandidateStatusTypeId                        as CandidateStatusTypeId
      ,CASE WHEN c.CandidateStatusTypeId=1 THEN 'Pre-Registered'
            WHEN c.CandidateStatusTypeId=2 THEN 'Activated'
			WHEN c.CandidateStatusTypeId=3 THEN 'Registered'
            WHEN c.CandidateStatusTypeId=4 THEN 'Suspended'
            WHEN c.CandidateStatusTypeId=5 THEN 'Pending Delete'
            WHEN c.CandidateStatusTypeId=6 THEN 'Deleted'
			ELSE 'Unknown'
		END                                            as CandidateStatusTypeDesc
	   ,capc.PostCode                                  as Postcode
	   ,c.ApplicationLimitEnforced                     as ApplicationLimitEnforced_v1
	   ,c.LastAccessedDate                             as LastAccessedDate_v1
	   ,c.LastAccessedManageApplications               as LastAccessedManageApplications_v1
	   ,c.BeingSupportedBy                             as BeingSupportedBy_v1
	   ,c.LockedForSupportUntil                        as LockedForSupportUntil_v1
	   ,c.AllowMarketingMessages                       as AllowMarketingMessages_v1
	   ,dbo.Fn_ConvertGuidToBase64(C.CandidateGuid)    as CandidateGuid
	   ,CAPC.AgeAtRegistration                         as AgeAtRegistration
	   ,convert(datetime2,ch.RegisteredDate)           as RegistrationDate
	   ,convert(datetime2,c.LastAccessedDate)          as LastAccessedDate   
	   ,'FAA-Avms'                                     as SourceDb
	   ,c.CandidateId                                  as SourceCandidateId_v1
	   ,''                                             as SourceCandidateId_v2
  FROM Stg.Avms_Candidate C
  left
  join (SELECT candidateId,EVENTDATE as RegisteredDate from Stg.Avms_candidatehistory where Comment='NAS Exemplar registered Candidate.') ch
    on c.CandidateId= ch.CandidateId
  left
  join Stg.Avms_CandidateAgePostCode CAPC
    ON CAPC.CandidateId=c.CandidateId
 WHERE NOT EXISTS (SELECT 1 FROM Stg.FAA_Users FU WHERE FU.BinaryId=dbo.Fn_ConvertGuidToBase64(C.CandidateGuid))
 union
 /* Candidates that are In Cosmos Db but not in AVMS */
 SELECT DISTINCT 
       -1                                               as CandidateStatusTypeId
      ,CASE WHEN FU.Status=0 THEN 'Unknown'
	        WHEN FU.Status=10 THEN 'PendingActivation'
			WHEN FU.Status=20 THEN 'Active'
			WHEN FU.Status=30 THEN 'Inactive'
			WHEN FU.Status=90 THEN 'Locked'
			WHEN FU.Status=100 THEN 'Dormant'
			WHEN FU.Status=999 THEN 'PendingDeletion'
		END                                             as CandidateStatusTypeDesc
	  ,CASE WHEN CHARINDEX(' ',PC.Postcode)<>0 THEN SUBSTRING(PC.PostCode,1,CHARINDEX(' ',PC.PostCode)) 
	        ELSE SUBSTRING(PC.Postcode,1,LEN(PC.Postcode)-3) 
	    END                                             as PostCode
	  ,NULL                                             as ApplicationLimitEnforced_v1
	  ,''                                               as LastAccessedDate_v1
	  ,''                                               as LastAccessedManageApplications_v1
	  ,'N/A'                                            as BeingSupportedBy_v1
	  ,''                                               as LockedForSupportUntil_v1
	  ,NULL                                             as AllowMarketingMessages_v1
	  ,CAST(Fu.BinaryId as Varchar(256))                as CandidateGuid
	  ,CASE WHEN [DB].[DateOfBirth] IS NULL	THEN - 1
		      WHEN DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) > DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			    OR DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) = DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			   AND DATEPART([DD],dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) > DATEPART([DD], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			  THEN DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp)) - 1
		      ELSE DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
		END                                             as AgeAtRegistration
	  ,dbo.Fn_ConvertTimeStampToDateTime([fu].[ActivationTimeStamp]) as RegistrationDate
	  ,dbo.Fn_ConvertTimeStampToDateTime([fu].[LastLogInTimeStamp])  as LastAccessedDate
	  ,'FAA-Cosmos'                                                  as SourceDb
	  ,''                                                            as SourceCandidateId_v1
	  ,FU.BinaryId                                                   as SourceCandidateId_v2
   FROM Stg.FAA_Users FU
   LEFT
   JOIN Stg.FAA_CandidatePostcode PC
     ON PC.CandidateId=FU.BinaryId
   LEFT
   JOIN Stg.FAA_CandidateDob Db
     ON Db.CandidateId=FU.BinaryId
  WHERE NOT EXISTS (SELECT 1 FROM Stg.Avms_Candidate C
                     WHERE dbo.Fn_ConvertGuidToBase64(C.CandidateGuid)=FU.BinaryId)
union
/* Candidates that are in both AVMS and FAA Cosmos Db */
 SELECT DISTINCT 
       -1                                               as CandidateStatusTypeId
      ,CASE WHEN FU.Status=0 THEN 'Unknown'
	        WHEN FU.Status=10 THEN 'PendingActivation'
			WHEN FU.Status=20 THEN 'Active'
			WHEN FU.Status=30 THEN 'Inactive'
			WHEN FU.Status=90 THEN 'Locked'
			WHEN FU.Status=100 THEN 'Dormant'
			WHEN FU.Status=999 THEN 'PendingDeletion'
		END                                             as CandidateStatusTypeDesc
	  ,CASE WHEN CHARINDEX(' ',PC.Postcode)<>0 THEN SUBSTRING(PC.PostCode,1,CHARINDEX(' ',PC.PostCode)) 
	        ELSE SUBSTRING(PC.Postcode,1,LEN(PC.Postcode)-3) 
	    END                                             as PostCode
	  ,ac.ApplicationLimitEnforced                      as ApplicationLimitEnforced_v1
	  ,ac.LastAccessedDate                              as LastAccessedDate_v1
	  ,ac.LastAccessedManageApplications                as LastAccessedManageApplications_v1
	  ,ac.BeingSupportedBy                              as BeingSupportedBy_v1
	  ,ac.LockedForSupportUntil                         as LockedForSupportUntil_v1
	  ,ac.AllowMarketingMessages                        as AllowMarketingMessages_v1
	  ,CAST(Fu.BinaryId as Varchar(256))                as CandidateGuid
	  ,CASE WHEN [DB].[DateOfBirth] IS NULL	THEN - 1
		      WHEN DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) > DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			    OR DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) = DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			   AND DATEPART([DD],dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) > DATEPART([DD], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			  THEN DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp)) - 1
		      ELSE DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
		END                                             as AgeAtRegistration
	  ,dbo.Fn_ConvertTimeStampToDateTime([fu].[ActivationTimeStamp]) as RegistrationDate
	  ,dbo.Fn_ConvertTimeStampToDateTime([fu].[LastLogInTimeStamp])  as LastAccessedDate
	  ,'FAA-Avms&Cosmos'                                             as SourceDb
	  ,ac.CandidateId                                                as SourceCandidateId_v1 
	  ,FU.BinaryId                                                   as SourceCandidateId_v2
   FROM Stg.FAA_Users FU
  INNER
   JOIN Stg.Avms_Candidate AC
     ON dbo.Fn_ConvertGuidToBase64(AC.CandidateGuid)=FU.BinaryId
   LEFT
   JOIN Stg.FAA_CandidatePostcode PC
     ON PC.CandidateId=FU.BinaryId
   LEFT
   JOIN Stg.FAA_CandidateDob Db
     ON Db.CandidateId=FU.BinaryId




   

     
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
	    'ImportVacanciesCandidateToPL',
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