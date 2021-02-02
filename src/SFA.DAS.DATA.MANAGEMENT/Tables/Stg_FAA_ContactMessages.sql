CREATE TABLE Stg.[FAA_ContactMessages]
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId varchar(256)
 ,TypeCode varchar(256)
 ,EntityId varchar(256)
 ,EntityTypeCode varchar(256)
 ,DateCreatedTimeStamp varchar(256)
 ,DateUpdatedTimeStamp varchar(256)
 ,UserId varchar(256) 
 ,Enquiry varchar(max)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
)
