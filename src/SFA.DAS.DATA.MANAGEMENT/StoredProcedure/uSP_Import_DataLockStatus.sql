
CREATE PROCEDURE uSP_Import_DataLockStatus
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import DataLock Status Related Data 
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

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
	   ,'Step-5'
	   ,'uSP_Import_DataLockStatus'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get DataLockStatus Data into Temp Table */

 IF OBJECT_ID ('tempdb..#tDataLockStatus') IS NOT NULL
DROP TABLE #tDataLockStatus

  SELECT *
  INTO #tDataLockStatus
  FROM Comt.Ext_Tbl_DataLockStatus

    IF OBJECT_ID ('tempdb..#tSourceDataLock') IS NOT NULL
DROP TABLE #tSourceDataLock

 select  a.ID as ApprenticeshipId
       -- ,tc.ID as TrainingCourseId 
        ,tSD.DataLockEventId
        ,tSD.DataLockEventDateTime
        ,tSD.PriceEpisodeIdentifier 
        ,tSD.IlrTrainingCourseCode 
        ,tSD.IlrTrainingType
        ,tSD.IlrActualStartDate 
        ,tSD.IlrEffectiveFromDate 
        ,tSD.IlrPriceEffectiveToDate
        ,tSD.IlrTotalCost 
        ,tSD.ErrorCode
        ,tSD.Status as DataLockStatus
        ,tSD.TriageStatus
        ,tSD.IsResolved
        ,tSD.EventStatus
        ,tSD.IsExpired
        ,tSD.Expired as Expireddatetime
		,tSD.ID as Source_DataLockStatusId
  into  #tSourceDataLock 
  from  #tDataLockStatus tSD
  LEFT
  JOIN  dbo.Apprenticeship a
    ON  a.Source_ApprenticeshipId=tSD.ApprenticeshipId 
  --LEFT
  --JOIN  dbo.TrainingCourse tc
  --  ON  tc.TrainingCode=tSD.IlrTrainingCourseCode
  -- AND  tc.TrainingType=tSD.IlrTrainingType

/* Full Refresh Code */

TRUNCATE TABLE dbo.DataLockStatus

INSERT INTO dbo.DataLockStatus([DataLockEventId]
              ,[DataLockEventDatetime]
              ,[PriceEpisodeIdentifier]
              ,[ApprenticeshipId]
              ,[IlrTrainingCourseCode]
              ,[IlrTrainingType]
              ,[IlrActualStartDate]
              ,[IlrEffectiveFromDate]
              ,[IlrPriceEffectiveToDate]
              ,[IlrTotalCost]
              ,[ErrorCode]
              ,[DataLockStatus]
              ,[TriageStatus]
              ,[IsResolved]
              ,[EventStatus]
              ,[IsExpired]
              ,[ExpiredDateTime]
			  ,Data_Source
			  ,Source_DataLockStatusId) 
 SELECT Source.[DataLockEventId]
              ,Source.[DataLockEventDatetime]
              ,Source.[PriceEpisodeIdentifier]
              ,Source.[ApprenticeshipId]
              ,Source.[IlrTrainingCourseCode]
              ,Source.[IlrTrainingType]
              ,Source.[IlrActualStartDate]
              ,Source.[IlrEffectiveFromDate]
              ,Source.[IlrPriceEffectiveToDate]
              ,Source.[IlrTotalCost]
              ,Source.[ErrorCode]
              ,Source.[DataLockStatus]
              ,Source.[TriageStatus]
              ,Source.[IsResolved]
              ,Source.[EventStatus]
              ,Source.[IsExpired]
              ,Source.[ExpiredDateTime]
			  ,'Commitments-DataLockStatus'
			  ,Source.Source_DataLockStatusId
   FROM #tSourceDataLock Source




 /* Delta Code */  
