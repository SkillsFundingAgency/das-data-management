CREATE PROCEDURE [dbo].[PopulateMetadataForRefreshDataset]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 28/05/2020
-- Description: Populate Metadata Table with Source Config for Import 
-- =========================================================================
*/

BEGIN TRY


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
	   ,'Step-3'
	   ,'PopulateMetadataForRefreshDataset'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='PopulateMetadataForRefreshDataset'
     AND RunId=@RunID

BEGIN TRANSACTION

--DELETE FROM [Mtd].[RefreshDatasetConfig]

IF OBJECT_ID ('tempdb..#tRefreshDatasetConfig') IS NOT NULL
DROP TABLE #tRefreshDatasetConfig

SELECT *
  INTO #tRefreshDatasetConfig
  FROM Mtd.RefreshDatasetConfig
 WHERE 1=0



INSERT INTO [Mtd].[RefreshDatasetConfig](ILRSnapshotReference,Dataset,PaymentsExtractionDate,DatamartRefreshDate)
SELECT ILRSnapshotReference,Dataset,PaymentsExtractionDate,DatamartRefreshDate
  FROM #tRefreshDatasetConfig tRDC
 WHERE NOT EXISTS (SELECT 1
                     FROM Mtd.[RefreshDatasetConfig] RDC
					WHERE RDC.PaymentsExtractionDate=tRDC.PaymentsExtractionDate
					)

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
	    'PopulateMetadataForRefreshDataset',
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