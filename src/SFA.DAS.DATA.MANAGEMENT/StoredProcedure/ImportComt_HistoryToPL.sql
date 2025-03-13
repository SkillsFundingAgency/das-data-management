CREATE PROCEDURE [dbo].[ImportComt_HistoryToPL]
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
	   ,'Step-6'
	   ,'ImportComt_HistoryToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportComt_HistoryToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

 /* Import Commitments History to PL */

DECLARE @VSQL1 NVARCHAR(MAX)

SET @VSQL1='
 
INSERT INTO [ASData_PL].[Comt_History] 
           ([ID]
           ,[EntityType]
           ,[EntityId]
           ,[CommitmentId]
           ,[ApprenticeshipId]
           ,[UpdatedByRole]
           ,[ChangeType]
           ,[CreatedOn]
           ,[ProviderId]
           ,[EmployerAccountId]
           ,[OriginalState_PaymentStatus]
           ,[UpdatedState_PaymentStatus]
           ,[CorrelationId]
           ,[AsDm_UpdatedDateTime]
           ,[IsRetentionApplied]
           ,[RetentionAppliedDate])
SELECT s.[ID]
      ,s.[EntityType]
      ,s.[EntityId]
      ,s.[CommitmentId]
      ,s.[ApprenticeshipId]
      ,s.[UpdatedByRole]
      ,s.[ChangeType]
      ,s.[CreatedOn]
      ,s.[ProviderId]
      ,s.[EmployerAccountId]
      ,s.[OriginalState_PaymentStatus]
      ,s.[UpdatedState_PaymentStatus]
      ,s.[CorrelationId]
      ,s.[AsDm_UpdatedDateTime]
      ,s.[IsRetentionApplied]
      ,s.[RetentionAppliedDate]
FROM [Stg].[Comt_History] s
WHERE NOT EXISTS (
    SELECT 1 
    FROM [ASData_PL].[Comt_History] t
    WHERE s.ID = t.ID
);

'

EXEC SP_EXECUTESQL @VSQL1

  /* Drop Staging Table as it's no longer required */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_History' AND TABLE_SCHEMA=N'Stg') 
DROP TABLE [Stg].Comt_History


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

	/* Drop Staging Table even if it fails */

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_history' AND TABLE_SCHEMA=N'Stg')
     DROP TABLE [Stg].Comt_History

	

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
	    'ImportComt_HistoryToPL',
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

