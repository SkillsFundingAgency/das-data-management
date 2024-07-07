CREATE PROCEDURE [StgPmts].[ImportEarningEventPeriod]
    @EarningEventId UNIQUEIDENTIFIER,
    @RunId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Begin Transaction
        BEGIN TRANSACTION;

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
            'Step-3',
            'StgPmtsImportEarningEventPeriod',
            GETDATE(),
            0;

        SELECT @LogID = MAX(LogId) 
        FROM Mgmt.Log_Execution_Results
        WHERE StoredProcedureName = 'StgPmtsImportEarningEventPeriod'
        AND RunId = @RunId;

        -- Delete existing data
        DELETE FROM [StgPmts].[EarningEventPeriod]
        WHERE [EarningEventId] = @EarningEventId;

        -- Insert data from StgPmts.stg_EarningEventPeriod
        INSERT INTO [StgPmts].[EarningEventPeriod] (
            [Id],
            [EarningEventId],
            [PriceEpisodeIdentifier],
            [TransactionType],
            [DeliveryPeriod],
            [Amount],
            [SfaContributionPercentage],
            [CreationDate],
            [CensusDate]
        )
        SELECT 
            [Id],
            [EarningEventId],
            [PriceEpisodeIdentifier],
            [TransactionType],
            [DeliveryPeriod],
            [Amount],
            [SfaContributionPercentage],
            [CreationDate],
            [CensusDate]
        FROM [StgPmts].[stg_EarningEventPeriod]
        WHERE [EarningEventId] = @EarningEventId;

        COMMIT TRANSACTION;

        UPDATE Mgmt.Log_Execution_Results
        SET Execution_Status = 1,
            EndDateTime = GETDATE(),
            FullJobStatus = 'Pending'
        WHERE LogId = @LogID
          AND RunId = @RunId;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

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
            'StgPmtsImportEarningEventPeriod',
            ERROR_MESSAGE(),
            GETDATE(),
            @RunId;

        SELECT @ErrorId = MAX(ErrorId) FROM Mgmt.Log_Error_Details;

        -- Update Log Execution Results as Fail if there is an Error
        UPDATE Mgmt.Log_Execution_Results
        SET Execution_Status = 0,
            EndDateTime = GETDATE(),
            ErrorId = @ErrorId
        WHERE LogId = @LogID
          AND RunID = @RunId;
    END CATCH
END;
