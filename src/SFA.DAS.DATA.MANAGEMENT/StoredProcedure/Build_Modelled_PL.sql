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

/* Import Public sector Data to Presentation Layer 
2023-01-30 PublicSectorReportDataToPL moved to a differnt pipeline
EXEC dbo.ImportPublicSectorReportDataToPL @RunId */

/* SubmittedApplicationAnswers */
EXEC [dbo].[ImportSubmittedApplicationAnswersToPL] @RunId

/* Populate LTM reference Data */
EXEC [dbo].[PopulateLTMReferenceData] @RunID

/* Run Payments Snaptshot */
Declare @StartDate  Date = dateadd(day,-2,cast(getdate() as date)),
		@EndDate Date = dateadd(day,2,cast(getdate() as date))
If exists(select DatamartRefreshDate from [Mtd].[RefreshDatasetConfig] where DatamartRefreshDate between @StartDate And @EndDate and isnull(IsProcessed,0)<>1)
Begin
	EXEC ImportPaymentsSnapshot @RunId

	UPDATE Mtd.RefreshDatasetConfig
	SET IsProcessed=1
	where YEAR(DataMartRefreshDate)=YEAR(@StartDate)
    AND MONTH(DataMartRefreshDate)=MONTH(@StartDate)
 end
If exists (SELECT 1 FROM ( SELECT MAX(EventTime) EventTime from StgPmts.Payment) PMT WHERE year(eventtime)=year(getdate()) and month(eventtime)=month(getdate())
                    and not exists (select 1 from mtd.RefreshDatasetConfig RDC where YEAR(RDC.DatamartRefreshDate)=YEAR(EVENTTIME) AND MONTH(RDC.DataMartRefreshDate)=Month(EventTime)
					                                                             and Isprocessed=1))
BEGIN	
	EXEC ImportPaymentsSnapshot @RunId

	INSERT INTO Mtd.RefreshDatasetConfig
	(DataSet,DataMartRefreshDate,IsProcessed)
	VALUES
	('Payments',convert(date,getdate()),1)
End 
 
 