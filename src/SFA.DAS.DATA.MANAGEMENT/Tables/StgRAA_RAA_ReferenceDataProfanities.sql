CREATE TABLE [StgRAA].[RAA_ReferenceDataProfanities]
(
 SourseSK BIGINT IDENTITY(1,1) NOT NULL
,BinaryId VARCHAR(256)
,LastUpdatedDateTimeStamp Varchar(256)
,Profanities Varchar(max)
,ProfanityId Varchar(256)
,RunId bigint  default(-1)
,AsDm_CreatedDate datetime2 default(getdate()) 
,AsDm_UpdatedDate datetime2 default(getdatE())
)