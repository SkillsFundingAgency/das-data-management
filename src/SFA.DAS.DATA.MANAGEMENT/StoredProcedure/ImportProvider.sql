
CREATE PROCEDURE ImportProvider
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import Provider Related Data 
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
	   ,'ImportProvider'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportProvider'
     AND RunId=@RunID

  /* Get Provider Data into Temp Table */

 /* Code for Full Refresh */

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

 INSERT INTO dbo.Provider
 (Ukprn,ProviderName,RunId)
 SELECT Ukprn,Name,@RunId
   FROM Comt.Ext_Tbl_Providers
COMMIT TRANSACTION
END





/* Code for Delta */

/* MERGE dbo.Provider as Target
 USING dbo.Ext_Tbl_Providers as Source
    ON Target.Ukprn=Source.Ukprn
  WHEN MATCHED AND Target.Ukprn<>Source.Ukprn
  THEN UPDATE SET Target.ProviderName=Source.Name
                 ,Target.Asdm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (Ukprn,ProviderName) 
       VALUES (Source.Ukprn, Source.[Name]);

*/
 
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
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
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'ImportProvider',
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
