CREATE TABLE [AsData_PL].[Comt_History]
(
   ID BIGINT PRIMARY KEY NOT NULL
  ,EntityType NVARCHAR(50)  null
  ,EntityId BIGINT null
  ,CommitmentId BIGINT null
  ,ApprenticeshipId BIGINT null
  ,UpdatedByRole NVARCHAR(50)
  ,ChangeType NVARCHAR(50)
  ,CreatedOn DATETIME
  ,ProviderId BIGINT
  ,EmployerAccountId BIGINT null
  ,OriginalState_PaymentStatus VARCHAR(25)
  ,UpdatedState_PaymentStatus VARCHAR(25)
  ,CorrelationId UNIQUEIDENTIFIER 
  ,[AsDm_UpdatedDateTime] datetime2 default getdate()
  ,[IsRetentionApplied] bit DEFAULT (0)
  ,[RetentionAppliedDate]  DateTime2(7)
)

GO
CREATE NONCLUSTERED INDEX IDX_ComtHist_WatermarkColumn
ON [AsData_PL].[Comt_History] (Createdon);