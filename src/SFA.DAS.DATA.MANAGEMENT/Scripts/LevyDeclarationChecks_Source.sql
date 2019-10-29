/* --------------------------------------------------------------------------------
Validate employer_financial.LevyDeclaration view has same content as source. 

Thes SQL pulls in totals from RDS for 3 way checks. 

Cut off at midnight on a specific date to allow the queries to be run and be 
repeatable over a period of testing - ie no new records turn up in between 
running queries. SET THE DATE BEFORE RUNNING THE SCRIPT. 

Run against [das-prd-eas-fin-db]
---------------------------------------------------------------------------------- */

DECLARE @CutoffDate DATE = '18-Oct-2019';

BEGIN

/* Count/Sum Overall Total comparison on source table */

	SELECT COUNT(*) AS CountSource
	, SUM( ld.LevyDueYTD) AS AmountYTDSource
	, SUM( ld.LevyAllowanceForYear ) AS AmountAllowanceSource
	FROM employer_financial.LevyDeclaration ld
	WHERE SubmissionDate < @CutoffDate

END