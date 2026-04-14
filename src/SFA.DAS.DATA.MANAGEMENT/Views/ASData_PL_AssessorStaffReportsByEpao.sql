CREATE VIEW [ASData_PL].[AssessorStaffReportsByEpao]
As
		
	  SELECT
	  org.[EndPointAssessorName] AS 'EPAO Name',
	  COUNT(*) AS 'Total', 
	  SUM(CASE WHEN ce.[CertificateReferenceId] < 10000 THEN 1 ELSE 0 END) AS 'Manual Total',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 THEN 1 ELSE 0 END) AS 'EPA Service Total',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] <> 'manual' THEN 1 ELSE 0 END) AS 'EPA Service',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] = 'manual' THEN 1 ELSE 0 END) AS 'EPA Service (Manual)',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Draft' THEN 1 ELSE 0 END) AS 'EPA Draft',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Submitted' THEN 1 ELSE 0 END) AS 'EPA Submitted',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Printed' THEN 1 ELSE 0 END) AS 'EPA Printed',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NOT NULL THEN 1 ELSE 0 END) AS 'Deleted'
  FROM [ASData_PL].[Assessor_Certificates] ce
  INNER JOIN [ASData_PL].[Assessor_Organisations] org ON ce.[OrganisationId] = org.[Id]
  WHERE  ce.[Type]='Standard'
  GROUP BY org.[EndPointAssessorName]

  UNION 

  SELECT
	  ' Summary' AS 'EPAO Name',
	  COUNT(*) AS 'Total', 
	  SUM(CASE WHEN ce.[CertificateReferenceId] < 10000 THEN 1 ELSE 0 END) AS 'Manual Total',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 THEN 1 ELSE 0 END) AS 'EPA Service Total',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] <> 'manual' THEN 1 ELSE 0 END) AS 'EPA Service',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 And ce.[CreatedBy] = 'manual' THEN 1 ELSE 0 END) AS 'EPA Service (Manual)',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Draft' THEN 1 ELSE 0 END) AS 'EPA Draft',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Submitted' THEN 1 ELSE 0 END) AS 'EPA Submitted',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NULL AND ce.[Status] = 'Printed' THEN 1 ELSE 0 END) AS 'EPA Printed',
	  SUM(CASE WHEN ce.[CertificateReferenceId] >= 10000 AND ce.[DeletedAt] IS NOT NULL THEN 1 ELSE 0 END) AS 'Deleted'
  FROM [ASData_PL].[Assessor_Certificates] ce
  WHERE  ce.[Type]='Standard'
  ORDER BY 5 DESC, 4 DESC, 2 DESC, 1
