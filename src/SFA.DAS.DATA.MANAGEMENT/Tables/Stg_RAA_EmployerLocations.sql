CREATE TABLE Stg.RAA_EmployerLocations
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256) 
 ,VacancyReference VARCHAR(256)
 ,EmployerAccountId VARCHAR(256)
 ,EmployerAddressLine1 VARCHAR(256)
 ,EmployerAddressLine2 VARCHAR(256)
 ,EmployerAddressLine3 VARCHAR(256)
 ,EmployerAddressLine4 VARCHAR(256)
 ,EmployerPostCode VARCHAR(256)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
