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
 ('2020-07-01T00:00:00Z','2020-07-31T23:59:59-00:00') 
,('2020-08-01T00:00:00Z','2020-08-31T23:59:59-00:00')
,('2020-09-01T00:00:00Z','2020-09-30T23:59:59-00:00')
,('2020-10-01T00:00:00Z','2020-10-31T23:59:59-00:00')
,('2020-03-01T00:00:00Z','2020-03-31T23:59:59-00:00') 
,('2020-04-01T00:00:00Z','2020-04-30T23:59:59-00:00') 
,('2020-05-01T00:00:00Z','2020-05-31T23:59:59-00:00') 
,('2020-06-01T00:00:00Z','2020-06-30T23:59:59-00:00') 
,('2020-10-21T00:00:00Z','2020-10-31T23:59:59-00:00') 
,('2021-02-01T00:00:00Z','2021-02-28T23:59:59-00:00') 

/* Set up config to Import Lead Data from May 2019 to Feb 2020 , set Activity Import Status to 1 so that it doesn't get triggered for Import */

INSERT INTO #tMarketoFilterConfig
(StartDateFilter,EndDateFilter,ImportStatus,ActivityImportStatus)
VALUES 
 ('2020-02-01T00:00:00Z','2020-02-29T23:59:59-00:00',0,1) 
,('2020-01-01T00:00:00Z','2020-01-31T23:59:59-00:00',0,1) 
,('2019-12-01T00:00:00Z','2019-12-31T23:59:59-00:00',0,1) 
,('2019-11-01T00:00:00Z','2019-11-30T23:59:59-00:00',0,1) 
,('2019-10-01T00:00:00Z','2019-10-31T23:59:59-00:00',0,1) 
,('2019-09-01T00:00:00Z','2019-09-30T23:59:59-00:00',0,1) 
,('2019-08-01T00:00:00Z','2019-08-31T23:59:59-00:00',0,1) 
,('2019-07-01T00:00:00Z','2019-07-31T23:59:59-00:00',0,1) 
,('2019-06-01T00:00:00Z','2019-06-30T23:59:59-00:00',0,1) 
,('2019-05-01T00:00:00Z','2019-05-31T23:59:59-00:00',0,1) 
,('2021-04-01T00:00:00Z','2021-04-30T23:59:59-00:00',0,1) 

/* BackFill Data where Jobs Failed */

INSERT INTO #tMarketoFilterConfig
(StartDateFilter,EndDateFilter)
VALUES
 ('2020-11-02T00:00:00Z','2020-11-05T23:59:59Z')
,('2021-02-19T00:00:00Z','2021-02-20T23:59:59Z')
,('2021-04-22T00:00:00Z','2021-04-23T23:59:59Z')
,('2021-05-01T00:00:00Z','2021-05-14T23:59:59Z')
,('2021-08-17T00:00:00Z','2021-08-26T00:00:00Z') 
/* Refresh Last 2 months Marketo Data */

INSERT INTO #tMarketoFilterConfig
(StartDateFilter,EndDateFilter)
VALUES
 ('2021-05-15T00:00:00Z','2021-05-31T23:59:59Z')
,('2021-06-01T00:00:00Z','2021-06-20T23:59:59Z')

/* Refresh last 1 and half month Marketo Data */

/* Delete previous config that wasn't successful */

Delete from Mtd.MarketoFilterConfig 
 where StartDateFilter='2021-11-24T00:00:00Z'
   and EndDateFilter='2021-12-24T23:59:59Z'

Delete from Mtd.MarketoFilterConfig 
 where StartDateFilter='2021-12-25T00:00:00Z'
   and EndDateFilter='2022-01-31T23:59:59Z'

Delete from Mtd.MarketoFilterConfig
 where StartDateFilter='2021-12-22T00:00:00Z'
   and EndDateFilter='2022-01-04T23:59:59Z'

Delete from Mtd.MarketoFilterConfig
 where StartDateFilter='2022-01-05T00:00:00Z'
   and EndDateFilter='2022-01-18T23:59:59Z'

Delete from Mtd.MarketoFilterConfig
 where StartDateFilter='2022-01-19T00:00:00Z'
   and EndDateFilter='2022-02-06T23:59:59Z'

delete from mtd.MarketoFilterConfig
where StartDateFilter='2022-02-09T00:00:00Z'
and EndDateFilter='2022-02-17T23:59:59Z'

