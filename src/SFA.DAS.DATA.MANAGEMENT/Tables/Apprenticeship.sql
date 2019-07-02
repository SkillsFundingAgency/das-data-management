CREATE TABLE dbo.Apprenticeship
  (ID int identity(1,1) PRIMARY KEY NOT NULL
  ,CommitmentId int Foreign Key References dbo.Commitment(id)
  ,ApprenticeId int Foreign Key References dbo.Apprentice(Id)
  ,TrainingCourseId int Foreign Key References dbo.TrainingCourse(Id)
  ,AssessmentOrgId int Foreign Key References dbo.AssessmentOrganisation(Id)
  ,Cost decimal(18,0)
  ,StartDate datetime
  ,EndDate Datetime
  ,AgreementStatus smallint
  ,AgreementStatusDesc as (CASE WHEN AgreementStatus=0 THEN 'Not Agreed' WHEN AgreementStatus=1 THEN 'Employer Agreed' WHEN AgreementStatus=2 THEN 'Provider Agreed' WHEN AgreementStatus=3 THEN 'Both Agreed' ELSE 'Unknown' END) PERSISTED
  ,ApprenticeshipStatus smallint
  ,ApprenticeshipStatusDesc as (CASE WHEN ApprenticeshipStatus=0 THEN 'Pending Approval' WHEN ApprenticeshipStatus=1 THEN 'Active' WHEN ApprenticeshipStatus=2 THEN 'Payments Halted' WHEN ApprenticeshipStatus=3 THEN 'CANCELLED' WHEN ApprenticeshipStatus=4 THEN 'COMPLETED' WHEN ApprenticeshipStatus=5 THEN 'Deleted' ELSE 'Unknown' END) PERSISTED
  ,EmployerRef nvarchar(50)
  ,ProviderRef nvarchar(50)
  ,CommitmentCreatedOn Datetime
  ,CommitmentAgreedOn DateTime
  ,PaymentOrder int
  ,StopDate date
  ,PauseDate date
  ,HasHadDataLockSuccess bit not null
  ,PendingUpdateOriginator tinyint
  ,PendingUpdateOrginatorDesc as (Case when PendingUpdateOriginator=0 then '' when PendingUpdateOriginator=1 then '' else 'unknown' end)
  ,CloneOf bigint
  ,ReservationId uniqueidentifier
  ,IsApproved  AS (case when ApprenticeshipStatus>(0) then CONVERT([bit],(1)) else CONVERT([bit],(0)) end) PERSISTED
  ,Data_Source varchar(255)
  ,Source_ApprenticeshipId int
  ,AsDm_CreatedDate datetime2 default(getdate()) 
  ,AsDm_UpdatedDate datetime2 default(getdatE())
  )
