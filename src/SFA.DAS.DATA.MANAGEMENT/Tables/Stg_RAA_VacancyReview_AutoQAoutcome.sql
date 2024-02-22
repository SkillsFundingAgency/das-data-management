CREATE TABLE Stg.RAA_VacancyReviews_AutoQAoutcome
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256)
 ,EmployerAccountId varchar(256) 
 ,UserId varchar(256)
 ,VacancyReference VARCHAR(256)
 ,RuleoutcomeID Varchar(256)
 ,Rule_RuleId varchar(256)
 ,Rule_Score varchar(256)
 ,Rule_Narrative varchar(max)
 ,Rule_Target varchar(256)
 ,Details_BinaryID varchar(256)
 ,Details_RuleID varchar(256)
 ,Details_score varchar(256)
 ,Details_narrative varchar(max)
 ,Details_data varchar(max)
 ,Details_target varchar(256)
 )