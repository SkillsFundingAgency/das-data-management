CREATE TABLE [AsData_PL].[Va_EducationLevel]
(
	EducationLevelId int Primary Key
   ,EducationLevelCodeName nvarchar(3)
   ,EducationLevelShortName nvarchar(10)
   ,EducationLevelFullName nvarchar(50)
   ,EducationLevelNamev2   nvarchar(100)
   ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
