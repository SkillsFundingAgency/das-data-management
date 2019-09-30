CREATE PROCEDURE [dbo].[UpdateCalendarMonth]
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/09/2019
-- Description: Update Calendar Data 
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

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
	   ,'UpdateCalendarMonth'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='UpdateCalendarMonth'
     AND RunId=@RunID


--Insert Date into Table
DECLARE @IntNumberOfYears INT = 50
--DECLARE @IntYearsInPast INT = 10 --Default to 10
DECLARE @IntNumberofMonths INT
DECLARE @DateFirstMonth DATE
DECLARE @DateLastMonth DATE
SET @DateFirstMonth = DATEFROMPARTS(2000,1,1)
SET @DateLastMonth = DATEADD(m,(12*@IntNumberOfYears),DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1))
SET @IntNumberofMonths = DATEDIFF(m,@DateFirstMonth,@DateLastMonth) +1

DECLARE @i INT = 1
--Temp Table
DECLARE @CalendarMonth TABLE
(
    CalendarMonthID INT NOT NULL PRIMARY KEY
    , CalendarDate DATE NOT NULL
    , CalendarMonthNumber INT NOT NULL
    , CalendarMonthName VARCHAR(20) NOT NULL
    , CalendarMonthShortName VARCHAR(20) NOT NULL
    , CalendarYear INT NOT NULL
    , CalendarMonthNameYear VARCHAR(20) NOT NULL
    , CalendarMonthShortNameYear VARCHAR(20) NOT NULL
    , TaxMonthNumber VARCHAR(20) NOT NULL
    , TaxYear VARCHAR(20) NOT NULL
    , AcademicMonthNumber INT NOT NULL
    , AcademicYear VARCHAR(20) NOT NULL
    , CalendarYearMonth_SortOrder INT NOT NULL
)
DECLARE @LoopDate DATE

SET @i = 1

WHILE @i <= @IntNumberofMonths
      BEGIN
		  SET @LoopDate =DATEADD(M,@i-1,@DateFirstMonth)
		  INSERT INTO @CalendarMonth
		  (
			 CalendarMonthID 
			 , CalendarDate 
			 , CalendarMonthNumber 
			 , CalendarMonthName 
			 , CalendarMonthShortName
			 , CalendarYear
			 , CalendarMonthNameYear
			 , CalendarMonthShortNameYear
			 , TaxMonthNumber
			 , TaxYear
			 , AcademicMonthNumber 
			 , AcademicYear 
                , CalendarYearMonth_SortOrder
		  )
		  SELECT 
			 CAST((CAST(YEAR(@LoopDate) AS VARCHAR(10)) + CAST(MONTH(@LoopDate) AS VARCHAR(2)) ) AS INT) AS CalendarMonthID 
			 , @LoopDate AS CalendarDate 
			 , MONTH(@LoopDate) AS CalendarMonthNumber 
			 , DATENAME(MONTH,@LoopDate) AS CalendarMonthName
			 , LEFT(DATENAME(MONTH,@LoopDate),3) AS CalendarMonthShortName 
			 , YEAR(@LoopDate) AS CalendarYear
			 , DATENAME(MONTH,@LoopDate) +' - '+ CAST(YEAR(@LoopDate) AS VARCHAR(20)) AS CalendarMonthNameYear
			 , LEFT(DATENAME(MONTH,@LoopDate),3) +' - '+ CAST(YEAR(@LoopDate) AS VARCHAR(20)) AS CalendarMonthShortNameYear
			 -- Tax Year
			 , CASE WHEN MONTH(@LoopDate) >= 4 THEN MONTH(@LoopDate) - 3
				  ELSE MONTH(@LoopDate) + 9 END TaxMonthNumber
			 , CASE WHEN MONTH(@LoopDate) >= 4 THEN CAST(RIGHT(YEAR(@LoopDate),2) AS VARCHAR(10)) + '-' + CAST(RIGHT(YEAR(@LoopDate)+1,2) AS VARCHAR(10)) 
				ELSE CAST(RIGHT(YEAR(@LoopDate)-1,2) AS VARCHAR(10)) + '-' + CAST(RIGHT(YEAR(@LoopDate),2) AS VARCHAR(10)) END  AS TaxYear --16-17
			 -- Academic Year
			 , CASE WHEN MONTH(@LoopDate) >= 8 THEN MONTH(@LoopDate) - 7
				  ELSE MONTH(@LoopDate) + 5 END AS AcademicMonthNumber 
			 , CASE WHEN MONTH(@LoopDate) >= 8 THEN CAST(YEAR(@LoopDate) AS VARCHAR(10)) + '/' + CAST(RIGHT(YEAR(@LoopDate)+1,2) AS VARCHAR(10)) 
				ELSE CAST(YEAR(@LoopDate)-1 AS VARCHAR(10)) + '/' + CAST(RIGHT(YEAR(@LoopDate),2) AS VARCHAR(10)) END AS AcademicYear 
                , CAST(YEAR(@LoopDate) AS VARCHAR(255)) +  CASE WHEN MONTH(@LoopDate) < 10 THEN '0' +  CAST(MONTH(@LoopDate) AS VARCHAR(255))  ELSE  CAST(MONTH(@LoopDate) AS VARCHAR(255)) END AS CalendarYearMonth_SortOrder

            SET @i = @i + 1

      END


