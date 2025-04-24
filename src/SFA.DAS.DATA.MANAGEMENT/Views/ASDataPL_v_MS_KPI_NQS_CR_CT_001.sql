CREATE VIEW [ASData_PL].[v_MS_KPI_NQS_CR_CT_001]
AS
/*##################################################################################################
	-Name:				NQS-CR/CT-001
	-Description:		Started forms are submitted within 2 weeks /
	                    Average Time (time between starting and submitting a form)

						KPI Indicator Type - Completion Rate / Completion Time
						Baseline CR - N/A
						Baseline CT - 1 week
						Target CR - > 95%
						Target CT - < 1 week

####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################
*/

WITH MessageMinSent AS (
    SELECT 
        M.ApplicationId,
        M.Type,
        MIN(M.SentAt) AS SentAt
    FROM [ASData_PL].[AODP_Messages] M 
    WHERE M.Type IN ('ApplicationSubmitted', 'Draft')
    GROUP BY M.ApplicationId, M.Type
)
SELECT  
    MM_MSG.ApplicationId,
    A.QualificationNumber,
    AO.RecognitionNumber,
    AO.Id AS AwardingOrganisationId,
    AO.NameLegal AS AwardingOrganisationName,
    MM_MSG.Type,
    MM_MSG.SentAt
FROM MessageMinSent MM_MSG
LEFT JOIN [ASData_PL].[AODP_Applications] A ON A.Id = MM_MSG.ApplicationId
LEFT JOIN [ASData_PL].[AODP_AwardingOrganisation] AO ON A.OrganisationId = AO.Id;