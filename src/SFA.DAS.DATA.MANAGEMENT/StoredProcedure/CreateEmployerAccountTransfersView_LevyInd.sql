CREATE PROCEDURE [dbo].[CreateEmployerAccountTransfersView_LevyInd]
(
   @RunId int
)
AS
/*===========================================================================
Author:      Robin Rai
Create Date: 07/01/2020
Description: Clone Transfers View and Add Levy Indicator by sourcing flag from Acct.Ext_tbl_Account on id 
             (which is the employer id ) and column is ApprenticeshipEmployerType which holds flag

=============================================================================*/

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
	   ,'Step-4'
	   ,'CreateEmployerAccountTransfersView_LevyInd'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerAccountTransfersView_LevyInd'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_Account_Transfers_LevyInd'')
Drop View Data_Pub.DAS_Employer_Account_Transfers_LevyInd
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_Account_Transfers_LevyInd]	AS 
	SELECT
	  ISNULL(CAST(AT.Id AS bigint),-1)                               AS TransferId
	, ISNULL(CAST(AT.SenderAccountId AS bigint),-1)                  as SenderAccountId
	, ISNULL(CAST(AT.ReceiverAccountId AS bigint),-1)                as ReceiverAccountId
	, ISNULL(p.PaymentID,''00000000-0000-0000-0000-000000000000'')   AS RequiredPaymentId
	, ISNULL(CAST(A.ID AS bigint),-1)                                AS CommitmentId
	, CAST(p.Amount as decimal(18,5))                                as Amount
	, ISNULL(CAST(AT.Type as nvarchar(50)),''NA'')                   AS Type
	, ISNULL(CAST (p.PeriodEnd AS NVARCHAR(10)),''XXXX'')            AS CollectionPeriodName
	, ISNULL(AT.CreatedDate,''9999-12-31'')                          AS UpdateDateTime

    , Acct1.ApprenticeshipEmployerType                               AS SenderAccountId_IsLevy
	, Acct2.ApprenticeshipEmployerType                               AS ReceiverAccountId_IsLevy
	FROM Fin.Ext_Tbl_AccountTransfers AT
	 JOIN Comt.Ext_Tbl_Apprenticeship A 
	    ON AT.ApprenticeshipId = A.ID
	 JOIN [Acct].[Ext_Tbl_Account] Acct1
        ON Acct1.id = AT.SenderAccountId
	 JOIN [Acct].[Ext_Tbl_Account] Acct2
        ON Acct2.id = AT.ReceiverAccountId

	LEFT OUTER JOIN 
	( SELECT xp.PaymentID
	  , xp.ApprenticeshipId
		, xp.PeriodEnd
		, xp.Amount
	  FROM Fin.Ext_Tbl_Payment xp 
	  WHERE xp.Fundingsource = 5 
	) AS p ON at.ApprenticeshipId=p.ApprenticeshipId and at.periodend=p.periodend

'
-- SET @VSQL3='  ' 
-- SET @VSQL4='  ' 

EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
EXEC (@VSQL2) -- run sql to create view. 
-- +@VSQL3+@VSQL4) -- no 3 or 4 as small view. 

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
	    'CreateEmployerAccountTransfersView_LevyInd',
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


		  

