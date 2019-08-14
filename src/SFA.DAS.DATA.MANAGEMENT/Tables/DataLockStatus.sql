  CREATE TABLE dbo.DataLockStatus
  (Id int Identity(1,1) not null
  ,ApprenticeshipId int 
  ,TrainingCourseId int
  ,DataLockEventId bigint not null
  ,DataLockEventDateTime datetime
  ,PriceEpisodeIdentifier nvarchar(25)
  ,IlrTrainingCourseCode nvarchar(20)
  ,IlrTrainingType tinyint
  ,IlrActualStartDate datetime
  ,IlrEffectiveFromDate datetime
  ,IlrPriceEffectiveToDate datetime
  ,IlrTotalCost decimal(18,0)
  ,ErrorCode int
  ,DataLockStatus tinyint
  ,DataLockStatusDesc as (CASE WHEN DataLockStatus=0 THEN 'Unknown' WHEN DataLockStatus=1 THEN 'Pass' WHEN DataLockStatus=2 THEN 'Fail' ELSE 'Unknown' END) PERSISTED
  ,TriageStatus tinyint
  ,TriageStatusDesc as (CASE WHEN TriageStatus=0 THEN 'Unknown' WHEN TriageStatus=1 THEN 'Change Requested' WHEN TriageStatus=2 THEN 'Stop/Restart Requested' WHEN TriageStatus=3 THEN 'FixIlr' ELSE 'Unknown' END) PERSISTED
  ,IsResolved bit
  ,EventStatus tinyint
  ,IsExpired bit
  ,Expireddatetime datetime
  ,Data_Source varchar(255)
  ,Source_DataLockStatusId int
  ,RunId bigint
  ,AsDm_CreatedDate datetime2 default(getdate())
  ,AsDm_UpdatedDate datetime2 default(getdate())
  ,CONSTRAINT PK_DataLockStatus_Id PRIMARY KEY(Id)
  ,CONSTRAINT FK_DataLockStatus_ApprenticeshipId Foreign Key(ApprenticeshipId) References dbo.Apprenticeship(Id)
  )