CREATE TABLE Stg.[FAA_Feedback]
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId varchar(256)
 ,UserId varchar(256)
 ,TypeCode varchar(10)
 ,DateCreatedTimeStamp varchar(256)
 ,Enquiry varchar(max)
 ,Details nvarchar(max)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
)
