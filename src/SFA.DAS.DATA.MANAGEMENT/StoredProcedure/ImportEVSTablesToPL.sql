CREATE PROCEDURE [dbo].[ImportEVSTablesToPL]
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
        'ImportEVSTablesToPL',
        GETDATE(),
        0;

    SELECT @LogID = MAX(LogId)
    FROM Mgmt.Log_Execution_Results
    WHERE StoredProcedureName = 'ImportEVSTablesToPL'
      AND RunId = @RunId;

    -- Begin Transaction
    DECLARE @IsLocalTransaction BIT = 0;

    IF @@TRANCOUNT = 0
    BEGIN
        SET @IsLocalTransaction = 1;
        BEGIN TRANSACTION;
    END

    -- Check and process each table
    IF OBJECT_ID('stg.EVS_AdhocEmploymentVerification', 'U') IS NOT NULL
    BEGIN
        -- MERGE logic for stg.EVS_AdhocEmploymentVerification
        ;WITH NewAVS AS (
            SELECT
                SRC.AdhocEmploymentVerificationId,
                SRC.CorrelationId,
                SRC.ApprenticeshipId,
                SRC.ULN,
                SRC.EmployerAccountId,
                SRC.MinDate,
                SRC.MaxDate,
                SRC.CreatedOn
            FROM stg.EVS_AdhocEmploymentVerification SRC
            LEFT JOIN ASData_PL.EVS_AdhocEmploymentVerification TGT
                ON SRC.AdhocEmploymentVerificationId = TGT.AdhocEmploymentVerificationId
            WHERE TGT.AdhocEmploymentVerificationId IS NULL
        )
        MERGE ASData_PL.EVS_AdhocEmploymentVerification AS TGT
        USING NewAVS AS SRC
        ON 1 = 0 -- Prevent updates by ensuring no match
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                AdhocEmploymentVerificationId,
                CorrelationId,
                ApprenticeshipId,
                ULN,
                EmployerAccountId,
                MinDate,
                MaxDate,
                CreatedOn,
                AsDm_UpdatedDateTime
            )
            VALUES (
                SRC.AdhocEmploymentVerificationId,
                SRC.CorrelationId,
                SRC.ApprenticeshipId,
                SRC.ULN,
                SRC.EmployerAccountId,
                SRC.MinDate,
                SRC.MaxDate,
                SRC.CreatedOn,
                GETDATE()
            );
    END

    IF OBJECT_ID('stg.EVS_EmploymentVerification', 'U') IS NOT NULL
    BEGIN
        -- MERGE logic for stg.EVS_EmploymentVerification
        ;WITH NewEVS AS (
            SELECT
                SRC.EmploymentVerificationId,
                SRC.CorrelationId,
                SRC.ApprenticeshipId,
                SRC.Employed,
                SRC.EmploymentCheckDate,
                SRC.EmploymentCheckRequestDate,
                SRC.RequestCompletionStatus,
                SRC.ErrorType,
                SRC.MessageSentDate,
                SRC.MinDate,
                SRC.MaxDate,
                SRC.CheckTypeId,
                SRC.CreatedOn,
                SRC.LastUpdatedOn
            FROM stg.EVS_EmploymentVerification SRC
        )
        MERGE ASData_PL.EVS_EmploymentVerification AS TGT
        USING NewEVS AS SRC
        ON TGT.EmploymentVerificationId = SRC.EmploymentVerificationId
        WHEN MATCHED AND SRC.LastUpdatedOn > TGT.LastUpdatedOn THEN
            UPDATE SET
                TGT.CorrelationId = SRC.CorrelationId,
                TGT.ApprenticeshipId = SRC.ApprenticeshipId,
                TGT.Employed = SRC.Employed,
                TGT.EmploymentCheckDate = SRC.EmploymentCheckDate,
                TGT.EmploymentCheckRequestDate = SRC.EmploymentCheckRequestDate,
                TGT.RequestCompletionStatus = SRC.RequestCompletionStatus,
                TGT.ErrorType = SRC.ErrorType,
                TGT.MessageSentDate = SRC.MessageSentDate,
                TGT.MinDate = SRC.MinDate,
                TGT.MaxDate = SRC.MaxDate,
                TGT.CheckTypeId = SRC.CheckTypeId,
                TGT.CreatedOn = SRC.CreatedOn,
                TGT.LastUpdatedOn = SRC.LastUpdatedOn,
                TGT.AsDm_UpdatedDateTime = GETDATE()
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                EmploymentVerificationId,
                CorrelationId,
                ApprenticeshipId,
                Employed,
                EmploymentCheckDate,
                EmploymentCheckRequestDate,
                RequestCompletionStatus,
                ErrorType,
                MessageSentDate,
                MinDate,
                MaxDate,
                CheckTypeId,
                CreatedOn,
                LastUpdatedOn,
                AsDm_UpdatedDateTime
            )
            VALUES (
                SRC.EmploymentVerificationId,
                SRC.CorrelationId,
                SRC.ApprenticeshipId,
                SRC.Employed,
                SRC.EmploymentCheckDate,
                SRC.EmploymentCheckRequestDate,
                SRC.RequestCompletionStatus,
                SRC.ErrorType,
                SRC.MessageSentDate,
                SRC.MinDate,
                SRC.MaxDate,
                SRC.CheckTypeId,
                SRC.CreatedOn,
                SRC.LastUpdatedOn,
                GETDATE()
            );
    END

    IF OBJECT_ID('stg.EVS_ScheduledEmploymentVerification', 'U') IS NOT NULL
    BEGIN
        -- MERGE logic for stg.EVS_ScheduledEmploymentVerification
        ;WITH NewSEV AS (
            SELECT
                ScheduledEmploymentVerificationId,
                CommitmentId,
                ApprenticeshipId,
                ULN,
                UKPRN,
                EmployerAccountId,
                CommitmentStartDate,
                CommitmentStatusId,
                PaymentStatusId,
                ApprovalsStatusId,
                EmployerAndProviderApprovedOn,
                TransferApprovalActionedOn,
                EmploymentCheckCount,
                CreatedOn,
                LastUpdatedOn
            FROM stg.EVS_ScheduledEmploymentVerification
        )
        MERGE ASData_PL.EVS_ScheduledEmploymentVerification AS TGT
        USING NewSEV AS SRC
        ON TGT.ScheduledEmploymentVerificationId = SRC.ScheduledEmploymentVerificationId
        WHEN MATCHED AND SRC.LastUpdatedOn > TGT.LastUpdatedOn THEN
            UPDATE SET
                TGT.CommitmentId = SRC.CommitmentId,
                TGT.ApprenticeshipId = SRC.ApprenticeshipId,
                TGT.ULN = SRC.ULN,
                TGT.UKPRN = SRC.UKPRN,
                TGT.EmployerAccountId = SRC.EmployerAccountId,
                TGT.CommitmentStartDate = SRC.CommitmentStartDate,
                TGT.CommitmentStatusId = SRC.CommitmentStatusId,
                TGT.PaymentStatusId = SRC.PaymentStatusId,
                TGT.ApprovalsStatusId = SRC.ApprovalsStatusId,
                TGT.EmployerAndProviderApprovedOn = SRC.EmployerAndProviderApprovedOn,
                TGT.TransferApprovalActionedOn = SRC.TransferApprovalActionedOn,
                TGT.EmploymentCheckCount = SRC.EmploymentCheckCount,
                TGT.LastUpdatedOn = SRC.LastUpdatedOn,
                TGT.AsDm_UpdatedDateTime = GETDATE()
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                ScheduledEmploymentVerificationId,
                CommitmentId,
                ApprenticeshipId,
                ULN,
                UKPRN,
                EmployerAccountId,
                CommitmentStartDate,
                CommitmentStatusId,
                PaymentStatusId,
                ApprovalsStatusId,
                EmployerAndProviderApprovedOn,
                TransferApprovalActionedOn,
                EmploymentCheckCount,
                CreatedOn,
                LastUpdatedOn,
                AsDm_UpdatedDateTime
            )
            VALUES (
                SRC.ScheduledEmploymentVerificationId,
                SRC.CommitmentId,
                SRC.ApprenticeshipId,
                SRC.ULN,
                SRC.UKPRN,
                SRC.EmployerAccountId,
                SRC.CommitmentStartDate,
                SRC.CommitmentStatusId,
                SRC.PaymentStatusId,
                SRC.ApprovalsStatusId,
                SRC.EmployerAndProviderApprovedOn,
                SRC.TransferApprovalActionedOn,
                SRC.EmploymentCheckCount,
                SRC.CreatedOn,
                SRC.LastUpdatedOn,
                GETDATE()
            );
    END

    -- Commit Transaction
    IF @IsLocalTransaction = 1 AND @@TRANCOUNT > 0
        COMMIT TRANSACTION;

    -- Update Log Execution Results as Success
    UPDATE Mgmt.Log_Execution_Results
    SET Execution_Status = 1,
        EndDateTime = GETDATE(),
        FullJobStatus = 'Pending'
    WHERE LogId = @LogID
      AND RunId = @RunId;
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
        'ImportEVSTablesToPL',
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
