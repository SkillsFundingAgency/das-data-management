/* --------------------------------------------------------------------------------
Validate Data_Pub.DAS_Employer_AccountTransactions view has same content as source. 

Cut off at midnight on a specific date to allow the queries to be run and be 
repeatable over a period of testing - ie no new records turn up in between 
running queries. SET THE DATE BEFORE RUNNING THE SCRIPT. 

Run against das-pp-datamgmt-staging-db
---------------------------------------------------------------------------------- */


DECLARE @CutoffDate DATE = '20-Oct-2019';

BEGIN

/* Check 01/02 Count/Sum Overall Total comparison */

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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
UNION ALL -- ** 3 Payments **
  SELECT 
	  p.AccountId 
  , p.EvidenceSubmittedOn AS CreatedDate
	, NULL as SubmissionDate
	, NULL as PayrollMonth
	,	NULL as PayrollYear
	, p.CollectionPeriodMonth
	, p.CollectionPeriodYear
  -- can't view reference data table so do a case statement
	, CASE 
	    WHEN p.TransactionType = 1 THEN 'OUT Learning'
			WHEN p.TransactionType = 2 THEN 'OUT Completion'
			WHEN p.TransactionType = 3 THEN 'OUT Balancing'
		END AS TransactionType
	, ROUND((P.Amount*-1),2) AS Amount -- Made negative as Payment
  FROM Fin.Ext_Tbl_Payment p
	WHERE p.FundingSource = 1
) 
, cte_DASAccountTransactions AS
( -- ** 4 join those 3 unions to get DASAccountID **
	SELECT
	  a.HashedId AS DASAccountId
  , gt.CreatedDate
  , gt.SubmissionDate
  , gt.PayrollMonth
  , gt.PayrollYear
  , gt.CollectionMonth
  , gt.CollectionYear
  , gt.TransactionType
  , gt.Amount
	FROM cte_GetTransactions gt
  LEFT JOIN Acct.Ext_Tbl_Account a ON gt.AccountId = a.Id
	WHERE a.HashedId IS NOT NULL
)
, cte_source AS 
( SELECT COUNT(*) AS CountSource
	, SUM( dat.Amount) AS AmountSource
	FROM cte_DASAccountTransactions dat 
)
, cte_view AS
( SELECT COUNT(*) AS CountView
	, SUM( Amount ) AS AmountView
	FROM Data_Pub.DAS_Employer_AccountTransactions 
) 
SELECT CountSource, CountView, CountSource - CountView AS RowCountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
FROM cte_source 
JOIN cte_view ON 1=1 -- trick to get parser to allow no ON clause.
;

/* Check 03/04 Count/Sum by DASAccountID  */

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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
UNION ALL -- ** 3 Payments **
  SELECT 
	  p.AccountId 
  , p.EvidenceSubmittedOn AS CreatedDate
	, NULL as SubmissionDate
	, NULL as PayrollMonth
	,	NULL as PayrollYear
	, p.CollectionPeriodMonth
	, p.CollectionPeriodYear
  -- can't view reference data table so do a case statement
	, CASE 
      WHEN p.TransactionType = 1 THEN 'OUT Learning'
			WHEN p.TransactionType = 2 THEN 'OUT Completion'
			WHEN p.TransactionType = 3 THEN 'OUT Balancing'
		END AS TransactionTypeVw
	, ROUND((P.Amount*-1),2) AS Amount -- Made negative as Payment
  FROM Fin.Ext_Tbl_Payment p
	WHERE p.FundingSource = 1
) 
, cte_DASAccountTransactions AS
( -- ** 4 join those 3 unions to get DASAccountID **
	SELECT
	  a.HashedId AS DASAccountId
  , gt.CreatedDate
  , gt.SubmissionDate
  , gt.PayrollMonth
  , gt.PayrollYear
  , gt.CollectionMonth
  , gt.CollectionYear
  , gt.TransactionType
  , gt.Amount
	FROM cte_GetTransactions gt
  LEFT JOIN Acct.Ext_Tbl_Account a ON gt.AccountId = a.Id
	WHERE a.HashedId IS NOT NULL
)
, cte_source AS 
( SELECT dat.DASAccountID
  , COUNT(*) AS CountSource
	, SUM( dat.Amount) AS AmountSource
	FROM cte_DASAccountTransactions dat 
	GROUP BY dat.DASAccountID
)
, cte_view AS
( SELECT eat.HashedId
  , COUNT(*) AS CountView
	, SUM( eat.Amount ) AS AmountView
	FROM Data_Pub.DAS_Employer_AccountTransactions eat
	WHERE CreatedDate < @CutoffDate
	GROUP BY eat.HashedId
) 
SELECT src.DasAccountId, vw.HashedID
  , CountSource, CountView, CountSource - CountView AS RowCountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
