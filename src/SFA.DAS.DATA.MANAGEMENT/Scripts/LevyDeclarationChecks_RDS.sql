/* --------------------------------------------------------------------------------
Validate Data_Pub.Das_LevyDeclarations view has same content as source. 

Cut off at midnight on a specific date to allow the queries to be run and be 
repeatable over a period of testing - ie no new records turn up in between 
running queries. SET THE DATE BEFORE RUNNING THE SCRIPT. 

Run against das-prd-data-db
---------------------------------------------------------------------------------- */

DECLARE @CutoffDate DATE = '18-Oct-2019';

BEGIN

/* Check 01/02 Count/Sum Overall Total comparison */

 SELECT COUNT(*) AS CountView
	, SUM( LevyDueYearToDate ) AS AmountYTDView
	, SUM( LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	AND Flag_Latest = 1
;

/* Check 03/04 Count/Sum by DASAccountID  */

SELECT ld.DASAccountID
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.DASAccountID
;

/* 05/06 count/sum by SubmissionDate */

SELECT ld.SubmissionDate
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.SubmissionDate
;

/* 09/10 count/sum by payroll year/month */
SELECT ld.PayrollYear, ld.PayrollMonth
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.PayrollYear, ld.PayrollMonth
;

/* Check 05/06 Count/Sum by PAYE Reference */
SELECT ld.PAYEReference
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.PAYEReference
;

/* 11/12 List rows where the source and target HMRCSubmissionID value is 
different or null (missing).

This works at transaction level to find rows which are missing/extra and can 
then be used to validate the other subtotal reports.
*/

SELECT ld.HmrcSubmissionId
  , COUNT(*) AS CountView
	, SUM( ld.LevyDueYearToDate ) AS AmountYTDView
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceView
	FROM Data_Pub.Das_LevyDeclarations ld -- #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE SubmissionDateTime < @CutoffDate
	GROUP BY ld.HmrcSubmissionId
;

END
;