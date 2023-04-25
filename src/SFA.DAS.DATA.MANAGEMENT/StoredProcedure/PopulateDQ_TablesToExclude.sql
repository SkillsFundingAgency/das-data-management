CREATE PROCEDURE [dbo].[PopulateDQ_TablesToExclude]
(
   @RunId int
)
AS

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
	   ,'PopulateDQ_TablesToExclude'
	   ,getdate()
	   ,0

SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
WHERE StoredProcedureName='PopulateDQ_TablesToExclude'
    AND RunId=@RunId
	
BEGIN TRANSACTION

DELETE FROM [Mgmt].[DQ_TablesToExclude]

INSERT INTO [Mgmt].[DQ_TablesToExclude]
           (SchemaName,TableName)
     VALUES	
('ASData_PL', 'Assessor_MergeOrganisations')
,('ASData_PL', 'Assessor_MergeOrganisationStandard')
,('ASData_PL', 'Assessor_MergeOrganisationStandardDeliveryArea')
,('ASData_PL', 'Assessor_MergeOrganisationStandardVersion')


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
	    'PopulateDQ_TablesToExclude',
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