CREATE TABLE [Stg].[RAA_ReferenceDataBannedPhrases]
(
 SourseSK BIGINT IDENTITY(1,1) NOT NULL
,BinaryId VARCHAR(256)
,LastUpdatedDateTimeStamp Varchar(256)
,BannedPhrases Varchar(max)
,RunId bigint  default(-1)
,AsDm_CreatedDate datetime2 default(getdate()) 
,AsDm_UpdatedDate datetime2 default(getdatE())
)