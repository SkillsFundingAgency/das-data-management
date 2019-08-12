
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
	   ,'Step-2'
	   ,'uSP_Import_Commitments'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get Commitment Data into Temp Table */
  
IF OBJECT_ID ('tempdb..#tCommitments') IS NOT NULL
DROP TABLE #tCommitments

SELECT *
INTO #tCommitments
from Comt.Ext_Tbl_Commitment

IF OBJECT_ID ('tempdb..#tSourceCommitments') IS NOT NULL
DROP TABLE #tSourceCommitments

select etc.id as Commitments_SourceId
      ,etc.[Reference]
      ,etc.[EmployerAccountId] as CmtEmployerAccountId
      ,etc.[LegalEntityId]
      ,etc.[LegalEntityName]
      ,etc.[LegalEntityAddress]
      ,etc.[LegalEntityOrganisationType]
      ,etc.[ProviderName]
      ,etc.[CommitmentStatus]
      ,etc.[EditStatus]
      ,etc.[CreatedOn] as CommitmentCreatedOn
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
	  ,EA.iD as EmployerAccountId
	  ,EALE.id as EmployerAccountLegalEntityId
	  ,Pro.Id as ProviderId
into #tSourceCommitments
from #tCommitments ETC
left
join dbo.EmployerAccount EA
  on ETC.EmployerAccountId=EA.Source_AccountId
LEFT
JOIN dbo.EmployerAccountLegalEntity EALE
  on ETC.EmployerAccountId=EALE.Source_AccountId
 and ETC.LegalEntityId=EALE.LegalEntityId
left
join dbo.Provider Pro
  on Pro.Ukprn=ETC.ProviderId

/* Full Refresh Code */

TRUNCATE TABLE dbo.Commitment

INSERT INTO dbo.Commitment(EmployerAccountId
              ,EmployerAccountLegalEntityId
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
			  ,Data_Source
			  ,Commitments_SourceId
			  )
SELECT Source.EmployerAccountId
	          ,Source.EmployerAccountLegalEntityId
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
			  ,'Commitments'
			  ,Source.Commitments_SourceId
   FROM #tSourceCommitments Source








  /* Delta Code */
/*

 MERGE dbo.Commitment as Target
 USING #tSourceCommitments as Source
    ON Target.Reference=Source.Reference
  WHEN MATCHED AND (  Target.EmployerAccountId<>Source.EmployerAccountId
                   OR Target.EmployerAccountLegalEntityId<>Source.EmployerAccountLegalEntityId
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
  THEN UPDATE SET Target.EmployerAccountId=Source.EmployerAccountId
                 ,Target.EmployerAccountLegalEntityId=Source.EmployerAccountLegalEntityId
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
   THEN INSERT(EmployerAccountId
              ,EmployerAccountLegalEntityId
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
			  ,Data_Source
			  ,Commitments_SourceId
			  )
	   VALUES (Source.EmployerAccountId
	          ,Source.EmployerAccountLegalEntityId
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
			  ,'Commitments'
			  ,Source.Commitments_SourceId
			  );

*/
 
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
	    'uSP_Import_Commitments',
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
