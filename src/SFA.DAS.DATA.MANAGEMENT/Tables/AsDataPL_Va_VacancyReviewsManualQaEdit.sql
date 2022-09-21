CREATE TABLE [AsData_PL].[Va_VacancyReviewsManualQaEdit]
(
   VacancyReviewManualQaEditId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY  
  ,ManualQaEditFieldIndicator varchar(256)
  ,ManualQaEditBefore varchar(4000)
  ,ManualQaEditAfter varchar(max) 
  ,SourceVacancyReviewId varchar(256)
  ,SourceDb varchar(256)
  ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
