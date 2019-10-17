-- ===========================================================================
-- Author:      Simon Heath
-- Create Date: 16/09/2019
-- Description: Create Views for EmployerPAYESchemes that mimics RDS view
-- ===========================================================================

/* --------------------------------------------------------------------------------
Author:      Simon Heath
Create Date: 16/09/2019
RDS to be run on das-prd-data-db
Description: Validate tables have same overall contents, by cutting off at midnight 
on a specific date to allow the queries to be run and be repeatable - ie no new 
records turn up in between running queries. 

AMEND THE DATE BEFORE RUNNING THE SCRIPT.
---------------------------------------------------------------------------------- */

/* Check 01/02 Count/Sum Overall Total comparison */

SELECT COUNT(*) AS TotalCountView
  , SUM(Amount) AS TotalAmountView
	FROM [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < '15-Oct-2019'
;
/* Check 03/04 Count/Sum by UKPRN  */

 SELECT UKPRN
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < '15-Oct-2019'
	GROUP BY UKPRN
;

/* Check 05/06 Count/Sum by ULN */
-- too many rows for xls 703,883 

SELECT ULN
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < '15-Oct-2019'
	GROUP BY ULN
;

/* 07/08 count/sum by DasAccountId */

SELECT DasAccountId
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < '15-Oct-2019'
	GROUP BY DasAccountId
;

/* 09/10 count/sum by collection period year/month */

SELECT CollectionMonth
  , CollectionYear
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < '15-Oct-2019'
	GROUP BY CollectionMonth, CollectionYear
;
/* 11/12 count/sum by */ 

SELECT DeliveryMonth
  , DeliveryYear
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < '15-Oct-2019'
	GROUP BY DeliveryMonth, DeliveryYear
;