delete from mtd.MarketoFilterConfig
where StartDateFilter='2022-02-18T00:00:00Z'
and EndDateFilter='2022-02-27T23:59:59Z'

INSERT INTO #tMarketoFilterConfig
(StartDateFilter,EndDateFilter)
VALUES
 ('2021-12-22T00:00:00Z','2021-12-28T23:59:59Z')
,('2021-12-29T00:00:00Z','2022-01-04T23:59:59Z')
,('2022-01-05T00:00:00Z','2022-01-11T23:59:59Z')
,('2022-01-12T00:00:00Z','2022-01-18T23:59:59Z')
,('2022-01-19T00:00:00Z','2022-01-25T23:59:59Z')
,('2022-01-26T00:00:00Z','2022-02-01T23:59:59Z')
,('2022-02-02T00:00:00Z','2022-02-08T23:59:59Z')
,('2022-01-04T23:59:59Z','2022-01-11T23:59:59Z')
,('2022-02-09T00:00:00Z','2022-02-12T23:59:59Z')
,('2022-02-13T00:00:00Z','2022-02-16T23:59:59Z')
,('2022-02-17T00:00:00Z','2022-02-20T23:59:59Z')
,('2022-02-21T00:00:00Z','2022-02-24T23:59:59Z')
,('2022-02-25T00:00:00Z','2022-02-28T23:59:59Z')
,('2022-03-01T00:00:00Z','2022-03-04T23:59:59Z')
,('2022-03-05T00:00:00Z','2022-03-08T23:59:59Z')
,('2022-03-09T00:00:00Z','2022-03-12T23:59:59Z')
,('2022-03-13T00:00:00Z','2022-03-16T23:59:59Z')
,('2022-03-17T00:00:00Z','2022-03-20T23:59:59Z')
,('2022-03-21T00:00:00Z','2022-03-27T23:59:59Z')
,('2022-03-28T00:00:00Z','2022-04-03T23:59:59Z')
,('2022-04-04T00:00:00Z','2022-04-10T23:59:59Z')
,('2022-04-11T00:00:00Z','2022-04-17T23:59:59Z')
,('2022-04-18T00:00:00Z','2022-04-30T23:59:59Z')


/* Insert main Config Table if not already exists */
INSERT INTO Mtd.MarketoFilterConfig
(StartDateFilter,EndDateFilter,ImportStatus,ActivityImportStatus)
SELECT StartDateFilter,EndDateFilter,ImportStatus,ActivityImportStatus
  FROM #tMarketoFilterConfig tMFC
 WHERE NOT EXISTS (SELECT 1
                     FROM Mtd.MarketoFilterConfig MFC
					WHERE MFC.StartDateFilter=TMFC.StartDateFilter
					  and MFC.EndDateFilter=TMFC.EndDateFilter)

/* Load Config For Programs */

IF OBJECT_ID ('tempdb..#tMarketoFilterConfigForPrograms') IS NOT NULL
DROP TABLE #tMarketoFilterConfigForPrograms

SELECT *
  INTO #tMarketoFilterConfigForPrograms
  FROM Mtd.MarketoFilterConfigForPrograms
 WHERE 1=0

INSERT INTO #tMarketoFilterConfigForPrograms
(StartDateFilter,EndDateFilter)
VALUES
 ('2020-07-01T00:00:00Z','2020-10-31T23:59:59Z') 
,('2020-07-01T00:00:00Z','2020-07-31T23:59:59Z')
,('2020-08-01T00:00:00Z','2020-08-31T23:59:59Z')
,('2020-09-01T00:00:00Z','2020-09-30T23:59:59Z')
,('2020-10-01T00:00:00Z','2020-10-31T23:59:59Z')
,('2020-03-01T00:00:00Z','2020-03-31T23:59:59Z') 
,('2020-04-01T00:00:00Z','2020-04-30T23:59:59Z') 
,('2020-05-01T00:00:00Z','2020-05-31T23:59:59Z') 
,('2020-06-01T00:00:00Z','2020-06-30T23:59:59Z') 
,('2020-10-21T00:00:00Z','2020-10-31T23:59:59Z')
/* BackFill Data where Jobs Failed */
,('2020-11-02T00:00:00Z','2020-11-05T23:59:59Z')
,('2021-02-19T00:00:00Z','2021-02-20T23:59:59Z')
,('2021-04-22T00:00:00Z','2021-04-23T23:59:59Z')
,('2021-05-01T00:00:00Z','2021-05-14T23:59:59Z')
,('2021-08-17T00:00:00Z','2021-08-26T23:59:59Z')
/* Refresh Last 2 months Marketo Data */
INSERT INTO #tMarketoFilterConfigForPrograms
(StartDateFilter,EndDateFilter)
VALUES
 ('2021-05-15T00:00:00Z','2021-05-31T23:59:59Z')
