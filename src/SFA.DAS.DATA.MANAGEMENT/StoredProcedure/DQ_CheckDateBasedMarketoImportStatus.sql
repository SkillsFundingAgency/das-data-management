CREATE PROCEDURE [dbo].[DQ_CheckDateBasedMarketoImportStatus] (@RunId int)
AS
BEGIN TRY

    Declare @Status BIT = 0;

    Declare @FailedTasks VARCHAR(MAX);

    SELECT @FailedTasks = String_AGG(ADFTaskType, ', ')
    FROM [Mgmt].[MarketoLoadStatus]
    where CAST([transactiontime] AS DATE) = CAST(GETDATE() AS DATE)
          AND (
                  [StagingExecutionStatus] = 0
                  OR [PLExecutionStatus] = 0
              );

    IF (@FailedTasks IS NULL)
        SET @Status = 1;
	ELSE
		set @FailedTasks = CONCAT('Failed Tasks: ', @FailedTasks)

    EXEC [dbo].[LogDQCheckStatus] @RunId,
                                  'CheckDateBasedMarketoImportStatus',
                                  @Status,
                                  @FailedTasks;


END TRY
BEGIN CATCH

    DECLARE @ErrorId int

    INSERT INTO Mgmt.Log_Error_Details
    (
        UserName,
        ErrorNumber,
        ErrorState,
        ErrorSeverity,
        ErrorLine,
        ErrorProcedure,
        ErrorMessage,
        ErrorDateTime,
        RunId
    )
    SELECT SUSER_SNAME(),
           ERROR_NUMBER(),
           ERROR_STATE(),
           ERROR_SEVERITY(),
           ERROR_LINE(),
           'DQ_CheckDateBasedMarketoImportStatus',
           ERROR_MESSAGE(),
           GETDATE(),
           @RunId as RunId;

END CATCH

GO
