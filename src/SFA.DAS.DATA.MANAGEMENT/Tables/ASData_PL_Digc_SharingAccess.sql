CREATE TABLE [ASData_PL].[Digc_SharingAccess]
(
	[Id] [uniqueidentifier] NULL,
	[SharingId] [uniqueidentifier] NULL,
	[AccessedAt] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)