CREATE TABLE Stg.RAA_VacancyReviewsManualQaEdit
(
  SourseSK BIGINT IDENTITY(1,1) NOT NULL
 ,BinaryId VARCHAR(256) 
 ,TypeCode VARCHAR(256)
 ,ManualQaEditFieldIndicator varchar(256)
 ,ManualQaEditBefore varchar(4000)
 ,ManualQaEditAfter varchar(4000)
 ,RunId bigint  default(-1)
 ,AsDm_CreatedDate datetime2 default(getdate()) 
 ,AsDm_UpdatedDate datetime2 default(getdatE())
 )
