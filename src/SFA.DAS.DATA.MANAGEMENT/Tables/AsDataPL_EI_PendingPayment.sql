CREATE TABLE [AsData_PL].[EI_PendingPayment]
(
  ID UniqueIdentifier Primary Key Not Null
 ,AccountId bigint not null
 ,ApprenticeshipIncentiveId uniqueidentifier not null
 ,DueDate datetime2(7) not null
 ,Amount decimal(9,2) not null
 ,CalculatedDate datetime2(7) not null
 ,PaymentMadeDate datetime2(7) null
 ,AsDm_UpdatedDateTime datetime2 default getdate()
)
