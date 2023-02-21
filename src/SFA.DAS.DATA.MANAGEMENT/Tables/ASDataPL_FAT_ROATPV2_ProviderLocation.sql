CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderLocation]
(
	  [Id]					                bigint					NOT NULL,
      [ImportedLocationId]                  int                     NULL,
      [NavigationId]                        uniqueidentifier        NOT NULL,
      [ProviderId]			                int						NOT NULL,
      [RegionId]                            int                     NULL,
      [LocationName]                        varchar(250)            NULL,     
      [Postcode]                            varchar(25)             NULL,
      [Latitude]                            float		        	NULL,
      [Longitude]                           float		        	NULL,
      [Email]                               varchar(300)            NULL,
      [Website]                             varchar(500)            NULL,
      [IsImported]                          bit                     NULL,
      [LocationType]                        bit                     NULL,
      [AsDm_UpdatedDateTime] [datetime2](7)		DEFAULT (getdate())
)
