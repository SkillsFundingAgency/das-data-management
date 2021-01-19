﻿CREATE TABLE [AsData_PL].[EI_ApprenticeshipIncentive]
(
   ID UniqueIdentifier Primary Key Not Null
  ,AccountId bigint not null
  ,ApprenticeshipId bigint not null
  ,EmployerType int not null
  ,IncentiveApplicationApprenticeshipId uniqueidentifier not null
  ,AccountLegalEntityId bigint null
  ,UKPRN bigint NULL
  ,RefreshedLearnerForEarnings bit NULL
  ,HasPossibleChangeOfCircumstances bit NULL
  ,PausePayments bit NULL
  ,AsDm_UpdatedDateTime datetime2 default getdate()
)
