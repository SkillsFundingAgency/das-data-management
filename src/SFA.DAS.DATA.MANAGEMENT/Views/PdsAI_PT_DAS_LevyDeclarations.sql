CREATE VIEW [Pds_AI].[PT_H]
	AS 
SELECT DISTINCT
      [EmpRef]                                  AS H1
      ,CASE WHEN sum([LevyDeclaredInMonth]) >= 5000 THEN 10000
	        ELSE 0
		END                                     AS H2
  FROM [ASData_PL].[Fin_GetLevyDeclarationAndTopUp]
 WHERE payrollyear in ('19-20','20-21','21-22')
   AND lastsubmission=1
 GROUP BY
 empref
