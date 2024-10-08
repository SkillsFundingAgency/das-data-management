﻿CREATE PROCEDURE [dbo].[PopulateMetadataNationalMinimumWageRates]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 04/03/2021
-- Description: Populate Metadata for National Minimum Wage Rates
-- we can get the details from this link https://www.acas.org.uk/national-minimum-wage-entitlement
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
-- Apr 2024 to Mar 2025
('2024-04-01','2025-03-31','21 and Over',11.44)
,('2024-04-01','2025-03-31','18 to 20',8.60)
,('2024-04-01','2025-03-31','Under 18',6.40)
,('2024-04-01','2025-03-31','Apprentice',6.40)
-- Apr 2023 to Mar 2024
,('2023-04-01','2024-03-31','23 and Over',10.42)
,('2023-04-01','2024-03-31','21 to 22',10.18)
,('2023-04-01','2024-03-31','18 to 20',7.49)
,('2023-04-01','2024-03-31','Under 18',5.28)
,('2023-04-01','2024-03-31','Apprentice',5.28)

-- Apr 2022 to Mar 2023
,('2022-04-01','2023-03-31','23 and Over',9.50)
,('2022-04-01','2023-03-31','21 to 22',9.18)
,('2022-04-01','2023-03-31','18 to 20',6.83)
,('2022-04-01','2023-03-31','Under 18',4.81)
,('2022-04-01','2023-03-31','Apprentice',4.81)

-- Apr 2021 to Mar 2022
,('2021-04-01','2022-03-31','23 and Over',8.91)
,('2021-04-01','2022-03-31','21 to 22',8.36)
,('2021-04-01','2022-03-31','18 to 20',6.56)
,('2021-04-01','2022-03-31','Under 18',4.62)
,('2021-04-01','2022-03-31','Apprentice',4.30)

-- Apr 2020 to Mar 2021
,('2020-04-01','2021-03-31','25 and Over',8.72)
,('2020-04-01','2021-03-31','21 to 24',8.20)
,('2020-04-01','2021-03-31','18 to 20',6.45)
,('2020-04-01','2021-03-31','Under 18',4.55)
,('2020-04-01','2021-03-31','Apprentice',4.15)

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