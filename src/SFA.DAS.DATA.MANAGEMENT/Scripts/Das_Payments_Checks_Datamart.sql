/* --------------------------------------------------------------------------------
Validate  rds_payment view has same content as source. 

Cut off at midnight on a specific date to allow the queries to be run and be 
repeatable over a period of testing - ie no new records turn up in between 
running queries. SET THE DATE BEFORE RUNNING THE SCRIPT. 

NOTE Each query can take over an hour to run depending on network performance. 
The temp table create usually takes over and hour. Hower it can be left overnight 
and the results will come back in different tabs. 
---------------------------------------------------------------------------------- */

DECLARE @CutoffDate DATE = '15-Oct-2019';

BEGIN

/* Create a temp table to store the AD Datamart view contents to 
speed up checking queries that follow
*/
select * 
into #das_payments
from [Data_Pub].[Das_Payments];

/* Check sample of columns match 
Could be improved by specify where clause to get different record types, 
but this is enough for now to validate mappings.
*/ 

select top 100 * from #das_payments vw
inner join [Fin].[Ext_Tbl_Payment]src on vw.PaymentId = src.PaymentId;

/* Check 01/02 Count/Sum Overall Total comparison */

WITH cte_source AS
( SELECT COUNT(*) AS TotalCountSource
	, SUM(Amount) AS TotalAmountSource
	FROM [Fin].[Ext_Tbl_Payment]
	WHERE EvidenceSubmittedOn < @CutoffDate
)
, cte__view AS
( SELECT COUNT(*) AS TotalCountView
  , SUM(Amount) AS TotalAmountView
	FROM #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < @CutoffDate
) 
SELECT TotalCountSource, TotalCountView, TotalCountSource - TotalCountView AS RowCountDiff,
  TotalAmountSource, TotalAmountView,  TotalAmountSource - TotalAmountView AS AmountDiff
from cte_source 
join cte_view on 1=1 -- trick to get parser to allow no ON clause.
;

/* Check 03/04 Count/Sum by UKPRN  */

WITH cte_source AS
( SELECT UKPRN
  , COUNT(*) AS CountSource
	, SUM(Amount) AS AmountSource
	FROM [Fin].[Ext_Tbl_Payment]
	WHERE EvidenceSubmittedOn < @CutoffDate
	GROUP BY UKPRN
)
, cte_view AS
( SELECT UKPRN
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < @CutoffDate
	GROUP BY UKPRN
) 
SELECT src.UKPRN, vw.UKPRN -- include both incase 1 side of join missing
  , CountSource, CountView, CountSource - CountView AS CountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
from cte_source src
full outer join cte_view vw on src.UKPRN = vw.UKPRN
;

/* Check 05/06 Count/Sum by ULN */

WITH cte_source AS
( SELECT ULN
  , COUNT(*) AS CountSource
	, SUM(Amount) AS AmountSource
	FROM [Fin].[Ext_Tbl_Payment]
	WHERE EvidenceSubmittedOn < @CutoffDate
	GROUP BY ULN
)
, cte_view AS
( SELECT ULN
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < @CutoffDate
	GROUP BY ULN
) 
SELECT src.ULN, vw.ULN -- include both incase 1 side of join missing
  , CountSource, CountView, CountSource - CountView AS CountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
from cte_source src
full outer join cte_view vw on src.ULN = vw.ULN
;

/* 07/08 count/sum by DasAccountId */

WITH cte_source AS
( SELECT a.HashedId AS DasAccountId
  , COUNT(*) AS CountSource
	, SUM(p.Amount) AS AmountSource
	FROM Fin.Ext_Tbl_Payment p
	LEFT OUTER JOIN Comt.Ext_Tbl_Accounts a on p.AccountID = a.Id
	WHERE p.EvidenceSubmittedOn < @CutoffDate
	GROUP BY a.HashedId
)
, cte_view AS
( SELECT DasAccountId
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn < @CutoffDate 
	GROUP BY DasAccountId

) 
SELECT src.DasAccountId, vw.DasAccountId -- include both incase 1 side of join missing
  , CountSource, CountView, CountSource - CountView AS CountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
