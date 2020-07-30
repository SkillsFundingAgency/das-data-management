CREATE TABLE AsData_Pl.Va_Vacancy
(
 VacancyId BIGINT IDENTITY(1,1) PRIMARY KEY
,VacancyGuid varchar(256)
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
,LegalEntitiyId Int
,LegalEntityName nvarchar(255)
,ProviderId int
,ProviderUkprn int
,ProviderFullName nvarchar(255)
,ProviderTradingName nvarchar(255)
--,ProviderRelationshipType nvarchar(100)
,VacancyOwner_v2 Varchar(100)
,ApprenticeshipType nvarchar(200)
,VacancyShortDescription nvarchar(max)
,VacancyDescription nvarchar(max)
,VacancyLocationTypeId_v1 int
,VacancyLocationType_v1 varchar(255)
,NumberOfPositions int
,SectorName varchar(255)
,FrameworkOrStandardID varchar(255)
,FrameworkOrStandardLarsCode varchar(255)
,FrameworkOrStandardName varchar(255)
,EducationLevel varchar(255)
,WeeklyWage_v1 decimal(19,4)
,WageLowerBound_v1 decimal(19,4)
,WageUpperBound_v1 decimal(19,4)
,WageType nvarchar(255)
,WageText nvarchar(max)
,WageUnitId_v1 Int
,WageUnitDesc varchar(255)
,WorkingWeek nvarchar(max)
,HoursPerWeek decimal(10,2)
,DurationTypeId int
,DurationTypeDesc int
,ApplicationClosingDate datetime
,InterviewsFromDate_v1 datetime
,ExpectedStartDate datetime
,ExpectedDuration nvarchar(max)
,NumberOfViews_v1 int
,MaxNumberOfApplications_v1 int
,ApplyOutsideNAVMS_v1 bit
,NoOfOfflineApplicants_v1 int
,MasterVacancyId_v1 int
,NoOfOfflineSystemApplicants_v1 int
,SmallEmployerWageIncentive_v1 bit
,SubmissionCount_v1 int
,StartedToQADateTime_v1 datetime
,TrainingTypeId_v1 int
,TrainingTypeFullName varchar(255)
,VacancyTypeId int
,VacancyTypeDesc varchar(255)
,UpdatedDateTime datetime
,EditedInRaa_v1 bit
,VacancySourceId_v1 int
,VacancySource varchar(255)
,OfflineVacancyTypeId_v1 int
,CreatedDate datetime
,IsDeleted_v2 Varchar(100)
,DeletedDateTime_v2 DateTime
,SubmittedDateTime_v2 DateTime
,SourceVacancyId INT
,SourceDb varchar(100)
)




