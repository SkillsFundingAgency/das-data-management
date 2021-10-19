CREATE PROCEDURE [dbo].[Build_Modelled_PL]
(@RunId bigint)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 25/09/2020
-- Description: Master Stored Proc that builds Modelled Presentation Layer
-- =========================================================================

EXEC dbo.ImportAppRedundancyAndComtToPL @RunId

EXEC dbo.ImportAccountsToPL @RunId

EXEC dbo.ImportFinanceToPL @RunId


/* Import CRS and CRS Delivery Data to Presentation Layer */

EXEC dbo.ImportProviderToPL @RunId

EXEC dbo.ImportFAT2FrameworkToPL @RunId

EXEC dbo.ImportFAT2SectorStandardToPL @RunId

/* Import Public sector Data to Presentation Layer */
EXEC dbo.ImportPublicSectorReportDataToPL @RunId

/* SubmittedApplicationAnswers */
EXEC [dbo].[ImportSubmittedApplicationAnswersToPL] @RunId

/* Run Payments Snaptshot */
Declare @StartDate  Date = dateadd(day,-2,cast(getdate() as date)),
		@EndDate Date = dateadd(day,2,cast(getdate() as date))
If exists(select DatamartRefreshDate from [Mtd].[RefreshDatasetConfig] where DatamartRefreshDate between @StartDate And @EndDate and isnull(IsProcessed,0)<>1)
or exists (SELECT 1 FROM ( SELECT MAX(EventTime) EventTime from StgPmts.Payment) PMT WHERE EXISTS (SELECT 1 FROM [Mtd].[RefreshDatasetConfig] mtd where YEAR(mtd.DatamartRefreshDate)=YEAR(pmt.EventTime) and MONTH(mtd.DatamartRefreshDate)=MONTH(pmt.EventTime) and ISNULL(IsProcessed,0)<>1))
Begin
	EXEC ImportPaymentsSnapshot @RunId
	
	UPDATE Mtd.RefreshDatasetConfig
	SET IsProcessed=1
	where YEAR(DataMartRefreshDate)=YEAR(@StartDate)
    AND MONTH(DataMartRefreshDate)=MONTH(@StartDate)
End  
 