CREATE TABLE [ASData_PL].[CRSDel_ProviderStandardLocation]
(
		[StandardId]			int				NOT NULL,
		[UkPrn]					int				NOT NULL,
		[LocationId]			int				NOT NULL,
		[DeliveryModes]			varchar(260)    NOT NULL,
		[Radius]				decimal(18,0)	NOT NULL,
		[National]				bit				NOT NULL,
		[AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())		
)

