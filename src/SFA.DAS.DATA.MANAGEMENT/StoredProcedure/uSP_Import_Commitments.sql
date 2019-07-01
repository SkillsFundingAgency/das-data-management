
CREATE PROCEDURE uSP_Import_Commitments
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import Provider Related Data 
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
	   ,'Step-5'
	   ,'uSP_Import_Commitments'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get Commitment Data into Temp Table */

IF OBJECT_ID ('tempdb..#tCommitments') IS NOT NULL
DROP TABLE #tCommitments

select etc.id as Commitments_SourceId
      ,etc.[Reference]
      ,etc.[EmployerAccountId]
      ,etc.[LegalEntityId]
      ,etc.[LegalEntityName]
      ,etc.[LegalEntityAddress]
      ,etc.[LegalEntityOrganisationType]
      ,etc.[ProviderName]
      ,etc.[CommitmentStatus]
      ,etc.[EditStatus]
      ,etc.[CreatedOn]
      ,etc.[LastAction]
      ,etc.[LastUpdatedByEmployerName]
      ,etc.[LastUpdatedByEmployerEmail]
      ,etc.[LastUpdatedByProviderName]
      ,etc.[LastUpdatedByProviderEmail]
      ,etc.[TransferApprovalActionedByEmployerName]
      ,etc.[TransferApprovalActionedByEmployerEmail]
      ,etc.[TransferApprovalActionedOn]
      ,etc.[AccountLegalEntityPublicHashedId]
      ,etc.[Originator]
	  ,emp.Id as EmployerId
	  ,Pro.Id as ProviderId
into #tCommitments
from dbo.Ext_Tbl_Commitment ETC
left
join dbo.Employer Emp
  on ETC.EmployerAccountId=Emp.Source_AccountId
 and ETC.LegalEntityId=Emp.LegalEntityId
left
join dbo.Provider Pro
  on Pro.Ukprn=ETC.ProviderId

 MERGE dbo.Commitment as Target
 USING #tCommitments as Source
    ON Target.Reference=Source.Reference
  WHEN MATCHED AND (  Target.EmployerId<>Source.EmployerId
                   OR Target.ProviderId<>Source.ProviderId
				   OR Target.CommitmentStatus<>Source.CommitmentStatus
				   OR Target.EditStatus<>Source.EditStatus
				   OR Target.CommitmentCreatedOn<>Source.CommitmentCreatedOn
				   OR Target.LastAction<>Source.LastAction
				   OR Target.LastUpdatedByEmployerName<>Source.LastUpdatedByEmployerName
				   OR Target.LastUpdatedByEmployerEmail<>Source.LastUpdatedByEmployerEmail
				   OR Target.LastUpdatedByProviderName<>Source.LastUpdatedByProviderName
				   OR Target.LastUpdatedByProviderEmail<>Source.LastUpdatedByProviderEmail
				   --OR Target.EmployerProviderPaymentPriority<>Source.EmployerProviderPaymentPriority
				   --OR Target.ProviderCanApproveCommitment<>Source.ProviderCanApproveCommitment
				   --OR Target.EmployerCanApproveCommitment<>Source.EmployerCanApproveCommitment
				   OR Target.Originator<>Source.Originator
				   OR Target.Commitments_SourceId<>Source.Commitments_SourceId
				   )
  THEN UPDATE SET Target.EmployerId=Source.EmployerId
                 ,Target.ProviderId=Source.ProviderId
				 ,Target.CommitmentStatus=Source.CommitmentStatus
				 ,Target.EditStatus=Source.EditStatus
				 ,Target.CommitmentCreatedOn=Source.CommitmentCreatedOn
				 ,Target.LastAction=Source.LastAction
				 ,Target.LastUpdatedByEmployerName=Source.LastUpdatedByEmployerName
				 ,Target.LastUpdatedByEmployerEmail=Source.LastUpdatedByEmployerEmail
				 ,Target.LastUpdatedByProviderName=Source.LastUpdatedByProviderName
				 ,Target.LastUpdatedByProviderEmail=Source.LastUpdatedByProviderEmail
				 --,Target.EmployerProviderPaymentPriority=Source.EmployerProviderPaymentPriority
				 --,Target.ProviderCanApproveCommitment=Source.ProviderCanApproveCommitment
				 --,Target.EmployerCanApproveCommitment=Source.EmployerCanApproveCommitment
				 ,Target.Originator=Source.Originator
				 ,Target.Commitments_SourceId=Source.Commitments_SourceId
				 ,Target.AsDm_UpdatedDate=getdate()
   WHEN NOT MATCHED BY TARGET 
   THEN INSERT(EmployerId
              ,ProviderId
			  ,Reference
			  ,CommitmentStatus
			  ,EditStatus
			  ,CommitmentCreatedOn
			  ,LastAction
			  ,LastUpdatedByEmployerName
			  ,LastUpdatedByEmployerEmail
			  ,LastUpdatedByProviderName
			  ,LastUpdatedByProviderEmail
			  --,EmployerProviderPaymentPriority
			  --,ProviderCanApproveCommitment
			  --,EmployerCanApproveCommitment
			  ,Originator
			  ,Commitments_SourceId
			  )
	   VALUES (Source.EmployerId
              ,Source.ProviderId
			  ,Source.Reference
			  ,Source.CommitmentStatus
			  ,Source.EditStatus
			  ,Source.CommitmentCreatedOn
			  ,Source.LastAction
			  ,Source.LastUpdatedByEmployerName
			  ,Source.LastUpdatedByEmployerEmail
			  ,Source.LastUpdatedByProviderName
			  ,Source.LastUpdatedByProviderEmail
			  --,Source.EmployerProviderPaymentPriority
			  --,Source.ProviderCanApproveCommitment
			  --,Source.EmployerCanApproveCommitment
			  ,Source.Originator
			  ,Source.Commitments_SourceId
			  );


 
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
	    'uSP_Import_Provider',
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