FROM cte_source src
FULL OUTER JOIN cte_view vw ON src.DASAccountId = vw.HashedId
;

/* 05/06 count/sum by payroll year/month */

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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
UNION ALL -- ** 3 Payments **
   SELECT 
	  p.AccountId 
  , p.EvidenceSubmittedOn AS CreatedDate
	, NULL as SubmissionDate
	, NULL as PayrollMonth
	,	NULL as PayrollYear
	, p.CollectionPeriodMonth
	, p.CollectionPeriodYear
  -- can't view reference data table so do a case statement
	, CASE 
			WHEN p.TransactionType = 1 THEN 'OUT Learning'
			WHEN p.TransactionType = 2 THEN 'OUT Completion'
			WHEN p.TransactionType = 3 THEN 'OUT Balancing'
		END AS TransactionTypeVw
	, ROUND((P.Amount*-1),2) AS Amount -- Made negative as Payment
  FROM Fin.Ext_Tbl_Payment p
	WHERE p.FundingSource = 1
) 
, cte_DASAccountTransactions AS
( -- ** 4 join those 3 unions to get DASAccountID **
	SELECT
	  a.HashedId AS DASAccountId
  , gt.CreatedDate
  , gt.SubmissionDate
  , gt.PayrollMonth
  , gt.PayrollYear
  , gt.CollectionMonth
  , gt.CollectionYear
  , gt.TransactionType
  , gt.Amount
	FROM cte_GetTransactions gt
  LEFT JOIN Acct.Ext_Tbl_Account a ON gt.AccountId = a.Id
	WHERE a.HashedId IS NOT NULL
)
, cte_source AS 
( SELECT dat.PayrollYear, dat.PayrollMonth
  , COUNT(*) AS CountSource
	, SUM( dat.Amount) AS AmountSource
	FROM cte_DASAccountTransactions dat 
	GROUP BY dat.PayrollYear, dat.PayrollMonth
)
, cte_view AS
( SELECT eat.PayrollYear, eat.PayrollMonth
  , COUNT(*) AS CountView
	, SUM( eat.Amount ) AS AmountView
	FROM Data_Pub.DAS_Employer_AccountTransactions eat
	WHERE CreatedDate < @CutoffDate
	GROUP BY  eat.PayrollYear, eat.PayrollMonth
) 
SELECT src.PayrollYear, src.PayrollMonth, vw.PayrollYear, vw.PayrollMonth
  , CountSource, CountView, CountSource - CountView AS RowCountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
FROM cte_source src
FULL OUTER JOIN cte_view vw ON src.PayrollYear = vw.PayrollYear and src.PayrollMonth = vw.PayrollMonth
;