/*
 MERGE dbo.DataLockStatus as Target
 USING #tSourceDataLock as Source
    ON Target.DataLockEventId=Source.DataLockEventId
  WHEN MATCHED AND ( Target.ApprenticeshipId<>Source.ApprenticeshipId
                --  OR Target.TrainingCourseId<>Source.TrainingCourseId
                  OR Target.DataLockEventId<>Source.DataLockEventId
                  OR Target.DataLockEventDateTime<>Source.DataLockEventDateTime
                  OR Target.PriceEpisodeIdentifier<>Source.PriceEpisodeIdentifier
                  OR Target.IlrTrainingCourseCode<>Source.IlrTrainingCourseCode
                  OR Target.IlrTrainingType<>Source.IlrTrainingType
                  OR Target.IlrActualStartDate<>Source.IlrActualStartDate
                  OR Target.IlrEffectiveFromDate<>Source.IlrEffectiveFromDate
                  OR Target.IlrPriceEffectiveToDate<>Source.IlrPriceEffectiveToDate
                  OR Target.IlrTotalCost<>Source.IlrTotalCost
                  OR Target.ErrorCode<>Source.ErrorCode
                  OR Target.DataLockStatus<>Source.DataLockStatus
                  OR Target.TriageStatus<>Source.TriageStatus
                  OR Target.IsResolved<>Source.IsResolved
                  OR Target.EventStatus<>Source.EventStatus
                  OR Target.IsExpired<>Source.IsExpired
                  OR Target.Expireddatetime<>Source.Expireddatetime
				  OR Target.Source_DataLockStatusId<>Source.Source_DataLockStatusId
				  )
  THEN UPDATE SET Target.ApprenticeshipId=Source.ApprenticeshipId
            --     ,Target.TrainingCourseId=Source.TrainingCourseId
                 ,Target.DataLockEventId=Source.DataLockEventId
                 ,Target.DataLockEventDateTime=Source.DataLockEventDateTime
                 ,Target.PriceEpisodeIdentifier=Source.PriceEpisodeIdentifier
                 ,Target.IlrTrainingCourseCode=Source.IlrTrainingCourseCode
                 ,Target.IlrTrainingType=Source.IlrTrainingType
                 ,Target.IlrActualStartDate=Source.IlrActualStartDate
                 ,Target.IlrEffectiveFromDate=Source.IlrEffectiveFromDate
                 ,Target.IlrPriceEffectiveToDate=Source.IlrPriceEffectiveToDate
                 ,Target.IlrTotalCost=Source.IlrTotalCost
                 ,Target.ErrorCode=Source.ErrorCode
                 ,Target.DataLockStatus=Source.DataLockStatus
                 ,Target.TriageStatus=Source.TriageStatus
                 ,Target.IsResolved=Source.IsResolved
                 ,Target.EventStatus=Source.EventStatus
                 ,Target.IsExpired=Source.IsExpired
                 ,Target.Expireddatetime=Source.Expireddatetime
				 ,Target.Source_DataLockStatusId=Source.Source_DataLockStatusId
                 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT ([DataLockEventId]
              ,[DataLockEventDatetime]
              ,[PriceEpisodeIdentifier]
              ,[ApprenticeshipId]
              ,[IlrTrainingCourseCode]
              ,[IlrTrainingType]
              ,[IlrActualStartDate]
              ,[IlrEffectiveFromDate]
              ,[IlrPriceEffectiveToDate]
              ,[IlrTotalCost]
              ,[ErrorCode]
              ,[DataLockStatus]
              ,[TriageStatus]
              ,[IsResolved]
              ,[EventStatus]
              ,[IsExpired]
              ,[ExpiredDateTime]
			  ,Data_Source
			  ,Source_DataLockStatusId) 
       VALUES (Source.[DataLockEventId]
              ,Source.[DataLockEventDatetime]
              ,Source.[PriceEpisodeIdentifier]
              ,Source.[ApprenticeshipId]
              ,Source.[IlrTrainingCourseCode]
              ,Source.[IlrTrainingType]
              ,Source.[IlrActualStartDate]
              ,Source.[IlrEffectiveFromDate]
              ,Source.[IlrPriceEffectiveToDate]
              ,Source.[IlrTotalCost]
              ,Source.[ErrorCode]
              ,Source.[DataLockStatus]
              ,Source.[TriageStatus]
              ,Source.[IsResolved]
              ,Source.[EventStatus]
              ,Source.[IsExpired]
              ,Source.[ExpiredDateTime]
			  ,'Commitments-DataLockStatus'
			  ,Source.Source_DataLockStatusId
	          );
 */
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
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
	  ,Run_Id
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'uSP_Import_DataLockStatus',
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
