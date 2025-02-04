CREATE PROCEDURE [dbo].[ImportFin_PaymentToPL]
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
	   ,'ImportFin_PaymentToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportFin_PaymentToPL'
     AND RunId=@RunID


BEGIN TRANSACTION

/* Import Fin_Payment Details */

IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_Payment' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')

MERGE INTO [AsData_PL].[Fin_Payment] AS TARGET
USING (SELECT * FROM stg.[Fin_Payment]) AS SOURCE
ON TARGET.[PaymentId] = SOURCE.[PaymentId] 

-- Update existing records if the source has a more recent DateImported
WHEN MATCHED AND SOURCE.[DateImported] > TARGET.[DateImported] THEN 
UPDATE SET
    TARGET.[Ukprn] = SOURCE.[Ukprn],
    TARGET.[Uln] = SOURCE.[Uln],
    TARGET.[AccountId] = SOURCE.[AccountId],
    TARGET.[ApprenticeshipId] = SOURCE.[ApprenticeshipId],
    TARGET.[DeliveryPeriodMonth] = SOURCE.[DeliveryPeriodMonth],
    TARGET.[DeliveryPeriodYear] = SOURCE.[DeliveryPeriodYear],
    TARGET.[CollectionPeriodId] = SOURCE.[CollectionPeriodId],
    TARGET.[CollectionPeriodMonth] = SOURCE.[CollectionPeriodMonth],
    TARGET.[CollectionPeriodYear] = SOURCE.[CollectionPeriodYear],
    TARGET.[EvidenceSubmittedOn] = SOURCE.[EvidenceSubmittedOn],
    TARGET.[EmployerAccountVersion] = SOURCE.[EmployerAccountVersion],
    TARGET.[ApprenticeshipVersion] = SOURCE.[ApprenticeshipVersion],
    TARGET.[FundingSource] = SOURCE.[FundingSource],
    TARGET.[TransactionType] = SOURCE.[TransactionType],
    TARGET.[Amount] = SOURCE.[Amount],
    TARGET.[PeriodEnd] = SOURCE.[PeriodEnd],
    TARGET.[PaymentMetaDataId] = SOURCE.[PaymentMetaDataId],
    TARGET.[DateImported] = SOURCE.[DateImported],
	Target.[AsDm_UpdatedDateTime]   = Getdate()

-- Insert new records if PaymentId does not exist in the target table
WHEN NOT MATCHED THEN 
INSERT ([PaymentId]
       ,[Ukprn]
	   ,[Uln]
	   ,[AccountId]
	   ,[ApprenticeshipId]
	   ,[DeliveryPeriodMonth]
	   ,[DeliveryPeriodYear]
	   ,[CollectionPeriodId]
	   ,[CollectionPeriodMonth]
	   ,[CollectionPeriodYear]
	   ,[EvidenceSubmittedOn]
	   ,[EmployerAccountVersion]
	   ,[ApprenticeshipVersion]
	   ,[FundingSource] 
       ,[TransactionType]
	   ,[Amount]
	   ,[PeriodEnd]
	   ,[PaymentMetaDataId]
	   ,[DateImported]
	   ,[AsDm_UpdatedDateTime])
VALUES (SOURCE.[PaymentId]
       ,SOURCE.[Ukprn]
       ,SOURCE.[Uln]
       ,SOURCE.[AccountId]
       ,SOURCE.[ApprenticeshipId]
       ,SOURCE.[DeliveryPeriodMonth]
       ,SOURCE.[DeliveryPeriodYear]
       ,SOURCE.[CollectionPeriodId]
       ,SOURCE.[CollectionPeriodMonth]
       ,SOURCE.[CollectionPeriodYear]
       ,SOURCE.[EvidenceSubmittedOn]
       ,SOURCE.[EmployerAccountVersion]
       ,SOURCE.[ApprenticeshipVersion]
       ,SOURCE.[FundingSource]
       ,SOURCE.[TransactionType]
       ,SOURCE.[Amount]
       ,SOURCE.[PeriodEnd]
       ,SOURCE.[PaymentMetaDataId]
       ,SOURCE.[DateImported]
	   ,Getdate()
       
       );

COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='Fin_Payment' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[Fin_Payment]

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
	    'ImportFin_PaymentToPL',
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
