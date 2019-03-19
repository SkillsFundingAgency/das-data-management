CREATE VIEW vw_Commitments_Apprenticeship_Details
AS
SELECT Comm.Id as CommitmentId
      ,Comm.ProviderId as ProviderId
	  ,Comm.ProviderName as ProviderName
	  ,Comm.EmployerAccountId
	  ,Comm.Reference
	  ,Comm.LegalEntityName
	  ,Comm.LegalEntityAddress
	  ,Comm.CommitmentStatus
	  ,Comm.CommitmentStatusDesc
	  ,App.FirstName ApprenticeFirstName
	  ,App.LastName ApprenticeLastName
	  ,App.ULN
	  ,App.TrainingCode
	  ,App.TrainingName
	  ,App.StartDate TrainingStartDate
	  ,App.EndDate  TrainingEndDate
	  ,CASE WHEN PaymentStatus=1 then 'PendingApproval'
	        WHEN PaymentStatus=2 then 'Active'
			WHEN PaymentStatus=3 then 'Paused'
			WHEN PaymentStatus=4 then 'Withdrawn'
			WHEN PaymentStatus=5 then 'Completed'
			WHEN PaymentStatus=6 then 'Deleted'
			Else 'Unknown'
		END AS PaymentStatus
	  ,AO.Name AS EPAOName
  FROM [Comt].[Apprenticeship] App
  JOIN [Comt].[Commitment] Comm
    ON App.CommitmentId=comm.Id
  LEFT JOIN [Comt].[AssessmentOrganisation] AO
    ON AO.EPAOrgId=APP.EPAOrgId
Go