CREATE PROCEDURE [dbo].[ImportDimDate]
(
   @RunId int
)
AS

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

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
	   ,'Step-6'
	   ,'ImportDimDate'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportDimDate'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.DimDate;

WITH DateSequence AS (
		SELECT CAST('1990-01-01' AS DATE) AS DateValue
		UNION ALL
		SELECT DATEADD(DAY, 1, DateValue)
		FROM DateSequence
		WHERE DateValue < '2100-12-31'
		),
		CombinedDetails AS (
			SELECT
				DateValue,
				CASE 
					WHEN MONTH(DateValue) >= 8 THEN YEAR(DateValue)
					ELSE YEAR(DateValue) - 1
				END AS Academic_Year_Start,
				DATEPART(MONTH, DATEADD(MONTH, -7, DateValue)) AS Academic_Month_Num,
				CASE 
					WHEN MONTH(DateValue) >= 8 THEN YEAR(DateValue) + 1
					ELSE YEAR(DateValue)
				END AS Academic_Year_End,
				CASE
					WHEN MONTH(DateValue) >= 8 THEN ((MONTH(DateValue) - 8) / 3) + 1
					WHEN MONTH(DateValue) < 8 THEN ((MONTH(DateValue) + 4) / 3) + 1
				END AS Academic_Quarter_Number,
				CASE 
					WHEN MONTH(DateValue) >= 4 THEN YEAR(DateValue)
					ELSE YEAR(DateValue) - 1
				END AS Financial_Year_Start,
				CASE 
					WHEN MONTH(DateValue) >= 4 THEN YEAR(DateValue) + 1
					ELSE YEAR(DateValue)
				END AS Financial_Year_End,
				CASE 
					WHEN MONTH(DateValue) >= 4 THEN MONTH(DateValue) - 3
					WHEN MONTH(DateValue) < 4 THEN MONTH(DateValue) + 9
				END AS Financial_Month_Num,
				CASE 
					WHEN MONTH(DateValue) BETWEEN 4 AND 6 THEN 1
					WHEN MONTH(DateValue) BETWEEN 7 AND 9 THEN 2
					WHEN MONTH(DateValue) BETWEEN 10 AND 12 THEN 3
					WHEN MONTH(DateValue) BETWEEN 1 AND 3 THEN 4
				END AS Financial_Quarter_Num
			FROM DateSequence
		)
    INSERT INTO DetailedDateInfo (
        Date_SK,
        Date_INT_Id,
        Date_DT_Id,
        Date_Description,
        Day_In_Year,
        Day_Name_Long,
        Day_Name_Short,
        Day_In_Week,
        Day_In_Month,
        Week_Id,
        Month_Id,
        Month_Name_Long,
        Month_Name_Short,
        Quarter_Id,
        Year_Id,
        Month_Number_In_Year,
        Month_Description,
        Quarter_Number_In_Year,
        Quarter_Name_Short,
        Quarter_Name_Long,
        Quarter_Desc,
        Half_Year_Number_In_Year,
        Half_Year_Name_Short,
        Half_Year_Name_Long,
        Calendar_Year_Account,
        Financial_Year_Account,
        Academic_Year_Account,
        Academic_Month_Id,
        Academic_Month,
        Academic_Month_Description,
        Academic_Month_Number_In_Year,
        Academic_Month_PeriodDescription,
        Academic_Quarter_Id,
        Academic_Quarter,
        Academic_Quarter2,
        Academic_Quarter_Description,
        Academic_Quarter_Number_In_Year,
        Academic_Year_Id,
        Academic_Year_Desc,
        Academic_Year_Desc2,
        Academic_Year_Desc3,
        Academic_Year_Desc4,
        Academic_Year_Desc5,
        Academic_Year_Desc6,
        Academic_Year_Quarter_Description,
        Financial_Month_Id,
        Financial_Month_Description,
        Financial_Month_Number_In_Year,
        Financial_Quarter_Id,
        Financial_Quarter_Description,
        Financial_Quarter_Number_In_Year,
        Financial_Year_Id,
        Financial_Year_Desc,
        Financial_Year_Desc2
    )
   SELECT
    FORMAT(DateValue, 'yyyyMMdd') AS Date_SK,
    CONVERT(INT, FORMAT(DateValue, 'yyyyMMdd')) AS Date_INT_Id,
    DateValue AS Date_DT_Id,
    FORMAT(DateValue, 'yyyy-MM-dd') AS Date_Description,
    DATEPART(DAYOFYEAR, DateValue) AS Day_In_Year,
    DATENAME(WEEKDAY, DateValue) AS Day_Name_Long,
    LEFT(DATENAME(WEEKDAY, DateValue), 3) AS Day_Name_Short,
    DATEPART(WEEKDAY, DateValue) AS Day_In_Week,
    DATEPART(DAY, DateValue) AS Day_In_Month,
    DATEPART(WEEK, DateValue) AS Week_Id,
    DATEPART(MONTH, DateValue) AS Month_Id,
    DATENAME(MONTH, DateValue) AS Month_Name_Long,
    LEFT(DATENAME(MONTH, DateValue), 3) AS Month_Name_Short,
    DATEPART(QUARTER, DateValue) AS Quarter_Id,
    DATEPART(YEAR, DateValue) AS Year_Id, 
	 DATEPART(MONTH, DateValue) AS Month_Number_In_Year,
        LEFT(DATENAME(MONTH, DateValue), 3) + '-' + RIGHT(YEAR(DateValue), 2) AS Month_Description,
        YEAR(DateValue) * 10 + DATEPART(QUARTER, DateValue) AS Quarter_Id,
        DATEPART(QUARTER, DateValue) AS Quarter_Number_In_Year,
        'Q' + CAST(DATEPART(QUARTER, DateValue) AS VARCHAR) AS Quarter_Name_Short,
        'Quarter ' + CAST(DATEPART(QUARTER, DateValue) AS VARCHAR) AS Quarter_Name_Long,
        'Qtr ' + CAST(DATEPART(QUARTER, DateValue) AS VARCHAR) AS Quarter_Desc,
        CASE 
            WHEN DATEPART(MONTH, DateValue) <= 6 THEN 1
            ELSE 2
        END AS Half_Year_Number_In_Year,
        CASE 
            WHEN DATEPART(MONTH, DateValue) <= 6 THEN 'H1'
            ELSE 'H2'
        END AS Half_Year_Name_Short,
        CASE 
            WHEN DATEPART(MONTH, DateValue) <= 6 THEN 'First Half'
            ELSE 'Second Half'
        END AS Half_Year_Name_Long,
        YEAR(DateValue) AS Year_Id,
    CONCAT(RIGHT(YEAR(DateValue), 2), RIGHT(YEAR(DateValue) + 1, 2)) AS [Calendar_Year_Account],
    -- Financial Year Account Created
    CASE 
        WHEN MONTH(DateValue) >= 4 THEN CONCAT(RIGHT(YEAR(DateValue), 2), RIGHT(YEAR(DateValue) + 1, 2))
        ELSE CONCAT(RIGHT(YEAR(DateValue) - 1, 2), RIGHT(YEAR(DateValue), 2))
    END AS [Financial_Year_Account],
    -- Academic Year Account Created
    CASE 
        WHEN MONTH(DateValue) >= 8 THEN CONCAT(RIGHT(YEAR(DateValue), 2), RIGHT(YEAR(DateValue) + 1, 2))
        ELSE CONCAT(RIGHT(YEAR(DateValue) - 1, 2), RIGHT(YEAR(DateValue), 2))
    END AS [Academic_Year Account],
    -- Academic Columns
    CONCAT(
        RIGHT(Academic_Year_Start, 2),
        RIGHT(Academic_Year_Start + 1, 2),
        FORMAT(Academic_Month_Num, '00')
    ) AS Academic_Month_Id,
    DATENAME(MONTH, DateValue) + ', ' + CAST(Academic_Year_Start AS VARCHAR) + '/' + RIGHT(Academic_Year_Start + 1, 2) AS Academic_Month,
    'Month ' + CAST(Academic_Month_Num AS VARCHAR) + ', ' + CAST(Academic_Year_Start AS VARCHAR) + '/' + RIGHT(Academic_Year_Start + 1, 2) AS Academic_Month_Description,
    Academic_Month_Num AS Academic_Month_Number_In_Year,
    'Period ' + CAST(((Academic_Month_Num - 1) / 3) + 1 AS VARCHAR) AS Academic_Month_PeriodDescription,
    CONCAT(
        RIGHT(Academic_Year_Start, 2),
        RIGHT(Academic_Year_Start + 1, 2),
        '1',
        CAST(((Academic_Month_Num - 1) / 3) + 1 AS VARCHAR)
    ) AS Academic_Quarter_Id,
    DATENAME(MONTH, DATEADD(MONTH, -2, DateValue)) + ' - ' + DATENAME(MONTH, DateValue) + ', ' + CAST(Academic_Year_Start AS VARCHAR) + '/' + RIGHT(Academic_Year_Start + 1, 2) AS Academic_Quarter,
    DATENAME(MONTH, DATEADD(MONTH, -2, DateValue)) + ' ' + CAST(Academic_Year_Start AS VARCHAR) + ' - ' + DATENAME(MONTH, DateValue) + ' ' + RIGHT(Academic_Year_Start + 1, 2) AS Academic_Quarter2,
    'Quarter ' + CAST(((Academic_Month_Num - 1) / 3) + 1 AS VARCHAR) + ', ' + CAST(Academic_Year_Start AS VARCHAR) + '/' + RIGHT(Academic_Year_Start + 1, 2) AS Academic_Quarter_Description,
	Academic_Quarter_Number AS Academic_Quarter_Number_In_Year,
    CONCAT(RIGHT(Academic_Year_Start, 2), RIGHT(Academic_Year_Start + 1, 2)) AS Academic_Year_Id,
    CAST(Academic_Year_Start AS VARCHAR) + '/' + RIGHT(Academic_Year_Start + 1, 2) AS Academic_Year_Desc,
    CONCAT(RIGHT(Academic_Year_Start, 2), RIGHT(Academic_Year_Start + 1, 2)) AS Academic_Year_Desc2,
    CAST(Academic_Year_Start AS VARCHAR) AS Academic_Year_Desc3,
    CAST(Academic_Year_Start AS VARCHAR) + '/' + CAST(Academic_Year_Start + 1 AS VARCHAR) AS Academic_Year_Desc4,
    CAST(Academic_Year_Start AS VARCHAR) + ' / ' + CAST(Academic_Year_Start + 1 AS VARCHAR) AS Academic_Year_Desc5,
    RIGHT(CAST(Academic_Year_Start AS VARCHAR), 2) + '/' + RIGHT(CAST(Academic_Year_Start + 1 AS VARCHAR), 2) AS Academic_Year_Desc6,
    CAST(Academic_Year_Start AS VARCHAR) + '/' + RIGHT(Academic_Year_Start + 1, 2) + ', Quarter ' + CAST(Academic_Quarter_Number AS VARCHAR) AS Academic_Year_Quarter_Description,
	CONCAT(RIGHT(Financial_Year_Start, 2), RIGHT(Financial_Year_End, 2), FORMAT(Financial_Month_Num, '00')) AS Financial_Month_Id,
    'Month ' + CAST(Financial_Month_Num AS VARCHAR) + ', ' + CAST(Financial_Year_Start AS VARCHAR) + '/' + RIGHT(Financial_Year_End, 2) AS Financial_Month_Description,
    Financial_Month_Num AS Financial_Month_Number_In_Year,
    CONCAT(RIGHT(Financial_Year_Start, 2), RIGHT(Financial_Year_End, 2), Financial_Quarter_Num) AS Financial_Quarter_Id,
    'Quarter ' + CAST(Financial_Quarter_Num AS VARCHAR) + ', ' + CAST(Financial_Year_Start AS VARCHAR) + '/' + RIGHT(Financial_Year_End, 2) AS Financial_Quarter_Description,
    Financial_Quarter_Num AS Financial_Quarter_Number_In_Year,
    CONCAT(RIGHT(Financial_Year_Start, 2), RIGHT(Financial_Year_End, 2)) AS Financial_Year_Id,
    CAST(Financial_Year_Start AS VARCHAR) + '/' + RIGHT(Financial_Year_End, 2) AS Financial_Year_Desc,
    RIGHT(CAST(Financial_Year_Start AS VARCHAR), 2) + '/' + RIGHT(CAST(Financial_Year_End AS VARCHAR), 2) AS Financial_Year_Desc2

FROM
    CombinedDetails
OPTION (MAXRECURSION 0);



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
	    'ImportDimDate',
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
