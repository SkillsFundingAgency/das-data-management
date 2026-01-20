/*##################################################################################################
	-Name:				NQR TU 002
	-Description:		Average time between “shared with Ofqual|IfATE” to outcome decision 
						(grouped by Ofqual and IfATE)

						KPI Indicator Type - Take-Up (Ofqual/IfATE)
						Baseline - 20 weeks
						Target - < 1 week
####################################################################################################
	Version No.			Updated By		Updated Date		Description of Change
####################################################################################################*/

CREATE VIEW [ASData_PL].[v_MS_KPI_NQR_TU_002] AS
WITH SharedWithCTE AS (
    SELECT 
        M.ApplicationId,
        M.SentAt AS SharedWithDate,
        M.Type,
        CASE M.Type
            WHEN 'ApplicationSharedWithOfqual' THEN 'Ofqual'
            WHEN 'ApplicationSharedWithSkillsEngland' THEN 'SkillsEngland / IfATE'
            ELSE ''
        END AS SharedWith,
        RANK() OVER (PARTITION BY M.ApplicationId ORDER BY M.SentAt ASC) AS R_K
    FROM [ASData_PL].[AODP_Messages] M
    WHERE M.Type IN ('ApplicationSharedWithOfqual', 'ApplicationSharedWithSkillsEngland')
),
AOInformedCTE AS (
    SELECT 
        M.ApplicationId,
        M.SentAt AS AOInformedOfDecisionDate,
        M.Type,
        CASE M.Type
            WHEN 'ApplicationSharedWithOfqual' THEN 'Ofqual'
            WHEN 'ApplicationSharedWithSkillsEngland' THEN 'SkillsEngland / IfATE'
            ELSE ''
        END AS SharedWith,
        RANK() OVER (PARTITION BY M.ApplicationId ORDER BY M.SentAt ASC) AS R_K
    FROM [ASData_PL].[AODP_Messages] M
    WHERE M.Type = 'AoInformedOfDecision'
)
SELECT 
    A.QualificationNumber,
    AO.RecognitionNumber,
    AO.Id AS AwardingOrganisationId,
    AO.NameLegal AS AwardingOrganisationName,
    SW.SharedWithDate,
    De.AOInformedOfDecisionDate,
    DATEDIFF(HOUR, SW.SharedWithDate, De.AOInformedOfDecisionDate) AS Duration
FROM [ASData_PL].[AODP_Applications] A 
LEFT JOIN [ASData_PL].[AODP_AwardingOrganisation]  AO ON A.OrganisationId = AO.Id
LEFT JOIN SharedWithCTE SW ON SW.ApplicationId = A.Id
LEFT JOIN AOInformedCTE De ON De.ApplicationId = A.Id 
Where SW.R_K = 1 and De.R_K = 1;