CREATE PROCEDURE [dbo].[ImportComt_ApprenticeCandRegDetailsToPL]
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
	   ,'ImportComt_ApprenticeCandRegDetailsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportComt_ApprenticeCandRegDetailsToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

 /* Import Commitments History to PL */

DECLARE @VSQL1 NVARCHAR(MAX)

SET @VSQL1='
 
MERGE [ASData_PL].[Comt_ApprenticeshipCandidateRegDetails] AS Target
USING 
    SELECT 
        AR.[ApprenticeshipId],
        AR.[CommitmentId],
        AR.[CandidateFirstName],
        AR.[CandidateLastName],
        AR.[CandidateFullName],
        AR.[CandidateDateOfBirth],
        AR.[CandidateEmail],
        AR.[UpdatedOn]
    FROM stg.[Comt_ApprenticeshipCandidateRegDetails] AR
) AS Source
ON Target.[ApprenticeshipId] = Source.[ApprenticeshipId]

WHEN MATCHED AND Source.[UpdatedOn] > Target.[UpdatedOn] THEN
    UPDATE SET
        Target.[CommitmentId] = Source.[CommitmentId],
        Target.[CandidateFirstName] = Source.[CandidateFirstName],
        Target.[CandidateLastName] = Source.[CandidateLastName],
        Target.[CandidateFullName] = Source.[CandidateFullName],
        Target.[CandidateDateOfBirth] = Source.[CandidateDateOfBirth],
        Target.[CandidateEmail] = Source.[CandidateEmail],
        Target.[UpdatedOn] = Source.[UpdatedOn],
        Target.[AsDm_UpdatedDateTime] = Source.[AsDm_UpdatedDateTime]
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        [ApprenticeshipId],
        [CommitmentId],
        [CandidateFirstName],
        [CandidateLastName],
        [CandidateFullName],
        [CandidateDateOfBirth],
        [CandidateEmail],
        [UpdatedOn],
        [AsDm_UpdatedDateTime]
    )
    VALUES (
        Source.[ApprenticeshipId],
        Source.[CommitmentId],
        Source.[CandidateFirstName],
        Source.[CandidateLastName],
        Source.[CandidateFullName],
        Source.[CandidateDateOfBirth],
        Source.[CandidateEmail],
        Source.[UpdatedOn],
        Source.[AsDm_UpdatedDateTime]
    );'

EXEC SP_EXECUTESQL @VSQL1

  /* Drop Staging Table as it's no longer required */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_ApprenticeshipCandidateRegDetail' AND TABLE_SCHEMA=N'Stg') 
DROP TABLE [Stg].Comt_ApprenticeshipCandidateRegDetail


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

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_ApprenticeshipCandidateRegDetail' AND TABLE_SCHEMA=N'Stg')
     DROP TABLE [Stg].Comt_ApprenticeshipCandidateRegDetail

	

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
	    'ImportComt_ApprenticeCandRegDetailsToPL',
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

