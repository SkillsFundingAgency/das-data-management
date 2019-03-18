CREATE VIEW [dbo].[vw_CommitmentSummary]
AS 

WITH ApprenticeshipApprovalStatus_CTE (Id, CommitmentId, AgreementStatus, EmployerCanApproveApprenticeship, ProviderCanApproveApprenticeship)
AS (SELECT Id, CommitmentId, AgreementStatus,
	CASE 
		WHEN
			a.FirstName IS NOT NULL AND 
			a.LastName IS NOT NULL AND 
			a.Cost IS NOT NULL AND 
			a.StartDate IS NOT NULL AND 
			a.EndDate IS NOT NULL AND 
			a.TrainingCode IS NOT NULL AND 
			a.DateOfBirth IS NOT NULL
		THEN 1 ELSE 0
	END AS 'EmployerCanApproveApprenticeship',
	CASE 
		WHEN
			a.FirstName IS NOT NULL AND 
			a.LastName IS NOT NULL AND 
			a.ULN IS NOT NULL AND -- ULN is required for provider approval
			a.Cost IS NOT NULL AND 
			a.StartDate IS NOT NULL AND 
			a.EndDate IS NOT NULL AND 
			a.TrainingCode IS NOT NULL AND 
			a.DateOfBirth IS NOT NULL
		THEN 1 ELSE 0
	END AS 'ProviderCanApproveApprenticeship'

	FROM 
		 [Comt].[Apprenticeship] a
)
SELECT c.Id,
        c.Reference,
		c.EmployerAccountId, 
		c.LegalEntityId, 
		c.LegalEntityName, 
		c.ProviderId, 
		c.ProviderName, 
		c.CommitmentStatus, 
		c.CommitmentStatusDesc,
		c.EditStatus, 
		c.EditStatusDesc,
		c.CreatedOn, 
		c.LastAction, 
		c.LastActionDesc,
	    c.LastUpdatedByEmployerEmail, 
		c.LastUpdatedByProviderEmail, 
		c.LastUpdatedByEmployerName, 
		c.LastUpdatedByProviderName, 
		c.LegalEntityAddress, 
	    c.LegalEntityOrganisationType, 
		c.TransferSenderId, 
		c.TransferSenderName, 
		c.TransferApprovalStatus, 
		c.TransferApprovalStatusDesc,
		c.TransferApprovalActionedByEmployerEmail,
	    c.TransferApprovalActionedByEmployerName, 
		c.TransferApprovalActionedOn, 
		c.AccountLegalEntityPublicHashedId, 
		c.Originator,  
	COUNT(a.Id) AS ApprenticeshipCount,

	COALESCE((SELECT TOP 1 AgreementStatus FROM ApprenticeshipApprovalStatus_CTE WHERE CommitmentId = c.Id), 0) AS AgreementStatus, -- because should all be same value

	CASE
		WHEN COUNT(a.Id) > 0 AND 1 = ALL (SELECT EmployerCanApproveApprenticeship FROM ApprenticeshipApprovalStatus_CTE WHERE CommitmentId = c.Id) 
		THEN 1
		ELSE 0 
	END AS EmployerCanApproveCommitment,

	CASE
		WHEN COUNT(a.Id) > 0 AND 1 = ALL (SELECT ProviderCanApproveApprenticeship FROM ApprenticeshipApprovalStatus_CTE WHERE CommitmentId = c.Id) 
		THEN 1 
		ELSE 0 
	END AS ProviderCanApproveCommitment

FROM 
	 [Comt].[Commitment] c
LEFT JOIN 
	 [Comt].[Apprenticeship] a ON a.CommitmentId = c.Id

GROUP BY 
	c.Id, c.Reference, c.EmployerAccountId, c.LegalEntityId, c.LegalEntityName, c.ProviderId, c.ProviderName, c.CommitmentStatus, c.CommitmentStatusDesc, c.EditStatus,
	c.EditStatusDesc, c.CreatedOn, c.LastAction, c.LastActionDesc,
	c.LastUpdatedByEmployerEmail, c.LastUpdatedByProviderEmail, c.LastUpdatedByEmployerName, c.LastUpdatedByProviderName, c.LegalEntityAddress, 
	c.LegalEntityOrganisationType, c.TransferSenderId, c.TransferSenderName, c.TransferApprovalStatus,c.TransferApprovalStatusDesc,
	c.TransferApprovalActionedByEmployerEmail,c.TransferApprovalActionedByEmployerName, c.TransferApprovalActionedOn, c.AccountLegalEntityPublicHashedId, c.Originator
