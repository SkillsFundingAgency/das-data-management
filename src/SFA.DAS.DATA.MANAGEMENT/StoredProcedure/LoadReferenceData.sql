CREATE PROCEDURE [dbo].[LoadReferenceData]
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/09/2019
-- Description: Load Reference Data from Discrete Dbs
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

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
	   ,'Step-3'
	   ,'LoadReferenceData'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='LoadReferenceData'
     AND RunId=@RunID


IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION
DELETE FROM dbo.ReferenceData

INSERT INTO dbo.ReferenceData
(Category,FieldName,FieldValue,FieldDesc)
VALUES
--TransactionType
('Payments','TransactionType',1,'Learning'),
('Payments','TransactionType',2,'Completion'),
('Payments','TransactionType',3,'Balancing'),
('Payments','TransactionType',4,'First16To18EmployerIncentive'),
('Payments','TransactionType',5,'First16To18ProviderIncentive'),
('Payments','TransactionType',6,'Second16To18EmployerIncentive'),
('Payments','TransactionType',7,'Second16To18ProviderIncentive'),
('Payments','TransactionType',8,'OnProgramme16To18FrameworkUplift'),
('Payments','TransactionType',9,'Completion16To18FrameworkUplift'),
('Payments','TransactionType',10,'Balancing16To18FrameworkUplift'),
('Payments','TransactionType',11,'FirstDisadvantagePayment'),
('Payments','TransactionType',12,'SecondDisadvantagePayment'),
('Payments','TransactionType',13,'OnProgrammeMathsAndEnglish'),
('Payments','TransactionType',14,'BalancingMathsAndEnglish'),
('Payments','TransactionType',15,'LearningSupport'),
('Payments','TransactionType',16,'CareLeaverApprenticePayment'),
--FundingSource
('Payments','FundingSource',1,'Levy'),
('Payments','FundingSource',2,'CoInvestedSfa'),
('Payments','FundingSource',3,'CoInvestedEmployer'),
('Payments','FundingSource',4,'FullyFundedSfa'),
('Payments','FundingSource',5,'LevyTransfer'),
-- Contract Type
('Payments','ContractType',0,'Unknown'),
('Payments','ContractType',1,'ContractWithEmployer'),
('Payments','ContractType',2,'ContractWithSfa'),
--Approvals
('Commitments','Approvals',0,'NotAgreed'),
('Commitments','Approvals',1,'EmployerAgreed'),
('Commitments','Approvals',2,'ProviderAgreed'),
('Commitments','Approvals',3,'EmployerAndProviderAgreed'),
('Commitments','Approvals',4,'TransferSenderAgreed'),
('Commitments','Approvals',5,'TransferSenderAndEmployerAgreed'),
('Commitments','Approvals',6,'TransferSenderAndProviderAgreed'),
('Commitments','Approvals',7,'AllAgreed'),


COMMIT TRANSACTION
END

/* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
	    'LoadReferenceData',
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
