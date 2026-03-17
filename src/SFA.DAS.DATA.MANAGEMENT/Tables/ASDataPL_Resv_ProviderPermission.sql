CREATE TABLE [AsData_PL].[Resv_ProviderPermission]
(
  [ProviderPermissionID] BIGINT IDENTITY(1,1) PRIMARY KEY ,
  [AccountId] [bigint] NOT NULL,
  [AccountLegalEntityId] [bigint] NOT NULL ,
  [UKPRN] BIGINT NOT NULL ,
  [CanCreateCohort] bit NOT NULL,
  [AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())
)
