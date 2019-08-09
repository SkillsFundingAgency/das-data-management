CREATE PROCEDURE [dbo].[uSP_Import_AssessmentOrganisation]
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import AssessmentOrganisation Related Data 
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
	   ,'uSP_Import_AssessmentOrganisation'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get AssessmentOrganisation Data into Temp Table */

  IF OBJECT_ID ('tempdb..#tAssessmentOrganisation') IS NOT NULL
DROP TABLE #tAssessmentOrganisation

  SELECT EPAOrgId AS EPAOId
        ,Name AS EPAO_Name
		,ID as Source_EPAOID
    INTO #tAssessmentOrganisation
    FROM Comt.Ext_Tbl_AssessmentOrganisation

/* Full Refresh Code */

TRUNCATE TABLE dbo.AssessmentOrganisation

INSERT INTO dbo.AssessmentOrganisation(EPAOId,EPAO_Name,Source_EPAOID,Data_Source)
SELECT Source.EPAOId,Source.EPAO_Name,Source_EPAOID,'Commitments-AssessmentOrganisation'
  FROM #tAssessmentOrganisation Source





/* Delta Code */
/*
 MERGE dbo.AssessmentOrganisation as Target
 USING #tAssessmentOrganisation as Source
    ON Target.EPAOId=Source.EPAOId
  WHEN MATCHED AND ( Target.EPAO_Name<>Source.EPAO_Name
                  OR Target.Source_EPAOID<>Source.Source_EPAOID
				    )
  THEN UPDATE SET Target.EPAO_Name=Source.EPAO_Name
                 ,Target.Source_EPAOID=Source.Source_EPAOID
                 ,Target.Asdm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (EPAOId,EPAO_Name,Source_EPAOID,Data_Source)
       VALUES (Source.EPAOId,Source.EPAO_Name,Source_EPAOID,'Commitments-AssessmentOrganisation')
        ;
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
	    'uSP_Import_AssessmentOrganisation',
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
