CREATE TABLE [StgRAA].[RAA_ReferenceDataQualificationTypes]
(
 SourseSK BIGINT IDENTITY(1,1) NOT NULL
,BinaryId VARCHAR(256)
,LastUpdatedDateTimeStamp Varchar(256)
,QualificationTypes varchar(max)
,RunId bigint  default(-1)
,AsDm_CreatedDate datetime2 default(getdate()) 
,AsDm_UpdatedDate datetime2 default(getdatE())
)