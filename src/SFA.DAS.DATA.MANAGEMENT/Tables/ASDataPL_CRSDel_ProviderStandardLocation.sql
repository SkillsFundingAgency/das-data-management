CREATE TABLE [ASData_PL].[CRSDel_ProviderStandardLocation]
(
		[StandardId]			int			NOT NULL,
		[UkPrn]					int			NOT NULL,
		[LocationId]			int			NOT NULL,
		[DeliveryModes]			varchar     NOT NULL,
		[Radius]				decimal     NOT NULL,
		[National]				bit			NOT NULL,
		[AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())		
)

