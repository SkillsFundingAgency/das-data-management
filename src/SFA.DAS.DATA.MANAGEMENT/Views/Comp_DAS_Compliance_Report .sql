CREATE VIEW [Comp].[DAS_Compliance_Report]
	AS 

SELECT			
	CN.DASAccountID		
	,ISNULL(CAST(Acc.Name as nvarchar(100)),'NA') as DASAccountName	
	,ISNULL(LD.PayrollYear, '2999') AS PayrollYear
	,ISNULL(LD.PayrollMonth, '99') AS PayrollMonth		
	,CN.CalendarYear		
	,CN.CalendarMonth		
	,SUM(ISNULL(LevyDeclaredInMonth, 0)) AS LevyDeclaredInMonth		
	,SUM(ISNULL(PaymentLevy, 0)) AS PaymentLevy		
	,SUM(ISNULL(PaymentCoInvestedESFA, 0)) AS PaymentCoInvestedESFA		
FROM			
(
	SELECT DISTINCT		
		 CASE	
		 	WHEN LD.PayrollMonth BETWEEN 1 AND 8 THEN LD.PayrollMonth + 4
		 	ELSE LD.PayrollMonth - 8
		 END AS CalendarMonth -- align	
		,CASE	
			WHEN LD.PayrollMonth BETWEEN 1 AND 8 THEN CONCAT('20', LEFT(LD.PayrollYear, 2))
			ELSE CONCAT('20', FORMAT(CONVERT(INT, SUBSTRING(LD.PayrollYear, 4, 2)), '00'))
		END AS CalendarYear
		 ,LD.PayrollMonth
		 ,LD.PayrollYear
		 ,ISNULL(EA.HashedId,'XXXXXX') AS DASAccountID
	FROM AsData_PL.Acc_Account EA
	LEFT JOIN ASData_PL.Fin_GetLevyDeclarationAndTopUp AS LD
		ON EA.ID=LD.AccountId
	WHERE LD.LastSubmission=1
	UNION		
	SELECT DISTINCT
		cp.CalendarMonth
		,
		cp.CalendarYear
		,
		CASE	
			WHEN cp.CalendarMonth BETWEEN 1 AND 4 THEN cp.CalendarMonth + 8
			ELSE cp.CalendarMonth - 4
		END AS PayrollMonth	
		,
		CASE	
			WHEN cp.CalendarMonth BETWEEN 1 AND 4 THEN CONCAT(CAST(RIGHT(cp.CalendarYear, 2) -1 AS VARCHAR), '-', CAST(RIGHT(cp.CalendarYear, 2) AS VARCHAR))
			ELSE CONCAT(CAST(RIGHT(cp.CalendarYear, 2) AS VARCHAR),'-', CAST(RIGHT(cp.CalendarYear, 2) + 1 AS VARCHAR))
		END AS PayrollYear	
		,
		DASAccountID	
	FROM
	(
	 SELECT
		ISNULL(CASE WHEN P.CollectionPeriod <= 12 THEN CalCP.CalendarMonthNumber
			WHEN P.CollectionPeriod = 13 THEN 9
			WHEN P.CollectionPeriod = 14 THEN 10
			END, -1) AS CalendarMonth
		,
		ISNULL(CASE WHEN P.CollectionPeriod <= 12 THEN CalCP.CalendarYear
		  WHEN P.CollectionPeriod IN (13,14) THEN
			CAST( CONCAT('20', SUBSTRING( CAST ( P.AcademicYear AS VARCHAR) , 3, 4)) AS INT )
		  END, -1) AS CalendarYear,
		EA.HashedId AS DASAccountID	
		FROM StgPmts.Payment P
	
		LEFT OUTER JOIN dbo.DASCalendarMonth CalCP -- Calendar Conversion for CollectionPeriod Dates
			ON CONCAT('20', SUBSTRING( CAST ( P.AcademicYear AS VARCHAR) , 1, 2), '/', SUBSTRING( CAST ( P.AcademicYear AS VARCHAR) , 3, 4)) = CalCP.AcademicYear
			AND P.CollectionPeriod = CalCP.AcademicMonthNumber
	
		LEFT JOIN 	AsData_PL.Acc_Account EA
			ON EA.ID=P.AccountId
	) AS cp	
) AS CN
	LEFT JOIN (	
	SELECT		
		 ISNULL(CAST(LD.[PayrollMonth] AS TINYINT),0) AS PayrollMonth
		,ISNULL(CAST(LD.[PayrollYear] AS NVARCHAR(10)),-1) AS PayrollYear
		,ISNULL(EA.HashedId,'XXXXXX') AS DASAccountID
		,SUM(LevyDeclaredInMonth) AS LevyDeclaredInMonth	
	FROM AsData_PL.Acc_Account EA
		LEFT JOIN ASData_PL.Fin_GetLevyDeclarationAndTopUp AS LD
		ON EA.ID=LD.AccountId
	GROUP BY		
		PayrollMonth	
		,PayrollYear	
		,ISNULL(EA.HashedId,'XXXXXX')
) AS LD		
		ON
         CN.PayrollMonth = LD.PayrollMonth	
		AND
         CN.PayrollYear = LD.PayrollYear	
		AND
         CN.DASAccountID = LD.DASAccountID	
	LEFT JOIN
	(		
	SELECT DISTINCT
		CP.CalendarMonth
		,
		CP.CalendarYear
		,
		CP.DASAccountID
		,
		SUM(CASE WHEN CP.FundingSource = 'Levy' THEN CP.Amount ELSE 0 END) AS PaymentLevy
		,
		SUM(CASE WHEN CP.FundingSource = 'CoInvestedSFA' THEN CP.Amount ELSE 0 END) AS PaymentCoInvestedESFA	
	FROM
		(
		SELECT 		
				ISNULL(CASE WHEN P.CollectionPeriod <= 12 THEN CalCP.CalendarMonthNumber
				WHEN P.CollectionPeriod = 13 THEN 9
				WHEN P.CollectionPeriod = 14 THEN 10
				END, -1) AS CalendarMonth
				,
			
				ISNULL(CASE WHEN P.CollectionPeriod <= 12 THEN CalCP.CalendarYear
				WHEN P.CollectionPeriod IN (13,14) THEN
				CAST( CONCAT('20', SUBSTRING( CAST ( P.AcademicYear AS VARCHAR) , 3, 4)) AS INT )
				END, -1) AS CalendarYear
		
				,EA.HashedId AS DASAccountID
			
				, CAST( COALESCE(FS.FieldDesc,'Unknown') AS nvarchar(25) ) AS FundingSource
				, ISNULL( CAST( P.Amount AS DECIMAL (18, 5) ), -1 ) AS Amount
			FROM		
				StgPmts.Payment AS P
	
			LEFT OUTER JOIN dbo.DASCalendarMonth CalCP -- Calendar Conversion for CollectionPeriod Dates
				ON CONCAT('20', SUBSTRING( CAST ( P.AcademicYear AS VARCHAR) , 1, 2), '/', SUBSTRING( CAST ( P.AcademicYear AS VARCHAR) , 3, 4)) = CalCP.AcademicYear
				AND P.CollectionPeriod = CalCP.AcademicMonthNumber
	
			LEFT JOIN AsData_PL.Acc_Account EA
				ON EA.ID=P.AccountId
			LEFT JOIN dbo.ReferenceData FS
			  ON FS.FieldValue=P.FundingSource
				AND FS.FieldName='FundingSource'
				AND FS.Category='Payments'
		) AS CP
	GROUP BY		
		CalendarMonth
		,CalendarYear
		,DASAccountID
	)
	AS Pay		
		ON CN.DASAccountID = Pay.DasAccountId	
		AND CN.CalendarMonth = Pay.CalendarMonth	
		AND CN.CalendarYear = Pay.CalendarYear	
	LEFT JOIN [ASData_PL].[Acc_Account] AS Acc
		ON CN.DasAccountId = isnull(CAST(Acc.HashedId AS nvarchar(100)),'XXXXXX')			
GROUP BY
	CN.DASAccountID
	,ISNULL(CAST(Acc.Name as nvarchar(100)),'NA')	
	,LD.PayrollYear
	,LD.PayrollMonth
	,CN.CalendarYear
	,CN.CalendarMonth
HAVING			
	SUM(ISNULL(LevyDeclaredInMonth, 0)) > 0
	OR SUM(ISNULL(PaymentLevy, 0)) > 0
	OR SUM(ISNULL(PaymentCoInvestedESFA, 0)) > 0 
GO

