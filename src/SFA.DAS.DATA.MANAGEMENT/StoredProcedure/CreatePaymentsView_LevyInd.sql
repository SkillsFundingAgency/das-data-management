


CREATE PROCEDURE [dbo].[CreatePaymentsView_LevyInd]
(
   @RunId int
)
AS

-- =========================================================================
-- Author:      Robin Rai
-- Create Date: 15/08/2019
-- Description: Create Payment View with Levy Indicator 
--
--
--     Change Control
--     
--     Date				Author        Jira             Description
--
--      05/03/2020		R.Rai		  ADM_677		  Payment View with Levy Indicator
--      09/03/2020      R.Rai         ADM_677         Change Schema name to ASData_PL
--
-- =====================================================================================================





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
	   ,'CreatePaymentsView_LevyInd'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreatePaymentsView_LevyInd'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='

IF  EXISTS (SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Payments_LevyInd'' AND TABLE_SCHEMA = ''ASData_PL'' )
BEGIN
     DROP VIEW ASData_PL.DAS_Payments_LevyInd
END

'
SET @VSQL2='
CREATE VIEW [ASData_PL].[DAS_Payments_LevyInd]
	AS 
	SELECT PS.[ID]
      ,PS.[PaymentID]
      ,PS.[UKPRN]
      ,PS.[ULN]
      ,PS.[EmployerAccountID]
      ,PS.[DasAccountId]
      ,PS.[CommitmentID]
      ,PS.[DeliveryMonth]
      ,PS.[DeliveryYear]
      ,PS.[CollectionMonth]
      ,PS.[CollectionYear]
      ,PS.[EvidenceSubmittedOn]
      ,PS.[EmployerAccountVersion]
      ,PS.[ApprenticeshipVersion]
      ,PS.[FundingSource]
      ,PS.[FundingAccountId]
      ,PS.[TransactionType]
      ,PS.[Amount]
      ,PS.[StdCode]
      ,PS.[FworkCode]
      ,PS.[ProgType]
      ,PS.[PwayCode]
      ,PS.[ContractType]
      ,PS.[UpdateDateTime]
      ,PS.[UpdateDate]
      ,PS.[Flag_Latest]
      ,PS.[Flag_FirstPayment]
      ,PS.[PaymentAge]
      ,PS.[PaymentAgeBand]
      ,PS.[DeliveryMonthShortNameYear]
      ,PS.[DASAccountName]
      ,PS.[CollectionPeriodName]
      ,PS.[CollectionPeriodMonth]
      ,PS.[CollectionPeriodYear]
      ,Convert(bit,C.ApprenticeshipEmployerTypeOnApproval)  as ApprenticeshipEmployerTypeOnApproval
   FROM [AsData_PL].[Payments_SS] PS
  LEFT JOIN  [Comt].[Ext_tbl_Apprenticeship] A
  ON A.Id= PS.CommitmentId
  LEFT JOIN  [Comt].[Ext_tbl_Commitment] C 
  ON A.CommitmentID = C.Id
  
'

  


EXEC SP_EXECUTESQL @VSQL1
EXEC (@VSQL2)

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
	    'CreatePaymentsView_LevyInd',
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


		  

