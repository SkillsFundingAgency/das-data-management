CREATE TABLE [AsData_PL].[Va_VacancyReviews]
(
   VacancyReviewId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY
  ,EmployerAccountId VARCHAR(256)
  ,CandidateId BIGINT
  ,CreatedDateTime DATETIME2
  ,SubmittedDateTime DateTime2
  ,VacancyReference Varchar(256)
  ,VacancyId bigint
  ,ManualOutcome varchar(256)
  ,ManualQaFieldIndicator varchar(256)
  ,ManualQaFieldChangeRequested varchar(256)
  ,ManualQaComment varchar(max)
  ,SourceVacancyReviewId varchar(256)
  ,SourceDb varchar(256)
)
