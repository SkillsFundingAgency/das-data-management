CREATE TABLE [AsData_PL].[Va_ApprenticeshipStandard]
(
	StandardId int
   ,LarsCode int
   ,StandardFullName nvarchar(max)
   ,StandardSectorId int
   ,StandardSectorName nvarchar(max)
   ,LarsStandardSectorCode int
   ,ApprenticeshipOccupationId int
   ,EducationLevelId int
   ,EducationLevelNumber int
   ,EducationLevelCodeName nvarchar(3)
   ,EducationLevelShortName nvarchar(10)
   ,EducationLevelFullName nvarchar(50)
   ,ApprenticeshipFrameworkStatusType nvarchar(100)
)
