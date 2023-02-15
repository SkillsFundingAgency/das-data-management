CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderRegistrationDetail]
(
	  [Ukprn]            int					NOT NULL,
      [LegalName]        varchar(1000)       NULL,
      [StatusId]         int					NULL,
      [StatusDate]       [datetime2](7)      NULL,
      [OrganisationTypeId]int					NULL,
      [ProviderTypeId]    int					NULL,
      [AsDm_UpdatedDateTime] [datetime2](7)		DEFAULT (getdate())
)
