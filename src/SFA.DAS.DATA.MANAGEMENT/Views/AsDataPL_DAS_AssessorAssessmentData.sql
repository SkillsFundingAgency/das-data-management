CREATE VIEW [AsData_PL].[DAS_AssessorAssessmentData]
As
SELECT
	CONVERT(VARCHAR(10), DATEADD(mm, DATEDIFF(mm, 0, DATEADD(mm, 0, cl.[EventTime])), 0), 120) AS [Month],
	cl.[EventTime],
	ce.[Uln] AS [Apprentice ULN],
	CONVERT(CHAR(10), ce.AchievementDate) AS [Achievement Date],
	UPPER(ce.StandardName) AS [Standard Name],
	ce.[StandardCode] AS [Standard Code],
	rg.[EndPointAssessorOrganisationId] AS [EPAO ID],
	rg.[EndPointAssessorName] AS [EPAO Name],
	ce.[ProviderUkPrn] AS [Provider UkPrn],
	UPPER(ce.ProviderName) AS [Provider Name],
	CASE
	WHEN cl.[EventTime] IS NULL THEN ce.[Status]
	ELSE cl.[Status]
	END AS [Status],
	CASE WHEN ce.OverallGrade = 'No grade awarded'
	THEN 'Pass'
	WHEN (ce.OverallGrade is null AND cl.EventTime is null)
	THEN 'Fail'
	WHEN (ce.OverallGrade is null AND cl.EventTime is not null)
	THEN 'Pass'
	ELSE 
	ce.OverallGrade 
	END AS OverallGrade,
	ce.[CertificateReferenceId],
	ce.[CreatedBy]
FROM [ASData_PL].[Assessor_Certificates] ce
JOIN [ASData_PL].[Assessor_Organisations] rg ON ce.[OrganisationId] = rg.[Id]
JOIN
(
			SELECT [Action],
			[CertificateId],
			[EventTime],
			[Status]
			FROM
			(
					SELECT [Action],
					[CertificateId],
					[EventTime],
					[Status],
					ROW_NUMBER() OVER (PARTITION BY [CertificateId], [Action] ORDER BY [EventTime]) rownumber
					FROM [ASData_PL].[Assessor_CertificateLogs]
					WHERE ACTION IN ('Submit') 
			) ab
			WHERE ab.rownumber = 1
) 
cl ON cl.[CertificateId] = ce.[Id]

