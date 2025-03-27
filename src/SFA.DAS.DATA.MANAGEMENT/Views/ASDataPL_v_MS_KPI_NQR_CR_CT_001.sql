CREATE VIEW [ASData_PL].[v_MS_KPI_NQR_CR_CT_001] AS
/*##################################################################################################
	-Name:				NQR-CR/CT-001
	-Description:		Decision Outcome within 4-week review cycle (excluding ‘hold’ status)

						KPI Indicator Type - Completion Rate / Completion Time
						Baseline CR - 60%
						Baseline CT - 4 weeks
						Target CR - > 70%
						Target CT - < 2 week
####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################
*/

WITH FirstSubmission AS (
    SELECT 
        M.ApplicationId, 
        MIN(M.SentAt) AS FirstSentAt
    FROM [ASData_PL].[AODP_Messages] M
    WHERE M.Type = 'ApplicationSubmitted'
    GROUP BY M.ApplicationId
)
SELECT 
    A.QualificationNumber,
    AO.RecognitionNumber,
    AO.Id AS AwardingOrganisationId,
    AO.NameLegal AS AwardingOrganisationName,
    M.FirstSentAt AS FormSubmissionDate,
    A.UpdatedAt AS StatusChangeDate,
    A.Status,
    CASE WHEN A.Status IN ('Approved', 'NotApproved', 'Withdrawn') THEN 'Outcome' ELSE 'Not Outcome' END AS StatusType,
    DATEDIFF(HOUR, A.UpdatedAt, M.FirstSentAt) AS Duration
FROM [ASData_PL].[AODP_Applications] A 
LEFT JOIN FirstSubmission M ON M.ApplicationId = A.Id
LEFT JOIN [ASData_PL].[AODP_AwardingOrganisation] AO ON A.OrganisationId = AO.Id;