CREATE TABLE Stg.RAA_VacancyReviews_AutoQAoutcomedetails
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256)
 ,UserId varchar(256)
 ,VacancyReference VARCHAR(256)
 ,RuleoutcomeID Varchar(256)
 ,Details_BinaryID varchar(256)
 ,Details_RuleID varchar(256)
 ,Details_score varchar(256)
 ,Details_narrative varchar(max)
 ,Details_data varchar(max)
 ,Details_target varchar(256)
 )