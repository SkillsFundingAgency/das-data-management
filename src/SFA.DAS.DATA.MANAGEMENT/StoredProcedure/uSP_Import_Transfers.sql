
CREATE PROCEDURE uSP_Import_Transfers
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import Transfers Related Data 
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
	   ,'Step-6'
	   ,'uSP_Import_Transfers'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get Transfers Data into Temp Table */

  
IF OBJECT_ID ('tempdb..#tCommitment') IS NOT NULL
DROP TABLE #tCommitment

SELECT *
  INTO #tCommitment
  FROM dbo.Ext_Tbl_Commitment

IF OBJECT_ID ('tempdb..#tTransferRequest') IS NOT NULL
DROP TABLE #tTransferRequest

SELECT *
  INTO #tTransferRequest
  FROM dbo.Ext_Tbl_TransferRequest





IF OBJECT_ID ('tempdb..#Transfers') IS NOT NULL
DROP TABLE #tTransfers

 SELECT DISTINCT 
         ETR.TrainingCourses
        ,ETR.Cost
		,ETR.Status as TransferStatus
		,ETR.TransferApprovalActionedByEmployerName
		,ETR.TransferApprovalActionedByEmployerEmail
		,ETR.TransferApprovalActionedOn
		,ETR.CreatedOn as TransferCreatedOn
		,ETR.FundingCap as FundingCap
		,TransferSender.ID as TransferSenderAccountId
		,TransferReceiver.ID as TransferReceiverAccountId
		,C.ID as CommitmentId
  into #tTransfers
  from #tTransferRequest ETR
  LEFT
  JOIN #tCommitment ETC
    ON ETR.CommitmentId=ETC.Id
  LEFT
  JOIN dbo.Commitment C
    ON C.Commitments_SourceId=ETC.Id
  LEFT
  JOIN dbo.EmployerAccount TransferSender
    ON TransferSender.Source_AccountId=ETC.TransferSenderId
  LEFT
  JOIN dbo.EmployerAccount TransferReceiver
    on TransferReceiver.Source_AccountId=ETC.EmployerAccountId



 MERGE dbo.Transfers as Target
 USING #tTransfers as Source
    ON Target.CommitmentID=Source.CommitmentID
   AND Target.TransferSenderAccountId=Source.TransferSenderAccountId
   AND Target.TransferReceiverAccountId=Source.TransferReceiverAccountId
  WHEN MATCHED AND (Target.TrainingCourses<>Source.TrainingCourses
                 OR Target.Cost<>Source.Cost
				 OR Target.TransferStatus<>Source.TransferStatus
				 OR Target.TransferApprovalActionedByEmployerName<>Source.TransferApprovalActionedByEmployerName
				 OR Target.TransferApprovalActionedByEmployerEmail<>Source.TransferApprovalActionedByEmployerEmail
				 OR Target.TransferApprovalActionedOn<>Source.TransferApprovalActionedOn
				 OR Target.TransferCreatedOn<>Source.TransferCreatedOn
				 OR Target.FundingCap<>Source.FundingCap
				 )           
  THEN UPDATE SET Target.TrainingCourses=Source.TrainingCourses
                 ,Target.Cost=Source.Cost
				 ,Target.TransferStatus=Source.TransferStatus
				 ,Target.TransferApprovalActionedByEmployerName=Source.TransferApprovalActionedByEmployerName
				 ,Target.TransferApprovalActionedByEmployerEmail=Source.TransferApprovalActionedByEmployerEmail
				 ,Target.TransferApprovalActionedOn=Source.TransferApprovalActionedOn
				 ,Target.TransferCreatedOn=Source.TransferCreatedOn
				 ,Target.FundingCap=Source.FundingCap
				 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (CommitmentId
	          ,Cost
	          ,TrainingCourses
	          ,TransferStatus
	          ,TransferSenderAccountId
	          ,TransferReceiverAccountId
	          ,TransferApprovalActionedByEmployerName
	          ,TransferApprovalActionedByEmployerEmail
	          ,TransferApprovalActionedOn 
	          ,FundingCap
			  ,TransferCreatedOn
	          ,Data_Source
	          ,Source_TransferId) 
       VALUES (Source.CommitmentId
	          ,Source.Cost
	          ,Source.TrainingCourses
	          ,Source.TransferStatus
	          ,Source.TransferSenderAccountId
	          ,Source.TransferReceiverAccountId
	          ,Source.TransferApprovalActionedByEmployerName
	          ,Source.TransferApprovalActionedByEmployerEmail
	          ,Source.TransferApprovalActionedOn 
	          ,Source.FundingCap
			  ,Source.TransferCreatedOn
	          ,'Commitments-TransferRequest'
	          ,Source.Source_TransferId);


 
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
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
	  ,Run_Id
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'uSP_Import_Transfers',
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
