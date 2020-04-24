CREATE TABLE [Stg].[RAA_ReferenceDataCandidateSkills]
(
 SourseSK BIGINT IDENTITY(1,1) NOT NULL
,CandidateSkillsId VARCHAR(256)
,CandidateSkillsLastUpdatedDateTimeStamp Varchar(256)
,Skills varchar(max)
,RunId bigint  default(-1)
,AsDm_CreatedDate datetime2 default(getdate()) 
,AsDm_UpdatedDate datetime2 default(getdatE())
)