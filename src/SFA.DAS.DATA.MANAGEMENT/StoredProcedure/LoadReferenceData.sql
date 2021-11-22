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

--Apprenticeship AgreementStatus
('Apprenticeship','AgreementStatus',0,'NotAgreed'),
('Apprenticeship','AgreementStatus',1,'EmployerAgreed'),
('Apprenticeship','AgreementStatus',2,'ProviderAgreed'),
('Apprenticeship','AgreementStatus',3,'BothAgreed'),

--Apprenticeship AgreementStatus
('Apprenticeship','PaymentStatus',0,'PendingApproval'),
('Apprenticeship','PaymentStatus',1,'Active'),
('Apprenticeship','PaymentStatus',2,'Paused'),
('Apprenticeship','PaymentStatus',3,'Cancelled'),
('Apprenticeship','PaymentStatus',4,'Completed'),
('Apprenticeship','PaymentStatus',5,'Deleted'),

--ApprenticeshipUpdate
('Commitments','ApprenticeshipUpdate',0,'Pending'),
('Commitments','ApprenticeshipUpdate',1,'Approved'),
('Commitments','ApprenticeshipUpdate',2,'Rejected'),
('Commitments','ApprenticeshipUpdate',3,'Deleted'),
('Commitments','ApprenticeshipUpdate',4,'Superceded'),
('Commitments','ApprenticeshipUpdate',5,'Expired'),

--LevyTransferMatching
('LevyTransferMatching','Level',1,'Level 2 - GCSE'),
('LevyTransferMatching','Level',2,'Level 3 - A level'),
('LevyTransferMatching','Level',4,'Level 4 - higher national cerificate (HNC)'),
('LevyTransferMatching','Level',8,'Level 5 - higher national diploma (HND)'),
('LevyTransferMatching','Level',16,'Level 6 - degree'),
('LevyTransferMatching','Level',32,'Level 7 - master''s degree'),
('LevyTransferMatching','Sector',1,'Agriculture, environmental and animal care'),
('LevyTransferMatching','Sector',2,'Business and administration'),
('LevyTransferMatching','Sector',4,'Care services'),
('LevyTransferMatching','Sector',8,'Catering and hospitality'),
('LevyTransferMatching','Sector',16,'Charity'),
('LevyTransferMatching','Sector',32,'Construction'),
('LevyTransferMatching','Sector',64,'Creative and design'),
('LevyTransferMatching','Sector',128,'Digital'),
('LevyTransferMatching','Sector',256,'Education and childcare'),
('LevyTransferMatching','Sector',512,'Engineering and manufacturing'),
('LevyTransferMatching','Sector',1024,'Hair and beauty'),
('LevyTransferMatching','Sector',2048,'Health and science'),
('LevyTransferMatching','Sector',4096,'Legal, finance and accounting'),
('LevyTransferMatching','Sector',8192,'Protective services'),
('LevyTransferMatching','Sector',16384,'Sales, marketing and procurement'),
('LevyTransferMatching','Sector',32768,'Transport and logistics'),
('LevyTransferMatching','JobRole',1,'Agriculture, environmental and animal care'),
('LevyTransferMatching','JobRole',2,'Business and administration'),
('LevyTransferMatching','JobRole',4,'Care services'),
('LevyTransferMatching','JobRole',8,'Catering and hospitality'),
('LevyTransferMatching','JobRole',16,'Construction'),
('LevyTransferMatching','JobRole',32,'Creative and design'),
('LevyTransferMatching','JobRole',64,'Digital'),
('LevyTransferMatching','JobRole',128,'Education and childcare'),
('LevyTransferMatching','JobRole',256,'Engineering and manufacturing'),
('LevyTransferMatching','JobRole',512,'Hair and beauty'),
('LevyTransferMatching','JobRole',1024,'Health and science'),
('LevyTransferMatching','JobRole',2048,'Legal, finance and accounting'),
('LevyTransferMatching','JobRole',4096,'Protective services'),
('LevyTransferMatching','JobRole',8192,'Sales, marketing and procurement'),
('LevyTransferMatching','JobRole',16384,'Transport and logistics');


INSERT INTO dbo.ReferenceData
(Category,FieldName,FieldValue,FieldDesc,FieldDetailDesc)
VALUES
('LevyTransferMatching','Status',0,'Pending','Pending - default state'),
('LevyTransferMatching','Status',1,'Approved','Approved by the sender'),
('LevyTransferMatching','Status',2,'Rejected','Rejected by the sender'),
('LevyTransferMatching','Status',3,'Accepted','Approved by the sender, accepted by the receiver'),
('LevyTransferMatching','Status',4,'FundsUsed','Accepted by the receiver and all funds used'),
('LevyTransferMatching','Status',5,'Declined','Approved by the sender, declined by the receiver'),
('LevyTransferMatching','Status',6,'Withdrawn','Withdrawn by the receiver')

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
