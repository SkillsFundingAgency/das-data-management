CREATE PROCEDURE [dbo].[Build_Modelled_PL]
(@RunId bigint)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 25/09/2020
-- Description: Master Stored Proc that builds Modelled Presentation Layer
-- =========================================================================

EXEC dbo.ImportAppRedundancyToPL @RunId

EXEC dbo.ImportAccountsToPL @RunId


/* Import CRS and CRS Delivery Data to Presentation Layer */

EXEC dbo.ImportProviderToPL @RunId

EXEC dbo.ImportFAT2FrameworkToPL @RunId

EXEC dbo.ImportFAT2SectorStandardToPL @RunId

/* Run Payments Snaptshot */
Declare @StartDate  Date = dateadd(day,-2,cast(getdate() as date)),
		@EndDate Date = dateadd(day,2,cast(getdate() as date))
If exists(select DatamartRefreshDate from [Mtd].[RefreshDatasetConfig] where DatamartRefreshDate between @StartDate  And  @EndDate)  
or exists (select top 1 [EventTime] from [StgPmts].[Payment]  where [EventTime] Between @StartDate And @EndDate)
Begin 
	EXEC ImportPaymentsSnapshot @RunId 
End 
 