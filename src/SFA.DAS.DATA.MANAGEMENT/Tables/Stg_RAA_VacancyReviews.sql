CREATE TABLE Stg.RAA_VacancyReviews
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256) 
 ,TypeCode VARCHAR(256)
 ,EmployerAccountId varchar(256)
 ,UserId varchar(256)
 ,CreatedTimeStamp varchar(256)
 ,SubmittedTimeStamp varchar(256)
 ,VacancyReference VARCHAR(256)
 ,SourceVacancyReference varchar(256)
 ,ManualOutcome varchar(256)
 ,ManualQaFieldIndicator varchar(256)
 ,ManualQaFieldChangeRequested varchar(256)
 ,ManualQaComment varchar(max)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