,('2021-06-01T00:00:00Z','2021-06-20T23:59:59Z')

/* Refresh last 1 and half month Marketo Data */

/* Delete previous config that wasn't successful */

Delete from Mtd.MarketoFilterConfigForPrograms
 where StartDateFilter='2021-11-24T00:00:00Z'
   and EndDateFilter='2021-12-24T23:59:59Z'

Delete from Mtd.MarketoFilterConfigForPrograms
 where StartDateFilter='2021-12-25T00:00:00Z'
   and EndDateFilter='2022-01-31T23:59:59Z'

Delete from Mtd.MarketoFilterConfigForPrograms
 where StartDateFilter='2021-12-22T00:00:00Z'
   and EndDateFilter='2022-01-04T23:59:59Z'

Delete from Mtd.MarketoFilterConfigForPrograms
 where StartDateFilter='2022-01-05T00:00:00Z'
   and EndDateFilter='2022-01-18T23:59:59Z'

Delete from Mtd.MarketoFilterConfigForPrograms
 where StartDateFilter='2022-01-19T00:00:00Z'
   and EndDateFilter='2022-02-06T23:59:59Z'

DELETE from mtd.MarketoFilterConfigForPrograms
where StartDateFilter='2022-02-09T00:00:00Z'
and EndDateFilter='2022-02-17T23:59:59Z'

DELETE from mtd.MarketoFilterConfigForPrograms
where StartDateFilter='2022-02-18T00:00:00Z'
and EndDateFilter='2022-02-27T23:59:59Z'

INSERT INTO #tMarketoFilterConfigForPrograms
(StartDateFilter,EndDateFilter)
VALUES
 ('2021-12-22T00:00:00Z','2021-12-28T23:59:59Z')
,('2021-12-29T00:00:00Z','2022-01-04T23:59:59Z')
,('2022-01-05T00:00:00Z','2022-01-11T23:59:59Z')
,('2022-01-12T00:00:00Z','2022-01-18T23:59:59Z')
,('2022-01-19T00:00:00Z','2022-01-25T23:59:59Z')
,('2022-01-26T00:00:00Z','2022-02-01T23:59:59Z')
,('2022-02-02T00:00:00Z','2022-02-08T23:59:59Z')
,('2022-01-04T23:59:59Z','2022-01-11T23:59:59Z')
,('2022-02-09T00:00:00Z','2022-02-12T23:59:59Z')
,('2022-02-13T00:00:00Z','2022-02-16T23:59:59Z')
,('2022-02-17T00:00:00Z','2022-02-20T23:59:59Z')
,('2022-02-21T00:00:00Z','2022-02-24T23:59:59Z')
,('2022-02-25T00:00:00Z','2022-02-28T23:59:59Z')
,('2022-03-01T00:00:00Z','2022-03-04T23:59:59Z')
,('2022-03-05T00:00:00Z','2022-03-08T23:59:59Z')
,('2022-03-09T00:00:00Z','2022-03-12T23:59:59Z')
,('2022-03-13T00:00:00Z','2022-03-16T23:59:59Z')
,('2022-03-17T00:00:00Z','2022-03-20T23:59:59Z')
,('2022-03-21T00:00:00Z','2022-03-27T23:59:59Z')
,('2022-03-28T00:00:00Z','2022-04-03T23:59:59Z')
,('2022-04-04T00:00:00Z','2022-04-10T23:59:59Z')
,('2022-04-11T00:00:00Z','2022-04-17T23:59:59Z')
,('2022-04-18T00:00:00Z','2022-04-30T23:59:59Z')


/* Insert main Config Table if not already exists */
INSERT INTO Mtd.MarketoFilterConfigForPrograms
(StartDateFilter,EndDateFilter)
SELECT StartDateFilter,EndDateFilter
  FROM #tMarketoFilterConfigForPrograms tMFC
 WHERE NOT EXISTS (SELECT 1
                     FROM Mtd.MarketoFilterConfigForPrograms MFC
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