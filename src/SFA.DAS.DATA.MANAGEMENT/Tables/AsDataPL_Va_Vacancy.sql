CREATE TABLE AsData_Pl.Va_Vacancy
(
 VacancyId INT PRIMARY KEY
,VacancyGuid uniqueidentifier
,VacancyReferenceNumber int
,VacancyStatus Varchar(100)
,VacancyTitle nvarchar(max)
,VacancyLocalAuthorityId int
,VacancyLocalAuthorityName varchar(255)
,VacancyPostcode varchar(25)
,VacancyCountyId int
,VacancyCounty varchar(255)
,EmployerId int
,EmployerFullName nvarchar(255)
,ProviderId int
,ProviderUkprn int
,ProviderFullName nvarchar(255)
,ProviderTradingName nvarchar(255)
,ProviderRelationshipType nvarchar(100)
,ApprenticeshipType nvarchar(200)
,VacancyShortDescription nvarchar(max)
,VacancyDescription nvarchar(max)
,VacancyLocationTypeId int
,VacancyLocationType varchar(255)
,NumberOfPositions smallint
,SectorId int
,SectorName varchar(255)
,FrameworkOrStandardID varchar(255)
,FrameworkOrStandardLarsCode varchar(255)
,FrameworkOrStandardName varchar(255)
,StandardLevel varchar(255)
,StandardLevelId int
,WeeklyWage decimal(19,4)
,WageLowerBound decimal(19,4)
,WageUpperBound decimal(19,4)
,WageType nvarchar(255)
,WageText nvarchar(max)
,WageUnitId int
,WageUnitDesc varchar(255)
,WorkingWeek nvarchar(max)
,HoursPerWeek decimal(10,2)
,DurationTypeId int
,DurationValue int
,ApplicationClosingDate datetime
,InterviewsFromDate datetime
,ExpectedStartDate datetime
,ExpectedDuration nvarchar(max)
,NumberOfViews int
,MaxNumberOfApplications int
,ApplyOutsideNAVMS bit
,NoOfOfflineApplicants int
,MasterVacancyId int
,NoOfOfflineSystemApplicants int
,SmallEmployerWageIncentive bit
,SubmissionCount int
,StartedToQADateTime datetime
,TrainingTypeId int
,TrainingTypeFullName varchar(255)
,VacancyTypeId int
,VacancyTypeDesc varchar(255)
,UpdatedDateTime datetime
,EditedInRaa bit
,VacancySourceId int
,VacancySource varchar(255)
,OfflineVacancyTypeId int
,CreatedDate datetime
)




