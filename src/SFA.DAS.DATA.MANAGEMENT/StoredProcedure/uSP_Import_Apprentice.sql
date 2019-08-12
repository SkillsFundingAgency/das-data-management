CREATE PROCEDURE [dbo].[uSP_Import_Apprentice]
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import Apprentice Related Data 
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
	   ,'Step-2'
	   ,'uSP_Import_Apprentice'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get AssessmentOrganisation Data into Temp Table */

IF OBJECT_ID ('tempdb..#tApprentice') IS NOT NULL
DROP TABLE #tApprentice

  SELECT DISTINCT 
         FirstName
		,LastName
		,ULN
		,DateOfBirth
		,NINumber
  INTO #tApprentice
  FROM Comt.Ext_Tbl_Apprenticeship

/* Full Refresh Code */

TRUNCATE TABLE dbo.Apprentice


INSERT INTO dbo.Apprentice(FirstName,LastName,DateOfBirth,NINumber,ULN,Data_Source) 
SELECT Source.FirstName,Source.LastName,Source.DateOfBirth,Source.NINumber,ULN,'Commitments-Apprenticeship'
  FROM #tApprentice Source






  /* Delta Code */
  /*
 MERGE dbo.Apprentice as Target
 USING #tApprentice as Source
    ON Target.ULN=Source.ULN
  WHEN MATCHED AND ( Target.FirstName<>Source.FirstName
                  OR Target.LastName<>Source.LastName
				  OR Target.DateOfBirth<>Source.DateOfBirth
				  OR Target.NINumber<>Source.NINumber
				  )
  THEN UPDATE SET Target.FirstName=Source.FirstName
                 ,Target.LastName=Source.LastName
				 ,Target.DateOfBirth=Source.DateOfBirth
				 ,Target.NINumber=Source.NINumber
                 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (FirstName,LastName,DateOfBirth,NINumber,ULN,Data_Source) 
       VALUES (Source.FirstName,Source.LastName,Source.DateOfBirth,Source.NINumber,ULN,'Commitments-Apprenticeship');
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
	    'uSP_Import_Apprentice',
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
