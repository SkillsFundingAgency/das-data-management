CREATE PROCEDURE [dbo].[ImportVacanciesApprenticeshipFrameworkStandardELToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import Vacancies Employer Data from v1 and v2
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
	   ,'ImportVacanciesApprenticeshipFrameworkStandardELToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesApprenticeshipFrameworkStandardELToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_ApprenticeshipFrameWorkAndOccupation
-- TRUNCATE TABLE AsData_PL.Va_ApprenticeshipStandard
-- TRUNCATE TABLE AsData_PL.Va_EducationLevel

/* Load Framework into Presentation Layer */

INSERT INTO [ASData_PL].[Va_ApprenticeshipFrameWorkAndOccupation]
           ([SourceApprenticeshipFrameworkId]
           ,[ProgrammeId_v2]
           ,[SourceDb]
           ,[ApprenticeshipOccupationId]
           ,[FrameworkCodeName]
           ,[FrameworkShortName]
           ,[FrameWorkFullName]
           ,[FrameworkTitle_v2]
           ,[ApprenticeshipFrameworkStatus]
           ,[FrameworkClosedDate]
           ,[PreviousApprenticeshipOccupationId]
           ,[StandardId]
           ,[ApprenticeshipOccupationCodeName]
           ,[ApprenticeshipOccupationShortName]
           ,[ApprenticehipOccupationFullName]
           ,[ApprenticeshipOccupationStatus]
           ,[ApprenticeshipOccupationClosedDate])
SELECT AF.ApprenticeshipFrameworkId  as ApprenticeshipFrameworkId
      ,'N/A'                         as ProgrammeId_v2
	  ,'RAAv1'                       as SourceDb
	  ,AO.ApprenticeshipOccupationId as ApprenticeshipOccupationId
	  ,AF.CodeName                   as FrameworkCodeName
	  ,AF.ShortName                  as FrameworkShortName
	  ,AF.FullName                   as FrameworkFullName
	  ,'N/A'                         as FrameworkTitle_v2
	  ,AFST.ShortName                as FrameworkStatus
	  ,AF.ClosedDate                 as FrameworkClosedDate
	  ,AF.PreviousApprenticeshipOccupationId as PreviousApprenticeshipOccupationId
	  ,AF.StandardId                 as StandardId
	  ,AO.Codename                   as ApprenticeshipOccupationCodeName
	  ,AO.ShortName                  as ApprenticeshipOccupationShortName
	  ,AO.FullName                   as ApprenticeshipOccupationFullName
	  ,AOST.FullName                 as ApprenticeshipOccupationStatus
	  ,AO.ClosedDate                 as ApprenticeshipOccupationClosedDate
  FROM Stg.Avms_ApprenticeshipFramework AF 
  JOIN Stg.Avms_ApprenticeshipOccupation AO 
    ON AO.ApprenticeshipOccupationId=AF.ApprenticeshipOccupationId
  LEFT
  JOIN Stg.Avms_ApprenticeshipFrameworkStatusType AFST
    ON AFST.ApprenticeshipFrameworkStatusTypeId=AF.ApprenticeshipFrameworkStatusTypeId
  LEFT
  JOIN Stg.Avms_ApprenticeshipOccupationStatusType AOST
    ON AOST.ApprenticeshipOccupationStatusTypeId=AO.ApprenticeshipOccupationStatusTypeId
 UNION
SELECT ap.SourseSK                                 as ApprenticeshipFrameworkId
      ,ap.ProgrammeId                              as ProgrammeId_v2
	  ,'RAAv2'                                     as SourceDb
	  ,AO.ApprenticeshipOccupationId               as ApprenticeshipOccupationId
	  ,AF.CodeName                                 as FrameworkCodeName
	  ,AF.ShortName                                as FrameworkShortName
	  ,AF.FullName                                 as FrameworkFullName
	  ,ap.Title                                    as FrameworkTitle
	  ,AFST.ShortName                              as FrameworkStatus
	  ,AF.ClosedDate                               as FrameworkClosedDate
	  ,AF.PreviousApprenticeshipOccupationId       as PreviousApprenticeshipOccupationId
	  ,AF.StandardId                               as StandardId
	  ,AO.Codename                                 as ApprenticeshipOccupationCodeName   
	  ,AO.ShortName                                as ApprenticeshipOccupationShortName
	  ,AO.FullName                                 as ApprenticeshipOccupationFullName
	  ,AOST.FullName                               as ApprenticeshipOccupationStatus
	  ,AO.ClosedDate                               as ApprenticeshipOccupationClosedDate
  FROM Stg.RAA_ReferenceDataApprenticeshipProgrammes AP
  LEFT
  JOIN Stg.Avms_ApprenticeshipFramework AF 
    ON AF.CodeName=SUBSTRING(AP.ProgrammeId,1,3)
   AND AP.ApprenticeshipType='Framework'
  JOIN Stg.Avms_ApprenticeshipOccupation AO 
    ON AO.ApprenticeshipOccupationId=AF.ApprenticeshipOccupationId
  LEFT
  JOIN Stg.Avms_ApprenticeshipFrameworkStatusType AFST
    ON AFST.ApprenticeshipFrameworkStatusTypeId=AF.ApprenticeshipFrameworkStatusTypeId
  LEFT
  JOIN Stg.Avms_ApprenticeshipOccupationStatusType AOST
    ON AOST.ApprenticeshipOccupationStatusTypeId=AO.ApprenticeshipOccupationStatusTypeId

/* Load Standard Into Presentation Layer */

-- INSERT INTO [ASData_PL].[Va_ApprenticeshipStandard]
--            ([StandardId]
--            ,[LarsCode]
--            ,[StandardFullName]
--            ,[StandardSectorId]
--            ,[StandardSectorName]
--            ,[LarsStandardSectorCode]
--            ,[ApprenticeshipOccupationId]
--            ,[EducationLevelId]
--            ,[ApprenticeshipFrameworkStatusType])
-- SELECT  ST.StandardId               as StandardId
--        ,ST.LarsCode                 as LarsCode
--        ,ST.FullName                 as StandardFullName 
-- 	   ,ST.StandardSectorId         as StandardSectorId
-- 	   ,SS.FullName                 as StandardFullName
-- 	   ,SS.[LarsStandardSectorCode] as LarsStandardSectorCode
-- 	   ,SS.ApprenticeshipOccupationId as ApprenticeshipOccupationId
-- 	   ,ST.EducationLevelId         as EducationLevelId
-- 	   ,AFST.FullName               as ApprenticeshipFrameworkStatusType
--   FROM Stg.Avms_Standard ST 
--   JOIN Stg.Avms_StandardSector SS 
--     ON ST.StandardSectorId=SS.StandardSectorId
--   LEFT
--   JOIN Stg.Avms_ApprenticeshipFrameworkStatusType AFST
--     ON AFST.ApprenticeshipFrameworkStatusTypeId=ST.ApprenticeshipFrameworkStatusTypeId

/* Load Education Level Into Presentation Layer */

-- INSERT INTO [ASData_PL].[Va_EducationLevel]
--            ([EducationLevelId]
--            ,[EducationLevelCodeName]
--            ,[EducationLevelShortName]
--            ,[EducationLevelFullName]
-- 		   ,[EducationLevelNamev2])
-- SELECT EducationLevelId
--       ,EducationLevelCodeName
-- 	  ,EducationLevelShortName
-- 	  ,EducationLevelFullName
-- 	  ,CASE WHEN EducationLevelCodeName=2 THEN 'Level 2 (GCSE)'
--             WHEN EducationLevelCodeName=3 THEN 'Level 3 (A level)'
--         	WHEN EducationLevelCodeName=4 THEN 'Level 4 (Higher national certificate)'
-- 			WHEN EducationLevelCodeName=5 THEN 'Level 5 (Higher national diploma)'
-- 	        WHEN EducationLevelCodeName=6 THEN 'Level 6 (Degree with honours)'
-- 		    WHEN EducationLevelCodeName=7 THEN 'Level 7 (Master''s degree)'
-- 	     	ELSE ''
-- 		END as EducationLevelNamev2
-- FROM
-- (SELECT EducationLevelId,CodeName as EducationLevelCodeName,ShortName as EducationLevelShortName,FullName as EducationLevelFullName
--    FROM Stg.Avms_EducationLevel
--   UNION
--  SELECT 998,5,5,'Higher'
--   WHERE NOT EXISTS (SELECT 1 FROM ASData_PL.Va_EducationLevel vel5
--                      WHERE vel5.EducationLevelCodeName=5)  -- Level5
--   UNION 
--  SELECT 999,7,7,'Degree'
--   WHERE NOT EXISTS (SELECT 1 FROM ASData_PL.Va_EducationLevel vel7
--                      WHERE vel7.EducationLevelCodeName=7)   -- Level7
--  ) EL



  






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
	    'ImportVacanciesApprenticeshipFrameworkStandardELToPL',
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
