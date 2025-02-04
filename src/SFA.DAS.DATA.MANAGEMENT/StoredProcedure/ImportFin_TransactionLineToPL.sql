CREATE PROCEDURE [dbo].[ImportFin_TransactionLineToPL]
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
	   ,'ImportFin_TransactionLineToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportFin_TransactionLineToPL'
     AND RunId=@RunID


BEGIN TRANSACTION

/* Import Fin_Payment Details */


IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_TransactionLine' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
DECLARE @VSQL NVARCHAR(MAX)

SET @VSQL='


MERGE INTO [AsData_PL].[Fin_TransactionLine] AS Target
USING (
SELECT [Id]
                      ,[AccountId]
                      ,[DateCreated]
                      ,[SubmissionId]
                      ,[TransactionDate]
                      ,[TransactionType]
                      ,[LevyDeclared]
                      ,[Amount]
                      ,convert(NVarchar(500),HASHBYTES(''SHA2_512'',LTRIM(RTRIM(CONCAT(EmpRef, saltkeydata.SaltKey)))),2) [EmpRef]
                      ,[PeriodEnd]
                      ,[Ukprn]
                      ,[SfaCoInvestmentAmount]
                      ,[EmployerCoInvestmentAmount]
                      ,[EnglishFraction]
                      ,[TransferSenderAccountId]
                      ,[TransferSenderAccountName]
                      ,[TransferReceiverAccountId]
                      ,[TransferReceiverAccountName]
				 FROM Stg.Fin_TransactionLine FT
				CROSS JOIN (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType =''EmployerReference''  Order by SaltKeyID DESC ) SaltKeyData) AS Source
ON Target.Id = Source.Id  -- Primary Key match

WHEN MATCHED THEN 
    UPDATE SET 
        Target.[AccountId] = Source.[AccountId],
        Target.[DateCreated] = Source.[DateCreated],
        Target.[SubmissionId] = Source.[SubmissionId],
        Target.[TransactionDate] = Source.[TransactionDate],
        Target.[TransactionType] = Source.[TransactionType],
        Target.[LevyDeclared] = Source.[LevyDeclared],
        Target.[Amount] = Source.[Amount],
        Target.[EmpRef] = Source.[EmpRef],
        Target.[PeriodEnd] = Source.[PeriodEnd],
        Target.[Ukprn] = Source.[Ukprn],
        Target.[SfaCoInvestmentAmount] = Source.[SfaCoInvestmentAmount],
        Target.[EmployerCoInvestmentAmount] = Source.[EmployerCoInvestmentAmount],
        Target.[EnglishFraction] = Source.[EnglishFraction],
        Target.[TransferSenderAccountId] = Source.[TransferSenderAccountId],
        Target.[TransferSenderAccountName] = Source.[TransferSenderAccountName],
        Target.[TransferReceiverAccountId] = Source.[TransferReceiverAccountId],
        Target.[TransferReceiverAccountName] = Source.[TransferReceiverAccountName],
		Target.[AsDm_UpdatedDateTime]   = Getdate()

WHEN NOT MATCHED THEN 
    INSERT ([Id]
	       ,[AccountId]
		   ,[DateCreated]
		   ,[SubmissionId]
		   ,[TransactionDate]
		   ,[TransactionType]
		   ,[LevyDeclared]
		   ,[Amount]
		   ,[EmpRef]
		   ,[PeriodEnd]
		   ,[Ukprn]
		   ,[SfaCoInvestmentAmount]
		   ,[EmployerCoInvestmentAmount]
		   ,[EnglishFraction]
		   ,[TransferSenderAccountId]
		   ,[TransferSenderAccountName]
		   ,[TransferReceiverAccountId]
		   ,[TransferReceiverAccountName]
		   ,[AsDm_UpdatedDateTime] )
    VALUES (Source.[Id]
	       ,Source.[AccountId]
		   ,Source.[DateCreated]
           ,Source.[SubmissionId] 
           ,Source.[TransactionDate]
		   ,Source.[TransactionType]
		   ,Source.[LevyDeclared]
		   ,Source.[Amount]
		   ,Source.[EmpRef]
		   ,Source.[PeriodEnd]
		   ,Source.[Ukprn]
		   ,Source.[SfaCoInvestmentAmount]
		   ,Source.[EmployerCoInvestmentAmount]
		   ,Source.[EnglishFraction]
		   ,Source.[TransferSenderAccountId]
		   ,Source.[TransferSenderAccountName]
		   ,Source.[TransferReceiverAccountId]
		   ,Source.[TransferReceiverAccountName]
		   ,Getdate()
		   );'

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
