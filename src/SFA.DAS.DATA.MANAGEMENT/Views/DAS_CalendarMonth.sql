CREATE VIEW [Data_Pub].[DAS_CalendarMonth]
	AS 
SELECT CalendarMonthID
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
  FROM dbo.DASCalendarMonth
