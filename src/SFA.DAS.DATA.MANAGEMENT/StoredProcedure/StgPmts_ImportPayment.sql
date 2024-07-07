CREATE PROCEDURE [StgPmts].[ImportPayment]
    @AcademicYear SMALLINT,
    @CollectionPeriod TINYINT,
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
            'StgPmtsImportPayment',
            GETDATE(),
            0;

        SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
        WHERE StoredProcedureName='StgPmtsImportPayment'
        AND RunId=@RunId;

        -- Delete existing data
        DELETE FROM [StgPmts].[Payment]
        WHERE [AcademicYear] = @AcademicYear
          AND [CollectionPeriod] = @CollectionPeriod;

        -- Insert data from StgPmts.stg_Payment
        INSERT INTO [StgPmts].[Payment] (
            [Id],
            [EventId],
            [EarningEventId],
            [FundingSourceEventId],
            [EventTime],
            [JobId],
            [DeliveryPeriod],
            [CollectionPeriod],
            [AcademicYear],
            [Ukprn],
            [LearnerReferenceNumber],
            [LearningAimSequenceNumber],
            [LearnerUln],
            [PriceEpisodeIdentifier],
            [Amount],
            [LearningAimReference],
            [LearningAimProgrammeType],
            [LearningAimStandardCode],
            [LearningAimFrameworkCode],
            [LearningAimPathwayCode],
            [LearningAimFundingLineType],
            [ContractType],
            [TransactionType],
            [FundingSource],
            [IlrSubmissionDateTime],
            [SfaContributionPercentage],
            [AgreementId],
            [AccountId],
            [TransferSenderAccountId],
            [CreationDate],
            [EarningsStartDate],
            [EarningsPlannedEndDate],
            [EarningsActualEndDate],
            [EarningsCompletionStatus],
            [EarningsCompletionAmount],
            [EarningsInstalmentAmount],
            [EarningsNumberOfInstalments],
            [LearningStartDate],
            [ApprenticeshipId],
            [ApprenticeshipPriceEpisodeId],
            [ApprenticeshipEmployerType],
            [ReportingAimFundingLineType],
            [NonPaymentReason],
            [DuplicateNumber]
        )
        SELECT 
            [Id],
            [EventId],
            [EarningEventId],
            [FundingSourceEventId],
            [EventTime],
            [JobId],
            [DeliveryPeriod],
            [CollectionPeriod],
            [AcademicYear],
            [Ukprn],
            [LearnerReferenceNumber],
            [LearningAimSequenceNumber],
            [LearnerUln],
            [PriceEpisodeIdentifier],
            [Amount],
            [LearningAimReference],
            [LearningAimProgrammeType],
            [LearningAimStandardCode],
            [LearningAimFrameworkCode],
            [LearningAimPathwayCode],
            [LearningAimFundingLineType],
            [ContractType],
            [TransactionType],
            [FundingSource],
            [IlrSubmissionDateTime],
            [SfaContributionPercentage],
            [AgreementId],
            [AccountId],
            [TransferSenderAccountId],
            [CreationDate],
            [EarningsStartDate],
            [EarningsPlannedEndDate],
            [EarningsActualEndDate],
            [EarningsCompletionStatus],
            [EarningsCompletionAmount],
            [EarningsInstalmentAmount],
            [EarningsNumberOfInstalments],
            [LearningStartDate],
            [ApprenticeshipId],
            [ApprenticeshipPriceEpisodeId],
            [ApprenticeshipEmployerType],
            [ReportingAimFundingLineType],
            [NonPaymentReason],
            [DuplicateNumber]
        FROM [StgPmts].[stg_Payment]
        WHERE [AcademicYear] = @AcademicYear
          AND [CollectionPeriod] = @CollectionPeriod;

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
            'StgPmtsImportPayment',
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
