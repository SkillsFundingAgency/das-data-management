/* --------------------------------------------------------------------------------
Validate employer_financial.GetLevyDeclarationAndTopUp view has same content as source. 

Thes SQL pull sin totals from RDS for 3 way checks. 

Cut off at midnight on a specific date to allow the queries to be run and be 
repeatable over a period of testing - ie no new records turn up in between 
running queries. SET THE DATE BEFORE RUNNING THE SCRIPT. 

Run against [das-prd-eas-fin-db]
---------------------------------------------------------------------------------- */



DECLARE @CutoffDate DATE = '20-Oct-2019';

BEGIN

WITH cte_GetTransactions AS
(	-- ** 1 Levy declarations adjusted for English fraction **
  SELECT 
	  gldt.AccountId 
  , gldt.CreatedDate
  , gldt.SubmissionDate
  , gldt.PayrollMonth
  , gldt.PayrollYear
  , NULL AS CollectionMonth
  , NULL AS CollectionYear
  , 'IN Levy Money from HMRC' AS TransactionType
  , ROUND((GLDT.LevyDeclaredInMonth * GLDT.EnglishFraction),2) AS Amount
	FROM employer_financial.GetLevyDeclarationAndTopUp gldt
	UNION ALL	-- ** 2 Top up payment **
  SELECT 
	  gldt.AccountId 
  , gldt.CreatedDate
  , gldt.SubmissionDate
  , gldt.PayrollMonth
  , gldt.PayrollYear
  , NULL AS CollectionMonth
  , NULL AS CollectionYear
  , 'IN Levy Top Up Amount' AS TransactionType
  , gldt.TopUp AS Amount
	FROM employer_financial.GetLevyDeclarationAndTopUp gldt
UNION ALL -- ** 3 Payments **
  SELECT 
	  p.AccountId 
  , p.EvidenceSubmittedOn AS CreatedDate
	, NULL as SubmissionDate
	, NULL as PayrollMonth
	,	NULL as PayrollYear
	, p.CollectionPeriodMonth
	, p.CollectionPeriodYear
  , 'OUT '+p.TransactionType AS TransactionType
  , ROUND((P.Amount*-1),2) AS Amount -- Made negative as Payment
  FROM employer_financial.Payment p
) 
select count(*), sum(amount) 
from cte_GetTransactions;

END;