﻿CREATE PROCEDURE [dbo].[uSP_Import_Apprenticeship]
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Import Apprenticeship Related Data 
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
	   ,'uSP_Import_Apprenticeship'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results

  /* Get Commitment Data into Temp Table */
  
IF OBJECT_ID ('tempdb..#tApprenticeship') IS NOT NULL
DROP TABLE #tApprenticeship

SELECT *
INTO #tApprenticeship
from dbo.Ext_Tbl_Apprenticeship

IF OBJECT_ID ('tempdb..#tSourceApprenticeship') IS NOT NULL
DROP TABLE #tSourceApprenticeship

select ta.id as Source_ApprenticeshipId
      ,c.id as CommitmentId
	  ,ao.id as AssessmentOrgId
	  ,tc.id as TrainingCourseId
	  ,a.id as ApprenticeId
      ,ta.Cost
	  ,ta.StartDate
	  ,ta.EndDate
	  ,ta.AgreementStatus
	  ,ta.PaymentStatus as ApprenticeshipStatus
	  ,ta.EmployerRef
	  ,ta.ProviderRef
	  ,ta.CreatedOn as CommitmentCreatedOn
	  ,ta.AgreedOn as CommitmentAgreedOn
	  ,ta.PaymentOrder 
	  ,ta.StopDate
	  ,ta.PauseDate
	  ,ta.HasHadDataLockSuccess
	  ,ta.PendingUpdateOriginator
	  ,ta.CloneOf
	  ,ta.ReservationId
	  ,ta.IsApproved    
into #tSourceApprenticeship
from #tApprenticeship ta
left
join dbo.Commitment c
  on c.Commitments_SourceId=ta.CommitmentId
left
join dbo.AssessmentOrganisation ao
  on ao.EPAOId=ta.EPAOrgId
left
join dbo.TrainingCourse tc
  on tc.TrainingType=ta.TrainingType
 and tc.TrainingCode=ta.TrainingCode
 and tc.TrainingName=ta.TrainingName
left
join dbo.Apprentice a
  on a.uln=ta.ULN
 and a.firstname=ta.FirstName
 and a.lastname=ta.LastName
 and a.dateofbirth=ta.DateOfBirth

 MERGE dbo.Apprenticeship as Target
 USING #tSourceApprenticeship as Source
    ON Target.CommitmentId=Source.CommitmentId
   AND Target.AssessmentOrgId=Source.AssessmentOrgId
   AND Target.TrainingCourseId=Source.TrainingCourseId
   AND Target.ApprenticeId=Source.ApprenticeId
  WHEN MATCHED AND ( Target.Cost<>Source.Cost
	              OR Target.StartDate<>Source.StartDate
	              OR Target.EndDate<>Source.EndDate
	              OR Target.AgreementStatus<>Source.AgreementStatus
	              OR Target.ApprenticeshipStatus<>Source.ApprenticeshipStatus
	              OR Target.EmployerRef<>Source.EmployerRef
	              OR Target.ProviderRef<>Source.ProviderRef
				  OR Target.CommitmentCreatedOn<>Source.CommitmentCreatedOn
				  OR Target.CommitmentAgreedOn<>Source.CommitmentAgreedOn
				  OR Target.PaymentOrder<>Source.PaymentOrder
	              OR Target.StopDate<>Source.StopDate
	              OR Target.PauseDate<>Source.PauseDate
	              OR Target.HasHadDataLockSuccess<>Source.HasHadDataLockSuccess
	              OR Target.PendingUpdateOriginator<>Source.PendingUpdateOriginator
	              OR Target.CloneOf<>Source.CloneOf
	              OR Target.ReservationId<>Source.ReservationId
	              OR Target.IsApproved <>Source.IsApproved  
				  OR Target.Source_ApprenticeshipId<>Source.Source_ApprenticeshipId
				  )
  THEN UPDATE SET Target.Cost=Source.Cost
	             ,Target.StartDate=Source.StartDate
	             ,Target.EndDate=Source.EndDate
	             ,Target.AgreementStatus=Source.AgreementStatus
	             ,Target.ApprenticeshipStatus=Source.ApprenticeshipStatus
	             ,Target.EmployerRef=Source.EmployerRef
	             ,Target.ProviderRef=Source.ProviderRef
				 ,Target.CommitmentCreatedOn=Source.CommitmentCreatedOn
				 ,Target.CommitmentAgreedOn=Source.CommitmentAgreedOn
				 ,Target.PaymentOrder=Source.PaymentOrder
	             ,Target.StopDate=Source.StopDate
	             ,Target.PauseDate=Source.PauseDate
	             ,Target.HasHadDataLockSuccess=Source.HasHadDataLockSuccess
	             ,Target.PendingUpdateOriginator=Source.PendingUpdateOriginator
	             ,Target.CloneOf=Source.CloneOf
	             ,Target.ReservationId=Source.ReservationId
	             ,Target.IsApproved=Source.IsApproved  
				 ,Target.Source_ApprenticeshipId=Source.Source_ApprenticeshipId
				 ,Target.AsDm_UpdatedDate=getdate()
   WHEN NOT MATCHED BY TARGET 
   THEN INSERT(CommitmentId 
              ,ApprenticeId
              ,TrainingCourseId
              ,EPAOId
              ,Cost
              ,StartDate 
              ,EndDate 
              ,AgreementStatus
              ,ApprenticeshipStatus 
              ,EmployerRef
              ,ProviderRef
              ,CommitmentCreatedOn
              ,CommitmentAgreedOn
              ,PaymentOrder
              ,StopDate
              ,PauseDate
              ,HasHadDataLockSuccess
              ,PendingUpdateOriginator
              ,PendingUpdateOrginatorDesc
              ,CloneOf
              ,ReservationId
              ,IsApproved
              ,Data_Source
              ,Source_ApprenticeshipId
			  )
	   VALUES (Source.CommitmentId 
              ,Source.ApprenticeId
              ,Source.TrainingCourseId
              ,Source.EPAOId
              ,Source.Cost
              ,Source.StartDate 
              ,Source.EndDate 
              ,Source.AgreementStatus
              ,Source.ApprenticeshipStatus 
              ,Source.EmployerRef
              ,Source.ProviderRef
              ,Source.CommitmentCreatedOn
              ,Source.CommitmentAgreedOn
              ,Source.PaymentOrder
              ,Source.StopDate
              ,Source.PauseDate
              ,Source.HasHadDataLockSuccess
              ,Source.PendingUpdateOriginator
              ,Source.PendingUpdateOrginatorDesc
              ,Source.CloneOf
              ,Source.ReservationId
              ,Source.IsApproved
              ,'Commitments-Apprenticeship'
              ,Source.Source_ApprenticeshipId
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
