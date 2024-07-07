CREATE PROCEDURE [StgPmts].[ImportJob]
    @AcademicYear SMALLINT,
    @CollectionPeriod TINYINT,
    @RunId int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Begin Transaction
        BEGIN TRANSACTION;

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

        -- Delete existing data
        DELETE FROM [StgPmts].[Job]
        WHERE [AcademicYear] = @AcademicYear
          AND [CollectionPeriod] = @CollectionPeriod;

        -- Insert data from StgPmts.stg_Job
        INSERT INTO [StgPmts].[Job] (
            [JobId],
            [JobType],
            [StartTime],
            [EndTime],
            [Status],
            [CreationDate],
            [DCJobId],
            [Ukprn],
            [IlrSubmissionTime],
            [LearnerCount],
            [AcademicYear],
            [CollectionPeriod],
            [DataLocksCompletionTime],
            [DCJobSucceeded],
            [DCJobEndTime]
        )
        SELECT 
            [JobId],
            [JobType],
            [StartTime],
            [EndTime],
            [Status],
            [CreationDate],
            [DCJobId],
            [Ukprn],
            [IlrSubmissionTime],
            [LearnerCount],
            [AcademicYear],
            [CollectionPeriod],
            [DataLocksCompletionTime],
            [DCJobSucceeded],
            [DCJobEndTime]
        FROM [StgPmts].[stg_Job]
        WHERE [AcademicYear] = @AcademicYear
          AND [CollectionPeriod] = @CollectionPeriod;

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