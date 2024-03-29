﻿CREATE TABLE [AsData_PL].[DimDate]
(
  Date_SK VARCHAR(8),
    Date_INT_Id INT,
    Date_DT_Id DATE,
    Date_Description VARCHAR(10),
    Day_In_Year INT,
    Day_Name_Long VARCHAR(9),
    Day_Name_Short VARCHAR(3),
    Day_In_Week INT,
    Day_In_Month INT,
    Week_Id INT,
    Month_Id INT,
    Month_Name_Long VARCHAR(9),
    Month_Name_Short VARCHAR(3),
    Quarter_Id INT,
    Year_Id INT,
    Month_Number_In_Year INT,
    Month_Description VARCHAR(7),
    Quarter_Number_In_Year INT,
    Quarter_Name_Short VARCHAR(2),
    Quarter_Name_Long VARCHAR(9),
    Quarter_Desc VARCHAR(5),
    Half_Year_Number_In_Year INT,
    Half_Year_Name_Short VARCHAR(2),
    Half_Year_Name_Long VARCHAR(11),
    Calendar_Year_Account VARCHAR(7),
    Financial_Year_Account VARCHAR(7),
    Academic_Year_Account VARCHAR(7),
    Academic_Month_Id VARCHAR(6),
    Academic_Month VARCHAR(20),
    Academic_Month_Description VARCHAR(20),
    Academic_Month_Number_In_Year INT,
    Academic_Month_PeriodDescription VARCHAR(8),
    Academic_Quarter_Id VARCHAR(6),
    Academic_Quarter VARCHAR(30),
    Academic_Quarter2 VARCHAR(30),
    Academic_Quarter_Description VARCHAR(30),
    Academic_Quarter_Number_In_Year INT,
    Academic_Year_Id VARCHAR(4),
    Academic_Year_Desc VARCHAR(7),
    Academic_Year_Desc2 VARCHAR(4),
    Academic_Year_Desc3 VARCHAR(4),
    Academic_Year_Desc4 VARCHAR(9),
    Academic_Year_Desc5 VARCHAR(11),
    Academic_Year_Desc6 VARCHAR(5),
    Academic_Year_Quarter_Description VARCHAR(20),
    Financial_Month_Id VARCHAR(6),
    Financial_Month_Description VARCHAR(20),
    Financial_Month_Number_In_Year INT,
    Financial_Quarter_Id VARCHAR(5),
    Financial_Quarter_Description VARCHAR(20),
    Financial_Quarter_Number_In_Year INT,
    Financial_Year_Id VARCHAR(4),
    Financial_Year_Desc VARCHAR(7),
    Financial_Year_Desc2 VARCHAR(5)
)