from cte_source src
full outer join cte_view vw on src.DasAccountId = vw.DasAccountId
;

/* 09/10 count/sum by collection period year/month */

WITH cte_source AS
( SELECT p.CollectionPeriodYear, p.CollectionPeriodMonth
  , COUNT(*) AS CountSource
	, SUM(p.Amount) AS AmountSource
	FROM Fin.Ext_Tbl_Payment p
	WHERE p.EvidenceSubmittedOn <  @CutoffDate
	GROUP BY p.CollectionPeriodYear, p.CollectionPeriodMonth
)
, cte_view AS
( SELECT CollectionMonth
  , CollectionYear
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn <  @CutoffDate
	GROUP BY CollectionMonth, CollectionYear
) 
SELECT src.CollectionPeriodYear, src.CollectionPeriodMonth  -- include both src and vw incase 1 side of join missing
  , vw.CollectionMonth, vw.CollectionYear 
  , CountSource, CountView, CountSource - CountView AS CountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
from cte_source src
full outer join cte_view vw on src.CollectionPeriodYear = vw.CollectionYear and src.CollectionPeriodMonth = vw.CollectionMonth
order by src.CollectionPeriodYear, src.CollectionPeriodMonth, vw.CollectionMonth, vw.CollectionYear 
;

/* 11/12 count/sum by */ 

WITH cte_source AS
( SELECT p.DeliveryPeriodYear, p.DeliveryPeriodMonth
  , COUNT(*) AS CountSource
	, SUM(p.Amount) AS AmountSource
	FROM Fin.Ext_Tbl_Payment p
	WHERE EvidenceSubmittedOn <  @CutoffDate
	GROUP BY p.DeliveryPeriodYear, p.DeliveryPeriodMonth
)
, cte_view AS
( SELECT DeliveryMonth
  , DeliveryPeriod
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn <  @CutoffDate
	GROUP BY DeliveryMonth, DeliveryPeriod
) 
SELECT src.DeliveryPeriodYear, src.DeliveryPeriodMonth  -- include both src and vw incase 1 side of join missing
  , vw.DeliveryMonth, vw.DeliveryPeriod 
  , CountSource, CountView, CountSource - CountView AS CountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
from cte_source src
full outer join cte_view vw on src.DeliveryPeriodYear = vw.DeliveryPeriod and src.DeliveryPeriodMonth = vw.DeliveryMonth
order by src.DeliveryPeriodYear, src.DeliveryPeriodMonth, vw.DeliveryMonth, vw.DeliveryPeriod 
;

/* 13/14 List rows where the source and target transation ID value is different or null 
(missing).

This works at transaction level so probably next best to run after the grand 
totals to find rows which are missing/extra and can then be used to validate 
the other subtotal reports.
*/

WITH cte_source AS
( SELECT p.PaymentId
  , COUNT(*) AS CountSource
	, SUM(p.Amount) AS AmountSource
	FROM Fin.Ext_Tbl_Payment p
	WHERE EvidenceSubmittedOn <  @CutoffDate
	GROUP BY p.PaymentId
)
, cte_view AS
( SELECT PaymentID
	, COUNT(*) AS CountView
  , SUM(Amount) AS AmountView
	FROM #das_payments -- replace view with temp table for performance [Data_Pub].[Das_Payments]
	WHERE EvidenceSubmittedOn <  @CutoffDate
	GROUP BY PaymentID
) 
, cte_comparison AS 
( SELECT src.PaymentId AS src_PaymentId
  , vw.PaymentId AS vw_PaymentId -- include both src and vw incase 1 side of join missing
  , CountSource, CountView, CountSource - CountView AS CountDiff
  , AmountSource, AmountView,  AmountSource - AmountView AS AmountDiff
from cte_source src
full outer join cte_view vw on src.PaymentId = vw.PaymentId
) 
SELECT * from cte_comparison 
where CountDiff IS NULL OR CountDiff <> 0 
OR AmountDiff IS NULL OR AmountDiff <> 0
;
END