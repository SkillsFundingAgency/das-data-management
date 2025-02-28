CREATE PROCEDURE [dbo].[UpdateEVSTables]
(
    @RunId INT
)
AS
BEGIN TRY
    SET NOCOUNT ON;

    DECLARE @LogID INT;

    -- Start Logging Execution
    INSERT INTO Mgmt.Log_Execution_Results
    (
        RunId,
        StepNo,
        StoredProcedureName,
        StartDateTime,
        Execution_Status
    )
    SELECT 
        @RunId,
        'Step-6',
        'UpdateEVSTables',
        GETDATE(),
        0;

    SELECT @LogID = MAX(LogId)
    FROM Mgmt.Log_Execution_Results
    WHERE StoredProcedureName = 'UpdateEVSTables'
      AND RunId = @RunId;

  -- Begin Transaction
    DECLARE @IsLocalTransaction BIT = 0;

    IF @@TRANCOUNT = 0
    BEGIN
        SET @IsLocalTransaction = 1;
        BEGIN TRANSACTION;
    END

        -- Check and process each table
    IF OBJECT_ID('Asdata_PL.EVS_EmploymentVerification', 'U') IS NOT NULL
    BEGIN
      ;WITH EVS_UP AS (
            SELECT 
        [EmploymentVerificationId], 
        [CorrelationId], 
        [ApprenticeshipId], 
        [Employed], 
        [EmploymentCheckDate], 
        [EmploymentCheckRequestDate], 
        [RequestCompletionStatus], 
        [ErrorType], 
        [MessageSentDate], 
        [MinDate], 
        [MaxDate], 
        [CheckTypeId], 
        [CreatedOn], 
        [LastUpdatedOn]
    FROM [ASData_PL].[EVS_EmploymentVerification]

    EXCEPT

    SELECT 
        [EmploymentVerificationId], 
        [CorrelationId], 
        [ApprenticeshipId], 
        [Employed], 
        [EmploymentCheckDate], 
        [EmploymentCheckRequestDate], 
        [RequestCompletionStatus], 
        [ErrorType], 
        [MessageSentDate], 
        [MinDate], 
        [MaxDate], 
        [CheckTypeId], 
        [CreatedOn], 
        [LastUpdatedOn]
    FROM [Stg].[EVS_EmploymentVerification]

        )

UPDATE EVS
SET ISDeleted = 1
FROM [ASData_PL].[EVS_EmploymentVerification] EVS
INNER JOIN EVS_UP ON EVS.EmploymentVerificationId = EVS_UP.EmploymentVerificationId;
;

END


IF OBJECT_ID('Asdata_PL.EVS_ScheduledEmploymentVerification', 'U') IS NOT NULL
    BEGIN
      ;
With tab as (
SELECT 
    [ScheduledEmploymentVerificationId],
    [CommitmentId], 
    [ApprenticeshipId], 
    [ULN], 
    [UKPRN], 
    [EmployerAccountId], 
    [CommitmentStartDate], 
    [CommitmentStatusId], 
    [PaymentStatusId], 
    [ApprovalsStatusId], 
    [EmployerAndProviderApprovedOn], 
    [TransferApprovalActionedOn], 
    [EmploymentCheckCount], 
    [LastUpdatedOn]
FROM [ASData_PL].[EVS_ScheduledEmploymentVerification]
EXCEPT
SELECT 
    [ScheduledEmploymentVerificationId],
    [CommitmentId], 
    [ApprenticeshipId], 
    [ULN], 
    [UKPRN], 
    [EmployerAccountId], 
    [CommitmentStartDate], 
    [CommitmentStatusId], 
    [PaymentStatusId], 
    [ApprovalsStatusId], 
    [EmployerAndProviderApprovedOn], 
    [TransferApprovalActionedOn], 
    [EmploymentCheckCount], 
    [LastUpdatedOn]
FROM [Stg].[EVS_ScheduledEmploymentVerification]
) 

UPDATE SEV_UP
SET ISDeleted = 1
FROM [ASData_PL].[EVS_ScheduledEmploymentVerification] SEV
INNER JOIN SEV_UP ON SEV.[ScheduledEmploymentVerificationId] = SEV_UP.[ScheduledEmploymentVerificationId]
;

END



END TRY
BEGIN CATCH
    -- Rollback Transaction
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Log Error
    DECLARE @ErrorId INT;

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
    SELECT 
        SUSER_SNAME(),
        ERROR_NUMBER(),
        ERROR_STATE(),
        ERROR_SEVERITY(),
        ERROR_LINE(),
        'UpdateEVSTables',
        ERROR_MESSAGE(),
        GETDATE(),
        @RunId;

    SELECT @ErrorId = MAX(ErrorId)
    FROM Mgmt.Log_Error_Details;

    -- Update Log Execution Results as Fail
    UPDATE Mgmt.Log_Execution_Results
    SET Execution_Status = 0,
        EndDateTime = GETDATE(),
        ErrorId = @ErrorId
    WHERE LogId = @LogID
      AND RunId = @RunId;
END CATCH;
