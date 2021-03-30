CREATE TABLE [Mtd].[NationalMinimumWageRates]
(
	[MNMWR_Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY
   ,[StartDate] DateTime2
   ,[EndDate] DateTime2
   ,[AgeGroup] Varchar(50)
   ,[WageRateInPounds] Decimal(19,4)
)
