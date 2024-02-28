CREATE TABLE [AsData_PL].[va_VacancyReviewsAutoQAOutcomeID]
(
   VacancyReviewId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY
  ,EmployerAccountId VARCHAR(256)
  ,CandidateId BIGINT
  ,VacancyReference Varchar(256)
  ,VacancyId bigint
  ,Ruleoutcome_BinaryID  Varchar(256)
  ,AutoQAfieldisReferred  Varchar(256)
  ,SourceVacancyReviewId varchar(256)
  ,SourceDb varchar(256)
  ,[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
)
