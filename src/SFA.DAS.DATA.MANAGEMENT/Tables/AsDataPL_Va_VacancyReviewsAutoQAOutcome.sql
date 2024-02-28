CREATE TABLE [AsData_PL].[va_VacancyReviewsAutoQAOutcomeID]
(
   VacancyReviewId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY
  ,EmployerAccountId VARCHAR(256)
  ,CandidateId BIGINT
  ,VacancyReference Varchar(256)
  ,VacancyId bigint
  ,RuleoutcomeID Varchar(256)
  ,Rule_RuleId Varchar(256)
  ,Rule_Score Varchar(256)
  ,Rule_Narrative Varchar(max)
  ,Rule_Target Varchar(256)
  ,Details_BinaryID Varchar(256)
  ,Details_RuleID Varchar(256)
  ,Details_score Varchar(256)
  ,Details_narrative Varchar(max)
  ,Details_data Varchar(max)
  ,Details_target Varchar(256)
  ,SourceVacancyReviewId varchar(256)
  ,SourceDb varchar(256)
  ,[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
)
