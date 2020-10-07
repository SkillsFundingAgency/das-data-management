CREATE PROCEDURE [dbo].[PopulateMarketoFilterConfigForImport]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 06/10/2020
-- Description: Populate Marketo Source Config for Import 
-- =========================================================================
*/

BEGIN TRY


DECLARE @LogID int

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-3'
	   ,'PopulateMarketoFilterConfigForImport'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='PopulateMarketoFilterConfigForImport'
     AND RunId=@RunID

BEGIN TRANSACTION

IF OBJECT_ID ('tempdb..#tMarketoFilterConfig') IS NOT NULL
DROP TABLE #tMarketoFilterConfig

SELECT *
  INTO #tMarketoFilterConfig
  FROM Mtd.MarketoFilterConfig
 WHERE 1=0

INSERT INTO #tMarketoFilterConfig
(StartDateFilter,EndDateFilter)
VALUES
 ('2020-09-01T00:00:00Z','2020-09-30T23:59:59-00:00')
,('2020-08-01T00:00:00Z','2020-08-31T23:59:59-00:00')
,('2020-07-01T00:00:00Z','2020-07-31T23:59:59-00:00')
,('2020-06-01T00:00:00Z','2020-06-30T23:59:59-00:00')
,('2020-05-01T00:00:00Z','2020-05-31T23:59:59-00:00')
,('2020-04-01T00:00:00Z','2020-04-30T23:59:59-00:00')
,('2020-03-01T00:00:00Z','2020-03-31T23:59:59-00:00')
,('2020-02-01T00:00:00Z','2020-02-29T23:59:59-00:00')
,('2020-01-01T00:00:00Z','2020-01-31T23:59:59-00:00')
,('2019-12-01T00:00:00Z','2019-12-31T23:59:59-00:00')
,('2019-11-01T00:00:00Z','2019-11-30T23:59:59-00:00')
,('2019-10-01T00:00:00Z','2019-10-31T23:59:59-00:00')
,('2019-09-01T00:00:00Z','2019-09-30T23:59:59-00:00')
,('2019-08-01T00:00:00Z','2019-08-31T23:59:59-00:00')
,('2019-07-01T00:00:00Z','2019-07-31T23:59:59-00:00')
,('2019-06-01T00:00:00Z','2019-06-30T23:59:59-00:00')
,('2019-05-01T00:00:00Z','2019-05-31T23:59:59-00:00')
,('2019-04-01T00:00:00Z','2019-04-30T23:59:59-00:00')
,('2019-03-01T00:00:00Z','2019-03-31T23:59:59-00:00')
,('2019-02-01T00:00:00Z','2019-02-28T23:59:59-00:00')
,('2019-01-01T00:00:00Z','2019-01-31T23:59:59-00:00')
,('2020-10-01T00:00:00Z','2020-10-31T23:59:59-00:00')

/* Insert main Config Table if not already exists */
INSERT INTO Mtd.MarketoFilterConfig
(StartDateFilter,EndDateFilter)
SELECT StartDateFilter,EndDateFilter
  FROM #tMarketoFilterConfig tMFC
 WHERE NOT EXISTS (SELECT 1
                     FROM Mtd.MarketoFilterConfig MFC
					WHERE MFC.StartDateFilter=TMFC.StartDateFilter
					  and MFC.EndDateFilter=TMFC.EndDateFilter)


COMMIT TRANSACTION


UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'PopulateMarketoFilterConfigForImport',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH

GO