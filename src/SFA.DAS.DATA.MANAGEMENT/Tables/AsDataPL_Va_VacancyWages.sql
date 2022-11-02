CREATE TABLE [AsData_PL].[Va_VacancyWages]
(
	[VacancyId] INT NOT NULL PRIMARY KEY
   ,[NumberOfPositions] int
   ,[WageType] nvarchar(255)
   ,[AnnaualMinimumWage] decimal(19,4)
   ,[AnnualMaximumWage] decimal(19,4)
)
