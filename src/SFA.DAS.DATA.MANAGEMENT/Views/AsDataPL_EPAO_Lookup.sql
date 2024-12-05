/*End point assessment organisation (EPAO) lookup as a view 

Server:   das-prd-shared-sql.secondary.database.windows.net
Database: das-prd-datamgmt-staging-db 

Created by analyst: Ryan Slender 
Created date: 26/11/2024 

One row of data is an EPAO. The list should be unique by EndPointAssessorOrganisationId 
Provides EPAO details and whether they have any active standards

Customers for the view: 

Matthew Heath 
David Nelson 
Kate McDonagh (for FJA)
*/

WITH ActiveStandards AS (
    SELECT
        endpointassessororganisationid AS epao,
        COUNT(DISTINCT standardcode) AS [EPAO - standards associated],
        COUNT(DISTINCT CASE 
                          WHEN CAST(a.effectiveto AS DATE) < CAST(GETDATE() AS DATE) THEN a.standardcode
                      END) AS [EPAO - Standards no longer active?],
        CASE
            WHEN COUNT(DISTINCT standardcode) = 
                 COUNT(DISTINCT CASE 
                                  WHEN CAST(a.effectiveto AS DATE) < CAST(GETDATE() AS DATE) THEN a.standardcode
                              END) THEN 'Yes' 
        END AS [EPAO - has no active standards?],
        MAX(EffectiveTo) AS [Standards - LatestEffectiveTo date],
        DATEDIFF(MONTH, MAX(effectiveto), GETDATE()) 
            + (DAY(GETDATE()) - DAY(MAX(effectiveto))) * 1.0 / DAY(EOMONTH(MAX(effectiveto))) AS [EPAO - Months since last active standard],
        CASE 
            WHEN MAX(EffectiveTo) IS NOT NULL
                 AND DATEDIFF(MONTH, MAX(effectiveto), GETDATE()) 
                     + (DAY(GETDATE()) - DAY(MAX(effectiveto))) * 1.0 / DAY(EOMONTH(MAX(effectiveto))) <= 36 THEN 'Yes' 
        END AS [EPAO - Last active standard within 3 years]
    FROM [asdata_pl].[assessor_organisationstandard] a
    GROUP BY endpointassessororganisationid
)
SELECT
    o.[EndPointAssessorUkprn],
    o.[EndPointAssessorName],
    o.[EndPointAssessorOrganisationId],
    ot.TypeDescription AS [Organisation type],
    o.[Status],
    ast.[EPAO - standards associated],
    ast.[EPAO - Standards no longer active?],
    ast.[EPAO - has no active standards?],
    CASE WHEN ast.[EPAO - has no active standards?] IS NOT NULL THEN CAST(ast.[EPAO - Months since last active standard] AS DECIMAL(10,1)) END AS [EPAO - Months since last active standard] ,
    CASE WHEN ast.[EPAO - has no active standards?] IS NOT NULL THEN ast.[EPAO - Last active standard within 3 years] END AS [EPAO - Last active standard within 3 years] ,
    CAST(o.[CreatedAt] AS DATE) AS CreatedAt,
    CAST(o.[DeletedAt] AS DATE) AS DeletedAt,
    CAST(o.[UpdatedAt] AS DATE) AS UpdatedAt
FROM [ASData_PL].[Assessor_Organisations] o
LEFT JOIN [ASData_PL].[Assessor_OrganisationType] ot
    ON o.OrganisationTypeId = ot.Id
LEFT JOIN ActiveStandards ast
    ON o.EndPointAssessorOrganisationId = ast.epao
WHERE
    o.EndPointAssessorOrganisationId <> 'EPA0000' -- remove test id
    AND ast.epao IS NOT NULL
ORDER BY EndPointAssessorOrganisationId;