CREATE PROCEDURE [dbo].[ImportEI_PendingPaymentValidationResultToPL]
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
	   ,'ImportEI_PendingPaymentValidationResultToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportEI_PendingPaymentValidationResultToPL'
     AND RunId=@RunID


BEGIN TRANSACTION

/* Import EI_PendingPaymentValidationResult Details */

IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='EI_PendingPaymentValidationResult' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')

INSERT INTO [AsData_PL].[EI_PendingPaymentValidationResult] 
(
     [Id]				
    ,[PendingPaymentId]	
    ,[Step]				
    ,[Result]			
    ,[PeriodNumber]		
    ,[PaymentYear]		
    ,[CreatedDateUTC]	
    ,[OverrideResult]	
    ,[AsDm_UpdatedDateTime]
   
)
SELECT 
     SOURCE.[Id]				
    ,SOURCE.[PendingPaymentId]	
    ,SOURCE.[Step]				
    ,SOURCE.[Result]			
    ,SOURCE.[PeriodNumber]		
    ,SOURCE.[PaymentYear]		
    ,SOURCE.[CreatedDateUTC]	
    ,SOURCE.[OverrideResult]	
    
    ,GETDATE() AS [AsDm_UpdatedDateTime]
FROM stg.[EI_PendingPaymentValidationResult] SOURCE
WHERE NOT EXISTS (
    SELECT 1 
    FROM [AsData_PL].[EI_PendingPaymentValidationResult] TARGET
    WHERE TARGET.[Id] = SOURCE.[Id]
)
AND SOURCE.[CreatedDateUTC] > (
    SELECT MAX(CreatedDateUTC)
    FROM [AsData_PL].[EI_PendingPaymentValidationResult]
);


COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='EI_PendingPaymentValidationResult' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
		       DROP TABLE [Stg].[EI_PendingPaymentValidationResult] 

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
	    'ImportEI_PendingPaymentValidationResultToPL',
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
