CREATE PROCEDURE [StgPmts].[ImportDataLockEvent]
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
            'StgPmtsImportDataLockEvent',
            GETDATE(),
            0;

        SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
        WHERE StoredProcedureName='StgPmtsImportDataLockEvent'
        AND RunId=@RunId;

        -- Delete existing data
        DELETE FROM [StgPmts].[DataLockEvent]
        WHERE [AcademicYear] = @AcademicYear
          AND [CollectionPeriod] = @CollectionPeriod;

        -- Insert data from StgPmts.stg_DataLockEvent
        INSERT INTO [StgPmts].[DataLockEvent] (
            [Id],
            [EventId],
            [EarningEventId],
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
            [IsPayable],
            [DataLockSourceId],
            [JobId],
            [EventTime],
            [CreationDate],
            [DuplicateNumber]
        )
        SELECT 
            [Id],
            [EventId],
            [EarningEventId],
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
            [IsPayable],
            [DataLockSourceId],
            [JobId],
            [EventTime],
            [CreationDate],
            [DuplicateNumber]
        FROM [StgPmts].[stg_DataLockEvent]
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
            'StgPmtsImportDataLockEvent',
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
