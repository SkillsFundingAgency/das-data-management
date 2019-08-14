CREATE PROCEDURE [dbo].[ImportTrainingCourse]
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import TrainingCourse Related Data 
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @LogID int

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    Run_Id
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-2'
	   ,'ImportTrainingCourse'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportTrainingCourse'
     AND Run_Id=@RunID

  /* Get AssessmentOrganisation Data into Temp Table */

IF OBJECT_ID ('tempdb..#tTrainingCourse') IS NOT NULL
DROP TABLE #tTrainingCourse

  SELECT DISTINCT 
         TrainingType
        ,TrainingCode
		,TrainingName
    INTO #tTrainingCourse
    FROM Comt.Ext_Tbl_Apprenticeship

/* Full Refresh Code */

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

INSERT INTO dbo.TrainingCourse(TrainingType,TrainingCode,TrainingName,Data_Source,RunId) 
SELECT Source.TrainingType,Source.TrainingCode,Source.TrainingName,'Commitments-Apprenticeship',@RunId
  FROM #tTrainingCourse Source

COMMIT TRANSACTION
END





	/* Delta Code */
	/*
 MERGE dbo.TrainingCourse as Target
 USING #tTrainingCourse as Source
    ON Target.TrainingCode=Source.TrainingCode
  WHEN MATCHED AND ( Target.TrainingType<>Source.TrainingType
                  OR Target.TrainingName<>Source.TrainingName
				  )
  THEN UPDATE SET Target.TrainingType=Source.TrainingType
                 ,Target.TrainingName=Source.TrainingName
                 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (TrainingType,TrainingCode,TrainingName,Data_Source) 
       VALUES (Source.TrainingType,Source.TrainingCode,Source.TrainingName,'Commitments-Apprenticeship');
 */
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND Run_ID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
	    'ImportTrainingCourse',
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
   AND Run_ID=@RunId

  END CATCH

GO
