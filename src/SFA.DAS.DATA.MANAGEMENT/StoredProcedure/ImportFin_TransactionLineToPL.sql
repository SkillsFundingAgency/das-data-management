CREATE PROCEDURE [dbo].[ImportFin_TransactionLineToPL]
(
   @RunId int
)
AS


BEGIN TRY

DECLARE @LogID int
DECLARE @VSQL NVARCHAR(MAX)


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
	   ,'ImportFin_TransactionLineToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportFin_TransactionLineToPL'
     AND RunId=@RunID


BEGIN TRANSACTION

/* Import Fin_Payment Details */

IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_TransactionLine' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')

SET @VSQL='

INSERT INTO [AsData_PL].[Fin_TransactionLine] 
(
    [Id],
    [AccountId],
    [DateCreated],
    [SubmissionId],
    [TransactionDate],
    [TransactionType],
    [LevyDeclared],
    [Amount],
    [EmpRef],
    [PeriodEnd],
    [Ukprn],
    [SfaCoInvestmentAmount],
    [EmployerCoInvestmentAmount],
    [EnglishFraction],
    [TransferSenderAccountId],
    [TransferSenderAccountName],
    [TransferReceiverAccountId],
    [TransferReceiverAccountName],
    [AsDm_UpdatedDateTime]
)
SELECT 
    FT.[Id],
    FT.[AccountId],
    FT.[DateCreated],
    FT.[SubmissionId],
    FT.[TransactionDate],
    FT.[TransactionType],
    FT.[LevyDeclared],
    FT.[Amount],
    CONVERT(NVARCHAR(500), HASHBYTES(''SHA2_512'', LTRIM(RTRIM(CONCAT(FT.EmpRef, SaltKeyData.SaltKey)))), 2) AS [EmpRef],
    FT.[PeriodEnd],
    FT.[Ukprn],
    FT.[SfaCoInvestmentAmount],
    FT.[EmployerCoInvestmentAmount],
    FT.[EnglishFraction],
    FT.[TransferSenderAccountId],
    FT.[TransferSenderAccountName],
    FT.[TransferReceiverAccountId],
    FT.[TransferReceiverAccountName],
    GETDATE() AS [AsDm_UpdatedDateTime]
FROM Stg.Fin_TransactionLine FT
CROSS JOIN (
    SELECT TOP 1 SaltKeyID, SaltKey 
    FROM Mgmt.SaltKeyLog 
    WHERE SourceType = ''EmployerReference''  
    ORDER BY SaltKeyID DESC
) SaltKeyData
WHERE NOT EXISTS (
    SELECT 1 
    FROM [AsData_PL].[Fin_TransactionLine] Target
    WHERE Target.[Id] = FT.[Id]
)
AND FT.[DateCreated] > (
    SELECT max(DateCreated)
    FROM [AsData_PL].[Fin_TransactionLine]
);
'

			EXEC SP_EXECUTESQL @VSQL
           
COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_TransactionLine' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Fin_TransactionLine] 

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
	    'ImportFin_TransactionLineToPL',
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
