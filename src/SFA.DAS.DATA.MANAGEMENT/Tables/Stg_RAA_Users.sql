CREATE TABLE Stg.RAA_Users
  (
  SourseSK INT IDENTITY(1,1) NOT NULL 
 ,BinaryId nvarchar(256)
 ,TypeCode nvarchar(256)
 ,IdamUserId nvarchar(256)
 ,UserType nvarchar(256)
 ,UserName nvarchar(256)
 ,UserEmail nvarchar(256) 
 ,UserCreatedTimeStamp nvarchar(256)
 ,LastSignedInTimeStamp nvarchar(256)
 ,EmployerAccountId nvarchar(512)
 ,Ukprn nvarchar(256)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
