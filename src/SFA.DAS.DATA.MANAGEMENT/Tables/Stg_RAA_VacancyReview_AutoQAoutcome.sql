CREATE TABLE Stg.RAA_VacancyReviews_AutoQAoutcome
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256) 
 ,UserId varchar(256)
 ,SubmittedTimeStamp varchar(256)
 ,VacancyReference VARCHAR(256)
 ,ManualQaFieldChangeRequested varchar(256)
 ,ruleId varchar(256)
 ,score varchar(256)
 ,narrative varchar(256)
 ,target varchar(256)
 )
