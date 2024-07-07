CREATE PROCEDURE [StgPmts].[ImportEarningEvent]
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
            'StgPmtsImportEarningEvent',
            GETDATE(),
            0;

        SELECT @LogID = MAX(LogId) 
        FROM Mgmt.Log_Execution_Results
        WHERE StoredProcedureName = 'StgPmtsImportEarningEvent'
        AND RunId = @RunId;

        -- Delete existing data
        DELETE FROM [StgPmts].[EarningEvent]
        WHERE [AcademicYear] = @AcademicYear
          AND [CollectionPeriod] = @CollectionPeriod;

        -- Insert data from StgPmts.stg_EarningEvent
        INSERT INTO [StgPmts].[EarningEvent] (
            [Id],
            [EventId],
            [Ukprn],
            [ContractType],
            [CollectionPeriod],
            [AcademicYear],
            [LearnerReferenceNumber],
            [LearnerUln],
            [LearningAimReference],
            [LearningAimProgrammeType],
            [LearningAimStandardCode],
            [LearningAimFrameworkCode],
            [LearningAimPathwayCode],
            [LearningAimFundingLineType],
            [LearningStartDate],
            [AgreementId],
            [IlrSubmissionDateTime],
            [JobId],
            [EventTime],
            [CreationDate],
            [LearningAimSequenceNumber],
            [SfaContributionPercentage],
            [IlrFileName],
            [EventType]
        )
        SELECT 
            [Id],
            [EventId],
            [Ukprn],
            [ContractType],
            [CollectionPeriod],
            [AcademicYear],
            [LearnerReferenceNumber],
            [LearnerUln],
            [LearningAimReference],
            [LearningAimProgrammeType],
            [LearningAimStandardCode],
            [LearningAimFrameworkCode],
            [LearningAimPathwayCode],
            [LearningAimFundingLineType],
            [LearningStartDate],
            [AgreementId],
            [IlrSubmissionDateTime],
            [JobId],
            [EventTime],
            [CreationDate],
            [LearningAimSequenceNumber],
            [SfaContributionPercentage],
            [IlrFileName],
            [EventType]
        FROM [StgPmts].[stg_EarningEvent]
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
            'StgPmtsImportEarningEvent',
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
