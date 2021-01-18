CREATE TABLE Stg.RAA_VacancyReviews
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256) 
 ,TypeCode VARCHAR(256)
 ,VacancyReference VARCHAR(256)
 ,ManualOutcome varchar(256)
 ,ManualQaFieldIndicator varchar(256)
 ,ManualQaFieldChangeRequested varchar(256)
 ,ManualQaComment varchar(256)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
