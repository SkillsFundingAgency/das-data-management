/* --------------------------------------------------------------------------------
Validate Data_Pub.DAS_Employer_AccountTransactions view has same content as source. 

Thes SQL pull sin totals from RDS for 3 way checks. 

Cut off at midnight on a specific date to allow the queries to be run and be 
repeatable over a period of testing - ie no new records turn up in between 
running queries. SET THE DATE BEFORE RUNNING THE SCRIPT. 

Run against [das-prd-data-db]
---------------------------------------------------------------------------------- */

 -- initial check on source 
DECLARE @CutoffDate DATE = '20-Oct-2019';

BEGIN
/* Check 01/02 Count/Sum Overall Total comparison */

SELECT COUNT(*) AS CountView
, SUM( Amount ) AS AmountView
FROM Data_Pub.DAS_Employer_AccountTransactions 
WHERE CreatedDate < @CutoffDate
;
/* Check 03/04 Count/Sum by DASAccountID  */

SELECT eat.DasAccountID
, COUNT(*) AS CountView
, SUM( eat.Amount ) AS AmountView
FROM Data_Pub.DAS_Employer_AccountTransactions eat
WHERE CreatedDate < @CutoffDate
GROUP BY eat.DasAccountId
;

/* 05/06 count/sum by payroll year/month */

SELECT eat.PayrollYear, eat.PayrollMonth
, COUNT(*) AS CountView
, SUM( eat.Amount ) AS AmountView
FROM Data_Pub.DAS_Employer_AccountTransactions eat
WHERE CreatedDate < @CutoffDate
GROUP BY  eat.PayrollYear, eat.PayrollMonth
; 

/* 07/08 count/sum by collection year/month */

SELECT eat.CollectionYear, eat.CollectionMonth
, COUNT(*) AS CountView
, SUM( eat.Amount ) AS AmountView
FROM Data_Pub.DAS_Employer_AccountTransactions eat
WHERE CreatedDate < @CutoffDate
GROUP BY eat.CollectionYear, eat.CollectionMonth
;

/* 09/10 count/sum by transaction type */

SELECT eat.TransactionType
, COUNT(*) AS CountView
, SUM( eat.Amount ) AS AmountView
FROM Data_Pub.DAS_Employer_AccountTransactions eat
WHERE CreatedDate < @CutoffDate
GROUP BY eat.TransactionType
;

END