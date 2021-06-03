CREATE TABLE [AsData_PL].[Comt_History]
(
   ID BIGINT PRIMARY KEY NOT NULL
  ,EntityType NVARCHAR(50)  null
  ,EntityId BIGINT null
  ,CommitmentId BIGINT null
  ,ApprenticeshipId BIGINT null
  ,UserId NVARCHAR(50) not null
  ,UpdatedByRole NVARCHAR(50)
  ,ChangeType NVARCHAR(50)
  ,CreatedOn DATETIME
  ,ProviderId BIGINT
  ,EmployerAccountId BIGINT null
  ,OriginalState_PaymentStatus VARCHAR(25)
  ,UpdatedState_PaymentStatus VARCHAR(25)
  ,CorrelationId UNIQUEIDENTIFIER 
  ,[AsDm_UpdatedDateTime] datetime2 default getdate(),
)