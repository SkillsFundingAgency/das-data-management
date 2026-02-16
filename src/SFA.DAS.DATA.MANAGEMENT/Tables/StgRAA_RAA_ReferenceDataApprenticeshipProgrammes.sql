CREATE TABLE [StgRAA].[RAA_ReferenceDataApprenticeshipProgrammes]
(
 SourseSK BIGINT IDENTITY(1,1) NOT NULL
,BinaryId VARCHAR(256)
,ProgrammeId varchar(256)
,LastUpdatedDateTimeStamp Varchar(256)
,ApprenticeshipType varchar(256)
,Title varchar(256)
,EffectiveFrom varchar(256)
,Duration varchar(256)
,IsActive varchar(256)
,EducationLevelNumber varchar(256)
,RunId bigint  default(-1)
,AsDm_CreatedDate datetime2 default(getdate()) 
,AsDm_UpdatedDate datetime2 default(getdatE())
)