CREATE PROCEDURE [dbo].[PopulateMetadataNationalMinimumWageRates]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 04/03/2021
-- Description: Populate Metadata for National Minimum Wage Rates
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
	   ,'PopulateMetadataNationalMinimumWageRates'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='PopulateMetadataNationalMinimumWageRates'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM Mtd.NationalMinimumWageRates

INSERT INTO Mtd.NationalMinimumWageRates
(StartDate
,EndDate
,AgeGroup
,WageRateInPounds
)
VALUES
 ('2021-04-01','2022-03-31','23 and Over',8.91)
,('2021-04-01','2022-03-31','21 to 22',8.36)
,('2021-04-01','2022-03-31','18 to 20',6.56)
,('2021-04-01','2022-03-31','Under 18',4.62)
,('2021-04-01','2022-03-31','Apprentice',4.30)
-- Apr 19 to Mar 2020
,('2019-04-01','2020-03-31','25 and Over',8.21)
,('2019-04-01','2020-03-31','21 to 24',7.70)
,('2019-04-01','2020-03-31','18 to 20',6.15)
,('2019-04-01','2020-03-31','Under 18',4.35)
,('2019-04-01','2020-03-31','Apprentice',3.90)
-- Apr 18 to Mar 2019

,('2018-04-01','2019-03-31','25 and Over',7.83)
,('2018-04-01','2019-03-31','21 to 24',7.38)
,('2018-04-01','2019-03-31','18 to 20',5.90)
,('2018-04-01','2019-03-31','Under 18',4.20)
,('2018-04-01','2019-03-31','Apprentice',3.70)

-- Apr 17 to Mar 2018
,('2017-04-01','2018-03-31','25 and Over',7.50)
,('2017-04-01','2018-03-31','21 to 24',7.05)
,('2017-04-01','2018-03-31','18 to 20',5.60)
,('2017-04-01','2018-03-31','Under 18',4.05)
,('2017-04-01','2018-03-31','Apprentice',3.50)

-- Oct 2016 to Mar 2017

,('2016-10-01','2017-03-31','25 and Over',7.20)
,('2016-10-01','2017-03-31','21 to 24',6.95)
,('2016-10-01','2017-03-31','18 to 20',5.55)
,('2016-10-01','2017-03-31','Under 18',4.00)
,('2016-10-01','2017-03-31','Apprentice',3.40)


-- Apr 2016 to Sept 2016

,('2016-04-01','2016-09-30','25 and Over',7.20)
,('2016-04-01','2016-09-30','21 to 24',6.70)
,('2016-04-01','2016-09-30','18 to 20',5.30)
,('2016-04-01','2016-09-30','Under 18',3.87)
,('2016-04-01','2016-09-30','Apprentice',3.30)





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
	    'PopulateMetadataNationalMinimumWageRates',
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