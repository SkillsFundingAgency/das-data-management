/* --------------------------------------------------------------------------------
Validate Data_Pub.Das_LevyDeclarations view has same content as source. 

Cut off at midnight on a specific date to allow the queries to be run and be 
repeatable over a period of testing - ie no new records turn up in between 
running queries. SET THE DATE BEFORE RUNNING THE SCRIPT. 

---------------------------------------------------------------------------------- */

DECLARE @CutoffDate DATE = '18-Oct-2019';

BEGIN

/* Check sample of columns match 
Could be improved by specify where clause to get different record types, 
but this is enough for now to validate mappings.
*/ 

select top 10 * 
from Fin.Ext_Tbl_LevyDeclaration vw
inner join Data_Pub.Das_LevyDeclarations src on vw.HmrcSubmissionId = src.HmrcSubmissionId;

/* Check 01/02 Count/Sum Overall Total comparison */

WITH cte_source AS
( SELECT COUNT(*) AS CountSource
	, SUM( ld.LevyDueYTD) AS AmountYTDSource
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceSource
	FROM Fin.Ext_Tbl_LevyDeclaration ld
	WHERE SubmissionDate < @CutoffDate
)
, cte_view AS
( SELECT COUNT(*) AS CountView
	, SUM( LevyDueYearToDate ) AS AmountYTDView
	, SUM( LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
) 
SELECT CountSource, CountView, CountSource - CountView AS RowCountDiff
  , AmountYTDSource, AmountYTDView,  AmountYTDSource - AmountYTDView AS AmountDiff
	, AmountAllowanceSource, AmountAllowanceView, AmountAllowanceSource - AmountAllowanceView AS AmountAllowanceDiff
from cte_source 
JOIN cte_view on 1=1 -- trick to get parser to allow no ON clause.
;

/* Check 03/04 Count/Sum by DASAccountID  */

WITH cte_source AS
( SELECT a.HashedId
  , COUNT(*) AS CountSource
	, SUM( ld.LevyDueYTD) AS AmountYTDSource
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceSource
	FROM Fin.Ext_Tbl_LevyDeclaration ld
	INNER JOIN Acct.Ext_Tbl_Account a on ld.AccountId = a.Id
	WHERE ld.SubmissionDate < @CutoffDate
	GROUP BY a.HashedId
)
, cte_view AS
( SELECT ld.DASAccountID
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.DASAccountID
) 
SELECT HashedId, DasAccountId
, CountSource, CountView, CountSource - CountView AS RowCountDiff
, AmountYTDSource, AmountYTDView,  AmountYTDSource - AmountYTDView AS AmountDiff
, AmountAllowanceSource, AmountAllowanceView, AmountAllowanceSource - AmountAllowanceView AS AmountAllowanceDiff
from cte_source src
full outer join cte_view vw on src.HashedId = vw.DASAccountID
;
/* 05/06 count/sum by SubmissionDate */

WITH cte_source AS
( SELECT CAST ( ld.SubmissionDate AS date ) AS SubmissionDate
  , COUNT(*) AS CountSource
	, SUM( ld.LevyDueYTD) AS AmountYTDSource
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceSource
	FROM Fin.Ext_Tbl_LevyDeclaration ld
	WHERE ld.SubmissionDate < @CutoffDate
	GROUP BY CAST ( ld.SubmissionDate AS date ) 
)
, cte_view AS
( SELECT ld.SubmissionDate
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.SubmissionDate
) 
SELECT src.SubmissionDate, vw.SubmissionDate
, CountSource, CountView, CountSource - CountView AS RowCountDiff
, AmountYTDSource, AmountYTDView,  AmountYTDSource - AmountYTDView AS AmountDiff
, AmountAllowanceSource, AmountAllowanceView, AmountAllowanceSource - AmountAllowanceView AS AmountAllowanceDiff
from cte_source src
full outer join cte_view vw on src.SubmissionDate = vw.SubmissionDate
;

/* 09/10 count/sum by payroll year/month */
WITH cte_source AS
( SELECT ld.PayrollYear, ld.PayrollMonth
  , COUNT(*) AS CountSource
	, SUM( ld.LevyDueYTD) AS AmountYTDSource
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceSource
	FROM Fin.Ext_Tbl_LevyDeclaration ld
	WHERE ld.SubmissionDate < @CutoffDate
	GROUP BY ld.PayrollYear, ld.PayrollMonth
)
, cte_view AS
( SELECT ld.PayrollYear, ld.PayrollMonth
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.PayrollYear, ld.PayrollMonth
) 
SELECT src.PayrollYear, src.PayrollMonth, vw.PayrollYear, vw.PayrollMonth
, CountSource, CountView, CountSource - CountView AS RowCountDiff
, AmountYTDSource, AmountYTDView,  AmountYTDSource - AmountYTDView AS AmountDiff
, AmountAllowanceSource, AmountAllowanceView, AmountAllowanceSource - AmountAllowanceView AS AmountAllowanceDiff
from cte_source src
full outer join cte_view vw on src.PayrollYear = vw.PayrollYear AND src.PayrollMonth = vw.PayrollMonth
;

/* Check 05/06 Count/Sum by PAYE Reference */
WITH cte_source AS
( SELECT HASHBYTES('SHA2_512',RTRIM(LTRIM(CAST(LD.empRef AS VARCHAR(20))))) AS PAYEReference
  , COUNT(*) AS CountSource
	, SUM( ld.LevyDueYTD) AS AmountYTDSource
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceSource
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp ld
	WHERE ld.SubmissionDate < @CutoffDate
	GROUP BY HASHBYTES('SHA2_512',RTRIM(LTRIM(CAST(LD.empRef AS VARCHAR(20))))) 
)
, cte_view AS
( SELECT ld.PAYEReference
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.PAYEReference
) 
SELECT src.PAYEReference, vw.PAYEReference
, CountSource, CountView, CountSource - CountView AS RowCountDiff
, AmountYTDSource, AmountYTDView,  AmountYTDSource - AmountYTDView AS AmountDiff
, AmountAllowanceSource, AmountAllowanceView, AmountAllowanceSource - AmountAllowanceView AS AmountAllowanceDiff
FROM cte_source src
FULL outer join cte_view vw on src.PAYEReference = vw.PAYEReference
;

/* 11/12 List rows where the source and target HMRCSubmissionID value is 
different or null (missing).

This works at transaction level to find rows which are missing/extra and can 
then be used to validate the other subtotal reports.
*/

WITH cte_source AS
( SELECT HmrcSubmissionId
  , COUNT(*) AS CountSource
	, SUM( ld.LevyDueYTD) AS AmountYTDSource
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceSource
	FROM Fin.Ext_Tbl_LevyDeclaration ld
	WHERE ld.SubmissionDate < @CutoffDate
	GROUP BY HmrcSubmissionId
)
, cte_view AS
( SELECT ld.HmrcSubmissionId
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.HmrcSubmissionId
) 
SELECT src.HmrcSubmissionId, vw.HmrcSubmissionId
, CountSource, CountView, CountSource - CountView AS RowCountDiff
, AmountYTDSource, AmountYTDView,  AmountYTDSource - AmountYTDView AS AmountDiff
, AmountAllowanceSource, AmountAllowanceView, AmountAllowanceSource - AmountAllowanceView AS AmountAllowanceDiff
FROM cte_source src
FULL outer join cte_view vw on src.HmrcSubmissionId = vw.HmrcSubmissionId
 
END
;