CREATE VIEW [ASData_PL].[AssessorStaffReportsByStandard]
As
		
SELECT 
[Standard Name], 
[Standard Code],
[Standard Reference], 
[Standard Version],
[Total], 
[Manual Total], 
[EPA Service Total], 
[EPA Service], 
[EPA Service Manual], 
[EPA Draft], 
[EPA Submitted], 
[EPA Printed], 
[Deleted]
FROM (
  SELECT
        TRIM(REPLACE(UPPER(REPLACE(StandardName, NCHAR(0x00A0), ' ')), 'Á', ' ')) AS [Standard Name],
		CONVERT(CHAR(10), ce.[StandardCode]) AS 'Standard Code',
        StandardCode AS [Standard Reference],
        ISNULL(Version,'') AS [Standard Version],
		ISNULL(RIGHT('00000'+REPLACE(LEFT(ce.[Version],PATINDEX('%.%',ce.[Version])),'.',''),5) +  RIGHT('00000'+REPLACE(ce.[Version],LEFT(ce.[Version],PATINDEX('%.%',ce.[Version])),''),5),'')  AS [orderVersion],
        COUNT(*) AS [Total],
        SUM(CASE WHEN ce.[CertificateReferenceId] < 10000 THEN 1 ELSE 0 END) AS [Manual Total],
        SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 THEN 1 ELSE 0 END) AS [EPA Service Total],
        SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] <> 'manual' THEN 1 ELSE 0 END) AS [EPA Service],
        SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] = 'manual' THEN 1 ELSE 0 END ) AS [EPA Service Manual],
        SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Draft' THEN 1 ELSE 0 END) AS [EPA Draft],
        SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Submitted' THEN 1 ELSE 0 END) AS [EPA Submitted],
        SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Printed' THEN 1 ELSE 0 END) AS [EPA Printed],
        SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NOT NULL THEN 1 ELSE 0 END) AS [Deleted]
  FROM [ASData_PL].Assessor_Certificates ce
  WHERE StandardReference IS NOT NULL AND ce.[Type]='Standard'
  GROUP BY TRIM(REPLACE(UPPER(REPLACE(StandardName, NCHAR(0x00A0), ' ')), 'Á', ' ')),
        StandardReference,ce.[Version], ce.StandardCode

  UNION 
  SELECT
		' Summary' AS [Standard Name],
		''  AS [Standard Code],
		''  AS [Standard Reference],
		''  AS [Standard Version],
		''  AS [orderVersion],
		COUNT(*) AS [Total],
		SUM(CASE WHEN ce.[CertificateReferenceId] < 10000 THEN 1 ELSE 0 END) AS [Manual Total],
		SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 THEN 1 ELSE 0 END) AS [EPA Service Total],
		SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] <> 'manual' THEN 1 ELSE 0 END) AS [EPA Service],
		SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] = 'manual' THEN 1 ELSE 0 END ) AS [EPA Service Manual],
		SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Draft' THEN 1 ELSE 0 END) AS [EPA Draft],
		SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Submitted' THEN 1 ELSE 0 END) AS [EPA Submitted],
		SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Printed' THEN 1 ELSE 0 END) AS [EPA Printed],
		SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NOT NULL THEN 1 ELSE 0 END) AS [Deleted]
  FROM [ASData_PL].[Assessor_Certificates] ce
  WHERE StandardReference is  NOT NULL AND ce.[Type]='Standard'
) st

-- ORDER BY SUM([EPA Service]) OVER (PARTITION BY [Standard Reference]) /* [EPA Service]*/ DESC,
--          MIN([Standard Name]) OVER (PARTITION BY [Standard Reference]) /*[Standard Name] */, 
-- 		 [orderVersion], 
-- 		 SUM([EPA Service Total]) OVER (PARTITION BY [Standard Reference]) /* [EPA Service Total] */ DESC,
-- 		 SUM([Total]) OVER (PARTITION BY [Standard Reference]) /* [Total] */ DESC
