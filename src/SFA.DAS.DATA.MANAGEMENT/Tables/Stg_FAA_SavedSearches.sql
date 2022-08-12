CREATE TABLE Stg.[FAA_SavedSearches]
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId varchar(256)
 ,TypeCode varchar(256)
 ,EntityId varchar(256)
 ,EntityTypeCode varchar(256)
 ,DateCreatedTimeStamp varchar(256)
 ,DateUpdatedTimeStamp varchar(256)
 ,CandidateId varchar(256)
 ,[Location] varchar(256)
 ,Keywords varchar(1096)
 ,WithinDistance varchar(256) 
 ,ApprenticeshipLevel varchar(256) 
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
)


