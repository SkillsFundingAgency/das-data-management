


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
	SELECT a.[ID]
      ,a.[PaymentID]
      ,a.[UKPRN]
      ,a.[ULN]
      ,a.[EmployerAccountID]
      ,a.[DasAccountId]
      ,a.[CommitmentID]
      ,a.[DeliveryMonth]
      ,a.[DeliveryYear]
      ,a.[CollectionMonth]
      ,a.[CollectionYear]
      ,a.[EvidenceSubmittedOn]
      ,a.[EmployerAccountVersion]
      ,a.[ApprenticeshipVersion]
      ,a.[FundingSource]
      ,a.[FundingAccountId]
      ,a.[TransactionType]
      ,a.[Amount]
      ,a.[StdCode]
      ,a.[FworkCode]
      ,a.[ProgType]
      ,a.[PwayCode]
      ,a.[ContractType]
      ,a.[UpdateDateTime]
      ,a.[UpdateDate]
      ,a.[Flag_Latest]
      ,a.[Flag_FirstPayment]
      ,a.[PaymentAge]
      ,a.[PaymentAgeBand]
      ,a.[DeliveryMonthShortNameYear]
      ,a.[DASAccountName]
      ,a.[CollectionPeriodName]
      ,a.[CollectionPeriodMonth]
      ,a.[CollectionPeriodYear]
      ,Convert(bit,c.ApprenticeshipEmployerTypeOnApproval)  as ApprenticeshipEmployerTypeOnApproval
   FROM [dbo].[Payments_SS] a
  LEFT JOIN  [Comt].[Ext_tbl_Apprenticeship] b
  ON b.Id= a.CommitmentId
  LEFT JOIN  [Comt].[Ext_tbl_Commitment] c 
  ON b.CommitmentID = c.Id
  
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


		  

