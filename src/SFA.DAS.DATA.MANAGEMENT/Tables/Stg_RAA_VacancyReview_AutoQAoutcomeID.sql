CREATE TABLE Stg.RAA_VacancyReviews_AutoQAoutcomeID
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256)
 ,UserId varchar(256)
 ,VacancyReference VARCHAR(256)
 ,Ruleoutcome_BinaryID Varchar(256)
 ,AutoQAfieldisReferred varchar(256)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
