﻿CREATE TABLE Stg.RAA_Vacancies
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256) 
 ,TypeCode VARCHAR(256)
 ,EmployerAccountId VARCHAR(256)
 ,VacancyReference VARCHAR(256)
 ,VacancyStatus VARCHAR(256)
 ,OwnerType VARCHAR(256)
 ,SourceOrigin VARCHAR(256)
 ,SourceType VARCHAR(256)
 ,ClosedDateTimeStamp VARCHAR(256)
 ,CreatedDateTimeStamp VARCHAR(256)
 ,CreatedByUserID VARCHAR(256)
 ,CreatedByUserName VARCHAR(256)
 ,CreatedByUserEmail VARCHAR(256)
 ,SubmittedDateTimeStamp VARCHAR(256)
 ,SubmittedByUserId VARCHAR(256)
 ,SubmittedByUserName VARCHAR(256)
 ,SubmittedByUserEmail VARCHAR(256)
 ,ApprovedDateTimeStamp VARCHAR(256)
 ,LiveDateTimeStamp VARCHAR(256)
 ,LastUpdatedTimeStamp VARCHAR(256)
 ,LastUpdatedByUserId VARCHAR(256)
 ,LastUpdatedByUserName VARCHAR(256)
 ,LastUpdatedByUserEmail VARCHAR(256)
 ,IsDeleted  VARCHAR(256)
 ,ApplicationIstructions VARCHAR(max)
 ,ApplicationMethod VARCHAR(512)
 ,ApplicationUrl VARCHAR(max)
 ,ClosingDateTimeStamp VARCHAR(256)
 ,VacancyDescription VARCHAR(max)
 ,DisabilityConfident VARCHAR(256)
 ,EmployerDescription VARCHAR(max)
 ,EmployerAddressLine1 VARCHAR(256)
 ,EmployerAddressLine2 VARCHAR(256)
 ,EmployerAddressLine3 VARCHAR(256)
 ,EmployerAddressLine4 VARCHAR(256)
 ,EmployerPostCode VARCHAR(256)
 ,EmployerLatitude VARCHAR(256)
 ,EmployerLongitude VARCHAR(256)
 ,EmployerName VARCHAR(256)
 ,EmployerNameOption VARCHAR(256)
 ,LegalEntityName VARCHAR(256)
 ,EmployerWebsiteUrl VARCHAR(256)
 ,GeoCodeMethod VARCHAR(256)
 ,LegalEntityId VARCHAR(256)
 ,AccountLegalEntityPublicHashedId VARCHAR(256)
 ,NumberOfPositions VARCHAR(256)
 ,OutcomeDescription VARCHAR(max)
 ,ProgrammeId VARCHAR(256)
 ,Qualifications VARCHAR(max)
 ,ShortDescription VARCHAR(max)
 ,Skills VARCHAR(max)
 ,StartDateTimeStamp VARCHAR(256)
 ,ThingsToConsider VARCHAR(max)
 ,VacancyTitle VARCHAR(max)
 ,TrainingDescription VARCHAR(max)
 ,TrainingProviderUkprn VARCHAR(256)
 ,TrainingProviderName VARCHAR(256)
 ,TrainingProviderAddressLine3 VARCHAR(256)
 ,TrainingProviderAddressLine4 VARCHAR(256)
 ,TrainingProviderPostcode VARCHAR(256)
 ,WageDuration VARCHAR(256)
 ,WageDurationUnit VARCHAR(256)
 ,WorkingWeekDescription VARCHAR(max)
 ,WeeklyHours VARCHAR(256)
 ,WageType VARCHAR(max)
 ,FixedWageYearlyAmount VARCHAR(256)
 ,WageAdditionalInformation VARCHAR(max)
 ,ClosureReason VARCHAR(256)
 ,DeletedDateTimeStamp VARCHAR(256)
 ,DeletedByUserId VARCHAR(256)
 ,DeletedByUserName VARCHAR(256)
 ,DeletedByUserEmail VARCHAR(256)
 ,EmployerContactName VARCHAR(256)
 ,EmployerContactEmail VARCHAR(256)
 ,EmployerContactPhone VARCHAR(256)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
