CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderCourseLocation]
(
	  [Id]					                bigint					NOT NULL,
      [NavigationId]                        uniqueidentifier        NOT NULL,
      [ProviderCourseId]                    int						NOT NULL,
      [ProviderLocationId]                  int						NOT NULL,
      [HasDayReleaseDeliveryOption]         bit                     NULL,
      [HasBlockReleaseDeliveryOption]       bit                     NULL,
      [IsImported]                          bit                     NULL,
      [AsDm_UpdatedDateTime] [datetime2](7)		DEFAULT (getdate())	

)
