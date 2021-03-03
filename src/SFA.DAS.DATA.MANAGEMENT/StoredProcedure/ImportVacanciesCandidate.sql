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
SELECT C.CandidateStatusTypeId
      ,CASE WHEN c.CandidateStatusTypeId=1 THEN 'Pre-Registered'
            WHEN c.CandidateStatusTypeId=2 THEN 'Activated'
			WHEN c.CandidateStatusTypeId=3 THEN 'Registered'
            WHEN c.CandidateStatusTypeId=4 THEN 'Suspended'
            WHEN c.CandidateStatusTypeId=5 THEN 'Pending Delete'
            WHEN c.CandidateStatusTypeId=6 THEN 'Deleted'
			ELSE 'Unknown'
		END
	   ,capc.PostCode
	   ,c.ApplicationLimitEnforced
	   ,c.LastAccessedDate
	   ,c.LastAccessedManageApplications
	   ,c.BeingSupportedBy
	   ,c.LockedForSupportUntil
	   ,c.AllowMarketingMessages
	   ,Cast(c.CandidateGuid as Varchar(256))
	   ,CAPC.AgeAtRegistration
	   ,convert(datetime2,ch.RegisteredDate)
	   ,convert(datetime2,c.LastAccessedDate)
	   ,'RAAv1'
	   ,c.CandidateId
	   ,CD.CandidateId
  FROM Stg.Avms_Candidate C
  LEFT
  JOIN Stg.FAA_Candidates CD
    ON CD.LegacyCandidateId=C.CandidateId
  left
  join (SELECT candidateId,EVENTDATE as RegisteredDate from Stg.Avms_candidatehistory where Comment='NAS Exemplar registered Candidate.') ch
    on c.CandidateId= ch.CandidateId
  left
  join Stg.Avms_CandidateAgePostCode CAPC
    ON CAPC.CandidateId=c.CandidateId
 union
 SELECT DISTINCT 
       -1
      ,'Registered'as CandidateStatusDesc
	  ,CASE WHEN CHARINDEX(' ',PC.Postcode)<>0 THEN SUBSTRING(PostCode,1,CHARINDEX(' ',Postcode)) 
	        ELSE SUBSTRING(Postcode,1,LEN(Postcode)-3) 
	    END as PostCode
	  ,NULL as ApplicationLimitEnforced
	  ,'' as LastAccessedDate
	  ,'' as LastAccessedManageApplications
	  ,'N/A' as BeingSupportedBy
	  ,'' as LockedForSupportUntil
	  ,NULL as AllowMarketingMessages
	  ,CAST(FC.CandidateId as Varchar(256))
	  ,CASE WHEN [DB].[DateOfBirth] IS NULL	THEN - 1
		      WHEN DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) > DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			    OR DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) = DATEPART([M], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			   AND DATEPART([DD],dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth])) > DATEPART([DD], dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
			  THEN DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp)) - 1
		      ELSE DATEDIFF(YEAR,dbo.Fn_ConvertTimeStampToDateTime([DB].[DateOfBirth]), dbo.Fn_ConvertTimeStampToDateTime(FU.ActivationTimeStamp))
		END   as AgeAtRegistration
	  ,dbo.Fn_ConvertTimeStampToDateTime([fu].[ActivationTimeStamp])
	  ,dbo.Fn_ConvertTimeStampToDateTime([fu].[LastLogInTimeStamp])
	  ,'RAAv2'
	  ,''
	  ,FC.CandidateId
   FROM Stg.FAA_Candidates FC
   LEFT
   JOIN Stg.FAA_CandidatePostcode PC
     ON PC.CandidateId=FC.CandidateId
   LEFT
   JOIN Stg.FAA_CandidateDob Db
     ON Db.CandidateId=FC.CandidateId
   LEFT
   JOIN Stg.FAA_Users FU
     ON FU.BinaryId=fc.CandidateId
  WHERE NOT EXISTS (SELECT 1 FROM Stg.Avms_Candidate AC
                     WHERE AC.CandidateId=FC.LegacyCandidateId)


   

     
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
