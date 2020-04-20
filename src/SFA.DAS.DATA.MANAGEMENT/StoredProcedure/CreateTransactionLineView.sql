CREATE PROCEDURE [dbo].[CreateTransactionLineView]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Robin Rai
-- Create Date: 09/10/2019
-- Description: Create View for TransactionLine
-- ===============================================================================

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

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
	   ,'Step-4'
	   ,'CreateTransactionLineView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateTransactionLineView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_TransactionLine'')
Drop View Data_Pub.DAS_TransactionLine
'
SET @VSQL2='
 CREATE VIEW [Data_Pub].[DAS_TransactionLine]  AS 
 SELECT [Id], 
 [AccountId],  
 [DateCreated],  
 [SubmissionId],  
 [TransactionDate],  
 [TransactionType],  
 [LevyDeclared],  
 [Amount], 
 HASHBYTES(''SHA2_512'',RTRIM(LTRIM(CAST([EmpRef] AS VARCHAR(20))))) AS [EmpRef],  
 [PeriodEnd],  
 [Ukprn],  
 [SfaCoInvestmentAmount],  
 [EmployerCoInvestmentAmount],  
 [EnglishFraction],  
 [TransferSenderAccountId],  
 [TransferSenderAccountName],  
 [TransferReceiverAccountId],  
 [TransferReceiverAccountName]  
 FROM [Fin].[Ext_Tbl_TransactionLine] 
'
-- SET @VSQL3=' ' 
-- SET @VSQL4=' ' 

EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
EXEC (@VSQL2) -- run sql to create view. 
-- +@VSQL3+@VSQL4) -- no 3 or 4 

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
	    'CreateTransactionLineView',
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
