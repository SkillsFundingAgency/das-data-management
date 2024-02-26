CREATE TABLE Stg.RAA_VacancyReviews_AutoQARuleoutcome
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
 ,Rule_Details varchar(max)
)