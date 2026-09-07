CREATE VIEW [ASData_PL].[AssessorStaffReportsDetailedExtract]
As
		
SELECT 
		CAST(DATEADD(day, 1, EOMONTH(DATEADD(month, -2, GETDATE()))) AS DATE) [Month], 
		[StandardCertificates].[Uln] [Apprentice ULN],
		UPPER(FullName) [Apprentice Names],
		AchievementDate  [Achievement Date],
		TRIM(UPPER(StandardName)) [Standard Name],
		[StandardCertificates].[StandardCode] [Standard Code],
		UPPER(StandardReference) [Standard Reference],
		ISNULL([Version],'') [Standard Version],
		[Organisations].[EndPointAssessorOrganisationId] [EPAO ID],
		[Organisations].[EndPointAssessorName] [EPAO Name],
		[StandardCertificates].[ProviderUkPrn] [Provider UkPrn],
		UPPER(ProviderName) [Provider Name],
		CASE
			WHEN [LatestSubmittedPassesBetweenReportDates].[EventTime] IS NULL THEN [StandardCertificates].[Status]
			ELSE [LatestSubmittedPassesBetweenReportDates].[Status]
			END AS [Status]
	FROM
		[ASData_PL].Assessor_Certificates AS [StandardCertificates] INNER JOIN [ASData_PL].Assessor_Organisations [Organisations]
		ON [StandardCertificates].OrganisationId = [Organisations].Id INNER JOIN
		(
			-- take the latest certificate submission from the logs within the report period which is not a fail
			SELECT
				[Action],
				[CertificateId],
				[EventTime],
				[Status]
			FROM
			(
				SELECT 
					[Action],
					[CertificateId],
					[EventTime],
					[Status],
					ROW_NUMBER() OVER (PARTITION BY [CertificateId], [Action] ORDER BY [EventTime]) RowNumber
				FROM [ASData_PL].Assessor_CertificateLogs
				WHERE 
					[Action] = 'Submit'
					AND [EventTime] BETWEEN DATEADD(day, 1, EOMONTH(DATEADD(month, -2, GETDATE()))) AND DATEADD(second, -1, DATEADD(day, 1, CAST(EOMONTH(DATEADD(day, 1, EOMONTH(DATEADD(month, -2, GETDATE())))) AS DATETIME)))
					AND ISNULL(LatestEpaOutcome,'Pass') != 'Fail'
			) [SubmittedPassesBetweenReportDates]
			WHERE 
				[SubmittedPassesBetweenReportDates].RowNumber = 1
		) [LatestSubmittedPassesBetweenReportDates] 
		ON [LatestSubmittedPassesBetweenReportDates].[CertificateId] = [StandardCertificates].[Id] AND [StandardCertificates].[CertificateReferenceId] >= 10000 AND [StandardCertificates].[CreatedBy] <> 'manual'
	WHERE
		-- any later certificate submission has not been rescinded
		ISNULL(LatestEpaOutcome,'Pass') != 'Fail' and StandardCertificates.[Type]='Standard'
