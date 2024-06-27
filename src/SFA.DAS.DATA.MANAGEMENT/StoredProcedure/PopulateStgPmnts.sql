CREATE PROCEDURE [dbo].[PopulateStgPmnts]
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
	   ,'PopulateStgPmnts'
	   ,getdate()
	   ,0

SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
WHERE StoredProcedureName='PopulateStgPmnts'
    AND RunId=@RunId
	
BEGIN TRANSACTION

DELETE FROM [Mgmt].[Config_StgPmnts]

INSERT INTO [Mgmt].[Config_StgPmnts]
           (SourceDBName, SourceTable, DestSchema, DestTable, LoadType, WhereClause)
     VALUES	
('DASPayments','[Payments2].[Apprenticeship]','[StgPmts]','[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[ApprenticeshipPause]','[StgPmts]','[Apprenticeship]','Full','')
/*,('DASPayments','[Payments2].[ApprenticeshipPriceEpisode]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[ApprenticeshipStatus]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[EmployerProviderPriority]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[Job]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[JobStatus]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[JobType]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[LevyAccount]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[Payment]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[ProviderAdjustmentPayments]','[StgPmts].[Apprenticeship]','Full','')
,('DASPayments','[Payments2].[SubmittedLearnerAim]','[StgPmts].[Apprenticeship]','Full','')*/




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
	    'PopulateStgPmnts',
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