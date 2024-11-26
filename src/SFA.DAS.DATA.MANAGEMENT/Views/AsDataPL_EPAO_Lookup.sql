CREATE VIEW [AsData_PL].[EPAO_Lookup]
	AS 
SELECT
    o.[EndPointAssessorUkprn]
      , o.[EndPointAssessorName]
      , o.[EndPointAssessorOrganisationId]
      , ot.TypeDescription AS [Organisation type]
      , o.[Status]
      , cast(o.[CreatedAt] AS DATE) AS CreatedAt
      , cast(o.[DeletedAt] AS DATE) AS DeletedAt
      , cast(o.[UpdatedAt] AS DATE) AS UpdatedAt

FROM [ASData_PL].[Assessor_Organisations] o
    LEFT JOIN [ASData_PL].[Assessor_OrganisationType] ot
    ON o.OrganisationTypeId = ot.Id

    ORDER BY EndPointAssessorOrganisationId