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

DELETE FROM [Mtd].[RefreshDatasetConfig]

INSERT INTO [Mtd].[RefreshDatasetConfig](ILRSnapshotReference,Dataset,PaymentsExtractionDate,DatamartRefreshDate)
Values  ('R01','Payments','11-September-2020','12-September-2020'),
		('R02','Payments','08-October-2020','09-October-2020'),
		('R03','Payments','09-November-2020','10-November-2020'),
		('R04','Payments','08-December-2020','09-December-2020'),
		('R05','Payments','11-January-2021','12-January-2021'),
		('R06','Payments','08-February-2021','09-February-2021'),
		('R07','Payments','08-March-2021','09-March-2021'),
		('R08','Payments','12-April-2021','13-April-2021'),
		('R09','Payments','11-May-2021','12-May-2021'),
		('R10','Payments','08-June-2021','09-June-2021'),
		('R11','Payments','08-July-2021','09-July-2021'),
		('R12','Payments','09-August-2021','10-August-2021'),
		('R13','Payments','16-September-2021','17-September-2021'),
		('R14','Payments','27-October-2021','28-October-2021')

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