/* 07/08 count/sum by collection year/month */

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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
UNION ALL -- ** 3 Payments **
   SELECT 
	  p.AccountId 
  , p.EvidenceSubmittedOn AS CreatedDate
	, NULL as SubmissionDate
	, NULL as PayrollMonth
	,	NULL as PayrollYear
	, p.CollectionPeriodMonth
	, p.CollectionPeriodYear
	-- can't view reference data table so do a case statement
	, CASE 
	    WHEN p.TransactionType = 1 THEN 'OUT Learning'
			WHEN p.TransactionType = 2 THEN 'OUT Completion'
			WHEN p.TransactionType = 3 THEN 'OUT Balancing'
		END AS TransactionTypeVw
	, ROUND((P.Amount*-1),2) AS Amount -- Made negative as Payment
  FROM Fin.Ext_Tbl_Payment p
	WHERE p.FundingSource = 1
) 
, cte_DASAccountTransactions AS
( -- ** 4 join those 3 unions to get DASAccountID **
	SELECT
	  a.HashedId AS DASAccountId
  , gt.CreatedDate
  , gt.SubmissionDate
  , gt.PayrollMonth
  , gt.PayrollYear
  , gt.CollectionMonth
  , gt.CollectionYear
  , gt.TransactionType
  , gt.Amount
	FROM cte_GetTransactions gt
  LEFT JOIN Acct.Ext_Tbl_Account a ON gt.AccountId = a.Id
	WHERE a.HashedId IS NOT NULL
)
, cte_source AS 
( SELECT dat.CollectionYear, dat.CollectionMonth
  , COUNT(*) AS CountSource
	, SUM( dat.Amount) AS AmountSource
	FROM cte_DASAccountTransactions dat 
	GROUP BY dat.CollectionYear, dat.CollectionMonth
)
, cte_view AS
( SELECT eat.CollectionYear, eat.CollectionMonth
  , COUNT(*) AS CountView
	, SUM( eat.Amount ) AS AmountView
	FROM Data_Pub.DAS_Employer_AccountTransactions eat
	WHERE CreatedDate < @CutoffDate
	GROUP BY eat.CollectionYear, eat.CollectionMonth
) 
SELECT src.CollectionYear, src.CollectionMonth, vw.CollectionYear, vw.CollectionMonth
  , CountSource, CountView, CountSource - CountView AS RowCountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
FROM cte_source src
FULL OUTER JOIN cte_view vw ON src.CollectionYear = vw.CollectionYear and src.CollectionMonth = vw.CollectionMonth
;

/* 09/10 count/sum by transaction type */

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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
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
	FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp gldt
	WHERE gldt.CreatedDate < @CutoffDate
UNION ALL -- ** 3 Payments **
   SELECT 
	  p.AccountId 
  , p.EvidenceSubmittedOn AS CreatedDate
	, NULL as SubmissionDate
	, NULL as PayrollMonth
	,	NULL as PayrollYear
	, p.CollectionPeriodMonth
	, p.CollectionPeriodYear
	-- can't view reference data table so do a case statement
	, CASE 
			WHEN p.TransactionType = 1 THEN 'OUTLearning'
			WHEN p.TransactionType = 2 THEN 'OUTCompletion'
			WHEN p.TransactionType = 3 THEN 'OUTBalancing'
		END AS TransactionTypeVw
	, ROUND((P.Amount*-1),2) AS Amount -- Made negative as Payment
  FROM Fin.Ext_Tbl_Payment p
	WHERE p.FundingSource = 1
) 
, cte_DASAccountTransactions AS
( -- ** 4 join those 3 unions to get DASAccountID **
	SELECT
	  a.HashedId AS DASAccountId
  , gt.CreatedDate
  , gt.SubmissionDate
  , gt.PayrollMonth
  , gt.PayrollYear
  , gt.CollectionMonth
  , gt.CollectionYear
  , gt.TransactionType
  , gt.Amount
	FROM cte_GetTransactions gt
  LEFT JOIN Acct.Ext_Tbl_Account a ON gt.AccountId = a.Id
	WHERE a.HashedId IS NOT NULL
)
, cte_source AS 
( SELECT dat.TransactionType
  , COUNT(*) AS CountSource
	, SUM( dat.Amount) AS AmountSource
	FROM cte_DASAccountTransactions dat 
	GROUP BY dat.TransactionType
)
, cte_view AS
( SELECT eat.TransactionType
  , COUNT(*) AS CountView
	, SUM( eat.Amount ) AS AmountView
	FROM Data_Pub.DAS_Employer_AccountTransactions eat
	WHERE CreatedDate < @CutoffDate
	GROUP BY eat.TransactionType
) 
SELECT src.TransactionType, vw.TransactionType
  , CountSource, CountView, CountSource - CountView AS RowCountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
FROM cte_source src
FULL OUTER JOIN cte_view vw ON src.TransactionType = vw.TransactionType
;

END
