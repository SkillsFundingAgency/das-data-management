CREATE TABLE [AsData_PL].[EI_Archive_PendingPayment]
(
  ID UniqueIdentifier Primary Key Not Null
 ,AccountId bigint not null
 ,ApprenticeshipIncentiveId uniqueidentifier not null
 ,DueDate datetime2(7) not null
 ,Amount decimal(9,2) not null
 ,CalculatedDate datetime2(7) not null
 ,PaymentMadeDate datetime2(7) null
 ,PeriodNumber tinyint null
 ,PaymentYear smallint null
 ,AccountLegalEntityId bigint null
 ,EarningType varchar(20) null
 ,ClawedBack BIT NOT NULL DEFAULT 0
 ,AsDm_UpdatedDateTime datetime2 default getdate()
)