-- Update rows

UPDATE CM
SET         [CalendarDate] = T_CM.[CalendarDate]
           ,[CalendarMonthNumber] = T_CM.[CalendarMonthNumber]
           ,[CalendarMonthName] = T_CM.[CalendarMonthName]
           ,[CalendarMonthShortName] = T_CM.[CalendarMonthShortName]
           ,[CalendarYear] = T_CM.[CalendarYear]
           ,[CalendarMonthNameYear] = T_CM.[CalendarMonthNameYear]
           ,[CalendarMonthShortNameYear] = T_CM.[CalendarMonthShortNameYear]
           ,[TaxMonthNumber] = T_CM.[TaxMonthNumber]
           ,[TaxYear] = T_CM.[TaxYear]
           ,[AcademicMonthNumber] = T_CM.[AcademicMonthNumber]
           ,[AcademicYear] = T_CM.[AcademicYear]
           ,[CalendarYearMonth_SortOrder] = T_CM.[CalendarYearMonth_SortOrder]
FROM dbo.DASCalendarMonth AS CM
INNER JOIN  @CalendarMonth AS T_CM ON CM.[CalendarMonthID] = T_CM.[CalendarMonthID]

-- Insert rows

INSERT INTO dbo.DASCalendarMonth
([CalendarMonthID]
           ,[CalendarDate]
           ,[CalendarMonthNumber]
           ,[CalendarMonthName]
           ,[CalendarMonthShortName]
           ,[CalendarYear]
           ,[CalendarMonthNameYear]
           ,[CalendarMonthShortNameYear]
           ,[TaxMonthNumber]
           ,[TaxYear]
           ,[AcademicMonthNumber]
           ,[AcademicYear]
           ,[CalendarYearMonth_SortOrder])
SELECT [CalendarMonthID]
           ,[CalendarDate]
           ,[CalendarMonthNumber]
           ,[CalendarMonthName]
           ,[CalendarMonthShortName]
           ,[CalendarYear]
           ,[CalendarMonthNameYear]
           ,[CalendarMonthShortNameYear]
           ,[TaxMonthNumber]
           ,[TaxYear]
           ,[AcademicMonthNumber]
           ,[AcademicYear]
           ,[CalendarYearMonth_SortOrder]
FROM @CalendarMonth
WHERE CalendarMonthID NOT IN (SELECT DISTINCT CalendarMonthID
						        FROM dbo.[DASCalendarMonth])

/* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
	    'UpdateCalendarMonth',
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

	
