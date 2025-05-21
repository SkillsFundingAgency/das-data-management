CREATE VIEW [ASData_PL].[v_MS_KPI_NQR_TU_003]
AS
/*##################################################################################################
	-Name:				NQR TU 003
	-Description:		AO average time from first saved draft of a form to submitting the form 
						(grouped by form name and version)

						KPI Indicator Type - Take-Up (DfE)
						Baseline - 2 weeks
						Target - < 3 Days


####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################
	1					Adam Leaver		18/03/2025			Original
##################################################################################################*/

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
