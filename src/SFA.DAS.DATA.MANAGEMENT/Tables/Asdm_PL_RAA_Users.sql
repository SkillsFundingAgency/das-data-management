CREATE TABLE AsData_PL.RAA_Users
(
  SourseSK INT IDENTITY(1,1) NOT NULL
 ,BinaryId varchar(256)
 ,TypeCode varchar(10)
 ,IdamUserId varchar(256)
 ,UserType varchar(256)
 ,UserName varchar(256) MASKED WITH (FUNCTION = 'default()')
 ,UserEmail varchar(256) MASKED WITH (FUNCTION = 'Email()') 
 ,UserCreatedTimeStamp bigint
 ,UserCreatedDateTime datetime2
 ,LastSignedInTimeStamp bigint
 ,LastSignedDateTime datetime2
 ,EmployerAccountId varchar(100)
 ,Ukprn int
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )

