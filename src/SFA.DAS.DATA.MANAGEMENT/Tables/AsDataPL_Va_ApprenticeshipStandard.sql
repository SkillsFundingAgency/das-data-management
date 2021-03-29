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
   ,ApprenticeshipFrameworkStatusType nvarchar(100)
   ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
