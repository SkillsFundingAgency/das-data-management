CREATE PROCEDURE [dbo].[ImportRiskAssessmentTool_Incentive_PAYE]
(
   @RunId int
)
AS
-- ==========================================================================================================

-- Description: Materialize the RiskAssessmentTool_Incentive_PAYE table 
-- ==========================================================================================================

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
			   ,'ImportRiskAssessmentTool_Incentive_PAYE'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		   WHERE StoredProcedureName='ImportRiskAssessmentTool_Incentive_PAYE'
			 AND RunId=@RunID

		BEGIN TRANSACTION

	

		TRUNCATE TABLE [ASData_PL].[RiskAssessmentTool_Incentive_PAYE]

       
	;WITH LatestAccountHistory AS
    (
        SELECT *,
               ROW_NUMBER() OVER
               (
                   PARTITION BY AccountId
                   ORDER BY ISNULL(RemovedDate,'9999-12-31') DESC
               ) rn
        FROM ASData_PL.Acc_AccountHistory
    )
    INSERT INTO dbo.RiskAssessmentTool_Incentive_PAYE
    (
        EmpRef,
        LiveEmployeeCount,
        SchemeStartDate,
        AccountId,
        PayeRef,
        RemovedDate,
        IncentiveApplicationApprenticeshipId_RecordId,
        IncentiveApplicationId,
        ApprenticeshipId,
        EmploymentStartDate,
        IncentiveApplicationId_RecordId,
        DateSubmitted,
        ApprenticeshipIncentiveId_RecordId,
        IncentiveApplicationApprenticeshipId,
        ApprenticeshipIncentiveId,
        PaidDate,
        HasHadDataLockSuccess
    )
			


SELECT Distinct
    -- PAYE Variables
    od.EmpRef,
    od.LiveEmployeeCount,
    od.SchemeStartDate,
    ah.AccountId,
    ah.PayeRef,
    ah.RemovedDate,
        
    -- Incentive Variables
    iaa.Id AS IncentiveApplicationApprenticeshipId_RecordId,
    iaa.IncentiveApplicationId,
    iaa.ApprenticeshipId,
    iaa.EmploymentStartDate,

    ia.Id AS IncentiveApplicationId_RecordId,
    ia.DateSubmitted,

    ai.Id AS ApprenticeshipIncentiveId_RecordId,
    ai.IncentiveApplicationApprenticeshipId,

    ep.ApprenticeshipIncentiveId,
    ep.PaidDate,

    ca.HasHadDataLockSuccess
FROM ASData_PL.EI_Payment ep
JOIN ASData_PL.EI_ApprenticeshipIncentive ai
    ON ep.ApprenticeshipIncentiveId = ai.Id
JOIN ASData_PL.EI_IncentiveApplicationApprenticeship iaa
    ON ai.IncentiveApplicationApprenticeshipId = iaa.Id
JOIN ASData_PL.EI_IncentiveApplication ia
    ON iaa.IncentiveApplicationId = ia.Id
JOIN LatestAccountHistory ah
    ON ep.AccountId = ah.AccountId
   AND ah.rn = 1
JOIN ASData_PL.Tpr_OrgDetails od
    ON ah.PayeRef = od.EmpRef
LEFT JOIN ASData_PL.Comt_Apprenticeship ca
    ON ca.Id = iaa.ApprenticeshipId
LEFT JOIN ASData_PL.Comt_Commitment c
    ON c.Id = ca.CommitmentId
   AND c.EmployerAccountId = ah.AccountId
			
		COMMIT TRANSACTION


		

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
				'ImportRiskAssessmentTool_Incentive_PAYE',
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