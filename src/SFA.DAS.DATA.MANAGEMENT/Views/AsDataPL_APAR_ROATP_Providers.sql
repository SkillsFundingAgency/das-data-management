CREATE VIEW [AsData_PL].[APAR_ROATP_Providers]
	AS 
SELECT
      o.[UKPRN]
      , o.[LegalName] AS Name
      , pt.ProviderType
      , CAST(JSON_VALUE(OrganisationData, '$.StartDate') AS DATE) AS StartDate
      , os.[Status]
      , CAST(JSON_VALUE(OrganisationData, '$.ApplicationDeterminedDate') AS DATE) AS ApplicationDeterminedDate

FROM [ASData_PL].[APAR_ROATP_Organisations] o
    LEFT JOIN [ASData_PL].[APAR_ROATP_ProviderTypes] pt
    ON o.ProviderTypeId = pt.Id
    LEFT JOIN [ASData_PL].[APAR_ROATP_OrganisationStatus] os
    ON o.StatusId = os.Id

WHERE 
 os.[Status] IN(
    'Active','Active - but not taking on apprentices')