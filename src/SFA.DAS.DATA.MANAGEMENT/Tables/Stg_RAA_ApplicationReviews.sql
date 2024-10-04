﻿CREATE TABLE [Stg].[RAA_ApplicationReviews]
(
 SourseSK BIGINT IDENTITY(1,1) NOT NULL
,BinaryId VARCHAR(256)
,TypeCode VARCHAR(256)
,CandidateId VARCHAR(256)
,CandidateId_UI UNIQUEIDENTIFIER 
,CandidateIdType VARCHAR(256)
,VacancyReference VARCHAR(256)
,ApplicationStatus VARCHAR(256)
,DateSharedWithEmployer VARCHAR(256)
,CreatedDateTimeStamp VARCHAR(256)
,SubmittedDateTimeStamp VARCHAR(256)
,ApplicantId VARCHAR(256)
,ApplicantType VARCHAR(256)
,ApplicantVacancyReference VARCHAR(256)
,ApplicationDateTimeStamp VARCHAR(256)
,ApplicantAddressLine1 VARCHAR(256)
,ApplicantAddressLine2 VARCHAR(256)
,ApplicantAddressLine3 VARCHAR(256)
,ApplicantAddressLine4 VARCHAR(256)
,ApplicantPostCode VARCHAR(256)
,ApplicantBirthDate VARCHAR(256)
,ApplicantDisabilityStatus VARCHAR(256)
,ApplicantEducationFromYear VARCHAR(256)
,ApplicantEducationInstitution VARCHAR(256)
,ApplicantEducationToYear VARCHAR(256)
,ApplicantEmail VARCHAR(256)
,ApplicantPhone VARCHAR(256)
,ApplicantFirstName VARCHAR(256)
,ApplicantLastName VARCHAR(256)
,ApplicantHobbiesAndInterests VARCHAR(max)
,ApplicantImprovements VARCHAR(max)
,ApplicantQualifications VARCHAR(MAX)
,ApplicantSkills VARCHAR(max)
,ApplicantStrengths VARCHAR(max)
,ApplicantSupport VARCHAR(max)
,ApplicantTrainingCourses VARCHAR(MAX)
,ApplicantWorkExperiences VARCHAR(MAX)
,ApplicantFromDateTimeStamp VARCHAR(256)
,ApplicantToDateTimeStamp VARCHAR(256)
,StatusUpdatedDateTimeStamp VARCHAR(256)
,StatusUpdatedByUserId VARCHAR(256)
,StatusUpdatedByName VARCHAR(256)
,StatusUpdatedByEmail VARCHAR(256)
,CandidateFeedback VARCHAR(max)
,IsWithDrawn VARCHAR(256)
,RunId bigint  default(-1)
,AsDm_CreatedDate datetime2 default(getdate()) 
,AsDm_UpdatedDate datetime2 default(getdatE())
)