CREATE TABLE Stg.RAA_Users
  (
  SourseSK INT IDENTITY(1,1) NOT NULL 
 ,BinaryId varchar(256)
 ,TypeCode varchar(256)
 ,IdamUserId varchar(256)
 ,UserType varchar(256)
 ,UserName varchar(256)
 ,UserEmail varchar(256) 
 ,UserCreatedTimeStamp varchar(256)
 ,LastSignedInTimeStamp varchar(256)
 ,EmployerAccountId varchar(max)
 ,Ukprn nvarchar(256)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
